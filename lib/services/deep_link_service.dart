import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class DeepLinkService {
  static const _storage = FlutterSecureStorage();
  static HttpServer? _server;


  static void Function(String token)? onTokenReceived;
  static void Function(String error)? onError;

  static Future<void> initialize() async {
    try {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8888);
      debugPrint('🔗 DeepLinkService: escuchando en http://localhost:8888');
      _server!.listen(_handleRequest);
    } catch (e) {
      debugPrint('❌ DeepLinkService: no se pudo iniciar el servidor: $e');
    }
  }

  static Future<void> _handleRequest(HttpRequest request) async {
    final token = request.uri.queryParameters['token'];
    final error = request.uri.queryParameters['error'];


    request.response
      ..statusCode = 200
      ..headers.contentType = ContentType.html
      ..write(_buildHtml(success: token != null, error: error));
    await request.response.close();

    if (token != null) {
      await _storage.write(key: 'auth_token', value: token);
      await Future.delayed(const Duration(milliseconds: 300));
      onTokenReceived?.call(token);
    } else if (error != null) {
      debugPrint('❌ Google OAuth error: $error');
      onError?.call(error);
    }
  }

  static String _buildHtml({required bool success, String? error}) => '''
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <title>Residencia Carlota</title>
    <style>
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body {
        background: #120018; color: #fff;
        font-family: -apple-system, sans-serif;
        display: flex; align-items: center; justify-content: center;
        height: 100vh; flex-direction: column; gap: 16px;
      }
      h2 { font-weight: 300; letter-spacing: 4px; font-size: 22px; }
      p  { color: #9B9B9B; font-size: 14px; }
    </style>
  </head>
  <body>
    ${success
      ? '<h2>Autenticación exitosa</h2><p>Podés cerrar esta ventana y volver a la app.</p>'
      : '<h2>Error de autenticación</h2><p>${error ?? "Ocurrió un error inesperado."}</p>'}
  </body>
</html>
''';

  static void dispose() {
    _server?.close(force: true);
    _server = null;
  }
}
