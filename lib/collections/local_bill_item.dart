import 'package:isar/isar.dart';

part 'local_bill_item.g.dart';

@collection
class LocalBillItem {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String uuid;

  @Index()
  late String billUuid; // Menyambungkan item ke LocalBill

  late int menuItemId;
  late String menuName;
  late int qty;
  late double price;
  late String notes;
  bool isDelivered = false;
  bool isCancelled = false;
  bool isPaid = false;
  bool isSynced = false;
}
