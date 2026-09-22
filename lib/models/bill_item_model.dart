class BillItemModel {
  final int id;
  final int menuId;
  final String menuName;
  final int qty;
  final double price;
  final String notes;
  final bool isDelivered;
  final bool isCancelled;

  BillItemModel({
    required this.id,
    required this.menuId,
    required this.menuName,
    required this.qty,
    required this.price,
    required this.notes,
    required this.isDelivered,
    required this.isCancelled,
  });

  double get totalPrice => qty * price;
}
