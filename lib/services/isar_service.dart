import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../collections/local_bill.dart';
import '../collections/local_bill_item.dart';
import '../collections/local_menu.dart';
import '../collections/local_shift.dart'; // <-- IMPORT LOCAL SHIFT
import '../database/isar_helper.dart';
import '../models/cart_item_model.dart';
import '../models/bill_model.dart';
import '../models/bill_item_model.dart';
import '../models/pending_order_model.dart';

class IsarService {
  static final Isar _isar = IsarHelper.isar;
  static const _uuid = Uuid();

  // 1. Simpan Nota Baru (+ POTONG STOK + TEMPEL SHIFT ID)
  static Future<BillModel> createBill({
    required String customerName,
    required List<CartItem> items,
    String? paymentMethod,
    bool isPaid = false,
  }) async {
    final billUuid = _uuid.v4();

    // Ambil shift yang sedang aktif ('open')
    final activeShift = await _isar.localShifts
        .filter()
        .statusEqualTo('open')
        .findFirst();

    final newBill = LocalBill()
      ..uuid = billUuid
      ..customerName = customerName
      ..status = isPaid ? 'paid' : 'unpaid'
      ..paymentMethod = paymentMethod
      ..createdAt = DateTime.now()
      ..shiftId = activeShift
          ?.uuid // <-- Tempelkan ID Shift aktif
      ..isSynced = false;

    final List<LocalBillItem> billItems = items.map((item) {
      return LocalBillItem()
        ..uuid = _uuid.v4()
        ..billUuid = billUuid
        ..menuItemId = item.menuId
        ..menuName = item.menuName
        ..qty = item.qty
        ..price = item.price
        ..notes = item.notes
        ..isDelivered = false
        ..isCancelled = false
        ..isPaid = isPaid
        ..isSynced = false;
    }).toList();

    await _isar.writeTxn(() async {
      await _isar.localBills.put(newBill);
      await _isar.localBillItems.putAll(billItems);

      // --- LOGIKA POTONG STOK OTOMATIS ---
      for (var item in items) {
        final menu = await _isar.localMenus.get(item.menuId);
        if (menu != null && menu.trackingMode == 'numeric') {
          menu.stockQty = menu.stockQty - item.qty;
          menu.isSynced = false;
          await _isar.localMenus.put(menu);
        }
      }
    });

    return BillModel(
      id: newBill.id,
      uuid: newBill.uuid,
      customerName: newBill.customerName,
      createdAt: newBill.createdAt,
      status: newBill.status,
      isAllDelivered: false,
    );
  }

  // 2. Ambil Semua Nota Aktif
  static Future<List<BillModel>> fetchActiveBills() async {
    final localBills = await _isar.localBills
        .filter()
        .not()
        .statusEqualTo('closed')
        .sortByCreatedAtDesc()
        .findAll();

    List<BillModel> result = [];
    for (var lb in localBills) {
      final items = await _isar.localBillItems
          .filter()
          .billUuidEqualTo(lb.uuid)
          .findAll();
      final validItems = items.where((i) => !i.isCancelled).toList();
      bool isAllDelivered =
          validItems.isNotEmpty && validItems.every((i) => i.isDelivered);

      result.add(
        BillModel(
          id: lb.id,
          uuid: lb.uuid,
          customerName: lb.customerName,
          createdAt: lb.createdAt,
          status: lb.status,
          isAllDelivered: isAllDelivered,
        ),
      );
    }
    return result;
  }

  // 3. Ambil Item berdasarkan Bill UUID
  static Future<List<BillItemModel>> getBillItems(String billUuid) async {
    final localItems = await _isar.localBillItems
        .filter()
        .billUuidEqualTo(billUuid)
        .findAll();
    return localItems
        .map(
          (i) => BillItemModel(
            id: i.id,
            uuid: i.uuid,
            menuId: i.menuItemId,
            menuName: i.menuName,
            qty: i.qty,
            price: i.price,
            notes: i.notes,
            isDelivered: i.isDelivered,
            isCancelled: i.isCancelled,
            isPaid: i.isPaid,
          ),
        )
        .toList();
  }

  // 4. Update Nama Pelanggan
  static Future<bool> updateCustomerName(String uuid, String newName) async {
    final bill = await _isar.localBills.filter().uuidEqualTo(uuid).findFirst();
    if (bill != null) {
      bill.customerName = newName;
      bill.isSynced = false;
      await _isar.writeTxn(() async => await _isar.localBills.put(bill));
      return true;
    }
    return false;
  }

  // 5. Hapus Nota Seluruhnya (+ KEMBALIKAN STOK)
  static Future<bool> deleteBill(String uuid) async {
    final bill = await _isar.localBills.filter().uuidEqualTo(uuid).findFirst();
    if (bill != null) {
      await _isar.writeTxn(() async {
        final itemsToRestore = await _isar.localBillItems
            .filter()
            .billUuidEqualTo(uuid)
            .and()
            .isCancelledEqualTo(false)
            .findAll();

        for (var item in itemsToRestore) {
          final menu = await _isar.localMenus.get(item.menuItemId);
          if (menu != null && menu.trackingMode == 'numeric') {
            menu.stockQty = menu.stockQty + item.qty;
            menu.isSynced = false;
            await _isar.localMenus.put(menu);
          }
        }

        await _isar.localBillItems.filter().billUuidEqualTo(uuid).deleteAll();
        await _isar.localBills.delete(bill.id);
      });
      return true;
    }
    return false;
  }

