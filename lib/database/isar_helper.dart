import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../collections/local_bill.dart';
import '../collections/local_bill_item.dart';
import '../collections/local_menu.dart';
import '../collections/local_expense_note.dart';
import '../collections/local_expense_item.dart';
import '../collections/local_employee.dart';
import '../collections/local_shift.dart';

class IsarHelper {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      LocalBillSchema,
      LocalBillItemSchema,
      LocalMenuSchema,
      LocalExpenseNoteSchema,
      LocalExpenseItemSchema,
      LocalEmployeeSchema,
      LocalShiftSchema,
    ], directory: dir.path);
  }
}
