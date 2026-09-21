class CartItem {
  final int menuId;
  final String menuName;
  int qty;
  final double price;
  String notes;
  bool isCancelled; // Untuk coretan batal
  bool isDelivered; // Untuk ceklis dapur

  CartItem({
    required this.menuId,
    required this.menuName,
    this.qty = 1,
    required this.price,
    this.notes = '',
    this.isCancelled = false,
    this.isDelivered = false,
  });

  double get totalPrice => qty * price;
}
