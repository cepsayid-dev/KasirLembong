class BillItemModel {
  final int id;
  final String uuid; // --- TAMBAHAN BARU ---
  final int menuId;
  final String menuName;
  final int qty;
  final double price;
  final String notes;
  final bool isDelivered;
  final bool isCancelled;
  final bool isPaid;

  BillItemModel({
    required this.id,
    this.uuid = '', // --- TAMBAHAN BARU ---
    required this.menuId,
    required this.menuName,
    required this.qty,
    required this.price,
    required this.notes,
    required this.isDelivered,
    required this.isCancelled,
    required this.isPaid,
  });

  double get totalPrice => qty * price;
}
