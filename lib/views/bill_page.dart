import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bill_provider.dart';
import '../services/isar_service.dart';
import '../services/sync_service.dart';
import 'menu_choice_page.dart';
import 'active_bill_page.dart';

class BillPage extends StatelessWidget {
  const BillPage({super.key});

  Future<void> _showDirectPaymentDialog(
    BuildContext context,
    BillProvider billProvider,
  ) async {
    String selectedMethod = 'Cash';
    final totalBill = billProvider.totalBill;
    final cashController = TextEditingController(
      text: totalBill.toInt().toString(),
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (statefulContext, setDialogState) {
          final cashInput = double.tryParse(cashController.text) ?? 0;
          final change = cashInput - totalBill;

          return AlertDialog(
            title: const Text('Pembayaran Langsung'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Tagihan: Rp ${totalBill.toInt()}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'Cash',
                          label: Text('Tunai (Cash)'),
                        ),
                        ButtonSegment(value: 'QRIS', label: Text('QRIS')),
                      ],
                      selected: {selectedMethod},
                      onSelectionChanged: (set) {
                        setDialogState(() => selectedMethod = set.first);
                      },
                    ),
                  ),
                  if (selectedMethod == 'Cash') ...[
                    const SizedBox(height: 16),
                    TextField(
                      controller: cashController,
                      keyboardType: TextInputType.number,
                      autofocus: true,
                      onChanged: (_) => setDialogState(() {}),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Uang Diterima (Rp)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kembalian:',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          change >= 0 ? 'Rp ${change.toInt()}' : 'Uang Kurang!',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: change >= 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: (selectedMethod == 'Cash' && cashInput < totalBill)
                    ? null
                    : () async {
                        final namaTamu =
                            billProvider.customerName.trim().isEmpty
                            ? 'Guest'
                            : billProvider.customerName.trim();

                        final newBill = await IsarService.createBill(
                          customerName: namaTamu,
                          items: billProvider.items,
                          isPaid: true,
                          paymentMethod: selectedMethod,
                        );

                        // Langsung dorong sinkronisasi di latar belakang
                        SyncService.syncAllToServer();

                        if (!dialogContext.mounted || !context.mounted) return;
                        Navigator.pop(dialogContext);
                        billProvider.clearBill();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ActiveBillPage(bill: newBill),
                          ),
                        );
                      },
                child: const Text('KONFIRMASI LUNAS'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentDate =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    final billProvider = Provider.of<BillProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Buat Pesanan Baru'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Text(currentDate, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'A.N : ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: TextField(
                    onChanged: (value) => billProvider.setCustomerName(value),
                    controller:
                        TextEditingController(text: billProvider.customerName)
                          ..selection = TextSelection.collapsed(
                            offset: billProvider.customerName.length,
                          ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: UnderlineInputBorder(),
                    ),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 35,
                    child: Center(
                      child: Text(
                        'Qty',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Menu',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: Center(
                      child: Text(
                        'Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: Center(
                      child: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(),
                    right: BorderSide(),
                    bottom: BorderSide(),
                  ),
                ),
                child: ListView.separated(
                  itemCount: billProvider.items.length + 1,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1, color: Colors.black),
                  itemBuilder: (context, index) {
                    if (index == billProvider.items.length) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MenuChoicePage(),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.add_circle,
                                  size: 24,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Tambah Menu',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    final item = billProvider.items[index];
                    return Dismissible(
                      key: ValueKey('${item.menuId}_$index'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 12),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        billProvider.removeItem(index);
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 35,
                            child: Center(
                              child: Text(
                                '${item.qty}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                                vertical: 4.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.menuName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (item.notes.isNotEmpty)
                                    Text(
                                      item.notes,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 70,
                            child: Center(child: Text('${item.price.toInt()}')),
                          ),
                          SizedBox(
                            width: 70,
                            child: Center(
                              child: Text('${item.totalPrice.toInt()}'),
                            ),
                          ),
                          SizedBox(
                            width: 40,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(
                                Icons.close,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () => billProvider.removeItem(index),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Tagihan',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Rp ${billProvider.totalBill.toInt()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // TOMBOL 1: SIMPAN AJA
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                          foregroundColor: Colors.orange,
                        ),
                        onPressed: billProvider.items.isEmpty
                            ? null
                            : () async {
                                try {
                                  final namaTamu =
                                      billProvider.customerName.trim().isEmpty
                                      ? 'Guest'
                                      : billProvider.customerName.trim();

                                  await IsarService.createBill(
                                    customerName: namaTamu,
                                    items: billProvider.items,
                                    isPaid: false,
                                    paymentMethod: 'Cash',
                                  );

                                  SyncService.syncAllToServer();

                                  if (!context.mounted) return;

                                  billProvider.clearBill();
                                  Navigator.pop(context, true);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Nota disimpan & masuk antrean dapur!',
                                      ),
                                    ),
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString())),
                                  );
                                }
                              },
                        child: const Text(
                          'SIMPAN AJA',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // TOMBOL 2: LANGSUNG BAYAR (PILIH CASH / QRIS)
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: billProvider.items.isEmpty
                            ? null
                            : () => _showDirectPaymentDialog(
                                context,
                                billProvider,
                              ),
                        child: const Text(
                          'LANGSUNG BAYAR',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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
  }
}
