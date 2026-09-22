import 'package:flutter/material.dart';

import '../models/bill_model.dart';
import '../models/bill_item_model.dart';
import '../services/bill_service.dart';

class ActiveBillPage extends StatefulWidget {
  final BillModel bill;

  const ActiveBillPage({super.key, required this.bill});

  @override
  State<ActiveBillPage> createState() => _ActiveBillPageState();
}

class _ActiveBillPageState extends State<ActiveBillPage> {
  List<BillItemModel> _items = [];
  bool _isLoading = true;
  String _paymentMethod = 'Cash';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    final items = await BillService.getBillItems(widget.bill.id);
    if (!mounted) return;
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  Future<void> _handleCancelItem(int itemId, String menuName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: Text(
          'Yakin ingin mencoret $menuName dari nota? Dapur tidak akan memasak pesanan ini.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Ya, Batalkan',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await BillService.cancelItem(itemId);
      if (success && mounted) _loadItems();
    }
  }

  Future<void> _handleCheckout() async {
    final success = await BillService.checkoutBill(
      widget.bill.id,
      _paymentMethod,
    );
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pembayaran Berhasil! Nota ditutup.')),
      );
      Navigator.pop(
        context,
        true,
      ); // Kembali ke Home Page dan bawa nilai 'true'
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memproses pembayaran.')),
      );
    }
  }

  // Hitung total tagihan hanya dari item yang tidak dicancel
  double get totalTagihan {
    return _items
        .where((item) => !item.isCancelled)
        .fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nota #${widget.bill.id} - ${widget.bill.customerName}'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: _items.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      // Logika tampilan untuk pesanan yang dicoret
                      final textStyle = TextStyle(
                        fontSize: 16,
                        decoration: item.isCancelled
                            ? TextDecoration.lineThrough
                            : null,
                        color: item.isCancelled ? Colors.grey : Colors.black,
                      );

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: item.isCancelled
                              ? Colors.grey
                              : (item.isDelivered
                                    ? Colors.green
                                    : Colors.orange),
                          child: Icon(
                            item.isCancelled
                                ? Icons.block
                                : (item.isDelivered
                                      ? Icons.check
                                      : Icons.outdoor_grill),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          '${item.qty}x ${item.menuName}',
                          style: textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: item.notes.isNotEmpty
                            ? Text(item.notes, style: textStyle)
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ${item.totalPrice.toInt()}',
                              style: textStyle,
                            ),
                            if (!item.isCancelled && !item.isDelivered) ...[
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onPressed: () =>
                                    _handleCancelItem(item.id, item.menuName),
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Panel Pembayaran (Bawah)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade50,
                    border: const Border(
                      top: BorderSide(color: Colors.black26),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Tagihan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Rp ${totalTagihan.toInt()}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                            value: 'Cash',
                            label: Text('Tunai (Cash)'),
                          ),
                          ButtonSegment(value: 'QRIS', label: Text('QRIS')),
                        ],
                        selected: {_paymentMethod},
                        onSelectionChanged: (set) =>
                            setState(() => _paymentMethod = set.first),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _items.isEmpty ? null : _handleCheckout,
                          child: const Text(
                            'BAYAR SEKARANG',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
