import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/api/rover_api.dart';
import 'core/config/api_config.dart';
import 'shared/providers/language_provider.dart';
import 'shared/providers/mine_alert_provider.dart';
import 'shared/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiConfig = ApiConfig();
  await apiConfig.load();
  final themeProvider = ThemeProvider();
  await themeProvider.load();
  final api = RoverApi(apiConfig);
  final mineAlerts = MineAlertProvider(api)..start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider.value(value: apiConfig),
        ChangeNotifierProvider.value(value: mineAlerts),
      ],
      child: const MyApp(),
    ),
  );
}
