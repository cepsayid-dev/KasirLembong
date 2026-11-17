import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';
import '../providers/bill_provider.dart';
import 'choice_detail_page.dart';

class MenuChoicePage extends StatefulWidget {
  const MenuChoicePage({super.key});

  @override
  State<MenuChoicePage> createState() => _MenuChoicePageState();
}

class _MenuChoicePageState extends State<MenuChoicePage> {
  List<MenuModel> _allMenus = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'Semua Kategori';

  final List<String> allowedCategories = [
    'Makanan',
    'Minuman',
    'Snack',
    'Topping',
    'Rokok',
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
    final results = await MenuService.fetchMenus();
    if (!mounted) return;
    setState(() {
      _allMenus = results
          .where(
            (m) => m.category != 'Rasa Goreng' && m.category != 'Rasa Rebus',
          )
          .toList();
      _isLoading = false;
    });
  }

  List<MenuModel> get _filteredMenus {
    final list = _allMenus.where((menu) {
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

    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  // Kelompokkan menu berdasarkan Kategori (seragam dengan MasterMenuPage)
  Map<String, List<MenuModel>> _groupMenusByCategory(List<MenuModel> menus) {
    final Map<String, List<MenuModel>> grouped = {};

    for (final cat in allowedCategories) {
      final itemsInCat = menus.where((m) => m.category == cat).toList();
      if (itemsInCat.isNotEmpty) {
        grouped[cat] = itemsInCat;
      }
    }

    for (final menu in menus) {
      if (!allowedCategories.contains(menu.category)) {
        final fallbackCat = menu.category.trim().isEmpty
            ? 'Lainnya'
            : menu.category;
        grouped.putIfAbsent(fallbackCat, () => []).add(menu);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final groupedMenus = _groupMenusByCategory(_filteredMenus);
    final List<String> filterCategories = [
      'Semua Kategori',
      ...allowedCategories,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Pesanan'), centerTitle: true),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Cari menu...',
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
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
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
                        icon: const Icon(Icons.filter_list),
                        items: filterCategories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c, overflow: TextOverflow.ellipsis),
                              ),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setState(() => _selectedCategory = val!),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : groupedMenus.isEmpty
                ? const Center(child: Text('Menu tidak ditemukan.'))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: groupedMenus.length,
                    itemBuilder: (context, index) {
                      final categoryName = groupedMenus.keys.elementAt(index);
                      final items = groupedMenus[categoryName]!;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: 2,
                        child: ExpansionTile(
                          key: PageStorageKey<String>(
                            'choice_cat_${categoryName}_${_searchQuery}_$_selectedCategory',
                          ),
                          initiallyExpanded:
                              _searchQuery.isNotEmpty ||
                              _selectedCategory != 'Semua Kategori',
                          title: Row(
                            children: [
                              Text(
                                categoryName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${items.length}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          children: items.map((menu) {
                            String displayStock = "";
                            Color stockColor = Colors.black;
                            bool isClickable = true;

                            if (menu.trackingMode == 'text') {
                              displayStock = menu.stockStatus;
                              if (menu.stockStatus == 'Out of Stock') {
                                stockColor = Colors.red;
                                isClickable = false;
                              } else if (menu.stockStatus == 'Few Left') {
                                stockColor = Colors.orange;
                              } else {
                                stockColor = Colors.green;
                              }
                            } else if (menu.trackingMode == 'numeric') {
                              displayStock = 'Stok: ${menu.stockQty}';
                              if (menu.stockQty <= 0) {
                                stockColor = Colors.red;
                                isClickable = false;
                              } else if (menu.stockQty <= 5) {
                                stockColor = Colors.orange;
                              } else {
                                stockColor = Colors.green;
                              }
                            }

                            return ListTile(
                              title: Text(
                                menu.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text('Rp ${menu.price.toInt()}  •  '),
                                  Text(
                                    displayStock,
                                    style: TextStyle(
                                      color: stockColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Icon(
                                Icons.add_circle,
                                color: isClickable ? Colors.blue : Colors.grey,
                              ),
                              onTap: isClickable
                                  ? () async {
                                      await showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (context) =>
                                            ChoiceDetailSheet(menu: menu),
                                      );

                                      if (context.mounted &&
                                          _searchQuery.isNotEmpty) {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      }
                                    }
                                  : null,
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: Consumer<BillProvider>(
        builder: (context, billProvider, child) {
          if (billProvider.items.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'LIHAT NOTA (${billProvider.items.length} ITEM) - Rp ${billProvider.totalBill.toInt()}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
