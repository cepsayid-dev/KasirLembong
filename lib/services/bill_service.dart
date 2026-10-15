import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

import '../database/db_connection.dart';
import '../models/bill_model.dart';
import '../models/bill_item_model.dart';
import '../providers/bill_provider.dart';
import '../models/cart_item_model.dart';

class BillService {
  static Future<List<BillModel>> fetchActiveBills() async {
    try {
      // Query menghitung jumlah item yang belum diantar (is_delivered = FALSE)
      final results = await DatabaseHelper.connection.execute(r"""
        SELECT b.id, b.customer_name, b.created_at, b.status,
               COALESCE(SUM(CASE WHEN bi.is_delivered = FALSE AND bi.is_cancelled = FALSE THEN 1 ELSE 0 END), 0) as undelivered_count
        FROM bills b
        LEFT JOIN bill_items bi ON b.id = bi.bill_id
        WHERE b.status IN ('unpaid', 'paid')
        GROUP BY b.id, b.customer_name, b.created_at, b.status
        ORDER BY b.created_at DESC
      """);

      return results.map((row) {
        final undeliveredCount = int.parse(row[4].toString());
        return BillModel(
          id: row[0] as int,
          customerName: row[1] as String? ?? 'Guest',
          createdAt: row[2] as DateTime,
          status: row[3] as String,
          isAllDelivered: undeliveredCount == 0,
        );
      }).toList();
    } catch (e) {
      debugPrint("Gagal mengambil nota aktif: $e");
      return [];
    }
  }

  // 2. Menyimpan nota baru (Diperbarui agar mengembalikan ID Nota)
  static Future<int?> saveBill(BillProvider provider) async {
    try {
      final customerName = provider.customerName.isEmpty
          ? 'Guest'
          : provider.customerName;

      final result = await DatabaseHelper.connection.execute(
        Sql.named(
          "INSERT INTO bills (customer_name, status) VALUES (@name, 'unpaid') RETURNING id",
        ),
        parameters: {'name': customerName},
      );
      final billId = result[0][0] as int;

      for (var item in provider.items) {
        await DatabaseHelper.connection.execute(
          Sql.named("""
            INSERT INTO bill_items (bill_id, menu_item_id, menu_name, qty, price, notes)
            VALUES (@billId, @menuId, @name, @qty, @price, @notes)
          """),
          parameters: {
            'billId': billId,
            'menuId': item.menuId,
            'name': item.menuName,
            'qty': item.qty,
            'price': item.price,
            'notes': item.notes,
          },
        );

        await DatabaseHelper.connection.execute(
          Sql.named("""
            UPDATE menu_items 
            SET stock_qty = stock_qty - @qty 
            WHERE id = @menuId AND tracking_mode = 'numeric'
          """),
          parameters: {'qty': item.qty, 'menuId': item.menuId},
        );
      }

      // KEMBALIKAN ID NOTA (Bukan true)
      return billId;
    } catch (e) {
      debugPrint("Gagal menyimpan nota: $e");
      return null;
    }
  }

