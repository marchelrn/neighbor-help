import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../screens/main_layout.dart';
import '../services/auth_service.dart';
import '../utils/storage.dart';
import '../widgets/location_picker_dialog.dart';

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

  double? pickedLat;
  double? pickedLong;

  bool isLoading = false;

  Future<void> openMapPicker() async {
    final LatLng? result = await showDialog<LatLng>(
      context: context,
      builder: (_) => const LocationPickerDialog(),
    );

    if (result != null) {
      setState(() {
        pickedLat = result.latitude;
        pickedLong = result.longitude;
      });
    }
  }



  Future<void> register() async {
    if (pickedLat == null || pickedLong == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap pilih lokasi Anda di peta terlebih dahulu.')),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      // Fetch actual location in background for security
      double actualLat = 0.0;
      double actualLong = 0.0;

      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (serviceEnabled) {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
          if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
            Position pos = await Geolocator.getCurrentPosition(
              locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
            );
            actualLat = pos.latitude;
            actualLong = pos.longitude;
          }
        }
      } catch (e) {
        // Continue even if geolocator fails, backend will check if it's 0.0
      }

      await AuthService.register(
        username: usernameController.text,
        email: emailController.text,
        password: passwordController.text,
        fullName: fullNameController.text,
        address: addressController.text,
        coordinateLat: pickedLat!,
        coordinateLong: pickedLong!,
        actualLat: actualLat,
        actualLong: actualLong,
      );

      final loginResponse = await AuthService.login(
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      await StorageService.saveToken(loginResponse['token']);

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

                // Location Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: OutlinedButton.icon(
                    onPressed: openMapPicker,
                    icon: const Icon(Icons.map),
                    label: Text(
                      pickedLat != null && pickedLong != null 
                          ? 'Lokasi Peta: ${pickedLat!.toStringAsFixed(4)}, ${pickedLong!.toStringAsFixed(4)}'
                          : 'Pilih Lokasi di Peta',
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      foregroundColor: pickedLat != null ? Colors.green : Colors.blue,
                      side: BorderSide(color: pickedLat != null ? Colors.green : Colors.blue),
                    ),
                  ),
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
