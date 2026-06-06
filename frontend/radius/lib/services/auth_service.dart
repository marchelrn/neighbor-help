import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:8080/api';

  // =========================
  // LOGIN
  // =========================

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception(data['message']);
  }

  // =========================
  // REGISTER
  // =========================

  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String fullName,
    required String address,
    required double coordinateLat,
    required double coordinateLong,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
        'address': address,
        'coordinate_lat': coordinateLat,
        'coordinate_long': coordinateLong,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return data;
    }

    throw Exception(data['message']);
  }

  // =========================
  // GET CURRENT USER
  // =========================

  static Future<Map<String, dynamic>> getCurrentUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    }

    throw Exception('Failed to get current user');
  }
}
