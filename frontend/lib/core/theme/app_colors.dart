import 'package:flutter/material.dart';

/// Extension de thème — sombre (lab) + clair (lisibilité impeccable).
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.backgroundMid,
    required this.backgroundAlt,
    required this.surface,
    required this.surfaceElevated,
    required this.surfaceHighlight,
    required this.border,
    required this.borderSubtle,
    required this.borderGlow,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.accent,
    required this.accentDeep,
    required this.accentBright,
    required this.accentSoft,
    required this.teal,
    required this.tealDeep,
    required this.tealSoft,
    required this.mist,
    required this.inkBlue,
    required this.dusk,
    required this.danger,
    required this.dangerSoft,
    required this.success,
    required this.successSoft,
    required this.warning,
    required this.atmosphere,
    required this.panel,
    required this.panelEdge,
    required this.champagne,
    required this.aqua,
    required this.action,
    required this.brandText,
    required this.heroWash,
    required this.onAccent,
  });

  final Color background;
  final Color backgroundMid;
  final Color backgroundAlt;
  final Color surface;
  final Color surfaceElevated;
  final Color surfaceHighlight;
  final Color border;
  final Color borderSubtle;
  final Color borderGlow;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color accent;
  final Color accentDeep;
  final Color accentBright;
  final Color accentSoft;
  final Color teal;
  final Color tealDeep;
  final Color tealSoft;
  final Color mist;
  final Color inkBlue;
  final Color dusk;
  final Color danger;
  final Color dangerSoft;
  final Color success;
  final Color successSoft;
  final Color warning;
  final Color onAccent;
  final LinearGradient atmosphere;
  final LinearGradient panel;
  final LinearGradient panelEdge;
  final LinearGradient champagne;
  final LinearGradient aqua;
  final LinearGradient action;
  final LinearGradient brandText;
  final LinearGradient heroWash;

  // Compat anciens noms
  Color get textColor => textPrimary;
  Color get buttonColor => surfaceElevated;
  Color get navBarColor => surface;
  Color get iconColor => textSecondary;

  static const AppPalette dark = AppPalette(
    background: Color(0xFF070C12),
    backgroundMid: Color(0xFF0E1620),
    backgroundAlt: Color(0xFF142030),
    surface: Color(0xFF152433),
    surfaceElevated: Color(0xFF1D3040),
    surfaceHighlight: Color(0xFF274056),
    border: Color(0xFF3A5368),
    borderSubtle: Color(0xFF2A3F52),
    borderGlow: Color(0x66E0B872),
    textPrimary: Color(0xFFF3F7FA),
    textSecondary: Color(0xFFA7BCC9),
    textMuted: Color(0xFF6F8798),
    accent: Color(0xFFE0B872),
    accentDeep: Color(0xFFC4924A),
    accentBright: Color(0xFFF0D29A),
    accentSoft: Color(0x33E0B872),
    teal: Color(0xFF5ECFBF),
    tealDeep: Color(0xFF2F9E90),
    tealSoft: Color(0x285ECFBF),
    mist: Color(0xFF7EB8C9),
    inkBlue: Color(0xFF1A3A55),
    dusk: Color(0xFF243B4D),
    danger: Color(0xFFFF6B5C),
    dangerSoft: Color(0x33FF6B5C),
    success: Color(0xFF5DCC8F),
    successSoft: Color(0x285DCC8F),
    warning: Color(0xFFF0C65A),
    onAccent: Color(0xFF1A1208),
    atmosphere: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF14283A), Color(0xFF0A121A), Color(0xFF0C1614)],
      stops: [0.0, 0.55, 1.0],
    ),
    panel: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF1E3344), Color(0xFF152433), Color(0xFF12202C)],
    ),
    panelEdge: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0x66E0B872), Color(0x334DB8A8), Color(0x222A3F52)],
    ),
    champagne: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFF0D29A), Color(0xFFE0B872), Color(0xFFC4924A)],
    ),
    aqua: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF7EE0D2), Color(0xFF5ECFBF), Color(0xFF2F9E90)],
    ),
    action: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFF243849), Color(0xFF1A2E3C), Color(0xFF1F3540)],
    ),
    brandText: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFF6E8), Color(0xFFF0D29A), Color(0xFFE0B872)],
    ),
    heroWash: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x66070C12),
        Color(0x33070C12),
        Color(0xCC0A1620),
        Color(0xFF070C12),
      ],
      stops: [0.0, 0.35, 0.72, 1.0],
    ),
  );

  /// Clair : fond brume froide, surfaces blanches, bronze & teal lisibles.
  static const AppPalette light = AppPalette(
    background: Color(0xFFF2F5F8),
    backgroundMid: Color(0xFFE6ECF2),
    backgroundAlt: Color(0xFFD9E2EB),
    surface: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFF8FAFC),
    surfaceHighlight: Color(0xFFEEF3F7),
    border: Color(0xFFB7C7D6),
    borderSubtle: Color(0xFFD3DEE8),
    borderGlow: Color(0x55B8893F),
    textPrimary: Color(0xFF12202C),
    textSecondary: Color(0xFF4A6172),
    textMuted: Color(0xFF7A909F),
    accent: Color(0xFFB8893F),
    accentDeep: Color(0xFF8F6A2A),
    accentBright: Color(0xFFCFA04E),
    accentSoft: Color(0x28B8893F),
    teal: Color(0xFF178A7C),
    tealDeep: Color(0xFF0F6B60),
    tealSoft: Color(0x22178A7C),
    mist: Color(0xFF3A8FA6),
    inkBlue: Color(0xFFD4E6F0),
    dusk: Color(0xFFE4EDF4),
    danger: Color(0xFFD64538),
    dangerSoft: Color(0x22D64538),
    success: Color(0xFF1B8F55),
    successSoft: Color(0x221B8F55),
    warning: Color(0xFFB8860B),
    onAccent: Color(0xFFFFFFFF),
    atmosphere: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFEAF1F6), Color(0xFFF2F5F8), Color(0xFFE8F0EE)],
      stops: [0.0, 0.55, 1.0],
    ),
    panel: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFF7FAFC), Color(0xFFF1F5F8)],
    ),
    panelEdge: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0x55B8893F), Color(0x33178A7C), Color(0x22D3DEE8)],
    ),
    champagne: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFCFA04E), Color(0xFFB8893F), Color(0xFF8F6A2A)],
    ),
    aqua: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF2BB5A3), Color(0xFF178A7C), Color(0xFF0F6B60)],
    ),
    action: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [Color(0xFFFFFFFF), Color(0xFFF4F8FA), Color(0xFFEDF3F7)],
    ),
    brandText: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFF8F6A2A), Color(0xFFB8893F), Color(0xFF178A7C)],
    ),
    heroWash: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x55F2F5F8),
        Color(0x22F2F5F8),
        Color(0xCCE8EEF4),
        Color(0xFFF2F5F8),
      ],
      stops: [0.0, 0.35, 0.72, 1.0],
    ),
  );

  @override
  AppPalette copyWith({
    Color? background,
    Color? textPrimary,
  }) {
    return AppPalette(
      background: background ?? this.background,
      backgroundMid: backgroundMid,
      backgroundAlt: backgroundAlt,
      surface: surface,
      surfaceElevated: surfaceElevated,
      surfaceHighlight: surfaceHighlight,
      border: border,
      borderSubtle: borderSubtle,
      borderGlow: borderGlow,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary,
      textMuted: textMuted,
      accent: accent,
      accentDeep: accentDeep,
      accentBright: accentBright,
      accentSoft: accentSoft,
      teal: teal,
      tealDeep: tealDeep,
      tealSoft: tealSoft,
      mist: mist,
      inkBlue: inkBlue,
      dusk: dusk,
      danger: danger,
      dangerSoft: dangerSoft,
      success: success,
      successSoft: successSoft,
      warning: warning,
      onAccent: onAccent,
      atmosphere: atmosphere,
      panel: panel,
      panelEdge: panelEdge,
      champagne: champagne,
      aqua: aqua,
      action: action,
      brandText: brandText,
      heroWash: heroWash,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return t < 0.5 ? this : other;
  }
}

