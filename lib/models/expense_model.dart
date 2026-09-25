class ExpenseNote {
  final int id;
  final String type; // 'Biasa' atau 'Restok'
  final String description;
  final double amount;
  final String status; // 'Draft' (Belum datang) atau 'Lunas' (Sudah dibeli)
  final DateTime createdAt;

  ExpenseNote({
    required this.id,
    required this.type,
    required this.description,
    required this.amount,
    required this.status,
    required this.createdAt,
  });
}

class RestockItem {
  final int? id;
  final int menuId;
  final String menuName;
  final String trackingMode;
  int qty; // Untuk input barang numerik
  double price; // Untuk auto-complete harga
  String stockStatus; // Untuk barang teks (Tersedia/Habis)

  RestockItem({
    this.id,
    required this.menuId,
    required this.menuName,
    required this.trackingMode,
    this.qty = 0,
    this.price = 0,
    this.stockStatus = 'in_stock',
  });
}
