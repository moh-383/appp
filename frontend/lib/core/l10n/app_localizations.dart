import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @settings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settings;

  /// No description provided for @connect.
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get connect;

  /// No description provided for @connectionInstructions.
  ///
  /// In fr, this message translates to:
  /// **'1. PC, téléphone et ESP32 sur le même Wi‑Fi.\n2. Lancez le backend sur le PC.\n3. Indiquez ci‑dessous l’URL du backend (IP du PC) et l’URL caméra ESP32.\n4. Flashez le firmware dans firmware/esp32_rover.'**
  String get connectionInstructions;

  /// No description provided for @language.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get language;

  /// No description provided for @mapTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cartographie'**
  String get mapTitle;

  /// No description provided for @about.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get about;

  /// No description provided for @aboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Projet Rover Détecteur de Mines'**
  String get aboutTitle;

  /// No description provided for @aboutDescription.
  ///
  /// In fr, this message translates to:
  /// **'Ce projet a été développé par une équipe passionnée de jeunes ingénieurs pour la compétition robotique Orange. L’objectif est de concevoir un rover autonome capable de détecter et localiser des mines dans des zones à risques.\n\nÉquipe :\n- Conseiga Mohamed\n- Loari Moumouni\n- Tall Yasmina\nTechnologies utilisées : Flutter, Python, Bluetooth/Wi‑Fi, capteurs embarqués.'**
  String get aboutDescription;

  /// No description provided for @pilot.
  ///
  /// In fr, this message translates to:
  /// **'Piloter le rover'**
  String get pilot;

  /// No description provided for @data.
  ///
  /// In fr, this message translates to:
  /// **'Données & capteurs'**
  String get data;

  /// No description provided for @map.
  ///
  /// In fr, this message translates to:
  /// **'Cartographie du terrain'**
  String get map;

  /// No description provided for @mineDetection.
  ///
  /// In fr, this message translates to:
  /// **'Zone de détection de mine'**
  String get mineDetection;

  /// No description provided for @mineDetected.
  ///
  /// In fr, this message translates to:
  /// **'⚠ MINE DÉTECTÉE'**
  String get mineDetected;

  /// No description provided for @homeTitle.
  ///
  /// In fr, this message translates to:
  /// **'R_Mind App'**
  String get homeTitle;

  /// No description provided for @robotName.
  ///
  /// In fr, this message translates to:
  /// **'Rover détecteur de mines'**
  String get robotName;

  /// No description provided for @home.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get home;

  /// No description provided for @battery.
  ///
  /// In fr, this message translates to:
  /// **'Batterie'**
  String get battery;

  /// No description provided for @temperature.
  ///
  /// In fr, this message translates to:
  /// **'Température'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In fr, this message translates to:
  /// **'Humidité'**
  String get humidity;

  /// No description provided for @distance.
  ///
  /// In fr, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @altitude.
  ///
  /// In fr, this message translates to:
  /// **'Altitude'**
  String get altitude;

  /// No description provided for @pressure.
  ///
  /// In fr, this message translates to:
  /// **'Pression'**
  String get pressure;

  /// No description provided for @voltage.
  ///
  /// In fr, this message translates to:
  /// **'Tension'**
  String get voltage;

  /// No description provided for @refresh.
  ///
  /// In fr, this message translates to:
  /// **'Actualiser'**
  String get refresh;

  /// No description provided for @position.
  ///
  /// In fr, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @direction.
  ///
  /// In fr, this message translates to:
  /// **'Direction'**
  String get direction;

  /// No description provided for @obstacles.
  ///
  /// In fr, this message translates to:
  /// **'Obstacles'**
  String get obstacles;

  /// No description provided for @mines.
  ///
  /// In fr, this message translates to:
  /// **'Mines'**
  String get mines;

  /// No description provided for @area.
  ///
  /// In fr, this message translates to:
  /// **'Zone explorée'**
  String get area;

  /// No description provided for @cameraView.
  ///
  /// In fr, this message translates to:
  /// **'Vue de la caméra'**
  String get cameraView;

  /// No description provided for @forward.
  ///
  /// In fr, this message translates to:
  /// **'Avance'**
  String get forward;

  /// No description provided for @backward.
  ///
  /// In fr, this message translates to:
  /// **'Recule'**
  String get backward;

  /// No description provided for @left.
  ///
  /// In fr, this message translates to:
  /// **'Gauche'**
  String get left;

  /// No description provided for @right.
  ///
  /// In fr, this message translates to:
  /// **'Droite'**
  String get right;

  /// No description provided for @stop.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter'**
  String get stop;

  /// No description provided for @reset.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get reset;

  /// No description provided for @controlTitle.
  ///
  /// In fr, this message translates to:
  /// **'Piloter le rover'**
  String get controlTitle;

  /// No description provided for @noMine.
  ///
  /// In fr, this message translates to:
  /// **'Aucune mine détectée'**
  String get noMine;

  /// No description provided for @startArm.
  ///
  /// In fr, this message translates to:
  /// **'Activer bras'**
  String get startArm;

  /// No description provided for @stopArm.
  ///
  /// In fr, this message translates to:
  /// **'Arrêter bras'**
  String get stopArm;

  /// No description provided for @auto.
  ///
  /// In fr, this message translates to:
  /// **'Mode automatique'**
  String get auto;

  /// No description provided for @cameraError.
  ///
  /// In fr, this message translates to:
  /// **'Caméra indisponible'**
  String get cameraError;

  /// No description provided for @gas.
  ///
  /// In fr, this message translates to:
  /// **'Gaz'**
  String get gas;

  /// No description provided for @motion.
  ///
  /// In fr, this message translates to:
  /// **'Mouvement'**
  String get motion;

  /// No description provided for @magneticField.
  ///
  /// In fr, this message translates to:
  /// **'Champ magnétique'**
  String get magneticField;

  /// No description provided for @metal.
  ///
  /// In fr, this message translates to:
  /// **'Métal'**
  String get metal;

  /// No description provided for @backendUrl.
  ///
  /// In fr, this message translates to:
  /// **'URL backend (PC)'**
  String get backendUrl;

  /// No description provided for @esp32CamUrl.
  ///
  /// In fr, this message translates to:
  /// **'URL caméra ESP32'**
  String get esp32CamUrl;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @testConnection.
  ///
  /// In fr, this message translates to:
  /// **'Tester la connexion'**
  String get testConnection;

  /// No description provided for @connectionOk.
  ///
  /// In fr, this message translates to:
  /// **'Connexion backend OK'**
  String get connectionOk;

  /// No description provided for @connectionFailed.
  ///
  /// In fr, this message translates to:
  /// **'Connexion échouée'**
  String get connectionFailed;

  /// No description provided for @offline.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne — vérifiez le backend'**
  String get offline;

  /// No description provided for @commandSent.
  ///
  /// In fr, this message translates to:
  /// **'Commande envoyée'**
  String get commandSent;

  /// No description provided for @pathPoints.
  ///
  /// In fr, this message translates to:
  /// **'Points de trajet'**
  String get pathPoints;

  /// No description provided for @apiKey.
  ///
  /// In fr, this message translates to:
  /// **'Clé API'**
  String get apiKey;

  /// No description provided for @followRover.
  ///
  /// In fr, this message translates to:
  /// **'Suivre le rover'**
  String get followRover;

  /// No description provided for @theme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get themeSystem;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