  static Future<List<BillItemModel>> getBillItems(int billId) async {
    try {
      final results = await DatabaseHelper.connection.execute(
        Sql.named("""
          SELECT id, menu_item_id, menu_name, qty, price, notes, is_delivered, is_cancelled, is_paid 
          FROM bill_items 
          WHERE bill_id = @id 
          ORDER BY id ASC
        """),
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
              isDelivered: row[6] as bool? ?? false,
              isCancelled: row[7] as bool? ?? false,
              isPaid: row[8] as bool? ?? false,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint("Gagal mengambil item nota: $e");
      return [];
    }
  }

  static Future<bool> addItemsToBill(
    int billId,
    List<CartItem> newItems,
  ) async {
    try {
      for (var item in newItems) {
        await DatabaseHelper.connection.execute(
          Sql.named("""
            INSERT INTO bill_items (bill_id, menu_item_id, menu_name, qty, price, notes)
            VALUES (@billId, @menuId, @name, @qty, @price, @notes)
          """),
          parameters: {
            'billId': billId,
            'menuId': item.menuId,
            'name': item.menuName,
            'qty': item.qty,
            'price': item.price,
            'notes': item.notes,
          },
        );

        await DatabaseHelper.connection.execute(
          Sql.named("""
            UPDATE menu_items 
            SET stock_qty = stock_qty - @qty 
            WHERE id = @menuId AND tracking_mode = 'numeric'
          """),
          parameters: {'qty': item.qty, 'menuId': item.menuId},
        );
      }

      await DatabaseHelper.connection.execute(
        Sql.named("UPDATE bills SET status = 'unpaid' WHERE id = @id"),
        parameters: {'id': billId},
      );

      return true;
    } catch (e) {
      debugPrint("Gagal menambah pesanan susulan: $e");
      return false;
    }
  }

  static Future<bool> cancelItem(int itemId) async {
    try {
      final itemData = await DatabaseHelper.connection.execute(
        Sql.named("SELECT menu_item_id, qty FROM bill_items WHERE id = @id"),
        parameters: {'id': itemId},
      );

      if (itemData.isNotEmpty) {
        final menuId = itemData[0][0] as int;
        final qty = itemData[0][1] as int;

        await DatabaseHelper.connection.execute(
          Sql.named("""
            UPDATE menu_items 
            SET stock_qty = stock_qty + @qty 
            WHERE id = @menuId AND tracking_mode = 'numeric'
          """),
          parameters: {'qty': qty, 'menuId': menuId},
        );
      }

      await DatabaseHelper.connection.execute(
        Sql.named('UPDATE bill_items SET is_cancelled = TRUE WHERE id = @id'),
        parameters: {'id': itemId},
      );
      return true;
    } catch (e) {
      debugPrint("Gagal membatalkan item: $e");
      return false;
    }
  }

  static Future<bool> checkoutBill(int billId, String paymentMethod) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named(
          "UPDATE bills SET status = 'paid', payment_method = @pm WHERE id = @id",
        ),
        parameters: {'pm': paymentMethod, 'id': billId},
      );
      return true;
    } catch (e) {
      debugPrint("Gagal proses checkout penuh: $e");
      return false;
    }
  }

  static Future<bool> deleteBill(int billId) async {
    try {
      final items = await DatabaseHelper.connection.execute(
        Sql.named(
          "SELECT menu_item_id, qty FROM bill_items WHERE bill_id = @id AND is_cancelled = FALSE",
        ),
        parameters: {'id': billId},
      );

      for (final row in items) {
        final menuId = row[0] as int;
        final qty = row[1] as int;

        await DatabaseHelper.connection.execute(
          Sql.named("""
            UPDATE menu_items 
            SET stock_qty = stock_qty + @qty 
            WHERE id = @menuId AND tracking_mode = 'numeric'
          """),
          parameters: {'qty': qty, 'menuId': menuId},
        );
      }

      await DatabaseHelper.connection.execute(
        Sql.named("DELETE FROM bill_items WHERE bill_id = @id"),
        parameters: {'id': billId},
      );

      await DatabaseHelper.connection.execute(
        Sql.named("DELETE FROM bills WHERE id = @id"),
        parameters: {'id': billId},
      );

      return true;
    } catch (e) {
      debugPrint("❌ Gagal menghapus nota: $e");
      return false;
    }
  }

  static Future<bool> payPartialItems(
    int billId,
    Map<int, int> selectedItems,
    String paymentMethod,
  ) async {
    try {
      for (var entry in selectedItems.entries) {
        int itemId = entry.key;
        int payQty = entry.value;
        if (payQty <= 0) {
          continue;
        }

        var itemData = await DatabaseHelper.connection.execute(
          Sql.named(
            "SELECT menu_item_id, menu_name, price, notes, is_delivered, qty FROM bill_items WHERE id = @id",
          ),
          parameters: {'id': itemId},
        );
        if (itemData.isEmpty) {
          continue;
        }

        var row = itemData[0];
        int currentQty = row[5] as int;

        if (payQty == currentQty) {
          await DatabaseHelper.connection.execute(
            Sql.named("UPDATE bill_items SET is_paid = TRUE WHERE id = @id"),
            parameters: {'id': itemId},
          );
        } else {
          await DatabaseHelper.connection.execute(
            Sql.named(
              "UPDATE bill_items SET qty = qty - @payQty WHERE id = @id",
            ),
            parameters: {'payQty': payQty, 'id': itemId},
          );
          await DatabaseHelper.connection.execute(
            Sql.named("""
              INSERT INTO bill_items (bill_id, menu_item_id, menu_name, qty, price, notes, is_delivered, is_paid)
              VALUES (@billId, @menuId, @name, @qty, @price, @notes, @isDelivered, TRUE)
            """),
            parameters: {
              'billId': billId,
              'menuId': row[0],
              'name': row[1],
              'qty': payQty,
              'price': row[2],
              'notes': row[3],
              'isDelivered': row[4],
            },
          );
        }
      }

      var checkData = await DatabaseHelper.connection.execute(
        Sql.named(
          "SELECT COUNT(*) FROM bill_items WHERE bill_id = @id AND is_cancelled = FALSE AND is_paid = FALSE",
        ),
        parameters: {'id': billId},
      );

      int unpaidCount = checkData[0][0] as int;
      if (unpaidCount == 0) {
        await DatabaseHelper.connection.execute(
          Sql.named(
            "UPDATE bills SET status = 'paid', payment_method = @pm WHERE id = @id",
          ),
          parameters: {'pm': paymentMethod, 'id': billId},
        );
      }
      return true;
    } catch (e) {
      debugPrint("Gagal proses bayar sebagian: $e");
      return false;
    }
  }

  static Future<bool> archiveBill(int billId) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named("UPDATE bills SET status = 'closed' WHERE id = @id"),
        parameters: {'id': billId},
      );
      return true;
    } catch (e) {
      debugPrint("Gagal mengarsipkan nota: $e");
      return false;
    }
  }

  // 10. MENGUBAH NAMA PELANGGAN (EDIT NAMA)
  static Future<bool> updateCustomerName(int billId, String newName) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named("UPDATE bills SET customer_name = @name WHERE id = @id"),
        parameters: {'name': newName, 'id': billId},
      );
      return true;
    } catch (e) {
      debugPrint("Gagal update nama pelanggan: $e");
      return false;
    }
  }
}
