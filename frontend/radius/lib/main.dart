import 'package:flutter/material.dart';
import 'screens/main_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neighbor Help',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        // 🔥 MATCH YOUR UI (GREEN BASE)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF16A34A), // green (better than blue here)
          brightness: Brightness.light,
        ),

        scaffoldBackgroundColor: const Color(0xFFF9FAFB),

        // 🧓 TEXT (GOOD FOR READABILITY)
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
          bodyLarge: TextStyle(fontSize: 18),
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        // 🔘 BUTTONS (CONSISTENT CTA STYLE)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF16A34A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // 📦 CARDS (SOFTER LIKE YOUR UI)
        cardTheme: CardThemeData(
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        // 🧾 INPUT (CHAT STYLE)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),

        // 🧱 DIVIDER (SUBTLE)
        dividerTheme: const DividerThemeData(
          thickness: 1,
          color: Color(0xFFE5E7EB),
        ),
      ),

      home: const MainLayout(),
    );
  }
}
