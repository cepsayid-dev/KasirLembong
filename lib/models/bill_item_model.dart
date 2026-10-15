class BillItemModel {
  final int id;
  final int menuId;
  final String menuName;
  final int qty;
  final double price;
  final String notes;
  final bool isDelivered;
  final bool isCancelled;
  final bool isPaid; // VARIABEL BARU

  BillItemModel({
    required this.id,
    required this.menuId,
    required this.menuName,
    required this.qty,
    required this.price,
    required this.notes,
    required this.isDelivered,
    required this.isCancelled,
    required this.isPaid, // VARIABEL BARU
  });

  double get totalPrice => qty * price;
}
