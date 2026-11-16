import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/bill_model.dart';
import '../services/isar_service.dart';
import '../services/sync_service.dart';
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

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isAutoSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadActiveBills();
    _setupAutoSync();
    // Cek langsung saat aplikasi baru dibuka (barangkali ada sisa data offline)
    _triggerSilentSync(delaySeconds: 2);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  // --- FUNGSI INTI AUTO-SYNC ANTI-SPAM ---
  Future<void> _triggerSilentSync({int delaySeconds = 4}) async {
    if (_isAutoSyncing) return;

    // 1. Cek apakah ada data baru yang belum di-sync
    final needsSync = await SyncService.hasUnsyncedData();
    if (!needsSync) {
      debugPrint("AutoSync: Tidak ada data baru, skip.");
      return;
    }

    // 2. Cek status koneksi saat ini
    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = connectivityResult.any(
      (r) => r != ConnectivityResult.none,
    );
    if (!hasConnection) {
      debugPrint("AutoSync: Masih offline, menunggu koneksi...");
      return;
    }

    _isAutoSyncing = true;
    debugPrint(
      "AutoSync: Menunggu $delaySeconds detik agar jaringan stabil...",
    );
    await Future.delayed(Duration(seconds: delaySeconds));

    final success = await SyncService.syncAllToServer();
    _isAutoSyncing = false;

    if (success && mounted) {
      debugPrint("AutoSync: BERHASIL!");
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('☁️ Data offline otomatis tersinkron ke server!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      debugPrint("AutoSync: Gagal terhubung ke server (Silent Fail).");
    }
  }

  void _setupAutoSync() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        debugPrint("AutoSync: Perubahan jaringan terdeteksi -> Online");
        await _triggerSilentSync(delaySeconds: 4);
      }
    });
  }

  Future<void> _loadActiveBills() async {
    setState(() => _isLoading = true);

    await IsarService.checkAndAutoArchiveBills();

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
                        _triggerSilentSync(delaySeconds: 1);
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
                _triggerSilentSync(delaySeconds: 1);
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
              icon: const Icon(Icons.cloud_upload, color: Colors.blue),
              tooltip: 'Sync Manual ke Server',
              onPressed: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menyinkronkan data ke server...'),
                  ),
                );

                final success = await SyncService.syncAllToServer();

                if (mounted) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? '✅ Berhasil Sync!'
                            : '❌ Gagal Sync! Cek koneksi server.',
                      ),
                      backgroundColor: success ? Colors.green : Colors.red,
                    ),
                  );
                }
              },
            ),
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
              onPressed: () {
                _loadActiveBills();
                _triggerSilentSync(delaySeconds: 1);
              },
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
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ExpensePage(),
                    ),
                  );
                  if (mounted) {
                    _triggerSilentSync(delaySeconds: 1);
                  }
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
              _triggerSilentSync(delaySeconds: 1);
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
