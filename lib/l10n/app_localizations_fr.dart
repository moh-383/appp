// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get settings => 'Paramètres';

  @override
  String get connect => 'Connexion';

  @override
  String get connectionInstructions => '1. Activez le Wi-Fi ou le Bluetooth dans les paramètres du téléphone.\n2. Recherchez un appareil nommé \"ROVER_WIFI\" ou \"ROVER_BT\".\n3. Connectez-vous avec le mot de passe : rover1234\n4. Revenez dans l’application pour piloter le rover.';

  @override
  String get mapTitle => 'Cartographie';

  @override
  String get language => 'Langue';

  @override
  String get about => 'À propos';

  @override
  String get aboutTitle => 'Projet Rover Détecteur de Mines';

  @override
  String get aboutDescription => 'Ce projet a été développé par une équipe passionnée de jeunes ingénieurs pour la compétition robotique Orange. L’objectif est de concevoir un rover autonome capable de détecter et localiser des mines dans des zones à risques.\n\nÉquipe :\n- Conseiga Mohamed\n- Loari Moumouni\n- Tall Yasmina\nTechnologies utilisées : Flutter, Python, Kivy, Bluetooth/Wi-Fi, capteurs embarqués.';

  @override
  String get pilot => 'Piloter le rover';

  @override
  String get data => 'Données & capteurs';

  @override
  String get map => 'Cartographie du terrain';

  @override
  String get mineDetection => 'Zone de détection de mine';

  @override
  String get mineDetected => '⚠ MINE DÉTECTÉE';

  @override
  String get homeTitle => 'ROVER CONTROL';

  @override
  String get robotName => 'Robot Intélligent';

  @override
  String get home => 'Accueil';

  @override
  String get battery => 'Batterie';

  @override
  String get temperature => 'Température';

  @override
  String get humidity => 'Humidité';

  @override
  String get distance => 'Distance';

  @override
  String get altitude => 'Altitude';

  @override
  String get pressure => 'pression';

  @override
  String get voltage => 'Tension';

  @override
  String get refresh => 'Actualiser';

  @override
  String get position => 'Position';

  @override
  String get direction => 'Direction';

  @override
  String get obstacles => 'Obstacles';

  @override
  String get mines => 'Mines';

  @override
  String get area => 'Zone explorée';

  @override
  String get forward => 'Avance';

  @override
  String get backward => 'Recule';

  @override
  String get left => 'Gauche';

  @override
  String get right => 'Droite';

  @override
  String get stop => 'Arrêter';

  @override
  String get reset => 'Renitialiser';

  @override
  String get cameraView => 'Vue de la caméra';

  @override
  String get controlTitle => 'Piloter le rover';
}
