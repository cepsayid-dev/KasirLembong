class OrderModel {
  final int id;
  final String customerName;
  final DateTime orderDate;
  final String status;
  final double totalAmount;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.orderDate,
    required this.status,
    required this.totalAmount,
  });

  // Konversi dari Record PostgreSQL ke Object Flutter
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] as int,
      customerName: map['customer_name'] as String,
      orderDate: DateTime.parse(map['order_date'].toString()),
      status: map['status'],
      totalAmount: double.parse(map['total_amount'].toString()),
    );
  }
}
