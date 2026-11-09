import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../database/isar_helper.dart';
import '../collections/local_menu.dart';
import '../models/menu_model.dart';

class MenuService {
  static final Isar _isar = IsarHelper.isar;

  static Future<List<MenuModel>> fetchMenus({String keyword = ''}) async {
    try {
      List<LocalMenu> results;

      if (keyword.isEmpty) {
        // Ambil semua menu dan urutkan berdasarkan nama
        results = await _isar.localMenus.where().sortByName().findAll();
      } else {
        // Filter berdasarkan kata kunci
        results = await _isar.localMenus
            .filter()
            .nameContains(keyword, caseSensitive: false)
            .sortByName()
            .findAll();
      }

      return results
          .map(
            (row) => MenuModel(
              id: row.id,
              name: row.name,
              price: row.price,
              trackingMode: row.trackingMode,
              stockQty: row.stockQty,
              stockStatus: row.stockStatus,
              category: row.category,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint("Error fetching menus dari Isar: $e");
      return [];
    }
  }

  static Future<bool> addMenu(
    String name,
    double price,
    String trackingMode,
    int stockQty,
    String stockStatus,
    String category,
  ) async {
    try {
      final newMenu = LocalMenu()
        ..name = name
        ..price = price
        ..trackingMode = trackingMode
        ..stockQty = stockQty
        ..stockStatus = stockStatus
        ..category = category
        ..isSynced = false;

      await _isar.writeTxn(() async {
        await _isar.localMenus.put(newMenu);
      });
      return true;
    } catch (e) {
      debugPrint("Gagal menambah menu ke Isar: $e");
      return false;
    }
  }

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
      final menu = await _isar.localMenus.get(id);
      if (menu != null) {
        menu.name = name;
        menu.price = price;
        menu.trackingMode = trackingMode;
        menu.stockQty = stockQty;
        menu.stockStatus = stockStatus;
        menu.category = category;
        menu.isSynced = false;

        await _isar.writeTxn(() async {
          await _isar.localMenus.put(menu);
        });
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Gagal update menu di Isar: $e");
      return false;
    }
  }

  static Future<bool> deleteMenu(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.localMenus.delete(id);
      });
      return true;
    } catch (e) {
      debugPrint("Gagal hapus menu dari Isar: $e");
      return false;
    }
  }
}
