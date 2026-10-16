import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:appp/app/app.dart';
import 'package:appp/core/api/rover_api.dart';
import 'package:appp/core/config/api_config.dart';
import 'package:appp/shared/providers/language_provider.dart';
import 'package:appp/shared/providers/mine_alert_provider.dart';
import 'package:appp/shared/providers/theme_provider.dart';

void main() {
  testWidgets('App starts on home screen', (WidgetTester tester) async {
    final apiConfig = ApiConfig();
    final api = RoverApi(apiConfig);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider.value(value: apiConfig),
          ChangeNotifierProvider.value(value: MineAlertProvider(api)),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pump();
    expect(find.textContaining('R_Mind'), findsWidgets);
  });
}
