import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:transportia/main.dart';
import 'package:transportia/util/prefs.dart';
import 'package:transportia/widgets/util/error_widget.dart';
import 'package:transportia/widgets/util/toasts.dart';

class Api {
  static final Api _instance = Api._internal();

  factory Api() {
    return _instance;
  }

  Api._internal();

  String baseUrl = "http://localhost:3000";

  Map<String, String> headers({bool json = false}) {
    final token = Preferences().getString("token");

    return {
      if (json) "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  Future<dynamic> get(String path) async {
    final response = await http.get(
      Uri.parse("$baseUrl$path"),
      headers: headers(),
    );

    return _handleResponse(response);
  }

  Future<dynamic> post(String path, dynamic body) async {
    final response = await http.post(
      Uri.parse("$baseUrl$path"),
      headers: headers(json: true),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> put(String path, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse("$baseUrl$path"),
      headers: headers(json: true),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final response = await http.patch(
      Uri.parse("$baseUrl$path"),
      headers: headers(json: true),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> delete(String path) async {
    final response = await http.delete(
      Uri.parse("$baseUrl$path"),
      headers: headers(),
    );

    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final exception = ApiHttpException(
        statusCode: response.statusCode,
        statusMessage: response.reasonPhrase ?? 'HTTP Error',
        message: ApiResponseHandler.extractErrorMessage(response.body),
      );

      showError(exception);

      throw exception;
    }

    if (response.body.isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }
}

class PatchField<T> {
  final bool isSet;
  final T? value;

  const PatchField.unset() : isSet = false, value = null;

  const PatchField.set(this.value) : isSet = true;

  Map<String, dynamic> toJson() => {if (isSet) 'value': value};
}

class ApiResponseHandler {
  static dynamic handle(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiHttpException(
        statusCode: response.statusCode,
        statusMessage: response.reasonPhrase ?? 'HTTP Error',
        message: extractErrorMessage(response.body),
      );
    }

    if (response.body.isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }

  static String extractErrorMessage(String body) {
    if (body.isEmpty) {
      return 'The server returned an empty error response.';
    }

    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded['message'] ??
            decoded['error'] ??
            decoded['detail'] ??
            body;
      }

      return body;
    } catch (_) {
      return body;
    }
  }
}
