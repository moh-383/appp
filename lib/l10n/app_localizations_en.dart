// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get connect => 'Connection';

  @override
  String get connectionInstructions => '1. Enable Wi-Fi or Bluetooth in your phone settings.\n2. Look for a device named \"ROVER_WIFI\" or \"ROVER_BT\".\n3. Connect using the password: rover1234\n4. Return to the app to control the rover.';

  @override
  String get mapTitle => 'Mapping';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get aboutTitle => 'Mine Detection Rover Project';

  @override
  String get aboutDescription => 'This project was developed by a passionate team of young engineers for the Orange robotics competition. The goal is to design an autonomous rover capable of detecting and locating mines in hazardous areas.\n\nTeam:\n- Conseiga Mohamed\n- Loari Moumouni\n- Tall Yasmina\nTechnologies used: Flutter, Python, Kivy, Bluetooth/Wi-Fi, embedded sensors.';

  @override
  String get pilot => 'Drive Rover';

  @override
  String get data => 'Data & Sensors';

  @override
  String get map => 'Terrain Map';

  @override
  String get mineDetection => 'Area of Mine Detection';

  @override
  String get mineDetected => '⚠ MINE DETECTED';

  @override
  String get homeTitle => 'ROVER CONTROL';

  @override
  String get robotName => 'Intelligent Robot';

  @override
  String get home => 'Home';

  @override
  String get battery => 'Battery';

  @override
  String get temperature => 'Temperature';

  @override
  String get humidity => 'Humidity';

  @override
  String get distance => 'Distance';

  @override
  String get altitude => 'Altitude';

  @override
  String get pressure => 'pressure';

  @override
  String get voltage => 'Voltage';

  @override
  String get refresh => 'Refresh';

  @override
  String get position => 'Position';

  @override
  String get direction => 'Direction';

  @override
  String get obstacles => 'Obstacles';

  @override
  String get mines => 'Mines';

  @override
  String get area => 'Area explored';
}
