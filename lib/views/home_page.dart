import 'package:flutter/material.dart';

import '../models/bill_model.dart';
import '../services/isar_service.dart'; // MENGGUNAKAN ISAR
import 'active_bill_page.dart';
import 'history_page.dart';
import 'master_menu_page.dart';
import 'order_page.dart';
import 'expense_page.dart';
import 'bill_page.dart';

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

    // JALANKAN PENGECEKAN AUTO-ARCHIVE TERLEBIH DAHULU
    await IsarService.checkAndAutoArchiveBills();

    // MENGGUNAKAN ISAR
    final bills = await IsarService.fetchActiveBills();
    if (!mounted) {
      return;
    }
    setState(() {
      _activeBills = bills;
      _isLoading = false;
    });
  }

  Widget _buildBillList(List<BillModel> bills, bool isPaidTab) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (bills.isEmpty) {
      return Center(
        child: Text(
          isPaidTab
              ? 'Belum ada nota lunas & diantar yang siap diarsip.'
              : 'Belum ada pesanan aktif.',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: bills.length,
      itemBuilder: (context, index) {
        final bill = bills[index];
        final timeString =
            "${bill.createdAt.hour.toString().padLeft(2, '0')}:${bill.createdAt.minute.toString().padLeft(2, '0')}";

        String statusLabel = 'BELUM BAYAR';
        Color cardColor = Colors.red.shade100;
        Color badgeColor = Colors.red;

        if (bill.status == 'paid' && !bill.isAllDelivered) {
          statusLabel = 'LUNAS (Masih Dimasak Dapur)';
          cardColor = Colors.orange.shade100;
          badgeColor = Colors.orange;
        } else if (bill.status == 'paid' && bill.isAllDelivered) {
          statusLabel = 'LUNAS & DIANTAR (Open)';
          cardColor = Colors.green.shade100;
          badgeColor = Colors.green;
        }

        return Card(
          color: cardColor,
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12.0),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            leading: CircleAvatar(
              backgroundColor: badgeColor,
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
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jam Order: $timeString'),
                Text(
                  statusLabel,
                  style: TextStyle(
                    color: badgeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            trailing: isPaidTab
                ? ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.archive, size: 18),
                    label: const Text('Arsipkan'),
                    onPressed: () async {
                      // MENGGUNAKAN ISAR
                      final success = await IsarService.archiveBill(bill.id);
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Nota #${bill.id} masuk ke Arsip Omzet!',
                            ),
                          ),
                        );
                        _loadActiveBills();
                      }
                    },
                  )
                : const Icon(Icons.arrow_forward_ios, size: 20),

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
    );
  }

  @override
  Widget build(BuildContext context) {
    final unpaidBills = _activeBills
        .where((b) => b.status == 'unpaid' || !b.isAllDelivered)
        .toList();

    final paidBills = _activeBills
        .where((b) => b.status == 'paid' && b.isAllDelivered)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dashboard Kasir',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.kitchen),
              tooltip: 'Antrean Dapur',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderPage()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.receipt_long),
              tooltip: 'Laporan Hari Ini',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryPage()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadActiveBills,
            ),
          ],
          bottom: const TabBar(
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            tabs: [
              Tab(text: 'BELUM LUNAS / DAPUR'),
              Tab(text: 'LUNAS (OPEN)'),
            ],
          ),
        ),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.black87),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.storefront, color: Colors.white, size: 40),
                    SizedBox(height: 12),
                    Text(
                      'POS Warkop Lembong',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.fastfood),
                title: const Text(
                  'Master Data Menu',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MasterMenuPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.money_off, color: Colors.red),
                title: const Text(
                  'Kas Keluar (Belanja)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExpensePage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        body: TabBarView(
          children: [
            _buildBillList(unpaidBills, false),
            _buildBillList(paidBills, true),
          ],
        ),

        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BillPage()),
            );
            if (result == true && mounted) {
              _loadActiveBills();
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
