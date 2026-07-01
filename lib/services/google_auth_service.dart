import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_geriatrico/core/config.dart';
import 'package:app_geriatrico/core/platform_helper.dart';
import 'package:app_geriatrico/data/models/auth_response.dart';

class GoogleAuthService {
  static const _webClientId =
      '663512816885-g46nq0aqobekoo055rtialobaqe37ov1.apps.googleusercontent.com';

  static const _androidClientId =
      '663512816885-00b8ifare8qtp35sdisomtri2j5383d7.apps.googleusercontent.com';

  static const _storage = FlutterSecureStorage();

  static Future<void> initialize() async {
    await GoogleSignIn.instance.initialize(
      clientId:     Platform.isAndroid ? _androidClientId : _webClientId,
      serverClientId: _webClientId,
    );
  }

  http.Client get _client {
    final httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }

  Future<AuthResponse?> signIn() async {
    if (PlatformHelper.isMobile) {
      return await _signInMobile();
    } else {
      await _signInDesktop();
      return null;
    }
  }

  Future<void> signOut() async {
    await _storage.delete(key: 'auth_token');
  }

  

  Future<AuthResponse> _signInMobile() async {
    try {
      final account = await GoogleSignIn.instance.authenticate();
      final idToken = account.authentication.idToken;

      if (idToken == null) {
        throw Exception('No se pudo obtener el id_token de Google');
      }

      return await _sendToBackend(idToken);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw Exception('cancelado');
      }
      throw Exception('Error Google Sign In: ${e.description}');
    }
  }

  Future<AuthResponse> _sendToBackend(String idToken) async {
    final client = _client;
    try {
      final response = await client.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/google'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id_token': idToken}),
      );

      Map<String, dynamic> body;
      try {
        body = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (_) {
        throw Exception('Respuesta inesperada del servidor');
      }

      if (response.statusCode == 200) {
        await _storage.write(
          key: 'auth_token',
          value: body['access_token'] as String,
        );
        return AuthResponse.fromJson(body);
      }

      throw Exception(body['message'] ?? 'Error al autenticar con Google');
    } finally {
      client.close();
    }
  }



  Future<void> _signInDesktop() async {
    final authUrl = Uri.parse('${ApiConfig.baseUrl}/auth/google/redirect');
    if (!await canLaunchUrl(authUrl)) {
      throw Exception('No se puede abrir el navegador');
    }
    await launchUrl(authUrl, mode: LaunchMode.externalApplication);
  }
}