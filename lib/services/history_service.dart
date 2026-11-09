import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';

import '../database/isar_helper.dart';
import '../collections/local_bill.dart';
import '../collections/local_bill_item.dart';
import '../models/history_bill_model.dart';

class HistoryService {
  static final Isar _isar = IsarHelper.isar;

  static Future<List<HistoryBill>> fetchTodayHistory() async {
    try {
      // 1. Ambil semua nota yang sudah diarsipkan
      final closedBills = await _isar.localBills
          .filter()
          .statusEqualTo('closed')
          .sortByCreatedAtDesc()
          .findAll();

      List<HistoryBill> historyList = [];

      for (var bill in closedBills) {
        // 2. Ambil rincian item untuk menghitung grand total
        final items = await _isar.localBillItems
            .filter()
            .billUuidEqualTo(bill.uuid)
            .and()
            .isCancelledEqualTo(false)
            .findAll();

        double grandTotal = 0;
        for (var item in items) {
          grandTotal += (item.qty * item.price);
        }

        historyList.add(
          HistoryBill(
            id: bill.id,
            uuid: bill.uuid, // Pass UUID ke model
            customerName: bill.customerName,
            createdAt: bill.createdAt,
            paymentMethod: bill.paymentMethod ?? 'Cash',
            totalAmount: grandTotal,
          ),
        );
      }

      return historyList;
    } catch (e) {
      debugPrint("Gagal mengambil riwayat dari Isar: $e");
      return [];
    }
  }
}
