import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_model.dart';
import '../models/cart_item_model.dart';
import '../providers/bill_provider.dart';
import '../services/menu_service.dart';

class ChoiceDetailPage extends StatefulWidget {
  final MenuModel menu;

  const ChoiceDetailPage({super.key, required this.menu});

  @override
  State<ChoiceDetailPage> createState() => _ChoiceDetailPageState();
}

class _ChoiceDetailPageState extends State<ChoiceDetailPage> {
  int _qty = 1;
  final TextEditingController _notesController = TextEditingController();

  String _tempType = 'Hot';
  String _mieType = 'Goreng';

  List<MenuModel> _varianRasaList = [];
  String? _selectedRasa;

  final Map<String, double> _toppingBerbayar = {
    'Kornet': 10000,
    'Baso': 5000,
    'Sosis': 5000,
    'Keju': 5000,
    'Telur 1/2 Matang': 5000,
    'Telur Matang': 5000,
  };
  final List<String> _selectedPaidToppings = [];

  final List<String> _toppingGratis = ['Sayur', 'Cabe', 'Chili Oil'];
  final List<String> _selectedFreeToppings = [];

  @override
  void initState() {
    super.initState();
    if (isIndomie) {
      _loadVarianRasa();
    }
  }

  Future<void> _loadVarianRasa() async {
    final menus = await MenuService.fetchMenus();
    if (!mounted) return;
    setState(() {
      _varianRasaList = menus
          .where(
            (m) => m.category == 'Rasa Goreng' || m.category == 'Rasa Rebus',
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get isMinuman => widget.menu.category == 'Minuman';
  bool get isIndomie =>
      widget.menu.name.toLowerCase().contains('indomi') ||
      widget.menu.name.toLowerCase().contains('mie');
  bool get isNasi => widget.menu.name.toLowerCase().contains('nasi');

  double get currentUnitPrice {
    double basePrice = widget.menu.price;
    double toppingPrice = 0;
    for (var top in _selectedPaidToppings) {
      toppingPrice += _toppingBerbayar[top]!;
    }
    return basePrice + toppingPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan'), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      widget.menu.name,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jumlah Qty',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (_qty > 1) {
                                setState(() => _qty--);
                              }
                            },
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              size: 30,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            '$_qty',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            onPressed: () => setState(() => _qty++),
                            icon: const Icon(
                              Icons.add_circle_outline,
                              size: 30,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.black, height: 30),

                  if (isMinuman) ...[
                    const Text(
                      'Penyajian (H/D)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment<String>(
                            value: 'Hot',
                            label: Text('Hot / Panas'),
                          ),
                          ButtonSegment<String>(
                            value: 'Cold',
                            label: Text('Cold / Dingin (+Es)'),
                          ),
                        ],
                        selected: {_tempType},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() => _tempType = newSelection.first);
                        },
                      ),
                    ),
                    const Divider(color: Colors.black, height: 30),
                  ],

                  if (isIndomie) ...[
                    const Text(
                      'Jenis Mie',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment<String>(
                            value: 'Goreng',
                            label: Text('Goreng'),
                          ),
                          ButtonSegment<String>(
                            value: 'Rebus',
                            label: Text('Rebus'),
                          ),
                        ],
                        selected: {_mieType},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _mieType = newSelection.first;
                            _selectedRasa = null;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      'Pilih Rasa (Sesuai Stok)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    Builder(
                      builder: (context) {
                        final currentRasaList = _varianRasaList
                            .where((m) => m.category == 'Rasa $_mieType')
                            .toList();

                        if (_varianRasaList.isEmpty) {
                          return const Text('Memuat varian rasa...');
                        }
                        if (currentRasaList.isEmpty) {
                          return Text(
                            'Belum ada varian rasa untuk Mie $_mieType di Master Menu.',
                          );
                        }

                        return Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: currentRasaList.map((rasa) {
                            bool isAvailable = true;
                            if (rasa.trackingMode == 'text' &&
                                rasa.stockStatus == 'Out of Stock') {
                              isAvailable = false;
                            }
                            if (rasa.trackingMode == 'numeric' &&
                                rasa.stockQty <= 0) {
                              isAvailable = false;
                            }

                            return ChoiceChip(
                              label: Text(
                                rasa.name + (isAvailable ? '' : ' (Habis)'),
                              ),
                              selected: _selectedRasa == rasa.name,
                              selectedColor: Colors.orange.shade300,
                              disabledColor: Colors.grey.shade300,
                              onSelected: isAvailable
                                  ? (bool selected) {
                                      setState(() {
                                        _selectedRasa = selected
                                            ? rasa.name
                                            : null;
                                      });
                                    }
                                  : null,
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const Divider(color: Colors.black, height: 30),
                  ],

                  if (isIndomie || isNasi) ...[
                    const Text(
                      'Topping Berbayar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: _toppingBerbayar.keys.map((String key) {
                        final isSelected = _selectedPaidToppings.contains(key);
                        return FilterChip(
                          label: Text(
                            '$key (+${_toppingBerbayar[key]!.toInt()})',
                          ),
                          selected: isSelected,
                          selectedColor: Colors.blue.shade100,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedPaidToppings.add(key);
                              } else {
                                _selectedPaidToppings.remove(key);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      'Topping Gratis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: _toppingGratis.map((String key) {
                        final isSelected = _selectedFreeToppings.contains(key);
                        return FilterChip(
                          label: Text(key),
                          selected: isSelected,
                          selectedColor: Colors.green.shade100,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedFreeToppings.add(key);
                              } else {
                                _selectedFreeToppings.remove(key);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const Divider(color: Colors.black, height: 30),
                  ],

                  const Text(
                    'Catatan Tambahan:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Cth: Jangan terlalu manis, pedas mampus...',
                    ),
                  ),
                ],
              ),
            ),
          ),

          Container(
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
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  List<String> finalNotesList = [];

                  if (isMinuman) {
                    finalNotesList.add("[$_tempType]");
                  }

                  if (isIndomie) {
                    String mieInfo = "[$_mieType";
                    if (_selectedRasa != null) {
                      mieInfo += " - $_selectedRasa";
                    }
                    mieInfo += "]";
                    finalNotesList.add(mieInfo);
                  }

                  if (_selectedPaidToppings.isNotEmpty) {
                    finalNotesList.add(
                      "+Topping: ${_selectedPaidToppings.join(', ')}",
                    );
                  }

                  if (_selectedFreeToppings.isNotEmpty) {
                    finalNotesList.add(
                      "+Gratis: ${_selectedFreeToppings.join(', ')}",
                    );
                  }

                  if (_notesController.text.isNotEmpty) {
                    finalNotesList.add("Catatan: ${_notesController.text}");
                  }

                  final finalNotes = finalNotesList.join(" | ");

                  final item = CartItem(
                    menuId: widget.menu.id,
                    menuName: widget.menu.name,
                    price: currentUnitPrice,
                    qty: _qty,
                    notes: finalNotes,
                  );

                  Provider.of<BillProvider>(
                    context,
                    listen: false,
                  ).addItem(item);
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${widget.menu.name} ditambahkan ke nota!'),
                    ),
                  );
                },
                child: Text(
                  'TAMBAH - Rp ${(currentUnitPrice * _qty).toInt()}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
