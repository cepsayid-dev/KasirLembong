import 'package:flutter/foundation.dart';

import '../database/db_connection.dart';
import '../models/order_model.dart';

class OrderService {
  static Future<List<OrderModel>> fetchOrders() async {
    try {
      final results = await DatabaseHelper.connection.execute(
        'SELECT id, customer_name, order_date, status, total_amount FROM orders ORDER BY id DESC',
      );

      List<OrderModel> orders = [];
      for (final row in results) {
        orders.add(
          OrderModel(
            id: row[0] as int,
            customerName: row[1] as String,
            orderDate: DateTime.parse(row[2].toString()),
            status: row[3] as String,
            totalAmount: double.parse(row[4].toString()),
          ),
        );
      }
      return orders;
    } catch (e) {
      debugPrint("Error fetching orders: $e");
      return [];
    }
  }
}
