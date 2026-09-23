import 'package:flutter/material.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';

class MasterMenuPage extends StatefulWidget {
  const MasterMenuPage({super.key});

  @override
  State<MasterMenuPage> createState() => _MasterMenuPageState();
}

class _MasterMenuPageState extends State<MasterMenuPage> {
  List<MenuModel> _menus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  Future<void> _loadMenus() async {
    setState(() => _isLoading = true);
    final menus = await MenuService.fetchMenus();
    if (!mounted) return;
    setState(() {
      _menus = menus;
      _isLoading = false;
    });
  }

  // Fungsi untuk menampilkan Pop-up Form (Tambah & Edit)
  void _showMenuForm({MenuModel? existingMenu}) {
    final isEdit = existingMenu != null;
    final nameController = TextEditingController(
      text: isEdit ? existingMenu.name : '',
    );
    final priceController = TextEditingController(
      text: isEdit ? existingMenu.price.toInt().toString() : '',
    );
    final stockQtyController = TextEditingController(
      text: isEdit ? existingMenu.stockQty.toString() : '0',
    );

    String trackingMode = isEdit ? existingMenu.trackingMode : 'numeric';
    String stockStatus = isEdit ? existingMenu.stockStatus : 'in_stock';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(isEdit ? 'Edit Menu' : 'Tambah Menu Baru'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Menu (Cth: Indomie Goreng)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga (Cth: 15000)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue:
                        trackingMode, // Sudah diperbaiki menjadi initialValue
                    decoration: const InputDecoration(
                      labelText: 'Mode Lacak Stok',
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'numeric',
                        child: Text('Angka/Kuantiti (numeric)'),
                      ),
                      DropdownMenuItem(
                        value: 'text',
                        child: Text('Teks Status (text)'),
                      ),
                    ],
                    onChanged: (val) =>
                        setDialogState(() => trackingMode = val!),
                  ),
                  const SizedBox(height: 12),

                  // Munculkan input angka jika mode numerik, dropdown jika mode teks
                  if (trackingMode == 'numeric')
                    TextField(
                      controller: stockQtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Jumlah Stok Saat Ini',
                      ),
                    )
                  else
                    DropdownButtonFormField<String>(
                      initialValue:
                          stockStatus, // Sudah diperbaiki menjadi initialValue
                      decoration: const InputDecoration(
                        labelText: 'Status Ketersediaan',
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
                          setDialogState(() => stockStatus = val!),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // Sudah dibungkus kurung kurawal
                  if (nameController.text.isEmpty ||
                      priceController.text.isEmpty) {
                    return;
                  }

                  final price = double.tryParse(priceController.text) ?? 0;
                  final qty = int.tryParse(stockQtyController.text) ?? 0;
                  bool success;

                  if (isEdit) {
                    success = await MenuService.updateMenu(
                      existingMenu.id,
                      nameController.text,
                      price,
                      trackingMode,
                      qty,
                      stockStatus,
                    );
                  } else {
                    success = await MenuService.addMenu(
                      nameController.text,
                      price,
                      trackingMode,
                      qty,
                      stockStatus,
                    );
                  }

                  // Sudah menggunakan context.mounted
                  if (success && context.mounted) {
                    Navigator.pop(context);
                    _loadMenus();
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _deleteMenu(int id, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Menu?'),
        content: Text('Yakin ingin menghapus $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await MenuService.deleteMenu(id);
      _loadMenus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Master Data Menu')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _menus.length,
              itemBuilder: (context, index) {
                final menu = _menus[index];

                // Menentukan tampilan stok berdasarkan mode
                String displayStock = menu.trackingMode == 'numeric'
                    ? 'Stok: ${menu.stockQty}'
                    : menu.stockStatus;

                return ListTile(
                  title: Text(
                    menu.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Rp ${menu.price.toInt()} | $displayStock'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showMenuForm(existingMenu: menu),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteMenu(menu.id, menu.name),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMenuForm,
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
