import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

import '../database/db_connection.dart';
import '../models/menu_model.dart';

class MenuService {
  static Future<List<MenuModel>> fetchMenus({String keyword = ''}) async {
    try {
      // TAMBAHAN: Memanggil kolom 'category' dari database
      final query = keyword.isEmpty
          ? 'SELECT id, name, price, tracking_mode, stock_qty, stock_status, category FROM menu_items ORDER BY name ASC'
          : "SELECT id, name, price, tracking_mode, stock_qty, stock_status, category FROM menu_items WHERE name ILIKE '%$keyword%' ORDER BY name ASC";

      final results = await DatabaseHelper.connection.execute(query);

      List<MenuModel> menus = [];
      for (final row in results) {
        menus.add(
          MenuModel(
            id: row[0] as int,
            name: row[1] as String,
            price: double.parse(row[2].toString()),
            trackingMode: row[3] as String,
            stockQty: row[4] as int,
            stockStatus: row[5] as String,
            category: row[6] as String? ?? 'Makanan', // Ambil data kategori
          ),
        );
      }
      return menus;
    } catch (e) {
      debugPrint("Error fetching menus: $e");
      return [];
    }
  }

  // TAMBAHAN: Parameter 'category' disisipkan ke database
  static Future<bool> addMenu(
    String name,
    double price,
    String trackingMode,
    int stockQty,
    String stockStatus,
    String category,
  ) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named(
          "INSERT INTO menu_items (name, price, tracking_mode, stock_qty, stock_status, category) VALUES (@name, @price, @mode, @qty, @status, @category)",
        ),
        parameters: {
          'name': name,
          'price': price,
          'mode': trackingMode,
          'qty': stockQty,
          'status': stockStatus,
          'category': category,
        },
      );
      return true;
    } catch (e) {
      debugPrint("Gagal menambah menu: $e");
      return false;
    }
  }

  // TAMBAHAN: Update parameter 'category'
  static Future<bool> updateMenu(
    int id,
    String name,
    double price,
    String trackingMode,
    int stockQty,
    String stockStatus,
    String category,
  ) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named(
          "UPDATE menu_items SET name = @name, price = @price, tracking_mode = @mode, stock_qty = @qty, stock_status = @status, category = @category WHERE id = @id",
        ),
        parameters: {
          'id': id,
          'name': name,
          'price': price,
          'mode': trackingMode,
          'qty': stockQty,
          'status': stockStatus,
          'category': category,
        },
      );
      return true;
    } catch (e) {
      debugPrint("Gagal update menu: $e");
      return false;
    }
  }

  static Future<bool> deleteMenu(int id) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named("DELETE FROM menu_items WHERE id = @id"),
        parameters: {'id': id},
      );
      return true;
    } catch (e) {
      debugPrint("Gagal hapus menu: $e");
      return false;
    }
  }
}
