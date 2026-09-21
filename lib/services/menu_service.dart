import 'package:flutter/foundation.dart';

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
}
