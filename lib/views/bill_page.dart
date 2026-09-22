import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/bill_provider.dart';
import '../services/bill_service.dart';
import 'menu_choice_page.dart';

class BillPage extends StatelessWidget {
  const BillPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca tanggal hari ini
    final String currentDate =
        "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    final billProvider = Provider.of<BillProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Nota Pesanan'), centerTitle: true),
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
                    width: 40,
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
                    width: 80,
                    child: Center(
                      child: Text(
                        'Price',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Center(
                      child: Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
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
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }

                    final item = billProvider.items[index];
                    return Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Center(child: Text('${item.qty}')),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            child: Text(
                              item.menuName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Center(child: Text('${item.price.toInt()}')),
                        ),
                        SizedBox(
                          width: 80,
                          child: Center(
                            child: Text('${item.totalPrice.toInt()}'),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(),
                    right: BorderSide(),
                    bottom: BorderSide(),
                  ),
                ),
                child: Text(
                  'Total Bill = Rp ${billProvider.totalBill.toInt()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Validasi: Pastikan keranjang tidak kosong
          if (billProvider.items.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Nota masih kosong, tambahkan menu terlebih dahulu!',
                ),
              ),
            );
            return;
          }

          // Proses simpan
          bool success = await BillService.saveBill(billProvider);

          if (success) {
            billProvider.clearBill();

            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Nota berhasil disimpan dengan status Belum Bayar (Merah)!',
                  ),
                ),
              );
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Gagal menyimpan nota ke database'),
                ),
              );
            }
          }
        },
        shape: const CircleBorder(
          side: BorderSide(color: Colors.black, width: 1),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        child: const Icon(Icons.check, color: Colors.black),
      ),
    );
  }
}
