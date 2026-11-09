import 'package:flutter/material.dart';

import '../models/history_bill_model.dart';
import '../models/bill_model.dart';
import '../models/expense_model.dart'; // <-- TAMBAHAN
import '../services/history_service.dart';
import '../services/expense_service.dart'; // <-- TAMBAHAN
import 'active_bill_page.dart';

// Helper class untuk menampung pemasukan dan pengeluaran per hari
class DailyRecord {
  final List<HistoryBill> bills = [];
  final List<ExpenseNote> expenses = [];
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Map<int, Map<int, Map<int, DailyRecord>>> _groupedData = {};
  bool _isLoading = true;

  final List<String> _monthNames = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);

    // Ambil data Pemasukan (Nota) dan Pengeluaran (Lunas) sekaligus
    final allHistory = await HistoryService.fetchTodayHistory();
    final allExpenses = await ExpenseService.fetchExpenseNotes();

    Map<int, Map<int, Map<int, DailyRecord>>> grouped = {};

    // 1. Masukkan data Pemasukan (Omzet)
    for (var bill in allHistory) {
      int year = bill.createdAt.year;
      int month = bill.createdAt.month;
      int day = bill.createdAt.day;

      grouped.putIfAbsent(year, () => {});
      grouped[year]!.putIfAbsent(month, () => {});
      grouped[year]![month]!.putIfAbsent(day, () => DailyRecord());

      grouped[year]![month]![day]!.bills.add(bill);
    }

    // 2. Masukkan data Pengeluaran (Hanya yang statusnya Lunas)
    final lunasExpenses = allExpenses
        .where((e) => e.status == 'Lunas')
        .toList();
    for (var exp in lunasExpenses) {
      int year = exp.createdAt.year;
      int month = exp.createdAt.month;
      int day = exp.createdAt.day;

      grouped.putIfAbsent(year, () => {});
      grouped[year]!.putIfAbsent(month, () => {});
      grouped[year]![month]!.putIfAbsent(day, () => DailyRecord());

      grouped[year]![month]![day]!.expenses.add(exp);
    }

    if (mounted) {
      setState(() {
        _groupedData = grouped;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Arsip & Omzet',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _groupedData.isEmpty
          ? const Center(
              child: Text('Belum ada riwayat transaksi atau pengeluaran.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _groupedData.length,
              itemBuilder: (context, yearIndex) {
                int year = _groupedData.keys.elementAt(yearIndex);
                Map<int, Map<int, DailyRecord>> monthsData =
                    _groupedData[year]!;

                // Hitung Total Tahunan
                double yearlyOmzet = 0;
                double yearlyExpense = 0;
                for (var days in monthsData.values) {
                  for (var record in days.values) {
                    yearlyOmzet += record.bills.fold(
                      0,
                      (s, b) => s + b.totalAmount,
                    );
                    yearlyExpense += record.expenses.fold(
                      0,
                      (s, e) => s + e.amount,
                    );
                  }
                }
                double yearlyNet = yearlyOmzet - yearlyExpense;

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.black87, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      'Tahun $year',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Laba Bersih: Rp ${yearlyNet.toInt()}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: monthsData.keys.map((month) {
                      Map<int, DailyRecord> daysData = monthsData[month]!;

                      // Hitung Total Bulanan
                      double monthlyOmzet = 0;
                      double monthlyExpense = 0;
                      for (var record in daysData.values) {
                        monthlyOmzet += record.bills.fold(
                          0,
                          (s, b) => s + b.totalAmount,
                        );
                        monthlyExpense += record.expenses.fold(
                          0,
                          (s, e) => s + e.amount,
                        );
                      }
                      double monthlyNet = monthlyOmzet - monthlyExpense;

                      return ExpansionTile(
                        title: Text(
                          _monthNames[month],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Laba Bersih: Rp ${monthlyNet.toInt()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: daysData.keys.map((day) {
                          DailyRecord record = daysData[day]!;

                          // Hitung Total Harian
                          double dailyCash = record.bills
                              .where((b) => b.paymentMethod == 'Cash')
                              .fold(0, (s, b) => s + b.totalAmount);
                          double dailyQris = record.bills
                              .where((b) => b.paymentMethod == 'QRIS')
                              .fold(0, (s, b) => s + b.totalAmount);

                          double dailyOmzet = dailyCash + dailyQris;
                          double dailyExpense = record.expenses.fold(
                            0,
                            (s, e) => s + e.amount,
                          );
                          double dailyNet = dailyOmzet - dailyExpense;

                          return ExpansionTile(
                            title: Text(
                              '$day ${_monthNames[month]} $year',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Omzet: Rp ${dailyOmzet.toInt()} | Keluar: Rp ${dailyExpense.toInt()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            children: [
                              // KOTAK REKAP HARIAN
                              Container(
                                color: Colors.blueGrey.shade50,
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildSummaryText(
                                      'OMZET',
                                      dailyOmzet,
                                      Colors.green,
                                    ),
                                    _buildSummaryText(
                                      'KELUAR',
                                      dailyExpense,
                                      Colors.red,
                                    ),
                                    _buildSummaryText(
                                      'BERSIH',
                                      dailyNet,
                                      dailyNet >= 0 ? Colors.blue : Colors.red,
                                    ),
                                  ],
                                ),
                              ),

                              // LIST PEMASUKAN
                              if (record.bills.isNotEmpty) ...[
                                Container(
                                  width: double.infinity,
                                  color: Colors.green.shade100,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 16,
                                  ),
                                  child: const Text(
                                    'PEMASUKAN (NOTA KASIR)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                                ...record.bills.map((bill) {
                                  final timeStr =
                                      "${bill.createdAt.hour.toString().padLeft(2, '0')}:${bill.createdAt.minute.toString().padLeft(2, '0')}";
                                  return ListTile(
                                    leading: Icon(
                                      bill.paymentMethod == 'QRIS'
                                          ? Icons.qr_code_2
                                          : Icons.money,
                                      color: bill.paymentMethod == 'QRIS'
                                          ? Colors.blue
                                          : Colors.green,
                                    ),
                                    title: Text(
                                      'Nota #${bill.id} - ${bill.customerName}',
                                    ),
                                    subtitle: Text(
                                      '$timeStr (Klik untuk lihat/cetak)',
                                    ),
                                    trailing: Text(
                                      '+ Rp ${bill.totalAmount.toInt()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ActiveBillPage(
                                            bill: BillModel(
                                              id: bill.id,
                                              uuid: bill.uuid,
                                              customerName: bill.customerName,
                                              createdAt: bill.createdAt,
                                              status: 'closed',
                                              isAllDelivered: true,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ],

                              // LIST PENGELUARAN
                              if (record.expenses.isNotEmpty) ...[
                                Container(
                                  width: double.infinity,
                                  color: Colors.red.shade100,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 16,
                                  ),
                                  child: const Text(
                                    'PENGELUARAN (KAS KELUAR)',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                ...record.expenses.map((exp) {
                                  final timeStr =
                                      "${exp.createdAt.hour.toString().padLeft(2, '0')}:${exp.createdAt.minute.toString().padLeft(2, '0')}";
                                  return ListTile(
                                    leading: Icon(
                                      exp.type == 'Restok'
                                          ? Icons.inventory
                                          : Icons.receipt,
                                      color: Colors.red,
                                    ),
                                    title: Text(exp.description),
                                    subtitle: Text('$timeStr - ${exp.type}'),
                                    trailing: Text(
                                      '- Rp ${exp.amount.toInt()}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                              const SizedBox(height: 8),
                            ],
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
    );
  }

  Widget _buildSummaryText(String label, double amount, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Rp ${amount.toInt()}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
