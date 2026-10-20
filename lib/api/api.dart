import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:transportia/util/prefs.dart';

class Api {
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal();

  String baseUrl = "http://localhost:3000";

  Map<String, String> _headers({bool json = false}) {
    final token = Preferences().getString("token");

    return {
      if (json) "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<dynamic> get(String path) async {
    final response = await http.get(
      Uri.parse("$baseUrl$path"),
      headers: _headers(),
    );

    return _handleResponse(response);
  }

  Future<dynamic> post(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$path"),
      headers: _headers(json: true),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$path"),
      headers: _headers(json: true),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final response = await http.patch(
      Uri.parse("$baseUrl$path"),
      headers: _headers(json: true),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> delete(String path) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$path"),
      headers: _headers(),
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception("HTTP ${response.statusCode}: ${response.body}");
    }

    if (response.body.isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }
}