  // 6. Batalkan 1 Item / Coret (+ KEMBALIKAN STOK)
  static Future<bool> cancelItem(String itemUuid) async {
    final item = await _isar.localBillItems
        .filter()
        .uuidEqualTo(itemUuid)
        .findFirst();
    if (item != null && !item.isCancelled) {
      await _isar.writeTxn(() async {
        item.isCancelled = true;
        item.isSynced = false;
        await _isar.localBillItems.put(item);

        final menu = await _isar.localMenus.get(item.menuItemId);
        if (menu != null && menu.trackingMode == 'numeric') {
          menu.stockQty = menu.stockQty + item.qty;
          menu.isSynced = false;
          await _isar.localMenus.put(menu);
        }
      });
      return true;
    }
    return false;
  }

  // 7. Tambah Pesanan Susulan (+ POTONG STOK)
  static Future<bool> addItemsToBill(
    String billUuid,
    List<CartItem> newItems,
  ) async {
    final List<LocalBillItem> isarItems = newItems.map((item) {
      return LocalBillItem()
        ..uuid = _uuid.v4()
        ..billUuid = billUuid
        ..menuItemId = item.menuId
        ..menuName = item.menuName
        ..qty = item.qty
        ..price = item.price
        ..notes = item.notes
        ..isDelivered = false
        ..isCancelled = false
        ..isPaid = false
        ..isSynced = false;
    }).toList();

    await _isar.writeTxn(() async {
      await _isar.localBillItems.putAll(isarItems);

      for (var item in newItems) {
        final menu = await _isar.localMenus.get(item.menuId);
        if (menu != null && menu.trackingMode == 'numeric') {
          menu.stockQty = menu.stockQty - item.qty;
          menu.isSynced = false;
          await _isar.localMenus.put(menu);
        }
      }
    });
    return true;
  }

  // 8. Bayar Sebagian
  static Future<bool> payPartialItems(
    String billUuid,
    Map<String, int> splitSelection,
    String paymentMethod,
  ) async {
    await _isar.writeTxn(() async {
      for (var entry in splitSelection.entries) {
        String itemUuid = entry.key;
        int payQty = entry.value;

        if (payQty > 0) {
          final item = await _isar.localBillItems
              .filter()
              .uuidEqualTo(itemUuid)
              .findFirst();
          if (item != null) {
            if (payQty == item.qty) {
              item.isPaid = true;
              item.isSynced = false;
              await _isar.localBillItems.put(item);
            } else {
              item.qty = item.qty - payQty;
              item.isSynced = false;
              await _isar.localBillItems.put(item);

              final paidItem = LocalBillItem()
                ..uuid = _uuid.v4()
                ..billUuid = billUuid
                ..menuItemId = item.menuItemId
                ..menuName = item.menuName
                ..qty = payQty
                ..price = item.price
                ..notes = item.notes
                ..isDelivered = item.isDelivered
                ..isCancelled = false
                ..isPaid = true
                ..isSynced = false;
              await _isar.localBillItems.put(paidItem);
            }
          }
        }
      }

      final allItems = await _isar.localBillItems
          .filter()
          .billUuidEqualTo(billUuid)
          .findAll();
      bool isAllPaid = allItems
          .where((i) => !i.isCancelled)
          .every((i) => i.isPaid);
      if (isAllPaid) {
        final bill = await _isar.localBills
            .filter()
            .uuidEqualTo(billUuid)
            .findFirst();
        if (bill != null) {
          bill.status = 'paid';
          bill.paymentMethod = paymentMethod;
          bill.isSynced = false;
          await _isar.localBills.put(bill);
        }
      }
    });
    return true;
  }

  // 9. Bayar Seluruh Sisa Nota
  static Future<bool> checkoutBill(
    String billUuid,
    String paymentMethod,
  ) async {
    final bill = await _isar.localBills
        .filter()
        .uuidEqualTo(billUuid)
        .findFirst();
    if (bill != null) {
      bill.status = 'paid';
      bill.paymentMethod = paymentMethod;
      bill.isSynced = false;
      await _isar.writeTxn(() async => await _isar.localBills.put(bill));
      return true;
    }
    return false;
  }

  // 10. Arsipkan Nota
  static Future<bool> archiveBill(int internalId) async {
    final bill = await _isar.localBills.get(internalId);
    if (bill != null) {
      bill.status = 'closed';
      bill.isSynced = false;
      await _isar.writeTxn(() async => await _isar.localBills.put(bill));
      return true;
    }
    return false;
  }

  // 11. Ubah Status Diantar
  static Future<bool> toggleItemDelivered(
    String itemUuid,
    bool currentStatus,
  ) async {
    final item = await _isar.localBillItems
        .filter()
        .uuidEqualTo(itemUuid)
        .findFirst();
    if (item != null) {
      item.isDelivered = !currentStatus;
      item.isSynced = false;
      await _isar.writeTxn(() async => await _isar.localBillItems.put(item));
      return true;
    }
    return false;
  }

  // 14. Auto-Archive Nota Lunas & Diantar jika > 3 jam tanpa aktivitas baru
  static Future<void> checkAndAutoArchiveBills() async {
    final activeBills = await _isar.localBills
        .filter()
        .statusEqualTo('paid')
        .findAll();

    final now = DateTime.now();

    await _isar.writeTxn(() async {
      for (var bill in activeBills) {
        final items = await _isar.localBillItems
            .filter()
            .billUuidEqualTo(bill.uuid)
            .findAll();

        final validItems = items.where((i) => !i.isCancelled).toList();

        bool isAllDelivered =
            validItems.isNotEmpty && validItems.every((i) => i.isDelivered);
        bool isAllPaid =
            validItems.isNotEmpty && validItems.every((i) => i.isPaid);

        if (isAllDelivered && isAllPaid) {
          final difference = now.difference(bill.createdAt).inHours;

          if (difference >= 3) {
            bill.status = 'closed';
            bill.isSynced = false;
            await _isar.localBills.put(bill);
          }
        }
      }
    });
  }
}
