import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const url = String.fromEnvironment('SUPABASE_URL');
  const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  if (url.isNotEmpty && anonKey.isNotEmpty) {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }
  runApp(const DingDongApp());
}

class DingDongApp extends StatelessWidget {
  const DingDongApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: '딩동',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB6E36A)),
      scaffoldBackgroundColor: const Color(0xFFF7F8F5),
    ),
    home: const HomeScreen(),
  );
}
