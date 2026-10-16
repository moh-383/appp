import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/routes.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final c = context.colors;
    final route = ModalRoute.of(context)?.settings.name;

    return Drawer(
      backgroundColor: c.backgroundMid,
      child: DecoratedBox(
        decoration: BoxDecoration(gradient: c.atmosphere),
        child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: c.panel,
                border: Border.all(color: c.borderGlow),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/r_mind_logo.png',
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (bounds) =>
                        c.brandText.createShader(bounds),
                    child: Text(
                      'R_Mind App',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    loc.robotName,
                    style: GoogleFonts.outfit(
                      color: c.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                children: [
                  _tile(
                    context,
                    icon: Icons.home_rounded,
                    label: loc.home,
                    selected: route == AppRoutes.home,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.home,
                        (_) => false,
                      );
                    },
                  ),
                  _tile(
                    context,
                    icon: Icons.ssid_chart_rounded,
                    label: loc.data,
                    selected: route == AppRoutes.data,
                    onTap: () => _go(context, AppRoutes.data),
                  ),
                  _tile(
                    context,
                    icon: Icons.sports_esports_rounded,
                    label: loc.pilot,
                    selected: route == AppRoutes.control,
                    onTap: () => _go(context, AppRoutes.control),
                  ),
                  _tile(
                    context,
                    icon: Icons.map_rounded,
                    label: loc.map,
                    selected: route == AppRoutes.map,
                    onTap: () => _go(context, AppRoutes.map),
                  ),
                  _tile(
                    context,
                    icon: Icons.settings_rounded,
                    label: loc.settings,
                    selected: route == AppRoutes.settings,
                    onTap: () => _go(context, AppRoutes.settings),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Text(
                'Field Ops · v1.0',
                style: GoogleFonts.outfit(
                  color: c.textMuted,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _go(BuildContext context, String route) {
    Navigator.pop(context);
    Navigator.pushNamed(context, route);
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool selected = false,
  }) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        selected: selected,
        selectedTileColor: c.accentSoft,
        leading: Icon(
          icon,
          color: selected ? c.accent : c.textSecondary,
        ),
        title: Text(
          label,
          style: GoogleFonts.outfit(
            color: selected ? c.accent : c.textPrimary,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 15,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        onTap: onTap,
      ),
    );
  }
}
