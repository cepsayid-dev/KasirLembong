import 'package:isar/isar.dart';
part 'local_expense_note.g.dart';

@collection
class LocalExpenseNote {
  Id id = Isar.autoIncrement;
  String? shiftId;
  late String type;
  late String description;
  late double amount;
  late String status;
  late DateTime createdAt;
  bool isSynced = false;
}
