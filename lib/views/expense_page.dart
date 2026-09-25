import 'package:flutter/material.dart';

import '../models/expense_model.dart';
import '../services/expense_service.dart';
import 'restock_confirm_page.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  List<ExpenseNote> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    setState(() => _isLoading = true);
    final notes = await ExpenseService.fetchExpenseNotes();
    if (mounted) {
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    }
  }

  void _showAddGeneralExpense() {
    final now = DateTime.now();
    final dateString =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

    // State array untuk menyimpan banyak baris input
    List<TextEditingController> descControllers = [TextEditingController()];
    List<TextEditingController> amountControllers = [TextEditingController()];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          // Hitung total secara real-time setiap ada angka diinput
          double grandTotal = 0;
          for (var ctrl in amountControllers) {
            grandTotal += double.tryParse(ctrl.text) ?? 0;
          }

          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: const BorderSide(
                color: Colors.black,
                width: 2,
              ), // Pinggiran tegas
            ),
            backgroundColor: Colors.yellow.shade100, // Warna kertas nota kuning
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // KOP NOTA
                    const Center(
                      child: Text(
                        'BUKTI KAS KELUAR',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Tanggal:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          dateString,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 1.5,
                      height: 24,
                    ),

                    const Text(
                      'Daftar Pengeluaran:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // GENERATE BARIS INPUT DINAMIS
                    ...List.generate(descControllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Keterangan
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: descControllers[index],
                                decoration: const InputDecoration(
                                  hintText: 'Keterangan (Cth: Beli Gas)',
                                  isDense: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (val) => setDialogState(
                                  () {},
                                ), // Trigger hitung ulang
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Nominal
                            Expanded(
                              flex: 2,
                              child: TextField(
                                controller: amountControllers[index],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Nominal',
                                  prefixText: 'Rp ',
                                  isDense: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black54,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                onChanged: (val) => setDialogState(
                                  () {},
                                ), // Trigger hitung ulang total
                              ),
                            ),

                            // Tombol Hapus Baris (Muncul jika baris > 1)
                            if (descControllers.length > 1)
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setDialogState(() {
                                    descControllers.removeAt(index);
                                    amountControllers.removeAt(index);
                                  });
                                },
                              )
                            else
                              const SizedBox(
                                width: 48,
                              ), // Penyeimbang jarak jika icon silang tidak ada
                          ],
                        ),
                      );
                    }),

                    // TOMBOL TAMBAH BARIS
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setDialogState(() {
                            descControllers.add(TextEditingController());
                            amountControllers.add(TextEditingController());
                          });
                        },
                        icon: const Icon(Icons.add, color: Colors.blue),
                        label: const Text(
                          'Tambah Baris',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const Divider(
                      color: Colors.black,
                      thickness: 1.5,
                      height: 24,
                    ),

                    // GRAND TOTAL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TOTAL:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'Rp ${grandTotal.toInt()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // TOMBOL SAHKAN
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Batal',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          onPressed: grandTotal <= 0
                              ? null
                              : () async {
                                  // 1. Gabungkan semua keterangan yang tidak kosong
                                  List<String> validDescriptions = [];
                                  for (
                                    int i = 0;
                                    i < descControllers.length;
                                    i++
                                  ) {
                                    String desc = descControllers[i].text
                                        .trim();
                                    double amt =
                                        double.tryParse(
                                          amountControllers[i].text,
                                        ) ??
                                        0;

                                    if (desc.isNotEmpty && amt > 0) {
                                      validDescriptions.add(desc);
                                    }
                                  }

                                  if (validDescriptions.isEmpty) return;

                                  // Gabung jadi satu teks, misal: "Gas, Es Batu, Kopi Hitam"
                                  String finalDesc = validDescriptions.join(
                                    ', ',
                                  );

                                  // 2. Simpan ke database
                                  final success =
                                      await ExpenseService.addGeneralExpense(
                                        finalDesc,
                                        grandTotal,
                                      );

                                  if (success && context.mounted) {
                                    Navigator.pop(context);
                                    _loadNotes(); // Refresh daftar pengeluaran
                                  }
                                },
                          child: const Text(
                            'SAHKAN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteNote(int id) async {
    final success = await ExpenseService.deleteNote(id);
    if (success) _loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buku Pengeluaran & PO')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notes.isEmpty
          ? const Center(child: Text('Belum ada catatan pengeluaran.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                final isDraft = note.status == 'Draft';
                final dateStr =
                    "${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}";

                return Card(
                  color: isDraft ? Colors.orange.shade50 : Colors.white,
                  child: ListTile(
                    leading: Icon(
                      note.type == 'Restok' ? Icons.inventory : Icons.receipt,
                      color: note.type == 'Restok' ? Colors.blue : Colors.grey,
                    ),
                    title: Text(
                      note.description,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('$dateStr - ${note.status}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          isDraft ? 'Menunggu' : 'Rp ${note.amount.toInt()}',
                          style: TextStyle(
                            color: isDraft ? Colors.orange : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.grey,
                            size: 20,
                          ),
                          onPressed: () => _deleteNote(note.id),
                        ),
                      ],
                    ),
                    onTap: () async {
                      // Jika nota Restok masih Draft, buka halaman konfirmasi
                      if (note.type == 'Restok' && isDraft) {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RestockConfirmPage(note: note),
                          ),
                        );
                        if (result == true) _loadNotes();
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.red,
        onPressed: _showAddGeneralExpense,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Pengeluaran Biasa',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
