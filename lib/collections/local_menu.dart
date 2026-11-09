import 'package:isar/isar.dart';

part 'local_menu.g.dart';

@collection
class LocalMenu {
  Id id = Isar.autoIncrement;

  late String name;
  late double price;
  late String trackingMode;
  late int stockQty;
  late String stockStatus;
  late String category;

  bool isSynced = false; // Penanda untuk sync ke PostgreSQL nanti
}
