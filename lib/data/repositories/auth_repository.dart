import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:app_geriatrico/core/config.dart';
import 'package:app_geriatrico/data/models/auth_response.dart';

class AuthRepository {
  http.Client get _client {
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };


  Future<AuthResponse> login(String email, String password) async {
    final client = _client;
    try {
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}/login'),
        headers: _headers,
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = _parseBody(response);
      if (response.statusCode == 200) return AuthResponse.fromJson(body);
      throw Exception(body['message'] ?? 'Credenciales incorrectas');
    } finally {
      client.close();
    }
  }

 
  Future<AuthResponse> loginWithToken(String token) async {
    final client = _client;
    try {
      final response = await client.get(
        Uri.parse('${ApiConfig.baseUrl}/me'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final body = _parseBody(response);
      if (response.statusCode == 200) {
        return AuthResponse(
          accessToken:  token,
          tokenType:    'Bearer',
          user:         body,
          institutions: (body['institutions'] as List<dynamic>?) ?? [],
        );
      }
      throw Exception(body['message'] ?? 'Sesión inválida');
    } finally {
      client.close();
    }
  }

  Future<bool> logout(String token) async {
    final client = _client;
    try {
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}/logout'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } finally {
      client.close();
    }
  }


  Map<String, dynamic> _parseBody(http.Response response) {
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw Exception(
          'El servidor devolvió una respuesta inesperada (${response.statusCode}).');
    }
  }
}
