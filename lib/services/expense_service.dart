import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

import '../database/db_connection.dart';
import '../models/expense_model.dart';
import '../models/menu_model.dart';

class ExpenseService {
  // 1. Inisialisasi Tabel Pintar
  static Future<void> initTables() async {
    try {
      // Tabel Kertas Nota Pengeluaran
      await DatabaseHelper.connection.execute('''
        CREATE TABLE IF NOT EXISTS expense_notes (
          id SERIAL PRIMARY KEY,
          type VARCHAR(50) DEFAULT 'Biasa', 
          description TEXT NOT NULL,
          amount NUMERIC DEFAULT 0,
          status VARCHAR(50) DEFAULT 'Lunas', 
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''');

      // Tabel Isi Belanjaan Restok
      await DatabaseHelper.connection.execute('''
        CREATE TABLE IF NOT EXISTS expense_items (
          id SERIAL PRIMARY KEY,
          note_id INT NOT NULL,
          menu_id INT NOT NULL,
          menu_name VARCHAR(255) NOT NULL,
          tracking_mode VARCHAR(50) DEFAULT 'numeric',
          qty INT DEFAULT 0,
          price NUMERIC DEFAULT 0
        )
      ''');
    } catch (e) {
      debugPrint("Gagal membuat tabel pengeluaran: $e");
    }
  }

  // 2. Mengambil Semua Nota Pengeluaran
  static Future<List<ExpenseNote>> fetchExpenseNotes() async {
    try {
      await initTables();
      final results = await DatabaseHelper.connection.execute(
        "SELECT id, type, description, amount, status, created_at FROM expense_notes ORDER BY created_at DESC",
      );

      return results
          .map(
            (row) => ExpenseNote(
              id: row[0] as int,
              type: row[1] as String,
              description: row[2] as String,
              amount: double.parse(row[3].toString()),
              status: row[4] as String,
              createdAt: row[5] as DateTime,
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // 3. Tambah Pengeluaran Biasa (Satu-satu seperti Beli Gas/Parkir)
  static Future<bool> addGeneralExpense(
    String description,
    double amount,
  ) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named(
          "INSERT INTO expense_notes (type, description, amount, status) VALUES ('Biasa', @desc, @amount, 'Lunas')",
        ),
        parameters: {'desc': description, 'amount': amount},
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // 4. BUAT DRAFT LIST BELANJA (PO)
  static Future<bool> createDraftRestock(List<MenuModel> selectedMenus) async {
    try {
      // Buat Notanya dulu
      final result = await DatabaseHelper.connection.execute(
        "INSERT INTO expense_notes (type, description, amount, status) VALUES ('Restok', 'Draft Belanja Restok', 0, 'Draft') RETURNING id",
      );
      final noteId = result.first[0] as int;

      // Masukkan list barang yang mau dibeli
      for (var menu in selectedMenus) {
        // Cek harga beli terakhir untuk fitur auto-complete!
        final priceResult = await DatabaseHelper.connection.execute(
          Sql.named(
            "SELECT price FROM expense_items WHERE menu_id = @id ORDER BY id DESC LIMIT 1",
          ),
          parameters: {'id': menu.id},
        );
        double lastPrice = priceResult.isEmpty
            ? 0
            : double.parse(priceResult.first[0].toString());

        await DatabaseHelper.connection.execute(
          Sql.named(
            "INSERT INTO expense_items (note_id, menu_id, menu_name, tracking_mode, qty, price) VALUES (@noteId, @menuId, @menuName, @mode, 0, @price)",
          ),
          parameters: {
            'noteId': noteId,
            'menuId': menu.id,
            'menuName': menu.name,
            'mode': menu.trackingMode,
            'price': lastPrice, // Terisi otomatis dengan harga beli sebelumnya!
          },
        );
      }
      return true;
    } catch (e) {
      debugPrint("Gagal buat draft restok: $e");
      return false;
    }
  }

  // 5. MENGAMBIL RINCIAN BARANG DARI NOTA DRAFT
  static Future<List<RestockItem>> fetchDraftItems(int noteId) async {
    try {
      final results = await DatabaseHelper.connection.execute(
        Sql.named(
          "SELECT id, menu_id, menu_name, tracking_mode, qty, price FROM expense_items WHERE note_id = @id",
        ),
        parameters: {'id': noteId},
      );
      return results
          .map(
            (row) => RestockItem(
              id: row[0] as int,
              menuId: row[1] as int,
              menuName: row[2] as String,
              trackingMode: row[3] as String,
              qty: row[4] as int,
              price: double.parse(row[5].toString()),
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  // 6. KONFIRMASI BARANG DATANG (UPDATE STOK & LUNASKAN NOTA)
  static Future<bool> confirmRestock(
    int noteId,
    List<RestockItem> items,
  ) async {
    try {
      double totalAmount = 0;

      for (var item in items) {
        totalAmount += item.price; // Hitung total seluruh belanja

        // A. Update rincian harga aktual di nota
        await DatabaseHelper.connection.execute(
          Sql.named(
            "UPDATE expense_items SET qty = @qty, price = @price WHERE id = @id",
          ),
          parameters: {'id': item.id, 'qty': item.qty, 'price': item.price},
        );

        // B. UPDATE STOK MASTER MENU OTOMATIS
        if (item.trackingMode == 'numeric') {
          await DatabaseHelper.connection.execute(
            Sql.named(
              "UPDATE menu_items SET stock_qty = stock_qty + @qty WHERE id = @id",
            ),
            parameters: {'id': item.menuId, 'qty': item.qty},
          );
        } else {
          await DatabaseHelper.connection.execute(
            Sql.named(
              "UPDATE menu_items SET stock_status = @status WHERE id = @id",
            ),
            parameters: {
              'id': item.menuId,
              'status': item.stockStatus,
            }, // Update teks jadi 'Tersedia' dsb
          );
        }
      }

      // C. Tutup nota menjadi Lunas dan set nominal pengeluaran aslinya
      await DatabaseHelper.connection.execute(
        Sql.named(
          "UPDATE expense_notes SET status = 'Lunas', amount = @amount, description = 'Restok Selesai' WHERE id = @id",
        ),
        parameters: {'id': noteId, 'amount': totalAmount},
      );

      return true;
    } catch (e) {
      debugPrint("Gagal konfirmasi restok: $e");
      return false;
    }
  }

  // 7. Hapus Nota
  static Future<bool> deleteNote(int id) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named("DELETE FROM expense_items WHERE note_id = @id"),
        parameters: {'id': id},
      );
      await DatabaseHelper.connection.execute(
        Sql.named("DELETE FROM expense_notes WHERE id = @id"),
        parameters: {'id': id},
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
