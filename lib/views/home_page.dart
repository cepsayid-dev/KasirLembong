import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/bill_model.dart';
import '../collections/local_shift.dart';
import '../collections/local_employee.dart';
import '../services/isar_service.dart';
import '../services/sync_service.dart';
import '../services/shift_service.dart';
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
  LocalShift? _activeShift;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isAutoSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _setupAutoSync();
    _triggerSilentSync(delaySeconds: 2);
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await _loadActiveShift();
    await _loadActiveBills();
  }

  Future<void> _loadActiveShift() async {
    final shift = await ShiftService.getActiveShift();
    if (mounted) {
      setState(() => _activeShift = shift);
    }
  }

  // --- FUNGSI INTI AUTO-SYNC ANTI-SPAM ---
  Future<void> _triggerSilentSync({int delaySeconds = 4}) async {
    if (_isAutoSyncing) return;

    final needsSync = await SyncService.hasUnsyncedData();
    if (!needsSync) return;

    final connectivityResult = await Connectivity().checkConnectivity();
    final hasConnection = connectivityResult.any(
      (r) => r != ConnectivityResult.none,
    );
    if (!hasConnection) return;

    _isAutoSyncing = true;
    await Future.delayed(Duration(seconds: delaySeconds));

    final success = await SyncService.syncAllToServer();
    _isAutoSyncing = false;

    if (success && mounted) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('☁️ Data offline otomatis tersinkron ke server!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _setupAutoSync() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((
      results,
    ) async {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        await _triggerSilentSync(delaySeconds: 4);
      }
    });
  }

  Future<void> _loadActiveBills() async {
    setState(() => _isLoading = true);
    await IsarService.checkAndAutoArchiveBills();
    final bills = await IsarService.fetchActiveBills();
    if (!mounted) return;
    setState(() {
      _activeBills = bills;
      _isLoading = false;
    });
  }

  // --- DIALOG 1: BUKA SHIFT BARU (MENDUKUNG ESTAFET MODAL DARI SHIFT LALU) ---
  Future<void> _showOpenShiftDialog({
    double? defaultOpeningCash,
    String? defaultSlot,
  }) async {
    var employees = await ShiftService.getEmployees();

    if (employees.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mengambil daftar pegawai dari server...'),
            duration: Duration(seconds: 1),
          ),
        );
      }
      await SyncService.pullEmployeesFromServer();
      employees = await ShiftService.getEmployees();
    }

    if (!mounted) return;
    if (employees.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Data pegawai kosong! Pastikan server nyala lalu tekan ikon Awan Biru.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    LocalEmployee selectedEmployee = employees.first;
    String selectedSlot = defaultSlot ?? 'Kasir 1';
    final pinController = TextEditingController();
    final openingCashController = TextEditingController(
      text: (defaultOpeningCash ?? 0).toInt().toString(),
    );

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              defaultOpeningCash != null
                  ? 'Mulai Shift Berikutnya (Estafet)'
                  : 'Mulai Shift Kasir',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedSlot,
                    decoration: const InputDecoration(
                      labelText: 'Posisi / Slot',
                    ),
                    items: ['Kasir 1', 'Kasir 2', 'Kasir 3']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedSlot = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<LocalEmployee>(
                    value: selectedEmployee,
                    decoration: const InputDecoration(
                      labelText: 'Nama Pegawai',
                    ),
                    items: employees
                        .map(
                          (e) =>
                              DropdownMenuItem(value: e, child: Text(e.name)),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedEmployee = val);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'PIN Pegawai',
                      hintText: 'Masukkan PIN rahasia',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: openingCashController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Modal Awal Laci (Rp)',
                      hintText: 'Uang kembalian di laci',
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  final openingCash =
                      double.tryParse(openingCashController.text) ?? 0;
                  final success = await ShiftService.openShift(
                    employee: selectedEmployee,
                    pinInput: pinController.text.trim(),
                    cashierSlot: selectedSlot,
                    openingCash: openingCash,
                  );

                  if (!context.mounted) return;
                  if (success) {
                    Navigator.pop(context);
                    await _loadActiveShift();
                    _triggerSilentSync(delaySeconds: 1);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '✅ Shift dimulai: $selectedSlot (${selectedEmployee.name})',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('❌ PIN salah! Silakan coba lagi.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: const Text('Buka Shift'),
              ),
            ],
          );
        },
      ),
    );
  }

  // --- DIALOG 2: CATAT UANG DIAMBIL OWNER ---
  void _showOwnerPickupDialog() {
    final amountController = TextEditingController();
    final notesController = TextEditingController(text: 'Diambil Owner');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Catat Pengambilan Uang Owner'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Nominal ini akan otomatis memotong hitungan sisa uang laci pada shift saat ini.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: 'Nominal Diambil (Rp)',
                prefixText: 'Rp ',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Catatan (Opsional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              final amount = double.tryParse(amountController.text) ?? 0;
              if (amount <= 0) return;

              final success = await ShiftService.recordOwnerPickup(
                amount: amount,
                notes: notesController.text.trim().isEmpty
                    ? 'Diambil Owner'
                    : notesController.text.trim(),
              );

              if (success && context.mounted) {
                Navigator.pop(context);
                _triggerSilentSync(delaySeconds: 1);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '💸 Tercatat: Owner ambil Rp ${amount.toInt()}',
                    ),
                    backgroundColor: Colors.orange.shade800,
                  ),
                );
              }
            },
            child: const Text('Simpan Catatan'),
          ),
        ],
      ),
    );
  }

  // --- DIALOG 3: TUTUP SHIFT OTOMATIS (+ PILIHAN LANJUT SHIFT LAIN) ---
  Future<void> _showAutoCloseShiftDialog() async {
    if (_activeShift == null) return;
    final summary = await ShiftService.calculateShiftSummary(_activeShift!);
    final endingCash = (summary['endingCash'] as double?) ?? 0;

    String nextSlot = 'Kasir 1';
    if (_activeShift!.cashierSlot == 'Kasir 1') {
      nextSlot = 'Kasir 2';
    } else if (_activeShift!.cashierSlot == 'Kasir 2') {
      nextSlot = 'Kasir 3';
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tutup Shift: ${_activeShift!.cashierSlot}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Petugas: ${_activeShift!.employeeName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20),
            _summaryRow('Modal Awal Laci', summary['openingCash'] ?? 0),
            _summaryRow(
              'Omzet Tunai (Cash)',
              summary['cashSales'] ?? 0,
              color: Colors.green,
            ),
            _summaryRow(
              'Kas Keluar Belanja',
              -(summary['operationalExpense'] ?? 0),
              color: Colors.red,
            ),
            _summaryRow(
              'Diambil Owner',
              -(summary['ownerPickup'] ?? 0),
              color: Colors.orange.shade800,
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sisa Uang di Laci:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  'Rp ${endingCash.toInt()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red.shade700,
              side: BorderSide(color: Colors.red.shade700),
            ),
            onPressed: () async {
              final success = await ShiftService.closeCurrentShiftAuto(
                _activeShift!,
              );
              if (success && context.mounted) {
                Navigator.pop(context);
                await _loadActiveShift();
                _triggerSilentSync(delaySeconds: 1);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🔒 Shift ditutup (Warkop Tutup).'),
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
              }
            },
            child: const Text('Tutup Saja'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: const Text('Lanjut Shift Lain'),
            onPressed: () async {
              final success = await ShiftService.closeCurrentShiftAuto(
                _activeShift!,
              );
              if (success && context.mounted) {
                Navigator.pop(context);
                await _loadActiveShift();
                _triggerSilentSync(delaySeconds: 1);
                _showOpenShiftDialog(
                  defaultOpeningCash: endingCash < 0 ? 0 : endingCash,
                  defaultSlot: nextSlot,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    double value, {
    Color color = Colors.black87,
  }) {
    final prefix = value < 0 ? '- Rp ' : 'Rp ';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13)),
          Text(
            '$prefix${value.abs().toInt()}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftBanner() {
    if (_activeShift == null) {
      return Material(
        color: Colors.amber.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Belum ada Shift Kasir aktif.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                ),
                onPressed: () => _showOpenShiftDialog(),
                child: const Text(
                  'Mulai Shift',
                  style: TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Material(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.person_pin, color: Colors.blue, size: 20),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '${_activeShift!.cashierSlot}: ${_activeShift!.employeeName}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            TextButton.icon(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange.shade900,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              ),
              icon: const Icon(Icons.payments_outlined, size: 16),
              label: const Text(
                'Owner Ambil',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              onPressed: () => _showOwnerPickupDialog(),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onPressed: () => _showAutoCloseShiftDialog(),
              child: const Text('Tutup Shift', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
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
                    content: Text('Menyinkronkan data & pegawai...'),
                  ),
                );

                await SyncService.pullEmployeesFromServer();
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
                _loadInitialData();
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
        body: Column(
          children: [
            _buildShiftBanner(),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBillList(unpaidBills, false),
                  _buildBillList(paidBills, true),
                ],
              ),
            ),
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
