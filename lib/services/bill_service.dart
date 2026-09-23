import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

import '../database/db_connection.dart';
import '../providers/bill_provider.dart';
import '../models/bill_model.dart'; // Impor model baru
// Tambahkan impor ini di baris paling atas
import '../models/bill_item_model.dart';
import '../models/cart_item_model.dart';

class BillService {
  static Future<bool> saveBill(BillProvider provider) async {
    try {
      final billResult = await DatabaseHelper.connection.execute(
        Sql.named(
          r"INSERT INTO bills (customer_name, status, payment_method) VALUES (@name, 'unpaid', 'Cash') RETURNING id",
        ),
        parameters: {
          'name': provider.customerName.isEmpty
              ? 'Guest'
              : provider.customerName,
        },
      );

      final int billId = billResult.first[0] as int;

      for (var item in provider.items) {
        await DatabaseHelper.connection.execute(
          Sql.named(
            r"INSERT INTO bill_items (bill_id, menu_item_id, menu_name, qty, price, notes) VALUES (@billId, @menuId, @menuName, @qty, @price, @notes)",
          ),
          parameters: {
            'billId': billId,
            'menuId': item.menuId,
            'menuName': item.menuName,
            'qty': item.qty,
            'price': item.price,
            'notes': item.notes,
          },
        );
      }

      debugPrint("✅ Nota Berhasil Disimpan ke Database!");
      return true;
    } catch (e) {
      debugPrint("❌ Gagal Menyimpan Nota: $e");
      return false;
    }
  }

  // FUNGSI BARU: Mengambil daftar nota yang statusnya 'unpaid' (Belum Bayar)
  static Future<List<BillModel>> fetchActiveBills() async {
    try {
      final results = await DatabaseHelper.connection.execute(
        "SELECT id, customer_name, created_at, status FROM bills WHERE status = 'unpaid' ORDER BY created_at DESC",
      );

      return results
          .map(
            (row) => BillModel(
              id: row[0] as int,
              customerName: row[1] as String? ?? 'Guest',
              createdAt: row[2] as DateTime,
              status: row[3] as String,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint("Gagal mengambil daftar nota aktif: $e");
      return [];
    }
  }

  // FUNGSI BARU 1: Mengambil isi menu dari nota tertentu
  static Future<List<BillItemModel>> getBillItems(int billId) async {
    try {
      final results = await DatabaseHelper.connection.execute(
        Sql.named(
          "SELECT id, menu_item_id, menu_name, qty, price, notes, is_delivered, is_cancelled FROM bill_items WHERE bill_id = @id ORDER BY id ASC",
        ),
        parameters: {'id': billId},
      );

      return results
          .map(
            (row) => BillItemModel(
              id: row[0] as int,
              menuId: row[1] as int,
              menuName: row[2] as String,
              qty: row[3] as int,
              price: double.parse(row[4].toString()),
              notes: row[5] as String? ?? '',
              isDelivered: row[6] as bool,
              isCancelled: row[7] as bool,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint("Gagal mengambil rincian nota: $e");
      return [];
    }
  }

  // FUNGSI BARU 2: Mencoret (Membatalkan) satu item pesanan
  static Future<bool> cancelItem(int itemId) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named("UPDATE bill_items SET is_cancelled = TRUE WHERE id = @id"),
        parameters: {'id': itemId},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // FUNGSI BARU 3: Memproses Pembayaran (Checkout)
  static Future<bool> checkoutBill(int billId, String paymentMethod) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named(
          "UPDATE bills SET status = 'paid', payment_method = @method WHERE id = @id",
        ),
        parameters: {'id': billId, 'method': paymentMethod},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // FUNGSI BARU 4: Menyimpan pesanan tambahan ke nota yang sudah ada
  static Future<bool> addItemsToBill(int billId, List<CartItem> items) async {
    try {
      for (var item in items) {
        await DatabaseHelper.connection.execute(
          Sql.named(
            r"INSERT INTO bill_items (bill_id, menu_item_id, menu_name, qty, price, notes) VALUES (@billId, @menuId, @menuName, @qty, @price, @notes)",
          ),
          parameters: {
            'billId': billId,
            'menuId': item.menuId,
            'menuName': item.menuName,
            'qty': item.qty,
            'price': item.price,
            'notes': item.notes,
          },
        );
      }
      return true;
    } catch (e) {
      debugPrint("Gagal menambah pesanan: $e");
      return false;
    }
  }
}
