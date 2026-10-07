import 'package:flutter/material.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';
import '../services/expense_service.dart';

class MasterMenuPage extends StatefulWidget {
  const MasterMenuPage({super.key});

  @override
  State<MasterMenuPage> createState() => _MasterMenuPageState();
}

class _MasterMenuPageState extends State<MasterMenuPage> {
  List<MenuModel> _allMenus = [];
  bool _isLoading = true;

  bool _isSelectionMode = false;
  final List<MenuModel> _selectedMenusForRestock = [];

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Semua Kategori';
  String _selectedSort = 'Abjad (A-Z)';

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
  void initState() {
    super.initState();
    _loadMenus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMenus() async {
    setState(() => _isLoading = true);
    final menus = await MenuService.fetchMenus();
    if (!mounted) return;
    setState(() {
      _allMenus = menus;
      _isLoading = false;
    });
  }

  List<MenuModel> get _processedMenus {
    List<MenuModel> list = _allMenus.where((menu) {
      if (_searchQuery.isNotEmpty &&
          !menu.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_selectedCategory != 'Semua Kategori' &&
          menu.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();

    if (_selectedSort == 'Stok Terdikit') {
      list.sort((a, b) {
        int valA = a.trackingMode == 'numeric'
            ? a.stockQty
            : (a.stockStatus == 'Out of Stock'
                  ? 0
                  : (a.stockStatus == 'Few Left' ? 5 : 999));
        int valB = b.trackingMode == 'numeric'
            ? b.stockQty
            : (b.stockStatus == 'Out of Stock'
                  ? 0
                  : (b.stockStatus == 'Few Left' ? 5 : 999));
        return valA.compareTo(valB);
      });
    } else if (_selectedSort == 'Stok Terbanyak') {
      list.sort((a, b) {
        int valA = a.trackingMode == 'numeric'
            ? a.stockQty
            : (a.stockStatus == 'Out of Stock'
                  ? 0
                  : (a.stockStatus == 'Few Left' ? 5 : 999));
        int valB = b.trackingMode == 'numeric'
            ? b.stockQty
            : (b.stockStatus == 'Out of Stock'
                  ? 0
                  : (b.stockStatus == 'Few Left' ? 5 : 999));
        return valB.compareTo(valA);
      });
    } else {
      list.sort((a, b) => a.name.compareTo(b.name));
    }

    return list;
  }

  Map<String, List<MenuModel>> _groupMenus(List<MenuModel> menus) {
    Map<String, List<MenuModel>> grouped = {};
    for (var menu in menus) {
      List<String> currentWords = menu.name.trim().split(RegExp(r'\s+'));
      int maxMatch = 0;
      String bestPrefix = currentWords.first;

      for (var other in menus) {
        if (menu.id == other.id) {
          continue;
        }
        List<String> otherWords = other.name.trim().split(RegExp(r'\s+'));
        int matchCount = 0;
        for (int i = 0; i < currentWords.length && i < otherWords.length; i++) {
          if (currentWords[i].toLowerCase() == otherWords[i].toLowerCase()) {
            matchCount++;
          } else {
            break;
          }
        }
        if (matchCount > maxMatch) {
          maxMatch = matchCount;
          bestPrefix = currentWords.take(matchCount).join(' ');
        }
      }
      grouped.putIfAbsent(bestPrefix, () => []).add(menu);
    }

    var sortedKeys = grouped.keys.toList()..sort();
    Map<String, List<MenuModel>> sortedGroup = {};
    for (var key in sortedKeys) {
      sortedGroup[key] = grouped[key]!;
    }
    return sortedGroup;
  }

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
    String category = 'Makanan';
    if (isEdit && allowedCategories.contains(existingMenu.category)) {
      category = existingMenu.category;
    }

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
                    decoration: const InputDecoration(labelText: 'Nama Menu'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Harga Jual'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: category,
                    decoration: const InputDecoration(
                      labelText: 'Kategori Manual',
                    ),
                    items: allowedCategories
                        .map(
                          (String cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                    onChanged: (val) => setDialogState(() => category = val!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: trackingMode,
                    decoration: const InputDecoration(
                      labelText: 'Mode Lacak Stok',
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
                    onChanged: (val) =>
                        setDialogState(() => trackingMode = val!),
                  ),
                  const SizedBox(height: 12),
                  if (trackingMode == 'numeric')
                    TextField(
                      controller: stockQtyController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Stok Saat Ini',
                      ),
                    )
                  else
                    DropdownButtonFormField<String>(
                      initialValue: stockStatus,
                      decoration: const InputDecoration(
                        labelText: 'Status Ketersediaan',
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
                  if (nameController.text.isEmpty ||
                      priceController.text.isEmpty) {
                    return;
                  }
                  final price = double.tryParse(priceController.text) ?? 0;
                  final qty = int.tryParse(stockQtyController.text) ?? 0;

                  bool success = isEdit
                      ? await MenuService.updateMenu(
                          existingMenu.id,
                          nameController.text,
                          price,
                          trackingMode,
                          qty,
                          stockStatus,
                          category,
                        )
                      : await MenuService.addMenu(
                          nameController.text,
                          price,
                          trackingMode,
                          qty,
                          stockStatus,
                          category,
                        );

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

  Widget _buildMenuTile(MenuModel menu) {
    String displayStock = menu.trackingMode == 'numeric'
        ? 'Stok: ${menu.stockQty}'
        : menu.stockStatus;
    final isSelected = _selectedMenusForRestock.contains(menu);

    Color stockColor = Colors.black;
    if (menu.trackingMode == 'numeric') {
      if (menu.stockQty <= 0) {
        stockColor = Colors.red;
      } else if (menu.stockQty <= 5) {
        stockColor = Colors.orange;
      } else {
        stockColor = Colors.green;
      }
    } else {
      if (menu.stockStatus == 'Out of Stock') {
        stockColor = Colors.red;
      } else if (menu.stockStatus == 'Few Left') {
        stockColor = Colors.orange;
      } else {
        stockColor = Colors.green;
      }
    }

    return ListTile(
      leading: _isSelectionMode
          ? Checkbox(
              value: isSelected,
              onChanged: (bool? val) {
                setState(() {
                  if (val == true) {
                    _selectedMenusForRestock.add(menu);
                  } else {
                    _selectedMenusForRestock.remove(menu);
                  }
                });
              },
            )
          : null,
      title: Text(
        menu.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rp ${menu.price.toInt()} | Kategori: ${menu.category}'),
          Text(
            displayStock,
            style: TextStyle(color: stockColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      isThreeLine: true,
      trailing: _isSelectionMode
          ? null
          : Row(
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
      onTap: _isSelectionMode
          ? () {
              setState(() {
                if (isSelected) {
                  _selectedMenusForRestock.remove(menu);
                } else {
                  _selectedMenusForRestock.add(menu);
                }
              });
            }
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final processedList = _processedMenus;
    List<String> filterCategories = ['Semua Kategori', ...allowedCategories];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isSelectionMode
              ? '${_selectedMenusForRestock.length} Dipilih'
              : 'Master Data Menu',
        ),
        actions: [
          if (_isSelectionMode)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() {
                _isSelectionMode = false;
                _selectedMenusForRestock.clear();
              }),
            )
          else
            IconButton(
              icon: const Icon(Icons.checklist),
              tooltip: 'Buat PO Belanja',
              onPressed: () => setState(() => _isSelectionMode = true),
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari menu master...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCategory,
                            isExpanded: true,
                            items: filterCategories
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(
                                      c,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedCategory = val!),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSort,
                            isExpanded: true,
                            items:
                                [
                                      'Abjad (A-Z)',
                                      'Stok Terdikit',
                                      'Stok Terbanyak',
                                    ]
                                    .map(
                                      (s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(
                                          s,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedSort = val!),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : processedList.isEmpty
                ? const Center(child: Text('Menu tidak ditemukan.'))
                : _selectedSort == 'Abjad (A-Z)'
                ? ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _groupMenus(processedList).length,
                    itemBuilder: (context, index) {
                      final groupedMenus = _groupMenus(processedList);
                      final groupName = groupedMenus.keys.elementAt(index);
                      final items = groupedMenus[groupName]!;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: 2,
                        child: ExpansionTile(
                          initiallyExpanded:
                              _searchQuery.isNotEmpty || _isSelectionMode,
                          title: Text(
                            groupName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          children: items
                              .map((menu) => _buildMenuTile(menu))
                              .toList(),
                        ),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: processedList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: 1,
                        child: _buildMenuTile(processedList[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: _isSelectionMode
          ? FloatingActionButton.extended(
              backgroundColor: Colors.blue,
              onPressed: () async {
                if (_selectedMenusForRestock.isEmpty) {
                  return;
                }
                final success = await ExpenseService.createDraftRestock(
                  _selectedMenusForRestock,
                );
                if (success && context.mounted) {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedMenusForRestock.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nota PO Belanja dibuat!')),
                  );
                }
              },
              icon: const Icon(
                Icons.shopping_cart_checkout,
                color: Colors.white,
              ),
              label: const Text(
                'Buat PO Restok',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : FloatingActionButton(
              onPressed: _showMenuForm,
              backgroundColor: Colors.black,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}
