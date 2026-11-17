import 'dart:async';

import 'package:isar/isar.dart';

import '../database/isar_helper.dart';
import '../collections/local_employee.dart';
import '../collections/local_shift.dart';
import '../collections/local_bill.dart';
import '../collections/local_bill_item.dart';
import '../collections/local_expense_note.dart';

class ShiftService {
  static final Isar _isar = IsarHelper.isar;

  // --- 1. Ambil Daftar Pegawai Lokal ---
  static Future<List<LocalEmployee>> getEmployees() async {
    return await _isar.localEmployees.where().sortByName().findAll();
  }

  // --- 2. Cek Shift yang Sedang Aktif ('open') ---
  static Future<LocalShift?> getActiveShift() async {
    return await _isar.localShifts.filter().statusEqualTo('open').findFirst();
  }

  // --- 3. Buka Shift Baru ---
  static Future<bool> openShift({
    required LocalEmployee employee,
    required String pinInput,
    required String cashierSlot,
    required double openingCash,
  }) async {
    if (employee.pin != pinInput) return false;

    final now = DateTime.now();
    final newShift = LocalShift()
      ..uuid = 'SHIFT-${now.millisecondsSinceEpoch}'
      ..employeeId = employee.id
      ..employeeName = employee.name
      ..cashierSlot = cashierSlot
      ..openedAt = now
      ..openingCash = openingCash
      ..status = 'open'
      ..isSynced = false;

    await _isar.writeTxn(() async {
      await _isar.localShifts.put(newShift);
    });
    return true;
  }

  // --- 4. Catat Pengambilan Uang oleh Owner ---
  static Future<bool> recordOwnerPickup({
    required double amount,
    String notes = 'Uang diambil Owner',
  }) async {
    final activeShift = await getActiveShift();
    if (activeShift == null) return false;

    final note = LocalExpenseNote()
      ..type = 'Setor Owner'
      ..description = notes
      ..amount = amount
      ..status = 'Lunas'
      ..createdAt = DateTime.now()
      ..shiftId = activeShift.uuid
      ..isSynced = false;

    await _isar.writeTxn(() async {
      await _isar.localExpenseNotes.put(note);
    });
    return true;
  }

  // --- 5. Hitung Ringkasan Kas Shift Aktif ---
  static Future<dynamic> calculateShiftSummary(LocalShift shift) async {
    final shiftBills = await _isar.localBills
        .filter()
        .shiftIdEqualTo(shift.uuid)
        .and()
        .group((q) => q.statusEqualTo('paid').or().statusEqualTo('closed'))
        .findAll();

    double totalCashSales = 0;
    for (var bill in shiftBills) {
      final method = (bill.paymentMethod ?? 'Cash').toLowerCase();
      if (method == 'cash' || method == 'tunai') {
        final items = await _isar.localBillItems
            .filter()
            .billUuidEqualTo(bill.uuid)
            .isCancelledEqualTo(false)
            .findAll();
        for (var item in items) {
          totalCashSales += (item.price * item.qty);
        }
      }
    }

    final shiftExpenses = await _isar.localExpenseNotes
        .filter()
        .shiftIdEqualTo(shift.uuid)
        .statusEqualTo('Lunas')
        .findAll();

    double totalOperationalExpense = 0;
    double totalOwnerPickup = 0;

    for (var exp in shiftExpenses) {
      if (exp.type == 'Setor Owner') {
        totalOwnerPickup += exp.amount;
      } else {
        totalOperationalExpense += exp.amount;
      }
    }

    final expectedEndingCash =
        shift.openingCash +
        totalCashSales -
        totalOperationalExpense -
        totalOwnerPickup;

    return {
      'openingCash': shift.openingCash,
      'cashSales': totalCashSales,
      'operationalExpense': totalOperationalExpense,
      'ownerPickup': totalOwnerPickup,
      'endingCash': expectedEndingCash,
    };
  }

  // --- 6. Tutup Shift Otomatis (Auto-Calculate) ---
  static Future<bool> closeCurrentShiftAuto(LocalShift currentShift) async {
    final summary = await calculateShiftSummary(currentShift);
    final calculatedCash = (summary['endingCash'] as double?) ?? 0;

    await _isar.writeTxn(() async {
      currentShift.closedAt = DateTime.now();
      currentShift.expectedCash = calculatedCash;
      currentShift.actualCash = calculatedCash;
      currentShift.discrepancy = 0;
      currentShift.status = 'closed';
      currentShift.isSynced = false;
      await _isar.localShifts.put(currentShift);
    });

    return true;
  }
}
