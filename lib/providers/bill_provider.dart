import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';

class BillProvider extends ChangeNotifier {
  String customerName = '';
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void setCustomerName(String name) {
    customerName = name;
    notifyListeners();
  }

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  double get totalBill {
    double total = 0;
    for (var item in _items) {
      if (!item.isCancelled) {
        total += item.totalPrice;
      }
    }
    return total;
  }

  void clearBill() {
    customerName = '';
    _items.clear();
    notifyListeners();
  }
}