extension AppPaletteX on BuildContext {
  AppPalette get colors =>
      Theme.of(this).extension<AppPalette>() ?? AppPalette.dark;

  bool get isDarkTheme => Theme.of(this).brightness == Brightness.dark;
}

/// Alias de compatibilité (thème sombre) — préférer `context.colors`.
class AppColors {
  static const Color background = Color(0xFF070C12);
  static const Color backgroundMid = Color(0xFF0E1620);
  static const Color backgroundAlt = Color(0xFF142030);
  static const Color surface = Color(0xFF152433);
  static const Color surfaceElevated = Color(0xFF1D3040);
  static const Color surfaceHighlight = Color(0xFF274056);
  static const Color border = Color(0xFF3A5368);
  static const Color borderSubtle = Color(0xFF2A3F52);
  static const Color borderGlow = Color(0x66E0B872);
  static const Color textPrimary = Color(0xFFF3F7FA);
  static const Color textSecondary = Color(0xFFA7BCC9);
  static const Color textMuted = Color(0xFF6F8798);
  static const Color accent = Color(0xFFE0B872);
  static const Color accentDeep = Color(0xFFC4924A);
  static const Color accentBright = Color(0xFFF0D29A);
  static const Color accentSoft = Color(0x33E0B872);
  static const Color teal = Color(0xFF5ECFBF);
  static const Color tealDeep = Color(0xFF2F9E90);
  static const Color tealSoft = Color(0x285ECFBF);
  static const Color mist = Color(0xFF7EB8C9);
  static const Color inkBlue = Color(0xFF1A3A55);
  static const Color dusk = Color(0xFF243B4D);
  static const Color danger = Color(0xFFFF6B5C);
  static const Color dangerSoft = Color(0x33FF6B5C);
  static const Color success = Color(0xFF5DCC8F);
  static const Color successSoft = Color(0x285DCC8F);
  static const Color warning = Color(0xFFF0C65A);
  static const Color textColor = textPrimary;
  static const Color buttonColor = surfaceElevated;
  static const Color navBarColor = surface;
  static const Color iconColor = textSecondary;
}

