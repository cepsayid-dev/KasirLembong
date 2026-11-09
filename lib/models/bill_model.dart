class BillModel {
  final int id;
  final String uuid; // --- TAMBAHAN BARU ---
  final String customerName;
  final DateTime createdAt;
  final String status;
  final bool isAllDelivered;

  BillModel({
    required this.id,
    this.uuid = '', // --- TAMBAHAN BARU (Beri default kosong agar file UI lain tidak error) ---
    required this.customerName,
    required this.createdAt,
    required this.status,
    this.isAllDelivered = true,
  });
}
