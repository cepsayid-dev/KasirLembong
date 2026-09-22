class BillModel {
  final int id;
  final String customerName;
  final DateTime createdAt;
  final String status;

  BillModel({
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.status,
  });
}
