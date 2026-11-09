import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'database/isar_helper.dart'; // Pastikan path ini sesuai

import 'database/db_connection.dart';
import 'views/home_page.dart';
import 'providers/bill_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await DatabaseHelper.initConnection();
  await IsarHelper.initialize();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BillProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir App Lembong',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ), // Diperbaiki di sini
      ),
      home: const HomePage(),
    );
  }
}
