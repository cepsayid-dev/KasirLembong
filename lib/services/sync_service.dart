import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';

import '../database/isar_helper.dart';
import '../collections/local_bill.dart';
import '../collections/local_bill_item.dart';
import '../collections/local_menu.dart';
import '../collections/local_expense_note.dart';
import '../collections/local_expense_item.dart';

class SyncService {
  static final Isar _isar = IsarHelper.isar;

  // GANTI IP INI SESUAI IP LAPTOP MAS
  static const String baseUrl = 'http://192.168.110.115:3000/api';

  // --- FUNGSI UTAMA: SYNC SEMUA DATA (PEMASUKAN & PENGELUARAN) ---
  static Future<bool> syncAllToServer() async {
    final billsSuccess = await syncBillsToServer();
    final expensesSuccess = await syncExpensesToServer();
    return billsSuccess && expensesSuccess;
  }

  // --- 1. PUSH: Kirim Transaksi Nota ke Server ---
  static Future<bool> syncBillsToServer() async {
    try {
      final unsyncedBills = await _isar.localBills
          .filter()
          .isSyncedEqualTo(false)
          .findAll();
      final unsyncedItems = await _isar.localBillItems
          .filter()
          .isSyncedEqualTo(false)
          .findAll();

      if (unsyncedBills.isEmpty && unsyncedItems.isEmpty) {
        return true;
      }

      final billsJson = unsyncedBills
          .map(
            (b) => {
              'id': b.uuid,
              'customer_name': b.customerName,
              'status': b.status,
              'payment_method': b.paymentMethod ?? 'Cash',
              'created_at': b.createdAt.toIso8601String(),
            },
          )
          .toList();

      final itemsJson = unsyncedItems
          .map(
            (i) => {
              'id': i.uuid,
              'bill_id': i.billUuid,
              'menu_item_id': i.menuItemId,
              'menu_name': i.menuName,
              'qty': i.qty,
              'price': i.price,
              'notes': i.notes,
              'is_delivered': i.isDelivered,
              'is_cancelled': i.isCancelled,
              'is_paid': i.isPaid,
            },
          )
          .toList();

      final response = await http.post(
        Uri.parse('$baseUrl/sync/bills'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'bills': billsJson, 'bill_items': itemsJson}),
      );

      if (response.statusCode == 200) {
        await _isar.writeTxn(() async {
          for (var b in unsyncedBills) {
            b.isSynced = true;
            await _isar.localBills.put(b);
          }
          for (var i in unsyncedItems) {
            i.isSynced = true;
            await _isar.localBillItems.put(i);
          }
        });
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Sync Bills Error: $e");
      return false;
    }
  }

  // --- 2. PUSH: Kirim Pengeluaran & Restok ke Server ---
  static Future<bool> syncExpensesToServer() async {
    try {
      final unsyncedNotes = await _isar.localExpenseNotes
          .filter()
          .isSyncedEqualTo(false)
          .findAll();
      final unsyncedItems = await _isar.localExpenseItems
          .filter()
          .isSyncedEqualTo(false)
          .findAll();

      if (unsyncedNotes.isEmpty && unsyncedItems.isEmpty) {
        return true;
      }

      // Ambil semua nota untuk referensi pembuatan ID unik pada item
      final allNotes = await _isar.localExpenseNotes.where().findAll();
      final noteTimeMap = {
        for (var n in allNotes) n.id: n.createdAt.millisecondsSinceEpoch,
      };

      final notesJson = unsyncedNotes
          .map(
            (n) => {
              'id': 'EXP-${n.createdAt.millisecondsSinceEpoch}-${n.id}',
              'type': n.type,
              'description': n.description,
              'amount': n.amount,
              'status': n.status,
              'created_at': n.createdAt.toIso8601String(),
            },
          )
          .toList();

      final itemsJson = unsyncedItems.map((i) {
        final noteTimestamp = noteTimeMap[i.noteId] ?? 0;
        return {
          'id': 'EXPITEM-$noteTimestamp-${i.id}',
          'note_id': 'EXP-$noteTimestamp-${i.noteId}',
          'menu_id': i.menuId,
          'menu_name': i.menuName,
          'tracking_mode': i.trackingMode,
          'qty': i.qty,
          'price': i.price,
          'stock_status': i.stockStatus ?? 'in_stock',
        };
      }).toList();

      final response = await http.post(
        Uri.parse('$baseUrl/sync/expenses'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'notes': notesJson, 'items': itemsJson}),
      );

      if (response.statusCode == 200) {
        await _isar.writeTxn(() async {
          for (var n in unsyncedNotes) {
            n.isSynced = true;
            await _isar.localExpenseNotes.put(n);
          }
          for (var i in unsyncedItems) {
            i.isSynced = true;
            await _isar.localExpenseItems.put(i);
          }
        });
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Sync Expenses Error: $e");
      return false;
    }
  }

  // --- 3. PULL: Tarik Master Menu dari Server ---
  static Future<bool> pullMenusFromServer() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/menus'));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 'success') {
          final List<dynamic> menuData = jsonResponse['data'];

          final List<LocalMenu> downloadedMenus = menuData.map((m) {
            return LocalMenu()
              ..id = m['id']
              ..name = m['name']
              ..price = double.parse(m['price'].toString())
              ..trackingMode = m['tracking_mode'] ?? 'numeric'
              ..stockQty = m['stock_qty'] ?? 0
              ..stockStatus = m['stock_status'] ?? 'in_stock'
              ..category = m['category'] ?? 'Makanan'
              ..isSynced = true;
          }).toList();

          await _isar.writeTxn(() async {
            await _isar.localMenus.putAll(downloadedMenus);
          });

          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint("Gagal Tarik Menu: $e");
      return false;
    }
  }
}
