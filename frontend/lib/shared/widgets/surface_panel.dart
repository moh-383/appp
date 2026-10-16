import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

class SurfacePanel extends StatelessWidget {
  const SurfacePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderColor,
    this.color,
    this.onTap,
    this.luminous = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? color;
  final VoidCallback? onTap;
  final bool luminous;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final radius = BorderRadius.circular(18);
    final isLight = !context.isDarkTheme;

    final panel = Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: luminous ? c.panelEdge : null,
      ),
      padding: const EdgeInsets.all(1.1),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(17),
          gradient: color == null ? c.panel : null,
          color: color,
          border: Border.all(
            color: borderColor ?? c.borderSubtle.withValues(alpha: 0.9),
          ),
          boxShadow: [
            BoxShadow(
              color: isLight
                  ? const Color(0x140F1C28)
                  : c.background.withValues(alpha: 0.45),
              blurRadius: isLight ? 14 : 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: child,
      ),
    );

    if (onTap == null) return panel;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: panel,
      ),
    );
  }
}
