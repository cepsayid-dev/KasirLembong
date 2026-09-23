import 'package:flutter/foundation.dart';

import '../database/db_connection.dart';
import '../models/history_bill_model.dart';

class HistoryService {
  static Future<List<HistoryBill>> fetchTodayHistory() async {
    try {
      final results = await DatabaseHelper.connection.execute(r"""
        SELECT b.id, b.customer_name, b.created_at, b.payment_method, 
               COALESCE(SUM(bi.qty * bi.price), 0) as grand_total
        FROM bills b
        LEFT JOIN bill_items bi ON b.id = bi.bill_id AND bi.is_cancelled = FALSE
        WHERE b.status = 'paid' 
        GROUP BY b.id, b.customer_name, b.created_at, b.payment_method
        ORDER BY b.created_at DESC
        """);

      return results
          .map(
            (row) => HistoryBill(
              id: row[0] as int,
              customerName: row[1] as String? ?? 'Guest',
              createdAt: row[2] as DateTime,
              paymentMethod: row[3] as String? ?? 'Cash',
              totalAmount: double.parse(row[4].toString()),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint("Gagal mengambil riwayat: $e");
      return [];
    }
  }
}
