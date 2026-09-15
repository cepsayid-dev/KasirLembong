import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Default di posisi 'O' (Orders)
  late Future<List<OrderModel>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _refreshOrders();
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = OrderService.fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Header', style: TextStyle(fontSize: 14)),
            Text(
              'Page Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada pesanan'));
          }

          final orders = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(8.0),
            itemCount: orders.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final item = orders[index];
              final formattedDate =
                  "${item.orderDate.day}/${item.orderDate.month}/${item.orderDate.year}";
              final isCompleted = item.status.toLowerCase() == 'completed';

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.8),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      // Kolom Nomor (No)
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.black),
                          ),
                        ),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Kolom Tengah (A.N | D/M/Y & Order List)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black),
                                ),
                              ),
                              child: Text(
                                'A.N: ${item.customerName} | $formattedDate',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Order List',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Kolom Status (Indikator Lingkaran Merah/Hijau)
                      Container(
                        width: 60,
                        decoration: const BoxDecoration(
                          border: Border(left: BorderSide(color: Colors.black)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(fontSize: 10),
                            ),
                            const SizedBox(height: 4),
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: isCompleted
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // Floating Action Button (+)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Akan dihubungkan ke Menu Choice / Buat Pesanan
        },
        child: const Icon(Icons.add, size: 30),
      ),
      // Bottom Navigation Bar (B, O, A, S)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Text(
              'B',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            label: 'Bill',
          ),
          BottomNavigationBarItem(
            icon: Text(
              'O',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Text(
              'A',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            label: 'Archive',
          ),
          BottomNavigationBarItem(
            icon: Text(
              'S',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            label: 'Stock',
          ),
        ],
      ),
    );
  }
}
