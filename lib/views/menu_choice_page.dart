import 'package:flutter/material.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';
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
  String _selectedCategory = 'Semua Menu';

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
    return _allMenus.where((menu) {
      if (_searchQuery.isNotEmpty &&
          !menu.name.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }
      if (_selectedCategory != 'Semua Menu' &&
          menu.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();
  }

  Map<String, List<MenuModel>> _groupMenus(List<MenuModel> menus) {
    Map<String, List<MenuModel>> grouped = {};
    for (var menu in menus) {
      List<String> currentWords = menu.name.trim().split(RegExp(r'\s+'));
      int maxMatch = 0;
      String bestPrefix = currentWords.first;

      for (var other in menus) {
        if (menu.id == other.id) continue;
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

  @override
  Widget build(BuildContext context) {
    final groupedMenus = _groupMenus(_filteredMenus);
    List<String> filterCategories = ['Semua Menu', ...allowedCategories];

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
                    itemCount: groupedMenus.length,
                    itemBuilder: (context, index) {
                      final category = groupedMenus.keys.elementAt(index);
                      final items = groupedMenus[category]!;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        elevation: 2,
                        child: ExpansionTile(
                          initiallyExpanded: _searchQuery.isNotEmpty,
                          title: Text(
                            category,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text('${items.length} varian menu'),
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
                              title: Text(menu.name),
                              subtitle: Row(
                                children: [
                                  Text('Rp ${menu.price.toInt()} | '),
                                  Text(
                                    displayStock,
                                    style: TextStyle(
                                      color: stockColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.add_circle,
                                color: Colors.blue,
                              ),
                              onTap: isClickable
                                  ? () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChoiceDetailPage(menu: menu),
                                        ),
                                      );

                                      if (mounted && _searchQuery.isNotEmpty) {
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
    );
  }
}
