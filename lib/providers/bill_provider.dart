import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';

class BillProvider extends ChangeNotifier {
  String customerName = '';
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // Mengubah nama pelanggan (A.N)
  void setCustomerName(String name) {
    customerName = name;
    notifyListeners();
  }

  // Menambah menu ke nota
  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  // Menghitung total tagihan saat ini
  double get totalBill {
    double total = 0;
    for (var item in _items) {
      if (!item.isCancelled) {
        total += item.totalPrice;
      }
    }
    return total;
  }

  // Mereset nota setelah disimpan
  void clearBill() {
    customerName = '';
    _items.clear();
    notifyListeners();
  }
}
