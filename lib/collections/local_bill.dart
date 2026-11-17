import 'package:isar/isar.dart';

part 'local_bill.g.dart';

@collection
class LocalBill {
  Id id = Isar.autoIncrement; // ID wajib Isar (integer)

  @Index(unique: true)
  late String uuid; // ID Unik untuk sinkronisasi ke Node.js nanti
  String? shiftId;

  late String customerName;
  late DateTime createdAt;
  late String status; // 'unpaid', 'paid', 'closed'
  late String? paymentMethod;
  bool isSynced = false; // Penanda apakah sudah dikirim ke REST API
}
