import 'package:isar/isar.dart';
part 'local_expense_item.g.dart';

@collection
class LocalExpenseItem {
  Id id = Isar.autoIncrement;
  late int noteId;
  late int menuId;
  late String menuName;
  late String trackingMode;
  late int qty;
  late double price;
  String? stockStatus;
  bool isSynced = false;
}
