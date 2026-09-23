import 'package:flutter/foundation.dart';
import 'package:postgres/postgres.dart';

import '../database/db_connection.dart';
import '../models/menu_model.dart';

class MenuService {
  static Future<List<MenuModel>> fetchMenus({String keyword = ''}) async {
    try {
      final query = keyword.isEmpty
          ? 'SELECT id, name, price, tracking_mode, stock_qty, stock_status FROM menu_items ORDER BY name ASC'
          : "SELECT id, name, price, tracking_mode, stock_qty, stock_status FROM menu_items WHERE name ILIKE '%$keyword%' ORDER BY name ASC";

      // Tanda seru (!) dihapus disini
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
          ),
        );
      }
      return menus;
    } catch (e) {
      debugPrint("Error fetching menus: $e");
      return [];
    }
  }

  // FUNGSI BARU 1: Tambah Menu
  static Future<bool> addMenu(
    String name,
    double price,
    String trackingMode,
    int stockQty,
    String stockStatus,
  ) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named(
          "INSERT INTO menu_items (name, price, tracking_mode, stock_qty, stock_status) VALUES (@name, @price, @mode, @qty, @status)",
        ),
        parameters: {
          'name': name,
          'price': price,
          'mode': trackingMode,
          'qty': stockQty,
          'status': stockStatus,
        },
      );
      return true;
    } catch (e) {
      debugPrint("Gagal menambah menu: $e");
      return false;
    }
  }

  // FUNGSI BARU 2: Update Menu
  static Future<bool> updateMenu(
    int id,
    String name,
    double price,
    String trackingMode,
    int stockQty,
    String stockStatus,
  ) async {
    try {
      await DatabaseHelper.connection.execute(
        Sql.named(
          "UPDATE menu_items SET name = @name, price = @price, tracking_mode = @mode, stock_qty = @qty, stock_status = @status WHERE id = @id",
        ),
        parameters: {
          'id': id,
          'name': name,
          'price': price,
          'mode': trackingMode,
          'qty': stockQty,
          'status': stockStatus,
        },
      );
      return true;
    } catch (e) {
      debugPrint("Gagal update menu: $e");
      return false;
    }
  }

  // FUNGSI BARU 3: Hapus Menu
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
