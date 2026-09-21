import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/menu_model.dart';
import '../models/cart_item_model.dart';
import '../providers/bill_provider.dart';

class ChoiceDetailPage extends StatefulWidget {
  final MenuModel menu;

  const ChoiceDetailPage({super.key, required this.menu});

  @override
  State<ChoiceDetailPage> createState() => _ChoiceDetailPageState();
}

class _ChoiceDetailPageState extends State<ChoiceDetailPage> {
  int _qty = 1;
  String _tempType = 'Hot';
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                widget.menu.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Qty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_qty > 1) setState(() => _qty--);
                      },
                      icon: const Icon(Icons.remove_circle_outline, size: 30),
                    ),
                    Text(
                      '$_qty',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _qty++),
                      icon: const Icon(Icons.add_circle_outline, size: 30),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(color: Colors.black, height: 30),

            const Text(
              'H/D',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Solusi pengganti RadioListTile yang deprecated
            SizedBox(
              width: double.infinity,
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment<String>(value: 'Hot', label: Text('Hot')),
                  ButtonSegment<String>(value: 'Cold', label: Text('Cold')),
                ],
                selected: {_tempType},
                onSelectionChanged: (Set<String> newSelection) {
                  setState(() {
                    _tempType = newSelection.first;
                  });
                },
              ),
            ),
            const Divider(color: Colors.black, height: 30),

            const Text(
              'Note:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Cth: Jangan terlalu manis, ekstra es...',
              ),
            ),

            const Spacer(),

            SizedBox(
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
                  final finalNotes = "[$_tempType] ${_notesController.text}"
                      .trim();

                  final item = CartItem(
                    menuId: widget.menu.id,
                    menuName: widget.menu.name,
                    price: widget.menu.price,
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
                      content: Text(
                        '${widget.menu.name} ditambahkan ke tagihan',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Add',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
