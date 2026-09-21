class MenuModel {
  final int id;
  final String name;
  final double price;
  final String trackingMode;
  final int stockQty;
  final String stockStatus;

  MenuModel({
    required this.id,
    required this.name,
    required this.price,
    required this.trackingMode,
    required this.stockQty,
    required this.stockStatus,
  });

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map['id'] as int,
      name: map['name'] as String,
      price: double.parse(map['price'].toString()),
      trackingMode: map['tracking_mode'] as String? ?? 'numeric',
      stockQty: map['stock_qty'] as int? ?? 0,
      stockStatus: map['stock_status'] as String? ?? 'in_stock',
    );
  }
}
