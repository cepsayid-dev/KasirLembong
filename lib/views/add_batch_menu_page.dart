import 'package:flutter/material.dart';

import '../services/menu_service.dart';
import '../services/sync_service.dart';

class _MenuFormRow {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController(
    text: '0',
  );
  String category;
  String trackingMode;
  String stockStatus;

  _MenuFormRow({
    this.category = 'Makanan',
    this.trackingMode = 'numeric',
    this.stockStatus = 'in_stock',
  });

  void dispose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
  }
}

class AddBatchMenuPage extends StatefulWidget {
  const AddBatchMenuPage({super.key});

  @override
  State<AddBatchMenuPage> createState() => _AddBatchMenuPageState();
}

class _AddBatchMenuPageState extends State<AddBatchMenuPage> {
  final List<_MenuFormRow> _rows = [_MenuFormRow()];
  bool _isSaving = false;

  final List<String> allowedCategories = [
    'Makanan',
    'Minuman',
    'Snack',
    'Topping',
    'Rokok',
    'Rasa Goreng',
    'Rasa Rebus',
    'Lainnya',
  ];

  @override
  void dispose() {
    for (var row in _rows) {
      row.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() {
      final lastRow = _rows.isNotEmpty ? _rows.last : null;
      _rows.add(
        _MenuFormRow(
          category: lastRow?.category ?? 'Makanan',
          trackingMode: lastRow?.trackingMode ?? 'numeric',
          stockStatus: lastRow?.stockStatus ?? 'in_stock',
        ),
      );
    });
  }

  void _removeRow(int index) {
    if (_rows.length <= 1) return;
    setState(() {
      _rows[index].dispose();
      _rows.removeAt(index);
    });
  }

  Future<void> _saveAllMenus() async {
    final validItems = [];

    for (int i = 0; i < _rows.length; i++) {
      final row = _rows[i];
      final name = row.nameController.text.trim();
      final priceText = row.priceController.text.trim();

      if (name.isEmpty && priceText.isEmpty && _rows.length > 1) {
        continue;
      }

      if (name.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Baris #${i + 1}: Nama menu wajib diisi!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final price = double.tryParse(priceText) ?? 0;
      if (price <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Baris #${i + 1} ($name): Harga jual harus lebih dari 0!',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final qty = int.tryParse(row.stockController.text.trim()) ?? 0;

      validItems.add({
        'name': name,
        'price': price,
        'trackingMode': row.trackingMode,
        'qty': row.trackingMode == 'numeric' ? qty : 0,
        'stockStatus': row.trackingMode == 'text'
            ? row.stockStatus
            : 'in_stock',
        'category': row.category,
      });
    }

    if (validItems.isEmpty) return;

    setState(() => _isSaving = true);

    try {
      int savedCount = 0;
      for (var item in validItems) {
        final ok = await MenuService.addMenu(
          item['name'],
          item['price'],
          item['trackingMode'],
          item['qty'],
          item['stockStatus'],
          item['category'],
          autoSync: false,
        );
        if (ok) savedCount++;
      }

      // Langsung kirim semua menu baru ke server dalam 1 request
      final synced = await SyncService.syncMenusToServer();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            synced
                ? '✅ $savedCount menu tersimpan & otomatis tersinkron ke server!'
                : '✅ $savedCount menu tersimpan offline (akan sync saat online).',
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menyimpan menu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Menu Baru',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            onPressed: _addRow,
            icon: const Icon(Icons.add_circle, color: Colors.blue),
            label: const Text(
              'Baris',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
        itemCount: _rows.length + 1,
        itemBuilder: (context, index) {
          if (index == _rows.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.blue, width: 1.5),
                ),
                onPressed: _addRow,
                icon: const Icon(Icons.add),
                label: const Text(
                  'Tambah Baris Menu Lainnya',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          final row = _rows[index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Menu #${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.blueGrey,
                        ),
                      ),
                      if (_rows.length > 1)
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          tooltip: 'Hapus baris ini',
                          onPressed: () => _removeRow(index),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: row.nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            labelText: 'Nama Menu',
                            hintText: 'Cth: Kopi Susu Gula Aren',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: row.priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Harga Jual',
                            prefixText: 'Rp ',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: row.category,
                          decoration: const InputDecoration(
                            labelText: 'Kategori Manual',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: allowedCategories
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => row.category = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: row.trackingMode,
                          decoration: const InputDecoration(
                            labelText: 'Mode Lacak Stok',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'numeric',
                              child: Text('Angka (numeric)'),
                            ),
                            DropdownMenuItem(
                              value: 'text',
                              child: Text('Teks (text)'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => row.trackingMode = val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (row.trackingMode == 'numeric')
                    TextField(
                      controller: row.stockController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok Saat Ini',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    )
                  else
                    DropdownButtonFormField<String>(
                      value: row.stockStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status Ketersediaan',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'in_stock',
                          child: Text('Tersedia'),
                        ),
                        DropdownMenuItem(
                          value: 'Few Left',
                          child: Text('Sisa Sedikit'),
                        ),
                        DropdownMenuItem(
                          value: 'Out of Stock',
                          child: Text('Habis'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => row.stockStatus = val);
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: SizedBox(
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              onPressed: _isSaving ? null : _saveAllMenus,
              icon: _isSaving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                _isSaving
                    ? 'Menyimpan...'
                    : 'SIMPAN SEMUA (${_rows.length} MENU)',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
