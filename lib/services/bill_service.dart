import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart'; // Wajib ditambahkan untuk Sql.named

import '../database/db_connection.dart';
import '../providers/bill_provider.dart';

class BillService {
  static Future<bool> saveBill(BillProvider provider) async {
    try {
      // 1. Simpan ke tabel induk (bills) menggunakan Sql.named
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

      // 2. Simpan seluruh item keranjang ke tabel anak (bill_items) menggunakan Sql.named
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
}
