import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

import '../database/db_connection.dart';
import '../providers/bill_provider.dart';
import '../models/bill_model.dart';
import '../models/bill_item_model.dart';
import '../models/cart_item_model.dart';

class BillService {
  // 1. Menyimpan Nota Baru (Sekaligus Potong Stok Otomatis)
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
        // Masukkan item ke bill_items
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

        // POTONG STOK OTOMATIS (Hanya jika tracking_mode = 'numeric')
        await DatabaseHelper.connection.execute(
          Sql.named(r"""
            UPDATE menu_items 
            SET stock_qty = stock_qty - @qty 
            WHERE id = @menuId AND tracking_mode = 'numeric'
          """),
          parameters: {'qty': item.qty, 'menuId': item.menuId},
        );
      }

      debugPrint("✅ Nota Berhasil Disimpan & Stok Terpotong!");
      return true;
    } catch (e) {
      debugPrint("❌ Gagal Menyimpan Nota: $e");
      return false;
    }
  }

  // 2. Mengambil daftar nota aktif (Unpaid ATAU Paid tapi belum diantar)
  static Future<List<BillModel>> fetchActiveBills() async {
    try {
      final results = await DatabaseHelper.connection.execute(r"""
        SELECT DISTINCT b.id, b.customer_name, b.created_at, b.status 
        FROM bills b
        LEFT JOIN bill_items bi ON b.id = bi.bill_id
        WHERE b.status = 'unpaid' 
           OR (b.status = 'paid' AND bi.is_delivered = FALSE AND bi.is_cancelled = FALSE)
        ORDER BY b.created_at DESC
        """);

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

  // 3. Mengambil isi menu dari nota tertentu
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

  // 4. Mencoret (Membatalkan) satu item pesanan
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

  // 5. Memproses Pembayaran (Checkout)
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

  // 6. Menyimpan pesanan tambahan ke nota yang sudah ada (Sekaligus Potong Stok Otomatis)
  static Future<bool> addItemsToBill(int billId, List<CartItem> items) async {
    try {
      for (var item in items) {
        // Masukkan item tambahan
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

        // POTONG STOK OTOMATIS UNTUK ITEM TAMBAHAN
        await DatabaseHelper.connection.execute(
          Sql.named(r"""
            UPDATE menu_items 
            SET stock_qty = stock_qty - @qty 
            WHERE id = @menuId AND tracking_mode = 'numeric'
          """),
          parameters: {'qty': item.qty, 'menuId': item.menuId},
        );
      }
      return true;
    } catch (e) {
      debugPrint("Gagal menambah pesanan: $e");
      return false;
    }
  }
}
