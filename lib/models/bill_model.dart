class BillModel {
  final int id;
  final String customerName;
  final DateTime createdAt;
  final String status;
  final bool isAllDelivered; // Penanda apakah semua makanan sudah diantar

  BillModel({
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.status,
    this.isAllDelivered = true,
  });
}
