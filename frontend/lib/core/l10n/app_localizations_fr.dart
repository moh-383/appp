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
  String get connectionInstructions =>
      '1. PC, téléphone et ESP32 sur le même Wi‑Fi.\n2. Lancez le backend sur le PC.\n3. Indiquez ci‑dessous l’URL du backend (IP du PC) et l’URL caméra ESP32.\n4. Flashez le firmware dans firmware/esp32_rover.';

  @override
  String get language => 'Langue';

  @override
  String get mapTitle => 'Cartographie';

  @override
  String get about => 'À propos';

  @override
  String get aboutTitle => 'Projet Rover Détecteur de Mines';

  @override
  String get aboutDescription =>
      'Ce projet a été développé par une équipe passionnée de jeunes ingénieurs pour la compétition robotique Orange. L’objectif est de concevoir un rover autonome capable de détecter et localiser des mines dans des zones à risques.\n\nÉquipe :\n- Conseiga Mohamed\n- Loari Moumouni\n- Tall Yasmina\nTechnologies utilisées : Flutter, Python, Bluetooth/Wi‑Fi, capteurs embarqués.';

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
  String get homeTitle => 'R_Mind App';

  @override
  String get robotName => 'Rover détecteur de mines';

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
  String get pressure => 'Pression';

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
  String get cameraView => 'Vue de la caméra';

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
  String get reset => 'Réinitialiser';

  @override
  String get controlTitle => 'Piloter le rover';

  @override
  String get noMine => 'Aucune mine détectée';

  @override
  String get startArm => 'Activer bras';

  @override
  String get stopArm => 'Arrêter bras';

  @override
  String get auto => 'Mode automatique';

  @override
  String get cameraError => 'Caméra indisponible';

  @override
  String get gas => 'Gaz';

  @override
  String get motion => 'Mouvement';

  @override
  String get magneticField => 'Champ magnétique';

  @override
  String get metal => 'Métal';

  @override
  String get backendUrl => 'URL backend (PC)';

  @override
  String get esp32CamUrl => 'URL caméra ESP32';

  @override
  String get save => 'Enregistrer';

  @override
  String get testConnection => 'Tester la connexion';

  @override
  String get connectionOk => 'Connexion backend OK';

  @override
  String get connectionFailed => 'Connexion échouée';

  @override
  String get offline => 'Hors ligne — vérifiez le backend';

  @override
  String get commandSent => 'Commande envoyée';

  @override
  String get pathPoints => 'Points de trajet';

  @override
  String get apiKey => 'Clé API';

  @override
  String get followRover => 'Suivre le rover';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';
}
