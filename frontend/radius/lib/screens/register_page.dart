import 'package:flutter/material.dart';

import '../screens/main_layout.dart';
import '../services/auth_service.dart';
import '../utils/storage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final fullNameController = TextEditingController();

  final addressController = TextEditingController();

  final latController = TextEditingController();

  final longController = TextEditingController();

  bool isLoading = false;

  Future<void> register() async {
    try {
      setState(() {
        isLoading = true;
      });

      final response = await AuthService.register(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        fullName: fullNameController.text,
        address: addressController.text,
        coordinateLat: double.parse(latController.text),
        coordinateLong: double.parse(longController.text),
      );

      await StorageService.saveToken(response['token']);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainLayout()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),

            child: Column(
              children: [
                TextField(
                  controller: usernameController,

                  decoration: const InputDecoration(labelText: 'Username'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: emailController,

                  decoration: const InputDecoration(labelText: 'Email'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: passwordController,

                  obscureText: true,

                  decoration: const InputDecoration(labelText: 'Password'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: fullNameController,

                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: addressController,

                  decoration: const InputDecoration(labelText: 'Address'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: latController,

                  decoration: const InputDecoration(labelText: 'Latitude'),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: longController,

                  decoration: const InputDecoration(labelText: 'Longitude'),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,

                  height: 56,

                  child: ElevatedButton(
                    onPressed: isLoading ? null : register,

                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
