import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

import '../database/db_connection.dart';
import '../providers/bill_provider.dart';
import '../models/bill_model.dart'; // Impor model baru

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
}
