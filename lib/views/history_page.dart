import 'package:flutter/material.dart';

import '../models/history_bill_model.dart';
import '../services/history_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  // Struktur: Map<Tahun, Map<Bulan, Map<Hari, List<Nota>>>>
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

                // Hitung Total Tahunan (Hanya Grand Total)
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
                  // TINGKAT 1: TAHUN
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

                      // Hitung Total Bulanan (Hanya Grand Total)
                      double monthlyTotal = daysData.values
                          .expand((bills) => bills)
                          .fold(0, (sum, bill) => sum + bill.totalAmount);

                      // TINGKAT 2: BULAN
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

                          // Hitung Total Harian (Ada Cash dan QRIS)
                          double dailyCash = billsInDay
                              .where((b) => b.paymentMethod == 'Cash')
                              .fold(0, (s, b) => s + b.totalAmount);
                          double dailyQris = billsInDay
                              .where((b) => b.paymentMethod == 'QRIS')
                              .fold(0, (s, b) => s + b.totalAmount);
                          double dailyTotal = dailyCash + dailyQris;

                          // TINGKAT 3: HARI
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
                              // Rincian Cash & QRIS (Hanya muncul di tingkat harian)
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

                              // Daftar Nota di hari tersebut
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
                                  subtitle: Text(timeStr),
                                  trailing: Text(
                                    'Rp ${bill.totalAmount.toInt()}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
