import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_exception.dart';

/// Centralized HTTP client managing requests, timeouts, and clean error translation.
class NetworkClient {
  final http.Client _client;
  final ApiConfig config;

  NetworkClient({
    http.Client? client,
    this.config = const ApiConfig(),
  }) : _client = client ?? http.Client();

  /// Perform a GET request.
  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .get(uri, headers: {...config.defaultHeaders, ...?headers})
          .timeout(config.timeout);

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw ApiException.networkError(e.message);
    } on TimeoutException {
      throw ApiException.timeout();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.serverError(null, e.toString());
    }
  }

  /// Perform a POST request.
  Future<dynamic> post(
    String url, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = Uri.parse(url);
      final response = await _client
          .post(
            uri,
            headers: {...config.defaultHeaders, ...?headers},
            body: jsonEncode(body),
          )
          .timeout(config.timeout);

      return _handleResponse(response);
    } on SocketException catch (e) {
      throw ApiException.networkError(e.message);
    } on TimeoutException {
      throw ApiException.timeout();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException.serverError(null, e.toString());
    }
  }

  dynamic _handleResponse(http.Response response) {
    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      decoded = response.body;
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      String message = 'Invalid request parameters.';
      if (decoded is Map && decoded.containsKey('detail')) {
        message = decoded['detail'].toString();
      }
      throw ApiException.clientError(response.statusCode, message);
    } else {
      throw ApiException.serverError(
        response.statusCode,
        decoded.toString(),
      );
    }
  }

  void close() {
    _client.close();
  }
}