class AppGradients {
  static LinearGradient atmosphereOf(BuildContext context) =>
      context.colors.atmosphere;
  static LinearGradient panelOf(BuildContext context) => context.colors.panel;
  static LinearGradient panelEdgeOf(BuildContext context) =>
      context.colors.panelEdge;
  static LinearGradient champagneOf(BuildContext context) =>
      context.colors.champagne;
  static LinearGradient aquaOf(BuildContext context) => context.colors.aqua;
  static LinearGradient actionOf(BuildContext context) => context.colors.action;
  static LinearGradient brandTextOf(BuildContext context) =>
      context.colors.brandText;
  static LinearGradient heroWashOf(BuildContext context) =>
      context.colors.heroWash;

  // Alias sombres (fallback)
  static LinearGradient get atmosphere => AppPalette.dark.atmosphere;
  static LinearGradient get panel => AppPalette.dark.panel;
  static LinearGradient get panelEdge => AppPalette.dark.panelEdge;
  static LinearGradient get champagne => AppPalette.dark.champagne;
  static LinearGradient get aqua => AppPalette.dark.aqua;
  static LinearGradient get action => AppPalette.dark.action;
  static LinearGradient get brandText => AppPalette.dark.brandText;
  static LinearGradient get heroWash => AppPalette.dark.heroWash;
}
