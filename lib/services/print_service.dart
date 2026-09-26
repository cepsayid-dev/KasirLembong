import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/bill_model.dart';
import '../models/bill_item_model.dart';

class PrintService {
  static Future<void> printReceipt({
    required BillModel bill,
    required List<BillItemModel> items,
    required double totalAmount,
    required double cashAmount,
    required double changeAmount,
  }) async {
    try {
      final pdf = pw.Document();

      // Gunakan ukuran kertas Roll 58mm (standar thermal kasir)
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.roll57,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                // HEADER
                pw.Center(
                  child: pw.Column(
                    children: [
                      pw.Text(
                        'WARKOP LEMBONG',
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        'Kuningan, Jawa Barat',
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Divider(borderStyle: pw.BorderStyle.dashed),
                    ],
                  ),
                ),

                // INFO NOTA
                pw.SizedBox(height: 4),
                pw.Text(
                  'Nota  : #${bill.id}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'Waktu : ${bill.createdAt.day}/${bill.createdAt.month}/${bill.createdAt.year} ${bill.createdAt.hour}:${bill.createdAt.minute.toString().padLeft(2, '0')}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.Text(
                  'Tamu  : ${bill.customerName}',
                  style: const pw.TextStyle(fontSize: 10),
                ),
                pw.SizedBox(height: 4),
                pw.Divider(borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 4),

                // DAFTAR ITEM
                ...items.where((item) => !item.isCancelled).map((item) {
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          item.menuName,
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                              '  ${item.qty}x @ Rp ${item.price.toInt()}',
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                            pw.Text(
                              'Rp ${(item.qty * item.price).toInt()}',
                              style: const pw.TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),

                pw.SizedBox(height: 4),
                pw.Divider(borderStyle: pw.BorderStyle.dashed),
                pw.SizedBox(height: 4),

                // TOTAL & BAYAR
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'TOTAL',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'Rp ${totalAmount.toInt()}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 4),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('TUNAI', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(
                      'Rp ${cashAmount.toInt()}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('KEMBALI', style: const pw.TextStyle(fontSize: 10)),
                    pw.Text(
                      'Rp ${changeAmount.toInt()}',
                      style: const pw.TextStyle(fontSize: 10),
                    ),
                  ],
                ),

                // FOOTER
                pw.SizedBox(height: 12),
                pw.Center(
                  child: pw.Text(
                    'Terima Kasih!',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Center(
                  child: pw.Text(
                    'Wi-Fi: warkop_lembong / Pass: kopi123',
                    style: const pw.TextStyle(fontSize: 8),
                  ),
                ),
                pw.SizedBox(
                  height: 20,
                ), // Spacing agar tidak terpotong pisau printer
              ],
            );
          },
        ),
      );

      // Jalankan dialog Print bawaan HP / OS
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Struk_Warkop_Lembong_${bill.id}',
      );
    } catch (e) {
      debugPrint("Gagal mencetak: $e");
    }
  }
}
