import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Đổi URL tùy theo nền tảng:
  // - Web: http://localhost:5000/api
  // - Android emulator: http://10.0.2.2:5000/api
  // - iOS simulator: http://localhost:5000/api
  // - Real device: http://<IP-máy>:5000/api
  static const String _baseUrl = 'http://localhost:5000/api';
  static const Duration _timeout = Duration(seconds: 10);

  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, String>? queryParams}) async {
    final uri = Uri.parse('$_baseUrl$endpoint')
        .replace(queryParameters: queryParams);
    final response = await _client.get(uri).timeout(_timeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final response = await _client
        .post(uri,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null)
        .timeout(_timeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final response = await _client
        .put(uri,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null)
        .timeout(_timeout);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final response = await _client.delete(uri).timeout(_timeout);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}

class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException($statusCode): $message';
}