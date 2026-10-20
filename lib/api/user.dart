import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:transportia/api/api.dart';

class ApiUser {
  final int id;

  final String email;
  final String username;

  final String? displayName;
  final String? bio;

  final String passwordHash;

  ApiUser({
    required this.id,
    required this.email,
    required this.username,
    this.displayName,
    this.bio,
    required this.passwordHash,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      id: json["id"],
      email: json["email"],
      username: json["username"],
      displayName: json["display_name"],
      bio: json["bio"],
      passwordHash: json["password_hash"],
    );
  }

  static Future<(bool, String)> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("${Api().baseUrl}/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password,
      }),
    );

    return (
      response.statusCode >= 200 && response.statusCode < 300,
      response.body,
    );
  }

  static Future<(bool, String)> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${Api().baseUrl}/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return (
      response.statusCode >= 200 && response.statusCode < 300,
      response.body,
    );
  }

  static Future<ApiUser> me() async {
    final response = await Api().get("/me");

    return ApiUser.fromJson(response);
  }

  static Future<List<ApiUser>> search(String query) async {
    final data = await Api().get(
      "/users?search=${Uri.encodeQueryComponent(query)}",
    );

    return (data as List).map((json) => ApiUser.fromJson(json)).toList();
  }
}
