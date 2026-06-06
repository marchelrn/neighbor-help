import 'package:flutter/material.dart';

import 'screens/login_page.dart';
import 'screens/main_layout.dart';
import 'utils/storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = true;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  Future<void> checkLogin() async {
    final token = await StorageService.getToken();

    setState(() {
      isLoggedIn = token != null;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Neighbor Help',

      theme: ThemeData(
        useMaterial3: true,

        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF16A34A)),

        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
      ),

      home: isLoading
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : isLoggedIn
          ? const MainLayout()
          : const LoginPage(),
    );
  }
}
