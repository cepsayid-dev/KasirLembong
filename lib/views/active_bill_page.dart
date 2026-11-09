import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bill_model.dart';
import '../models/bill_item_model.dart';
import '../services/isar_service.dart';
import '../providers/bill_provider.dart';
import '../services/print_service.dart';
import 'menu_choice_page.dart';

class ActiveBillPage extends StatefulWidget {
  final BillModel bill;

  const ActiveBillPage({super.key, required this.bill});

  @override
  State<ActiveBillPage> createState() => _ActiveBillPageState();
}

class _ActiveBillPageState extends State<ActiveBillPage> {
  List<BillItemModel> _items = [];
  bool _isLoading = true;
  String _paymentMethod = 'Cash';
  late String _customerName;

  @override
  void initState() {
    super.initState();
    _customerName = widget.bill.customerName;
    _loadItems();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BillProvider>(context, listen: false).clearBill();
    });
  }

  Future<void> _loadItems() async {
    setState(() {
      _isLoading = true;
    });

    final items = await IsarService.getBillItems(widget.bill.uuid);

    if (!context.mounted) {
      return;
    }

    setState(() {
      _items = items;
      _isLoading = false;

      // Jika nota sudah kosong (semua dicancel) dan belum dibayar, tutup halaman
      if (items.isNotEmpty &&
          items.every((i) => i.isPaid || i.isCancelled) &&
          widget.bill.status == 'unpaid') {
        Navigator.pop(context, true);
      }
    });
  }

  Future<void> _editCustomerName() async {
    final nameController = TextEditingController(text: _customerName);
    final newName = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit Nama Pelanggan'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'Masukkan nama baru',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, nameController.text),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (!context.mounted) {
      return;
    }

    if (newName != null &&
        newName.trim().isNotEmpty &&
        newName.trim() != _customerName) {
      final success = await IsarService.updateCustomerName(
        widget.bill.uuid,
        newName.trim(),
      );

      if (!context.mounted) {
        return;
      }

      if (success) {
        setState(() {
          _customerName = newName.trim();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama pelanggan diperbarui!')),
        );
      }
    }
  }

  Future<void> _deleteEntireBill() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Seluruh Nota?'),
        content: Text(
          'Yakin ingin membatalkan nota #${widget.bill.id} atas nama $_customerName?\n\nSeluruh pesanan akan dihapus dan stok akan dikembalikan secara otomatis.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Tidak'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Ya, Hapus Nota',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (!context.mounted) {
      return;
    }

    if (confirm == true) {
      final success = await IsarService.deleteBill(widget.bill.uuid);

      if (!context.mounted) {
        return;
      }

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Nota #${widget.bill.id} dihapus & stok dikembalikan.',
            ),
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Gagal menghapus nota.')));
      }
    }
  }

  Future<void> _handleCancelItem(
    String itemUuid,
    String menuName,
    bool isDelivered,
  ) async {
    final pesanTeks = isDelivered
        ? 'Item ini SUDAH DIANTAR. Yakin ingin membatalkan/retur pesanan ini? Tagihan akan hangus.'
        : 'Yakin ingin mencoret $menuName dari nota? Dapur tidak akan memasak pesanan ini.';

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Batalkan Pesanan?'),
        content: Text(pesanTeks),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text(
              'Ya, Batalkan',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (!context.mounted) {
      return;
    }

    if (confirm == true) {
      final success = await IsarService.cancelItem(itemUuid);

      if (!context.mounted) {
        return;
      }

      if (success) {
        _loadItems();
      }
    }
  }

  Future<void> _showPartialPaymentDialog() async {
    final validItems = _items
        .where((i) => !i.isCancelled && !i.isPaid)
        .toList();
    if (validItems.isEmpty) {
      return;
    }

    Map<String, int> splitSelection = {
      for (var item in validItems) item.uuid: 0,
    };
    String tempMethod = _paymentMethod;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (statefulContext, setDialogState) {
          int totalSelectedQty = splitSelection.values.fold(
            0,
            (sum, val) => sum + val,
          );
          double totalSelectedPrice = 0;

          for (var item in validItems) {
            totalSelectedPrice += (item.price * splitSelection[item.uuid]!);
          }

          return AlertDialog(
            title: const Text('Bayar Sebagian (Patungan)'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pilih menu yang dibayar duluan oleh pelanggan:'),
                  const SizedBox(height: 8),
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: validItems.length,
                      itemBuilder: (context, index) {
                        final item = validItems[index];
                        final selectedQty = splitSelection[item.uuid]!;

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            item.menuName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            'Rp ${item.price.toInt()} / item',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: selectedQty > 0
                                    ? () => setDialogState(
                                        () => splitSelection[item.uuid] =
                                            selectedQty - 1,
                                      )
                                    : null,
                              ),
                              Text(
                                '$selectedQty / ${item.qty}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.add_circle,
                                  color: Colors.green,
                                ),
                                onPressed: selectedQty < item.qty
                                    ? () => setDialogState(
                                        () => splitSelection[item.uuid] =
                                            selectedQty + 1,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Terpilih:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rp ${totalSelectedPrice.toInt()}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Cash', label: Text('Cash')),
                      ButtonSegment(value: 'QRIS', label: Text('QRIS')),
                    ],
                    selected: {tempMethod},
                    onSelectionChanged: (set) =>
                        setDialogState(() => tempMethod = set.first),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(statefulContext),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onPressed: totalSelectedQty > 0
                    ? () async {
                        final success = await IsarService.payPartialItems(
                          widget.bill.uuid,
                          splitSelection,
                          tempMethod,
                        );

                        if (!statefulContext.mounted || !context.mounted) {
                          return;
                        }

                        if (success) {
                          Navigator.pop(statefulContext);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Menu terpilih berhasil dilunaskan!',
                              ),
                            ),
                          );
                          _loadItems();
                        }
                      }
                    : null,
                child: const Text('LUNASKAN INI'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleCheckout() async {
    if (_paymentMethod == 'QRIS') {
      final success = await IsarService.checkoutBill(widget.bill.uuid, 'QRIS');

      if (!context.mounted) {
        return;
      }

      if (success) {
        Map<String, int> remainingItems = {
          for (var item in _items.where((i) => !i.isCancelled && !i.isPaid))
            item.uuid: item.qty,
        };
        await IsarService.payPartialItems(
          widget.bill.uuid,
          remainingItems,
          'QRIS',
        );

        if (!context.mounted) {
          return;
        }

        _showSuccessPrintDialog(sisaTagihan, sisaTagihan, 0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal memproses pembayaran.')),
        );
      }
      return;
    }

    final cashController = TextEditingController(
      text: sisaTagihan.toInt().toString(),
    );
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Pelunasan Sisa Nota (Tunai)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sisa Tagihan: Rp ${sisaTagihan.toInt()}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: cashController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Uang Diterima (Rp)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
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
            onPressed: () async {
              final cashAmount = double.tryParse(cashController.text) ?? 0;
              if (cashAmount < sisaTagihan) {
                if (!context.mounted) {
                  return;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Uang kurang dari tagihan!')),
                );
                return;
              }

              final success = await IsarService.checkoutBill(
                widget.bill.uuid,
                'Cash',
              );

              if (!context.mounted) {
                return;
              }

              if (success) {
                Map<String, int> remainingItems = {
                  for (var item in _items.where(
                    (i) => !i.isCancelled && !i.isPaid,
                  ))
                    item.uuid: item.qty,
                };
                await IsarService.payPartialItems(
                  widget.bill.uuid,
                  remainingItems,
                  'Cash',
                );

                if (!context.mounted || !dialogContext.mounted) {
                  return;
                }

                Navigator.pop(dialogContext);
                _showSuccessPrintDialog(
                  sisaTagihan,
                  cashAmount,
                  cashAmount - sisaTagihan,
                );
              }
            },
            child: const Text('LUNASKAN SEMUA'),
          ),
        ],
      ),
    );
  }

  void _showSuccessPrintDialog(double total, double cash, double change) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 50),
            SizedBox(height: 8),
            Text('Semua Lunas!', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Kembalian:', style: TextStyle(fontSize: 16)),
            Text(
              'Rp ${change.toInt()}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context, true);
            },
            child: const Text(
              'Selesai',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            onPressed: () => PrintService.printReceipt(
              bill: widget.bill,
              items: _items,
              totalAmount: total,
              cashAmount: cash,
              changeAmount: change,
            ),
            icon: const Icon(Icons.print),
            label: const Text('Cetak Struk'),
          ),
        ],
      ),
    );
  }

  double get sisaTagihan {
    return _items
        .where((item) => !item.isCancelled && !item.isPaid)
        .fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get totalKeseluruhan {
    return _items
        .where((item) => !item.isCancelled)
        .fold(0, (sum, item) => sum + item.totalPrice);
  }

  @override
  Widget build(BuildContext context) {
    final billProvider = Provider.of<BillProvider>(context);
    final bool canInteract = _items.isNotEmpty && billProvider.items.isEmpty;
    final bool isClosed =
        widget.bill.status == 'closed'; // <-- HANYA cek diarsipkan atau belum

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }
        Navigator.pop(context, true);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, true),
          ),
          title: InkWell(
            onTap: !isClosed ? _editCustomerName : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    'Nota #${widget.bill.id} - $_customerName',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (!isClosed) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, size: 18, color: Colors.blue),
                ],
              ],
            ),
          ),
          centerTitle: true,
          actions: [
            if (!isClosed)
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                tooltip: 'Hapus Nota',
                onPressed: _deleteEntireBill,
              ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          ..._items.map((item) {
                            final isSelesaiBayar = item.isPaid;
                            final textStyle = TextStyle(
                              fontSize: 16,
                              decoration: item.isCancelled
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: item.isCancelled
                                  ? Colors.grey
                                  : (isSelesaiBayar
                                        ? Colors.black38
                                        : Colors.black),
                            );

                            return ListTile(
                              onTap: isClosed || item.isCancelled
                                  ? null
                                  : () async {
                                      final success =
                                          await IsarService.toggleItemDelivered(
                                            item.uuid,
                                            item.isDelivered,
                                          );
                                      if (!context.mounted) {
                                        return;
                                      }
                                      if (success) {
                                        _loadItems();
                                      }
                                    },
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 4,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: item.isCancelled
                                    ? Colors.grey
                                    : (item.isDelivered
                                          ? Colors.green
                                          : Colors.orange),
                                child: Icon(
                                  item.isCancelled
                                      ? Icons.block
                                      : (item.isDelivered
                                            ? Icons.check
                                            : Icons.outdoor_grill),
                                  color: Colors.white,
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    '${item.qty}x ${item.menuName}',
                                    style: textStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isSelesaiBayar) ...[
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade100,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text(
                                        '✅ LUNAS',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              subtitle: item.notes.isNotEmpty
                                  ? Text(item.notes, style: textStyle)
                                  : null,
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Rp ${item.totalPrice.toInt()}',
                                    style: textStyle,
                                  ),
                                  // Selama nota belum ditutup dan item belum lunas, bisa dicancel.
                                  if (!item.isCancelled &&
                                      !isSelesaiBayar &&
                                      !isClosed) ...[
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                      onPressed: () => _handleCancelItem(
                                        item.uuid,
                                        item.menuName,
                                        item.isDelivered,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            );
                          }),

                          if (billProvider.items.isNotEmpty && !isClosed) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                border: Border.all(
                                  color: Colors.blue.shade200,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.new_releases,
                                        color: Colors.blue,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Pesanan Tambahan',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.blue),
                                  ...billProvider.items.map(
                                    (newItem) => ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: const CircleAvatar(
                                        backgroundColor: Colors.blue,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        ),
                                      ),
                                      title: Text(
                                        '${newItem.qty}x ${newItem.menuName}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      subtitle: newItem.notes.isNotEmpty
                                          ? Text(newItem.notes)
                                          : null,
                                      trailing: Text(
                                        'Rp ${newItem.totalPrice.toInt()}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              billProvider.clearBill(),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                          ),
                                          child: const Text('Batal'),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 2,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            final success =
                                                await IsarService.addItemsToBill(
                                                  widget.bill.uuid,
                                                  billProvider.items,
                                                );

                                            if (!context.mounted) {
                                              return;
                                            }

                                            if (success) {
                                              billProvider.clearBill();
                                              _loadItems();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Pesanan tambahan dikirim ke Dapur!',
                                                      ),
                                                    ),
                                                  );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text(
                                            'Simpan & Masak',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // ================= BAGIAN BAWAH (BOTTOM BAR) =================
                  // Tampilkan Bottom Bar normal selama NOTA BELUM DIARSIPKAN
                  if (!isClosed)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        border: const Border(
                          top: BorderSide(color: Colors.black26),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Keseluruhan',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                'Rp ${totalKeseluruhan.toInt()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Sisa Tagihan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp ${sisaTagihan.toInt()}',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Jika masih ada sisa tagihan, tampilkan tombol bayar
                          if (sisaTagihan > 0) ...[
                            SegmentedButton<String>(
                              segments: const [
                                ButtonSegment(
                                  value: 'Cash',
                                  label: Text('Tunai (Cash)'),
                                ),
                                ButtonSegment(
                                  value: 'QRIS',
                                  label: Text('QRIS'),
                                ),
                              ],
                              selected: {_paymentMethod},
                              onSelectionChanged: (set) =>
                                  setState(() => _paymentMethod = set.first),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: SizedBox(
                                    height: 50,
                                    child: OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: canInteract
                                              ? Colors.blue
                                              : Colors.grey,
                                          width: 2,
                                        ),
                                        foregroundColor: Colors.blue,
                                      ),
                                      onPressed: canInteract
                                          ? _showPartialPaymentDialog
                                          : null,
                                      icon: const Icon(Icons.pie_chart),
                                      label: const Text(
                                        'Sebagian',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  flex: 2,
                                  child: SizedBox(
                                    height: 50,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor: Colors.white,
                                      ),
                                      onPressed: canInteract
                                          ? _handleCheckout
                                          : null,
                                      child: const Text(
                                        'LUNASI SEMUA SISA',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]
                          // Jika sudah lunas (0) tapi belum diarsipkan
                          else ...[
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '✅ TAGIHAN LUNAS\n(Klik ikon item di atas jika pesanan sudah diantar atau klik + untuk tambah pesanan baru)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () => PrintService.printReceipt(
                                  bill: widget.bill,
                                  items: _items,
                                  totalAmount: totalKeseluruhan,
                                  cashAmount: totalKeseluruhan,
                                  changeAmount: 0,
                                ),
                                icon: const Icon(Icons.print),
                                label: const Text('Cetak Struk'),
                              ),
                            ),
                          ],

                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.grey.shade300,
                              ),
                              icon: const Icon(Icons.save),
                              label: const Text(
                                'SIMPAN KE ANTREAN (KEMBALI)',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    // Tampilan jika nota SUDAH DIARSIPKAN (CLOSED)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.blueGrey.shade100,
                      child: Column(
                        children: [
                          const Text(
                            'NOTA SUDAH DIARSIPKAN (CLOSED)',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () => PrintService.printReceipt(
                              bill: widget.bill,
                              items: _items,
                              totalAmount: totalKeseluruhan,
                              cashAmount: totalKeseluruhan,
                              changeAmount: 0,
                            ),
                            icon: const Icon(Icons.print),
                            label: const Text('Cetak Ulang Struk'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
        // Tombol + (Tambah) sekarang AKAN SELALU MUNCUL selama nota belum diarsipkan
        floatingActionButton: !isClosed
            ? FloatingActionButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MenuChoicePage(),
                  ),
                ),
                backgroundColor: Colors.black,
                child: const Icon(Icons.add_shopping_cart, color: Colors.white),
              )
            : null,
      ),
    );
  }
}
