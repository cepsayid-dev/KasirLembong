import 'package:flutter/material.dart';

import '../models/menu_model.dart';
import '../services/menu_service.dart';
import 'choice_detail_page.dart'; // Import halaman detail pesanan

class MenuChoicePage extends StatefulWidget {
  const MenuChoicePage({super.key});

  @override
  State<MenuChoicePage> createState() => _MenuChoicePageState();
}

class _MenuChoicePageState extends State<MenuChoicePage> {
  List<MenuModel> _menus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenus();
  }

  Future<void> _loadMenus([String keyword = '']) async {
    setState(() => _isLoading = true);
    final results = await MenuService.fetchMenus(keyword: keyword);
    setState(() {
      _menus = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _loadMenus,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: _menus.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Colors.black),
              itemBuilder: (context, index) {
                final menu = _menus[index];

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
                  if (menu.stockQty == 0) {
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
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  onTap: isClickable
                      ? () {
                          // Navigasi ke halaman detail dengan membawa data menu
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChoiceDetailPage(menu: menu),
                            ),
                          );
                        }
                      : null,
                );
              },
            ),
    );
  }
}
