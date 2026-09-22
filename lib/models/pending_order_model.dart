class PendingOrder {
  final int itemId;
  final int billId;
  final String customerName;
  final String menuName;
  final int qty;
  final String notes;
  final DateTime createdAt;
  final String category;

  PendingOrder({
    required this.itemId,
    required this.billId,
    required this.customerName,
    required this.menuName,
    required this.qty,
    required this.notes,
    required this.createdAt,
    required this.category,
  });
}
