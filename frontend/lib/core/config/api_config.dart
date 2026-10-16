// ignore_for_file: undefined_class, undefined_identifier

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig extends ChangeNotifier {
  static const String _kBackend = 'backend_base_url';
  static const String _kEsp32Cam = 'esp32_cam_url';
  static const String _kApiKey = 'api_key';

  static const String defaultBackendBaseUrl = 'http://192.168.100.12:8000';
  static const String defaultEsp32CamUrl = 'http://192.168.100.50/stream';
  static const String defaultApiKey = 'rover-secret-key';

  String _backendBaseUrl = defaultBackendBaseUrl;
  String _esp32CamUrl = defaultEsp32CamUrl;
  String _apiKey = defaultApiKey;

  String get backendBaseUrl => _backendBaseUrl;
  String get esp32CamUrl => _esp32CamUrl;
  String get apiKey => _apiKey;

  /// URL MJPEG avec api_key (firmware protège /stream).
  String get esp32CamStreamUrl {
    final base = _esp32CamUrl.trim();
    if (_apiKey.isEmpty) return base;
    final uri = Uri.parse(base);
    final params = Map<String, String>.from(uri.queryParameters);
    params.putIfAbsent('api_key', () => _apiKey);
    return uri.replace(queryParameters: params).toString();
  }

  Map<String, String> get authHeaders => {
        if (_apiKey.isNotEmpty) 'X-API-Key': _apiKey,
      };

  String backend(String path) {
    final normalized = path.startsWith('/') ? path : '/$path';
    return '$_backendBaseUrl$normalized';
  }

  Uri backendUri(String path) => Uri.parse(backend(path));

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _backendBaseUrl = _read(prefs, _kBackend, defaultBackendBaseUrl);
    _esp32CamUrl = _read(prefs, _kEsp32Cam, defaultEsp32CamUrl);
    _apiKey = _read(prefs, _kApiKey, defaultApiKey);
    notifyListeners();
  }

  String _read(SharedPreferences prefs, String key, String fallback) {
    final value = prefs.getString(key)?.trim();
    return (value != null && value.isNotEmpty) ? value : fallback;
  }

  Future<void> update({
    String? backendBaseUrl,
    String? esp32CamUrl,
    String? apiKey,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (backendBaseUrl != null && backendBaseUrl.trim().isNotEmpty) {
      _backendBaseUrl = backendBaseUrl.trim().replaceAll(RegExp(r'/$'), '');
      await prefs.setString(_kBackend, _backendBaseUrl);
    }
    if (esp32CamUrl != null && esp32CamUrl.trim().isNotEmpty) {
      _esp32CamUrl = esp32CamUrl.trim();
      await prefs.setString(_kEsp32Cam, _esp32CamUrl);
    }
    if (apiKey != null) {
      _apiKey = apiKey.trim();
      await prefs.setString(_kApiKey, _apiKey);
    }
    notifyListeners();
  }
}
