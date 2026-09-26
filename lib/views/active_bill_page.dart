import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bill_model.dart';
import '../models/bill_item_model.dart';
import '../services/bill_service.dart';
import '../providers/bill_provider.dart';
import '../services/print_service.dart'; // Tambahkan import Print Service
import 'menu_choice_page.dart';

class ActiveBillPage extends StatefulWidget {
  final BillModel bill;

  const ActiveBillPage({super.key, required this.bill});

  @override
  State<ActiveBillPage> createState() => _ActiveBillPageState();
}

class _ActiveBillPageState extends State<ActiveBillPage> {
  List<BillItemModel> _items = [];
  bool _isLoading = true;
  String _paymentMethod = 'Cash'; // Default metode pembayaran

  @override
  void initState() {
    super.initState();
    _loadItems();
    // Memastikan keranjang Provider kosong saat halaman pertama dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillProvider>(context, listen: false).clearBill();
    });
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

  Future<void> _handleCancelItem(
    int itemId,
    String menuName,
    bool isDelivered,
  ) async {
    final pesanTeks = isDelivered
        ? 'Item ini SUDAH DIANTAR. Yakin ingin membatalkan/retur pesanan ini? Tagihan akan hangus.'
        : 'Yakin ingin mencoret $menuName dari nota? Dapur tidak akan memasak pesanan ini.';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: Text(pesanTeks),
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

  // FUNGSI CHECKOUT YANG DIPERBARUI
  Future<void> _handleCheckout() async {
    // JIKA QRIS: Langsung bayar tanpa pop-up input uang
    if (_paymentMethod == 'QRIS') {
      final success = await BillService.checkoutBill(widget.bill.id, 'QRIS');

      // Hentikan eksekusi jika halaman sudah keburu ditutup
      if (!mounted) return;

      if (success) {
        _showSuccessPrintDialog(totalTagihan, totalTagihan, 0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memproses pembayaran.')),
        );
      }
      return;
    }

    // JIKA CASH: Tampilkan Pop-up input uang pelanggan
    final cashController = TextEditingController(
      text: totalTagihan.toInt().toString(),
    );
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Pembayaran Tunai'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Tagihan: Rp ${totalTagihan.toInt()}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cashController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Uang Diterima (Rp)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final cashAmount = double.tryParse(cashController.text) ?? 0;

              if (cashAmount < totalTagihan) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Uang kurang dari tagihan!')),
                );
                return;
              }

              final success = await BillService.checkoutBill(
                widget.bill.id,
                'Cash',
              );
              if (success && context.mounted) {
                Navigator.pop(context); // Tutup pop-up input uang
                final kembalian = cashAmount - totalTagihan;
                _showSuccessPrintDialog(totalTagihan, cashAmount, kembalian);
              }
            },
            child: const Text('LUNASKAN'),
          ),
        ],
      ),
    );
  }

  // FUNGSI POP-UP KEMBALIAN & CETAK STRUK
  void _showSuccessPrintDialog(double total, double cash, double change) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 8),
            Text('Lunas!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Kembalian:', style: TextStyle(fontSize: 16)),
            Text(
              'Rp ${change.toInt()}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          // TOMBOL 1: Selesai Tanpa Cetak
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog ini
              Navigator.pop(context, true); // Kembali ke halaman utama (Home)
            },
            child: const Text(
              'Selesai',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          // TOMBOL 2: Cetak Struk
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              PrintService.printReceipt(
                bill: widget.bill,
                items: _items,
                totalAmount: total,
                cashAmount: cash,
                changeAmount: change,
              );
              // Tidak menutup dialog otomatis agar kasir bisa klik 'Selesai' jika ngeprint sudah beres
            },
            icon: const Icon(Icons.print),
            label: const Text('Cetak Struk'),
          ),
        ],
      ),
    );
  }

  double get totalTagihan {
    return _items
        .where((item) => !item.isCancelled)
        .fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    final billProvider = Provider.of<BillProvider>(context);

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
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        // --- 1. DAFTAR ITEM LAMA (Dari Database) ---
                        ..._items.map((item) {
                          final textStyle = TextStyle(
                            fontSize: 16,
                            decoration: item.isCancelled
                                ? TextDecoration.lineThrough
                                : null,
                            color: item.isCancelled
                                ? Colors.grey
                                : Colors.black,
                          );

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 4,
                            ),
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
                                if (!item.isCancelled) ...[
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.cancel,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _handleCancelItem(
                                      item.id,
                                      item.menuName,
                                      item.isDelivered,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        }),

                        // --- 2. BLOK ITEM TAMBAHAN (Belum Disimpan) ---
                        if (billProvider.items.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              border: Border.all(
                                color: Colors.blue.shade200,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    Icon(
                                      Icons.new_releases,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Pesanan Tambahan',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(color: Colors.blue),
                                ...billProvider.items.map(
                                  (newItem) => ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: const CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                    title: Text(
                                      '${newItem.qty}x ${newItem.menuName}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: newItem.notes.isNotEmpty
                                        ? Text(newItem.notes)
                                        : null,
                                    trailing: Text(
                                      'Rp ${newItem.totalPrice.toInt()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () =>
                                            billProvider.clearBill(),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: const Text('Batal'),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 2,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          final success =
                                              await BillService.addItemsToBill(
                                                widget.bill.id,
                                                billProvider.items,
                                              );
                                          if (success) {
                                            billProvider.clearBill();
                                            _loadItems(); // Refresh daftar utama
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Pesanan tambahan dikirim ke Dapur!',
                                                      ),
                                                    ),
                                                  );
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text(
                                          'Simpan & Masak',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // --- 3. PANEL PEMBAYARAN ---
                if (widget.bill.status == 'unpaid')
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

                        // Pemilihan Cash / QRIS menggunakan UI bawaan Anda sebelumnya
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
                            onPressed:
                                (_items.isEmpty ||
                                    billProvider.items.isNotEmpty)
                                ? null
                                : _handleCheckout,
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
                  )
                else
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.green.shade100,
                    child: const Text(
                      'NOTA SUDAH LUNAS\nMenunggu sisa pesanan diselesaikan oleh Dapur.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MenuChoicePage()),
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add_shopping_cart, color: Colors.white),
      ),
    );
  }
}
