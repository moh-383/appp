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
  String get connectionInstructions =>
      '1. Keep PC, phone and ESP32 on the same Wi‑Fi.\n2. Start the backend on the PC.\n3. Set the backend URL (PC IP) and ESP32 camera URL below.\n4. Flash the firmware in firmware/esp32_rover.';

  @override
  String get language => 'Language';

  @override
  String get mapTitle => 'Mapping';

  @override
  String get about => 'About';

  @override
  String get aboutTitle => 'Mine Detection Rover Project';

  @override
  String get aboutDescription =>
      'This project was developed by a passionate team of young engineers for the Orange robotics competition. The goal is to design an autonomous rover capable of detecting and locating mines in hazardous areas.\n\nTeam:\n- Conseiga Mohamed\n- Loari Moumouni\n- Tall Yasmina\nTechnologies used: Flutter, Python, Bluetooth/Wi‑Fi, embedded sensors.';

  @override
  String get pilot => 'Drive Rover';

  @override
  String get data => 'Data & Sensors';

  @override
  String get map => 'Terrain Map';

  @override
  String get mineDetection => 'Mine detection zone';

  @override
  String get mineDetected => '⚠ MINE DETECTED';

  @override
  String get homeTitle => 'R_Mind App';

  @override
  String get robotName => 'Mine detection rover';

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
  String get pressure => 'Pressure';

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

  @override
  String get cameraView => 'Camera View';

  @override
  String get forward => 'Forward';

  @override
  String get backward => 'Backward';

  @override
  String get left => 'Left';

  @override
  String get right => 'Right';

  @override
  String get stop => 'Stop';

  @override
  String get reset => 'Reset';

  @override
  String get controlTitle => 'Drive Rover';

  @override
  String get noMine => 'No mine detected';

  @override
  String get startArm => 'Start Arm';

  @override
  String get stopArm => 'Stop Arm';

  @override
  String get auto => 'Auto Mode';

  @override
  String get cameraError => 'Camera unavailable';

  @override
  String get gas => 'Gas';

  @override
  String get motion => 'Motion';

  @override
  String get magneticField => 'Magnetic field';

  @override
  String get metal => 'Metal';

  @override
  String get backendUrl => 'Backend URL (PC)';

  @override
  String get esp32CamUrl => 'ESP32 camera URL';

  @override
  String get save => 'Save';

  @override
  String get testConnection => 'Test connection';

  @override
  String get connectionOk => 'Backend connection OK';

  @override
  String get connectionFailed => 'Connection failed';

  @override
  String get offline => 'Offline — check the backend';

  @override
  String get commandSent => 'Command sent';

  @override
  String get pathPoints => 'Path points';

  @override
  String get apiKey => 'API key';

  @override
  String get followRover => 'Follow rover';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';
}
