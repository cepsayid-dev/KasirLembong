import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

import '../database/db_connection.dart';
import '../models/pending_order_model.dart';

class OrderService {
  static Future<List<PendingOrder>> fetchPendingOrders() async {
    try {
      final results = await DatabaseHelper.connection.execute(r"""
        SELECT bi.id, b.id, b.customer_name, bi.menu_name, bi.qty, bi.notes, b.created_at, m.category
        FROM bill_items bi
        JOIN bills b ON bi.bill_id = b.id
        JOIN menu_items m ON bi.menu_item_id = m.id
        WHERE bi.is_delivered = FALSE AND bi.is_cancelled = FALSE
        ORDER BY b.created_at ASC
        """);

      return results
          .map(
            (row) => PendingOrder(
              itemId: row[0] as int,
              billId: row[1] as int,
              customerName: row[2] as String? ?? 'Guest',
              menuName: row[3] as String,
              qty: row[4] as int,
              notes: row[5] as String? ?? '',
              createdAt: row[6] as DateTime,
              category: row[7] as String? ?? 'Makanan',
            ),
          )
          .toList();
    } catch (e) {
      debugPrint("Gagal mengambil antrean: $e");
      return [];
    }
  }

  static Future<bool> markAsDelivered(int itemId) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named('UPDATE bill_items SET is_delivered = TRUE WHERE id = @id'),
        parameters: {'id': itemId},
      );
      return true;
    } catch (e) {
      debugPrint("Gagal update status: $e");
      return false;
    }
  }
}
