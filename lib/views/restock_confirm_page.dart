import 'package:flutter/material.dart';

import '../models/expense_model.dart';
import '../services/expense_service.dart';

class RestockConfirmPage extends StatefulWidget {
  final ExpenseNote note;

  const RestockConfirmPage({super.key, required this.note});

  @override
  State<RestockConfirmPage> createState() => _RestockConfirmPageState();
}

class _RestockConfirmPageState extends State<RestockConfirmPage> {
  List<RestockItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  Future<void> _loadItems() async {
    final items = await ExpenseService.fetchDraftItems(widget.note.id);
    if (mounted) {
      setState(() {
        _items = items;
        _isLoading = false;
      });
    }
  }

  Future<void> _submitRestock() async {
    // Tampilkan loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => const Center(child: CircularProgressIndicator()),
    );

    final success = await ExpenseService.confirmRestock(widget.note.id, _items);

    if (mounted) {
      Navigator.pop(context); // Tutup loading
      if (success) {
        Navigator.pop(
          context,
          true,
        ); // Kembali ke halaman sebelumnya dengan status true (sukses)
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan konfirmasi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Barang Datang')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.menuName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),

                        // Input berdasarkan tracking mode
                        if (item.trackingMode == 'numeric')
                          TextFormField(
                            initialValue: item.qty.toString(),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Jumlah Datang (Qty)',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (val) =>
                                item.qty = int.tryParse(val) ?? 0,
                          )
                        else
                          DropdownButtonFormField<String>(
                            initialValue: item.stockStatus,
                            decoration: const InputDecoration(
                              labelText: 'Status Ketersediaan Saat Ini',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'in_stock',
                                child: Text('Tersedia (in_stock)'),
                              ),
                              DropdownMenuItem(
                                value: 'Few Left',
                                child: Text('Sisa Sedikit (Few Left)'),
                              ),
                              DropdownMenuItem(
                                value: 'Out of Stock',
                                child: Text('Habis (Out of Stock)'),
                              ),
                            ],
                            onChanged: (val) =>
                                item.stockStatus = val ?? 'in_stock',
                          ),

                        const SizedBox(height: 12),
                        TextFormField(
                          initialValue: item.price.toInt().toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Total Harga Beli Item Ini (Rp)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          onChanged: (val) =>
                              item.price = double.tryParse(val) ?? 0,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: _items.isEmpty ? null : _submitRestock,
          child: const Text(
            'SIMPAN & UPDATE STOK',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
