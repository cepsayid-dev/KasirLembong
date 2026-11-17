import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../database/isar_helper.dart';
import '../collections/local_expense_note.dart';
import '../collections/local_expense_item.dart';
import '../collections/local_menu.dart';
import '../collections/local_shift.dart'; // <-- IMPORT LOCAL SHIFT
import '../models/expense_model.dart';
import '../models/menu_model.dart';

class ExpenseService {
  static final Isar _isar = IsarHelper.isar;

  // 1. Init tables dibiarkan kosong agar tidak error jika terlanjur dipanggil di UI lama
  static Future<void> initTables() async {}

  // 2. Mengambil Semua Nota Pengeluaran
  static Future<List<ExpenseNote>> fetchExpenseNotes() async {
    try {
      final results = await _isar.localExpenseNotes
          .where()
          .sortByCreatedAtDesc()
          .findAll();

      return results
          .map(
            (row) => ExpenseNote(
              id: row.id,
              type: row.type,
              description: row.description,
              amount: row.amount,
              status: row.status,
              createdAt: row.createdAt,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint("Error Isar Expense: $e");
      return [];
    }
  }

  // 3. Tambah Pengeluaran Biasa (+ TEMPEL SHIFT ID)
  static Future<bool> addGeneralExpense(
    String description,
    double amount,
  ) async {
    try {
      final activeShift = await _isar.localShifts
          .filter()
          .statusEqualTo('open')
          .findFirst();

      final note = LocalExpenseNote()
        ..type = 'Biasa'
        ..description = description
        ..amount = amount
        ..status = 'Lunas'
        ..createdAt = DateTime.now()
        ..shiftId = activeShift
            ?.uuid // <-- Tempelkan ID Shift aktif
        ..isSynced = false;

      await _isar.writeTxn(() async {
        await _isar.localExpenseNotes.put(note);
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // 4. BUAT DRAFT LIST BELANJA (PO) (+ TEMPEL SHIFT ID)
  static Future<bool> createDraftRestock(List<MenuModel> selectedMenus) async {
    try {
      final activeShift = await _isar.localShifts
          .filter()
          .statusEqualTo('open')
          .findFirst();

      final note = LocalExpenseNote()
        ..type = 'Restok'
        ..description = 'Draft Belanja Restok'
        ..amount = 0
        ..status = 'Draft'
        ..createdAt = DateTime.now()
        ..shiftId = activeShift
            ?.uuid // <-- Tempelkan ID Shift aktif
        ..isSynced = false;

      await _isar.writeTxn(() async {
        final noteId = await _isar.localExpenseNotes.put(note);

        List<LocalExpenseItem> itemsToSave = [];
        for (var menu in selectedMenus) {
          final historyItems = await _isar.localExpenseItems
              .filter()
              .menuIdEqualTo(menu.id)
              .findAll();

          double lastPrice = 0;
          if (historyItems.isNotEmpty) {
            lastPrice = historyItems.last.price;
          }

          itemsToSave.add(
            LocalExpenseItem()
              ..noteId = noteId
              ..menuId = menu.id
              ..menuName = menu.name
              ..trackingMode = menu.trackingMode
              ..qty = 0
              ..price = lastPrice
              ..stockStatus = menu.stockStatus
              ..isSynced = false,
          );
        }
        await _isar.localExpenseItems.putAll(itemsToSave);
      });
      return true;
    } catch (e) {
      debugPrint("Gagal buat draft restok Isar: $e");
      return false;
    }
  }

  // 5. MENGAMBIL RINCIAN BARANG DARI NOTA DRAFT
  static Future<List<RestockItem>> fetchDraftItems(int noteId) async {
    try {
      final results = await _isar.localExpenseItems
          .filter()
          .noteIdEqualTo(noteId)
          .findAll();

      return results
          .map(
            (row) => RestockItem(
              id: row.id,
              menuId: row.menuId,
              menuName: row.menuName,
              trackingMode: row.trackingMode,
              qty: row.qty,
              price: row.price,
              stockStatus: row.stockStatus ?? 'in_stock',
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // 6. KONFIRMASI BARANG DATANG (UPDATE STOK LOKAL & LUNASKAN NOTA)
  static Future<bool> confirmRestock(
    int noteId,
    List<RestockItem> items,
  ) async {
    try {
      double totalAmount = 0;

      await _isar.writeTxn(() async {
        for (var item in items) {
          totalAmount += item.price;

          if (item.id != null) {
            final localItem = await _isar.localExpenseItems.get(item.id!);
            if (localItem != null) {
              localItem.qty = item.qty;
              localItem.price = item.price;
              localItem.isSynced = false;
              await _isar.localExpenseItems.put(localItem);
            }
          }

          final menu = await _isar.localMenus.get(item.menuId);
          if (menu != null) {
            if (item.trackingMode == 'numeric') {
              menu.stockQty += item.qty;
            } else {
              menu.stockStatus = item.stockStatus;
            }
            menu.isSynced = false;
            await _isar.localMenus.put(menu);
          }
        }

        final note = await _isar.localExpenseNotes.get(noteId);
        if (note != null) {
          note.status = 'Lunas';
          note.amount = totalAmount;
          note.description = 'Restok Selesai';
          note.isSynced = false;
          await _isar.localExpenseNotes.put(note);
        }
      });

      return true;
    } catch (e) {
      debugPrint("Gagal konfirmasi restok Isar: $e");
      return false;
    }
  }

  // 7. Hapus Nota
  static Future<bool> deleteNote(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.localExpenseItems.filter().noteIdEqualTo(id).deleteAll();
        await _isar.localExpenseNotes.delete(id);
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
