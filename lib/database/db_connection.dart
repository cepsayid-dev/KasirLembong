import 'package:postgres/postgres.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DatabaseHelper {
  static late Connection connection;

  static Future<void> initConnection() async {
    try {
      connection = await Connection.open(
        Endpoint(
          host: dotenv.env['DB_HOST'] ?? 'localhost',
          database: dotenv.env['DB_NAME'] ?? 'postgres',
          username: dotenv.env['DB_USER'] ?? 'postgres',
          password: dotenv.env['DB_PASSWORD'] ?? '',
          port: int.parse(dotenv.env['DB_PORT'] ?? '5432'),
        ),
        settings: ConnectionSettings(
          // Gunakan SslMode.require jika Anda menggunakan database cloud (Supabase/Neon)
          // Gunakan SslMode.disable jika menggunakan database lokal (pgAdmin)
          sslMode: SslMode.disable,
        ),
      );
      print("✅ Koneksi Database PostgreSQL Berhasil!");
    } catch (e) {
      print("❌ Gagal terhubung ke Database: $e");
    }
  }
}
