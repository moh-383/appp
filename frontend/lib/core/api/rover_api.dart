import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiResult {
  const ApiResult({
    required this.ok,
    this.statusCode,
    this.data,
    this.error,
  });

  final bool ok;
  final int? statusCode;
  final Map<String, dynamic>? data;
  final String? error;

  factory ApiResult.success(Map<String, dynamic>? data, [int? code]) =>
      ApiResult(ok: true, statusCode: code, data: data);

  factory ApiResult.failure(String error, [int? code]) =>
      ApiResult(ok: false, statusCode: code, error: error);
}

class RoverApi {
  RoverApi(this.config);

  final ApiConfig config;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        ...config.authHeaders,
      };

  Future<ApiResult> sendCommand(String direction) async {
    return _post('/control/', body: {'direction': direction});
  }

  Future<ApiResult> setAutoMode(bool enabled) async {
    return _post('/control/auto', body: {'enabled': enabled});
  }

  Future<ApiResult> getAutoMode() => _get('/control/auto');

  Future<ApiResult> startArm() => _post('/arm/start_servo');
  Future<ApiResult> stopArm() => _post('/arm/stop_servo');
  Future<ApiResult> fetchSensors() => _get('/sensors/');
  Future<ApiResult> fetchMap() => _get('/map/');
  Future<ApiResult> health() => _get('/health');
  Future<ApiResult> getCalibration() => _get('/sensors/calibration');
  Future<ApiResult> calibrate() => _post('/sensors/calibrate');
  Future<ApiResult> clearCalibration() => _delete('/sensors/calibration');

  Future<ApiResult> _delete(String path) async {
    try {
      final response = await http
          .delete(config.backendUri(path), headers: config.authHeaders)
          .timeout(const Duration(seconds: 4));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResult.success(_decodeMap(response.body), response.statusCode);
      }
      return ApiResult.failure(
        'Erreur ${response.statusCode}',
        response.statusCode,
      );
    } catch (e) {
      debugPrint('Erreur DELETE $path: $e');
      return ApiResult.failure('Backend injoignable');
    }
  }

  Future<ApiResult> _post(String path, {Map<String, dynamic>? body}) async {
    try {
      final response = await http
          .post(
            config.backendUri(path),
            headers: _headers,
            body: body == null ? null : jsonEncode(body),
          )
          .timeout(const Duration(seconds: 4));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResult.success(_decodeMap(response.body), response.statusCode);
      }
      return ApiResult.failure(
        'Erreur ${response.statusCode}',
        response.statusCode,
      );
    } catch (e) {
      debugPrint('Erreur POST $path: $e');
      return ApiResult.failure('Backend / ESP32 injoignable');
    }
  }

  Future<ApiResult> _get(String path) async {
    try {
      final response = await http
          .get(config.backendUri(path), headers: config.authHeaders)
          .timeout(const Duration(seconds: 4));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResult.success(_decodeMap(response.body), response.statusCode);
      }
      return ApiResult.failure(
        'Erreur ${response.statusCode}',
        response.statusCode,
      );
    } catch (e) {
      debugPrint('Erreur GET $path: $e');
      return ApiResult.failure('Backend injoignable');
    }
  }

  Map<String, dynamic>? _decodeMap(String body) {
    if (body.isEmpty) return null;
    final data = json.decode(body);
    if (data is Map<String, dynamic>) return data;
    return null;
  }
}
