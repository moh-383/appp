import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/api/rover_api.dart';
import '../core/config/api_config.dart';
import '../features/about/about_screen.dart';
import '../features/control/control_screen.dart';
import '../features/home/home_screen.dart';
import '../features/map/map_screen.dart';
import '../features/sensors/sensors_screen.dart';
import '../features/settings/settings_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String map = '/map';
  static const String data = '/data';
  static const String settings = '/settings';
  static const String about = '/about';
  static const String control = '/control';

  static Map<String, WidgetBuilder> get routes => {
        home: (_) => const HomeScreen(),
        map: (context) => MapScreen(api: RoverApi(context.read<ApiConfig>())),
        data: (context) =>
            SensorsScreen(api: RoverApi(context.read<ApiConfig>())),
        settings: (_) => const SettingsScreen(),
        about: (_) => const AboutScreen(),
        control: (context) =>
            ControlScreen(api: RoverApi(context.read<ApiConfig>())),
      };
}
