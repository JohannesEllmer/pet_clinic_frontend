import 'dart:convert';
import 'package:http/http.dart' as http;

import 'api_config.dart';

class ApiClient {
  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Uri _uri(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, String>> _headers({String? token}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<http.Response> get(String path, {String? token}) async {
    return _client.get(
      _uri(path),
      headers: await _headers(token: token),
    );
  }

  Future<http.Response> post(String path, {Object? body, String? token}) async {
    return _client.post(
      _uri(path),
      headers: await _headers(token: token),
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> put(String path, {Object? body, String? token}) async {
    return _client.put(
      _uri(path),
      headers: await _headers(token: token),
      body: body == null ? null : jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path, {String? token}) async {
    return _client.delete(
      _uri(path),
      headers: await _headers(token: token),
    );
  }

  /// Simple decode ohne Statuscode-Check
  dynamic decode(http.Response res) {
    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  dynamic _decodeOrThrow(http.Response res) {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      throw ApiException(
        statusCode: res.statusCode,
        body: res.body,
      );
    }

    if (res.body.isEmpty) return null;
    return jsonDecode(res.body);
  }

  Future<dynamic> getJson(String path, {String? token}) async {
    final res = await _client.get(
      _uri(path),
      headers: await _headers(token: token),
    );
    return _decodeOrThrow(res);
  }

  Future<dynamic> postJson(String path, {String? token, Object? body}) async {
    final res = await _client.post(
      _uri(path),
      headers: await _headers(token: token),
      body: body == null ? null : jsonEncode(body),
    );
    return _decodeOrThrow(res);
  }

  Future<dynamic> putJson(String path, {String? token, Object? body}) async {
    final res = await _client.put(
      _uri(path),
      headers: await _headers(token: token),
      body: body == null ? null : jsonEncode(body),
    );
    return _decodeOrThrow(res);
  }

  Future<dynamic> deleteJson(String path, {String? token}) async {
    final res = await _client.delete(
      _uri(path),
      headers: await _headers(token: token),
    );
    return _decodeOrThrow(res);
  }

  void close() => _client.close();
}

class ApiException implements Exception {
  final int statusCode;
  final String body;

  ApiException({
    required this.statusCode,
    required this.body,
  });

  @override
  String toString() => 'ApiException($statusCode): $body';
}
