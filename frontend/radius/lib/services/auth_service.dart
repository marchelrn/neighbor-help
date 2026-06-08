import 'dart:convert';

import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<bool> createHelpRequest(
    String title,
    String description,
    String category,
  ) async {
    final token = await StorageService.getToken();
    if (token == null) return false;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/help'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'title': title,
          'description': description,
          'category': category,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // =========================
  // LOGIN
  // =========================

  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
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
    required double actualLat,
    required double actualLong,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'full_name': fullName,
        'address': address,
        'coordinate_lat': coordinateLat,
        'coordinate_long': coordinateLong,
        'actual_lat': actualLat,
        'actual_long': actualLong,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      return data;
    }

    throw Exception(data['message']);
  }

  // =========================
  // GET MY HELP REQUESTS
  // =========================

  static Future<List<Map<String, dynamic>>> getMyHelpRequests(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/my-help'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> helpRequests = data['help_requests'] ?? [];
      return helpRequests.cast<Map<String, dynamic>>();
    }

    throw Exception('Failed to get help requests');
  }

  // =========================
  // UPDATE HELP REQUEST STATUS
  // =========================

  static Future<void> updateHelpRequestStatus(
    String token,
    int helpRequestId,
    String status,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/help/$helpRequestId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );

    if (response.statusCode != 200 &&
        response.statusCode != 201 &&
        response.statusCode != 202) {
      throw Exception('Failed to update help request status');
    }
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
      if (data is Map<String, dynamic> &&
          data['data'] is Map<String, dynamic>) {
        return data['data'];
      }

      return data;
    }

    throw Exception('Failed to get current user');
  }

  // =========================
  // GET NOTIFICATIONS
  // =========================

  static Future<List<Map<String, dynamic>>> getNotifications(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final List<dynamic> notifications = data['notifications'] ?? [];
      return notifications.cast<Map<String, dynamic>>();
    }

    throw Exception('Failed to get notifications');
  }

  // =========================
  // GET UNREAD NOTIFICATION COUNT
  // =========================

  static Future<int> getUnreadNotificationCount(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notifications/unread-count'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['count'] ?? 0;
    }

    throw Exception('Failed to get unread notification count');
  }

  // =========================
  // MARK NOTIFICATIONS AS READ
  // =========================

  static Future<void> markNotificationsAsRead(String token) async {
    final response = await http.put(
      Uri.parse('$baseUrl/notifications/read'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to mark notifications as read');
    }
  }
}
