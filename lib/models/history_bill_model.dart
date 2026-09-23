class HistoryBill {
  final int id;
  final String customerName;
  final DateTime createdAt;
  final String paymentMethod;
  final double totalAmount;

  HistoryBill({
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.paymentMethod,
    required this.totalAmount,
  });
}
