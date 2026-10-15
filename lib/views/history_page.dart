import 'package:flutter/material.dart';

import '../models/history_bill_model.dart';
import '../models/bill_model.dart';
import '../services/history_service.dart';
import 'active_bill_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Map<int, Map<int, Map<int, List<HistoryBill>>>> _groupedData = {};
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

    final allHistory = await HistoryService.fetchTodayHistory();

    Map<int, Map<int, Map<int, List<HistoryBill>>>> grouped = {};

    for (var bill in allHistory) {
      int year = bill.createdAt.year;
      int month = bill.createdAt.month;
      int day = bill.createdAt.day;

      grouped.putIfAbsent(year, () => {});
      grouped[year]!.putIfAbsent(month, () => {});
      grouped[year]![month]!.putIfAbsent(day, () => []).add(bill);
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
          ? const Center(child: Text('Belum ada riwayat transaksi.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _groupedData.length,
              itemBuilder: (context, yearIndex) {
                int year = _groupedData.keys.elementAt(yearIndex);
                Map<int, Map<int, List<HistoryBill>>> monthsData =
                    _groupedData[year]!;

                double yearlyTotal = monthsData.values
                    .expand((days) => days.values)
                    .expand((bills) => bills)
                    .fold(0, (sum, bill) => sum + bill.totalAmount);

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
                      'Total Omzet: Rp ${yearlyTotal.toInt()}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: monthsData.keys.map((month) {
                      Map<int, List<HistoryBill>> daysData = monthsData[month]!;

                      double monthlyTotal = daysData.values
                          .expand((bills) => bills)
                          .fold(0, (sum, bill) => sum + bill.totalAmount);

                      return ExpansionTile(
                        title: Text(
                          _monthNames[month],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Total: Rp ${monthlyTotal.toInt()}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        children: daysData.keys.map((day) {
                          List<HistoryBill> billsInDay = daysData[day]!;

                          double dailyCash = billsInDay
                              .where((b) => b.paymentMethod == 'Cash')
                              .fold(0, (s, b) => s + b.totalAmount);
                          double dailyQris = billsInDay
                              .where((b) => b.paymentMethod == 'QRIS')
                              .fold(0, (s, b) => s + b.totalAmount);
                          double dailyTotal = dailyCash + dailyQris;

                          return ExpansionTile(
                            title: Text(
                              '$day ${_monthNames[month]} $year',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Total Harian: Rp ${dailyTotal.toInt()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey,
                              ),
                            ),
                            children: [
                              Container(
                                color: Colors.blueGrey.shade50,
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildSummaryText(
                                      'CASH',
                                      dailyCash,
                                      Colors.green,
                                    ),
                                    _buildSummaryText(
                                      'QRIS',
                                      dailyQris,
                                      Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 1, color: Colors.black26),

                              // DAFTAR NOTA YANG BISA DIKLIK ULANG
                              ...billsInDay.map((bill) {
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
                                    'Rp ${bill.totalAmount.toInt()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onTap: () {
                                    // Buka kembali nota arsip
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ActiveBillPage(
                                          bill: BillModel(
                                            id: bill.id,
                                            customerName: bill.customerName,
                                            createdAt: bill.createdAt,
                                            status: 'closed', // Status closed
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
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
