import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/routes.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_drawer.dart';
import '../../shared/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final c = context.colors;
    final top = MediaQuery.paddingOf(context).top;
    final heroHeight = MediaQuery.sizeOf(context).height * 0.56;

    return Scaffold(
      backgroundColor: c.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: c.atmosphere),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: Image.asset(
              'assets/Rover.jpg',
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: c.heroWash),
            ),
          ),
          Positioned(
            top: heroHeight * 0.15,
            right: -40,
            child: IgnorePointer(
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      c.accent.withValues(alpha: 0.18),
                      c.accent.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: heroHeight * 0.45,
            left: -50,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      c.teal.withValues(alpha: 0.12),
                      c.teal.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(24, top > 0 ? 8 : 20, 24, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.asset(
                      'assets/r_mind_logo.png',
                      width: 88,
                      height: 88,
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
                        fontSize: 42,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.2,
                        height: 1.05,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    loc.robotName,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: c.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 56,
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      gradient: c.champagne,
                    ),
                  ),
                  const SizedBox(height: 28),
                  CustomButton(
                    text: loc.pilot,
                    icon: Icons.sports_esports_rounded,
                    accentColor: c.accent,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.control),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: loc.data,
                    icon: Icons.ssid_chart_rounded,
                    accentColor: c.teal,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.data),
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: loc.map,
                    icon: Icons.map_rounded,
                    accentColor: c.mist,
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRoutes.map),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
