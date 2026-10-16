import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appp/core/config/api_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('ApiConfig defaults and update', () async {
    SharedPreferences.setMockInitialValues({});
    final config = ApiConfig();
    await config.load();
    expect(config.backendBaseUrl, ApiConfig.defaultBackendBaseUrl);
    expect(config.authHeaders['X-API-Key'], ApiConfig.defaultApiKey);

    await config.update(
      backendBaseUrl: 'http://10.0.0.1:8000/',
      apiKey: 'abc',
    );
    expect(config.backendBaseUrl, 'http://10.0.0.1:8000');
    expect(config.apiKey, 'abc');
    expect(config.backend('/sensors/'), 'http://10.0.0.1:8000/sensors/');
    expect(
      config.esp32CamStreamUrl.contains('api_key=abc'),
      isTrue,
    );
  });
}
