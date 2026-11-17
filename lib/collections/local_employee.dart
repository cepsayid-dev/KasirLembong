import 'package:isar/isar.dart';
part 'local_employee.g.dart';

@collection
class LocalEmployee {
  Id id = Isar.autoIncrement; // Menggunakan ID asli dari PostgreSQL
  late String name;
  late String pin;
  late String role;
}
