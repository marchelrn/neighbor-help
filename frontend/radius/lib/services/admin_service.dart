import 'dart:convert';

import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class AdminService {
  static const String baseUrl = 'http://localhost:3000/admin';

  // =========================
  // USERS
  // =========================

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> users = data['data'] ?? [];
      return users.cast<Map<String, dynamic>>();
    }

    throw Exception(data['message'] ?? 'Failed to get users');
  }

  static Future<void> updateUser(String username, Map<String, dynamic> payload) async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.put(
      Uri.parse('$baseUrl/user/$username'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to update user');
    }
  }

  static Future<void> deleteUser(int id) async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.delete(
      Uri.parse('$baseUrl/user/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to delete user');
    }
  }

  // =========================
  // HELP REQUESTS
  // =========================

  static Future<List<Map<String, dynamic>>> getHelpRequests() async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.get(
      Uri.parse('$baseUrl/help'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 202 || response.statusCode == 200) {
      final List<dynamic> helpRequests = data['help_requests'] ?? [];
      return helpRequests.cast<Map<String, dynamic>>();
    }

    throw Exception(data['message'] ?? 'Failed to get help requests');
  }

  static Future<void> updateHelpRequest(int id, Map<String, dynamic> payload) async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.put(
      Uri.parse('$baseUrl/help/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to update help request');
    }
  }

  static Future<void> deleteHelpRequest(int id) async {
    final token = await StorageService.getToken();
    if (token == null) throw Exception('No token found');

    final response = await http.delete(
      Uri.parse('$baseUrl/help/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to delete help request');
    }
  }
}
