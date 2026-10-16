import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import 'app_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.showDrawer = true,
    this.actions,
    this.floatingActionButton,
    this.padding,
    this.extendBodyBehindAppBar = false,
  });

  final Widget body;
  final String? title;
  final bool showDrawer;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final orbAlpha = context.isDarkTheme ? 1.0 : 0.55;

    return Scaffold(
      backgroundColor: c.background,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: AppBar(
        title: title == null
            ? null
            : Text(
                title!,
                style: GoogleFonts.outfit(
                  color: c.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.2,
                ),
              ),
        actions: actions,
      ),
      drawer: showDrawer ? const AppDrawer() : null,
      floatingActionButton: floatingActionButton,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: c.atmosphere),
            ),
          ),
          Positioned(
            top: -80,
            right: -60,
            child: _GlowOrb(
              size: 220,
              color: c.accent.withValues(alpha: 0.14 * orbAlpha),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -70,
            child: _GlowOrb(
              size: 260,
              color: c.teal.withValues(alpha: 0.10 * orbAlpha),
            ),
          ),
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.35,
            right: -40,
            child: _GlowOrb(
              size: 140,
              color: c.mist.withValues(alpha: 0.07 * orbAlpha),
            ),
          ),
          Positioned.fill(
            child: padding == null
                ? body
                : SafeArea(
                    child: Padding(padding: padding!, child: body),
                  ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color,
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}
