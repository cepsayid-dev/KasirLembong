import 'package:isar/isar.dart';
part 'local_shift.g.dart';

@collection
class LocalShift {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String uuid; // Format: SHIFT-1794855322680
  late int employeeId;
  late String employeeName;
  late String cashierSlot; // Contoh: 'Kasir 1', 'Kasir 2'
  late DateTime openedAt;
  DateTime? closedAt;
  late double openingCash;
  double expectedCash = 0;
  double actualCash = 0;
  double discrepancy = 0;
  late String status; // 'open' atau 'closed'
  bool isSynced = false;
}
