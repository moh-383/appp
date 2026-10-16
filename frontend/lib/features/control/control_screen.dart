import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/api/rover_api.dart';
import '../../core/config/api_config.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/providers/mine_alert_provider.dart';
import '../../shared/utils/snack.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/surface_panel.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key, required this.api});

  final RoverApi api;

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  String _lastDirection = 'stop';
  DateTime _lastSent = DateTime.fromMillisecondsSinceEpoch(0);
  bool _busy = false;
  bool _auto = false;
  String _coveragePhase = '';
  Timer? _autoPoll;

  Future<void> _send(String direction, {bool force = false}) async {
    final now = DateTime.now();
    if (!force &&
        direction == _lastDirection &&
        now.difference(_lastSent) < const Duration(milliseconds: 250)) {
      return;
    }
    if (!force && now.difference(_lastSent) < const Duration(milliseconds: 180)) {
      return;
    }
    _lastDirection = direction;
    _lastSent = now;

    final result = await widget.api.sendCommand(direction);
    if (!mounted || direction == 'stop' && result.ok) return;
    if (!result.ok) {
      showAppSnack(context, result.error ?? 'Erreur commande', isError: true);
    }
  }

  void _onJoystickMove(StickDragDetails details) {
    if (_auto) return;
    if (details.y < -0.7) {
      _send('forward');
    } else if (details.y > 0.7) {
      _send('backward');
    } else if (details.x < -0.7) {
      _send('left');
    } else if (details.x > 0.7) {
      _send('right');
    } else {
      _send('stop');
    }
  }

  void _onJoystickRelease() {
    if (!_auto) _send('stop', force: true);
  }

  Future<void> _arm(Future<ApiResult> Function() action, String okMsg) async {
    if (_busy) return;
    setState(() => _busy = true);
    final result = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    showAppSnack(
      context,
      result.ok ? okMsg : (result.error ?? 'Erreur'),
      isError: !result.ok,
    );
  }

  Future<void> _toggleAuto(bool enabled) async {
    if (enabled && context.read<MineAlertProvider>().mineDetected) {
      showAppSnack(context, 'Mine détectée — auto désactivé', isError: true);
      return;
    }
    // La boucle d'avance / stop-mine tourne côté backend (auto_pilot).
    final result = await widget.api.setAutoMode(enabled);
    if (!mounted) return;
    if (!result.ok) {
      showAppSnack(context, result.error ?? 'Erreur', isError: true);
      return;
    }
    final enabledServer = result.data?['auto_mode'] == true;
    final phase = result.data?['coverage'] is Map
        ? result.data!['coverage']['phase']?.toString() ?? ''
        : '';
    setState(() {
      _auto = enabledServer;
      _coveragePhase = phase;
    });
    if (result.data?['error'] != null) {
      showAppSnack(context, result.data!['error'].toString(), isError: true);
    }
    _ensureAutoPoll();
  }

  void _ensureAutoPoll() {
    _autoPoll ??= Timer.periodic(const Duration(seconds: 2), (_) async {
      final status = await widget.api.getAutoMode();
      if (!mounted || !status.ok) return;
      final enabled = status.data?['auto_mode'] == true;
      final phase = status.data?['coverage'] is Map
          ? status.data!['coverage']['phase']?.toString() ?? ''
          : '';
      if (enabled != _auto || phase != _coveragePhase) {
        setState(() {
          _auto = enabled;
          _coveragePhase = phase;
        });
        if (!enabled && context.read<MineAlertProvider>().mineDetected) {
          showAppSnack(context, 'Mine détectée — auto arrêté', isError: true);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _ensureAutoPoll();
    widget.api.getAutoMode().then((status) {
      if (!mounted || !status.ok) return;
      final phase = status.data?['coverage'] is Map
          ? status.data!['coverage']['phase']?.toString() ?? ''
          : '';
      setState(() {
        _auto = status.data?['auto_mode'] == true;
        _coveragePhase = phase;
      });
    });
  }

  @override
  void dispose() {
    _autoPoll?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final c = context.colors;
    final camUrl = context.watch<ApiConfig>().esp32CamStreamUrl;
    final mine = context.watch<MineAlertProvider>().mineDetected;

    return AppScaffold(
      title: loc.controlTitle,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SurfacePanel(
              child: SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  loc.auto,
                  style: GoogleFonts.outfit(
                    color: c.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  mine
                      ? loc.mineDetected
                      : _auto && _coveragePhase.isNotEmpty
                          ? 'Couverture lawnmower · phase $_coveragePhase'
                          : loc.pilot,
                  style: GoogleFonts.outfit(
                    color: mine ? c.danger : c.textSecondary,
                    fontSize: 13,
                  ),
                ),
                value: _auto,
                activeThumbColor: c.teal,
                onChanged: mine ? null : _toggleAuto,
              ),
            ),
            const SizedBox(height: 16),
            SurfacePanel(
              padding: EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
                  child: ColoredBox(
                    color: Colors.black,
                    child: Mjpeg(
                      stream: camUrl,
                      isLive: true,
                      error: (context, error, stack) => Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.videocam_off_rounded,
                              color: c.textMuted,
                              size: 36,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              loc.cameraError,
                              style: GoogleFonts.outfit(
                                color: c.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              loc.pilot,
              style: GoogleFonts.outfit(
                color: c.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 16),
            Listener(
              onPointerUp: (_) => _onJoystickRelease(),
              onPointerCancel: (_) => _onJoystickRelease(),
              child: Joystick(
                mode: JoystickMode.all,
                stick: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: c.champagne,
                    boxShadow: [
                      BoxShadow(
                        color: c.accent.withValues(alpha: 0.45),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.navigation_rounded,
                    color: Color(0xFF1A1208),
                    size: 26,
                  ),
                ),
                base: Container(
                  width: 210,
                  height: 210,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: c.panel,
                    border: Border.all(
                      color: c.accent.withValues(alpha: 0.35),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 18,
                        child: Text(loc.forward, style: _labelStyle),
                      ),
                      Positioned(
                        bottom: 18,
                        child: Text(loc.backward, style: _labelStyle),
                      ),
                      Positioned(
                        left: 18,
                        child: Text(loc.left, style: _labelStyle),
                      ),
                      Positioned(
                        right: 18,
                        child: Text(loc.right, style: _labelStyle),
                      ),
                    ],
                  ),
                ),
                listener: _onJoystickMove,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    label: loc.stop,
                    icon: Icons.stop_rounded,
                    color: c.danger,
                    softColor: c.dangerSoft,
                    onPressed: () => _send('stop', force: true),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    label: loc.startArm,
                    icon: Icons.play_arrow_rounded,
                    color: c.teal,
                    softColor: c.tealSoft,
                    onPressed: _busy
                        ? null
                        : () => _arm(widget.api.startArm, loc.commandSent),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ActionButton(
                    label: loc.stopArm,
                    icon: Icons.pause_rounded,
                    color: c.accent,
                    softColor: c.accentSoft,
                    onPressed: _busy
                        ? null
                        : () => _arm(widget.api.stopArm, loc.commandSent),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _labelStyle => GoogleFonts.outfit(
    color: context.colors.textSecondary,
    fontWeight: FontWeight.w600,
    fontSize: 12,
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.softColor,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color softColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: softColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: c.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
