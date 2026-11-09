import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../database/isar_helper.dart';
import '../collections/local_bill.dart';
import '../collections/local_bill_item.dart';
import '../models/pending_order_model.dart';
import 'menu_service.dart'; // <-- IMPORT MENU SERVICE UNTUK KATEGORI ASLI

class OrderService {
  static final Isar _isar = IsarHelper.isar;

  static Future<List<PendingOrder>> fetchPendingOrders() async {
    try {
      final items = await _isar.localBillItems
          .filter()
          .isDeliveredEqualTo(false)
          .and()
          .isCancelledEqualTo(false)
          .findAll();

      // AMBIL KATEGORI ASLI DARI MASTER MENU (PostgreSQL)
      final menus = await MenuService.fetchMenus();
      final categoryMap = {for (var m in menus) m.id: m.category};

      List<PendingOrder> result = [];
      for (var item in items) {
        final bill = await _isar.localBills
            .filter()
            .uuidEqualTo(item.billUuid)
            .findFirst();

        if (bill != null && bill.status != 'closed') {
          // Cocokkan id menu dengan kategori aslinya (default ke Makanan jika tidak ketemu)
          String realCategory = categoryMap[item.menuItemId] ?? 'Makanan';

          result.add(
            PendingOrder(
              itemUuid: item.uuid,
              billUuid: bill.uuid,
              billId: bill.id,
              customerName: bill.customerName,
              menuName: item.menuName,
              qty: item.qty,
              notes: item.notes,
              createdAt: bill.createdAt,
              category: realCategory, // Kategori kembali akurat 100%
            ),
          );
        }
      }

      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return result;
    } catch (e) {
      debugPrint("Gagal mengambil antrean Isar: $e");
      return [];
    }
  }

  static Future<bool> markAsDelivered(String itemUuid) async {
    try {
      final item = await _isar.localBillItems
          .filter()
          .uuidEqualTo(itemUuid)
          .findFirst();
      if (item != null) {
        item.isDelivered = true;
        item.isSynced = false;
        await _isar.writeTxn(() async => await _isar.localBillItems.put(item));
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Gagal update status di Isar: $e");
      return false;
    }
  }
}
