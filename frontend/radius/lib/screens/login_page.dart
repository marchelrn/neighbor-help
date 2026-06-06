import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../utils/storage.dart';
import 'main_layout.dart';
import 'register_page.dart';
import 'admin/pages/admin_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    clearOldToken();
  }

  // =====================================
  // CLEAR OLD TOKEN
  // =====================================

  Future<void> clearOldToken() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove("token");

    debugPrint("OLD TOKEN CLEARED");
  }

  // =====================================
  // LOGIN
  // =====================================

  Future<void> login() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await AuthService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      debugPrint("LOGIN RESPONSE:");
      debugPrint(response.toString());

      await StorageService.saveToken(response['token']);

      final token = response['token'];

      final user = await AuthService.getCurrentUser(token);

      debugPrint("CURRENT USER:");
      debugPrint(user.toString());

      final role = user['role'];
      debugPrint("ROLE:");
      debugPrint(role.toString());

      if (!mounted) return;

      if (role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainLayout()),
        );
      }
    } catch (e) {
      debugPrint("LOGIN ERROR:");
      debugPrint(e.toString());

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                const Icon(
                  Icons.volunteer_activism,
                  size: 80,
                  color: Color(0xFF16A34A),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Neighbor Help",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : login,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login'),
                  ),
                ),

                const SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text('Belum punya akun? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
