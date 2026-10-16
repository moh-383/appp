import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/surface_panel.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final c = context.colors;

    return AppScaffold(
      title: loc.about,
      showDrawer: false,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      body: ListView(
        children: [
          SurfacePanel(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/r_mind_logo.png',
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 18),
                ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) =>
                      c.brandText.createShader(bounds),
                  child: Text(
                    'R_Mind App',
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  loc.aboutTitle,
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    color: c.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SurfacePanel(
            child: Text(
              loc.aboutDescription,
              style: GoogleFonts.outfit(
                fontSize: 16,
                height: 1.55,
                color: c.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
