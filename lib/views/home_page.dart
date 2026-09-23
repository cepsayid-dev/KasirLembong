import 'package:flutter/material.dart';

import '../models/bill_model.dart';
import '../services/bill_service.dart';
import 'bill_page.dart';
import 'order_page.dart'; // Impor halaman antrean dapur
import 'active_bill_page.dart';
import 'history_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BillModel> _activeBills = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadActiveBills();
  }

  Future<void> _loadActiveBills() async {
    setState(() => _isLoading = true);
    final bills = await BillService.fetchActiveBills();

    if (!mounted) return; // Mencegah warning context saat async

    setState(() {
      _activeBills = bills;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nota Aktif',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.kitchen), // Tombol akses ke Dapur (Tab O)
          tooltip: 'Antrean Dapur',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderPage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.receipt_long,
            ), // Tombol baru untuk Riwayat/Laporan
            tooltip: 'Laporan Hari Ini',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadActiveBills,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _activeBills.isEmpty
          ? const Center(
              child: Text(
                'Belum ada pesanan aktif',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _activeBills.length,
              itemBuilder: (context, index) {
                final bill = _activeBills[index];
                final isPaid = bill.status == 'paid'; // Cek apakah sudah lunas

                final timeString =
                    "${bill.createdAt.hour.toString().padLeft(2, '0')}:${bill.createdAt.minute.toString().padLeft(2, '0')}";

                return Card(
                  // Jika lunas = Hijau, jika belum = Merah
                  color: isPaid ? Colors.green.shade100 : Colors.red.shade100,
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: isPaid ? Colors.green : Colors.red,
                      child: Text(
                        '${bill.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      'A.N: ${bill.customerName}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jam Order: $timeString'),
                        // Tambahkan teks status kecil di bawah jam
                        Text(
                          isPaid ? 'LUNAS (Menunggu Dapur)' : 'BELUM BAYAR',
                          style: TextStyle(
                            color: isPaid
                                ? Colors.green.shade800
                                : Colors.red.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActiveBillPage(bill: bill),
                        ),
                      );

                      if (result == true && mounted) {
                        _loadActiveBills();
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Buka nota kosong, lalu refresh halaman setelah kembali dari halaman Bill
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BillPage()),
          ).then((_) => _loadActiveBills());
        },
        backgroundColor: Colors.black,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}
