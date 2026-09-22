import 'package:flutter/material.dart';

import 'dart:async';

import '../models/pending_order_model.dart';
import '../services/order_service.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<PendingOrder> _allOrders = [];
  bool _isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadOrders();
    // Memperbarui UI setiap 1 menit agar warna waktu (SLA) otomatis berubah
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadOrders() async {
    setState(() => _isLoading = true);
    final orders = await OrderService.fetchPendingOrders();
    if (!mounted) return;
    setState(() {
      _allOrders = orders;
      _isLoading = false;
    });
  }

  Future<void> _handleCheck(int itemId, String menuName) async {
    final success = await OrderService.markAsDelivered(itemId);
    if (!mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$menuName selesai!'),
          duration: const Duration(seconds: 1),
        ),
      );
      _loadOrders();
    }
  }

  // Menentukan warna SLA berdasarkan selisih waktu
  Color _getSlaColor(DateTime createdAt) {
    final minutes = DateTime.now().difference(createdAt).inMinutes;
    if (minutes >= 15) return Colors.red.shade100; // Terlambat
    if (minutes >= 10) return Colors.orange.shade100; // Warning
    return Colors.green.shade50; // Aman
  }

  // Membuat widget untuk setiap Tab (Makanan atau Minuman)
  Widget _buildOrderView(String category) {
    // 1. Filter pesanan berdasarkan kategori
    final categoryOrders = _allOrders
        .where((o) => o.category == category)
        .toList();

    if (categoryOrders.isEmpty) {
      return const Center(
        child: Text('Antrean Kosong', style: TextStyle(fontSize: 16)),
      );
    }

    // 2. Buat Rekap Total (Summary) untuk Batch Cooking
    Map<String, int> summary = {};
    for (var order in categoryOrders) {
      String key = order.notes.isEmpty
          ? order.menuName
          : "${order.menuName} (${order.notes})";
      summary[key] = (summary[key] ?? 0) + order.qty;
    }

    // 3. Kelompokkan pesanan berdasarkan ID Nota
    Map<int, List<PendingOrder>> groupedByBill = {};
    for (var order in categoryOrders) {
      groupedByBill.putIfAbsent(order.billId, () => []).add(order);
    }

    return Column(
      children: [
        // BAGIAN ATAS: REKAP TOTAL (SUMMARY)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Colors.blueGrey.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'REKAP TOTAL (MASAK MASSAL)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: summary.entries
                    .map(
                      (entry) => Chip(
                        backgroundColor: Colors.black,
                        label: Text(
                          '${entry.value}x ${entry.key}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: Colors.black),

        // BAGIAN BAWAH: DAFTAR PER NOTA
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: groupedByBill.length,
            itemBuilder: (context, index) {
              int billId = groupedByBill.keys.elementAt(index);
              List<PendingOrder> billItems = groupedByBill[billId]!;

              // Gunakan waktu pembuatan dari item pertama di nota tersebut
              DateTime billTime = billItems.first.createdAt;
              int waitTime = DateTime.now().difference(billTime).inMinutes;
              String customer = billItems.first.customerName == 'Guest'
                  ? ''
                  : ' - ${billItems.first.customerName}';

              return Card(
                color: _getSlaColor(billTime),
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Nota
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nota #$billId$customer',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '$waitTime mnt lalu',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.black26),

                      // Rincian Item di dalam Nota ini
                      ...billItems.map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Text(
                              '${item.qty}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            item.menuName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: item.notes.isNotEmpty
                              ? Text(
                                  item.notes,
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                )
                              : null,
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.check_box_outline_blank,
                              size: 30,
                            ),
                            onPressed: () =>
                                _handleCheck(item.itemId, item.menuName),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Antrean Dapur (O)'),
          centerTitle: true,
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadOrders),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            tabs: [
              Tab(text: 'MAKANAN'),
              Tab(text: 'MINUMAN'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildOrderView('Makanan'),
                  _buildOrderView('Minuman'),
                ],
              ),
      ),
    );
  }
}
