import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/api/rover_api.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/utils/mine_status.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/surface_panel.dart';

class SensorsScreen extends StatefulWidget {
  const SensorsScreen({super.key, required this.api});

  final RoverApi api;

  @override
  State<SensorsScreen> createState() => _SensorsScreenState();
}

class _SensorsScreenState extends State<SensorsScreen> {
  bool _calibrated = false;
  bool _calibrating = false;

  static const Map<String, dynamic> _defaults = {
    'mine': false,
    'temperature': '--',
    'humidity': '--',
    'gas': '--',
    'distance': '--',
    'motion': '--',
    'magnetic_field': '--',
    'metal': '--',
  };

  Map<String, dynamic> _capteurs = Map<String, dynamic>.from(_defaults);
  Timer? _timer;
  bool _offline = false;
  bool _prevMine = false;

  Future<void> _fetchData() async {
    final result = await widget.api.fetchSensors();
    if (!mounted) return;

    if (!result.ok || result.data == null) {
      setState(() => _offline = true);
      return;
    }

    final data = result.data!;
    final sensorData = data['sensor_data'];
    final detected = isMineDetectedStatus(
      data['mine_status']?.toString(),
      mineDetectedFlag: data['mine_detected'] == true,
    );

    if (detected && !_prevMine) {
      HapticFeedback.heavyImpact();
    }
    _prevMine = detected;

    final cal = data['calibration'];
    setState(() {
      _offline = false;
      _calibrated = cal is Map && cal['calibrated'] == true;
      _capteurs = {
        ..._defaults,
        'mine': detected,
        if (sensorData is Map) ...Map<String, dynamic>.from(sensorData),
      };
    });
  }

  Future<void> _calibrate() async {
    setState(() => _calibrating = true);
    final result = await widget.api.calibrate();
    if (!mounted) return;
    setState(() => _calibrating = false);
    final ok = result.ok && result.data?['ok'] != false;
    if (ok) {
      setState(() => _calibrated = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Calibration terrain enregistrée')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.data?['error']?.toString() ??
                result.error ??
                'Calibration échouée',
          ),
        ),
      );
    }
  }

  String _value(String key) => _capteurs[key]?.toString() ?? '--';

  @override
  void initState() {
    super.initState();
    _fetchData();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final c = context.colors;
    final mineDetected = _capteurs['mine'] == true;
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 360 ? 1 : 2;

    final sensors = [
      _SensorItem(Icons.thermostat_rounded, loc.temperature, _value('temperature')),
      _SensorItem(Icons.water_drop_rounded, loc.humidity, _value('humidity')),
      _SensorItem(Icons.cloud_rounded, loc.gas, _value('gas')),
      _SensorItem(Icons.straighten_rounded, loc.distance, _value('distance')),
      _SensorItem(Icons.directions_run_rounded, loc.motion, _value('motion')),
      _SensorItem(Icons.explore_rounded, loc.magneticField, _value('magnetic_field')),
      _SensorItem(Icons.build_circle_rounded, loc.metal, _value('metal')),
    ];

    return AppScaffold(
      title: loc.data,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      body: Column(
        children: [
          if (_offline)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SurfacePanel(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.cloud_off, color: c.warning),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        loc.offline,
                        style: GoogleFonts.outfit(color: c.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          _MineAlert(mineDetected: mineDetected, loc: loc),
          const SizedBox(height: 8),
          SurfacePanel(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  _calibrated ? Icons.verified_rounded : Icons.tune_rounded,
                  color: _calibrated ? c.teal : c.warning,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _calibrated
                        ? 'Calibration terrain active'
                        : 'Non calibré (seuils lab)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      color: c.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _calibrating ? null : _calibrate,
                  child: Text(_calibrating ? '...' : 'Calibrer'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final gap = 10.0;
                final cardWidth =
                    (constraints.maxWidth - gap * (columns - 1)) / columns;
                // Cartes un peu plus hautes que larges pour éviter l'overflow
                final aspect = columns == 1 ? 2.4 : 1.05;

                return GridView.builder(
                  itemCount: sensors.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    mainAxisSpacing: gap,
                    crossAxisSpacing: gap,
                    childAspectRatio: aspect,
                  ),
                  itemBuilder: (context, index) {
                    final item = sensors[index];
                    return SurfacePanel(
                      padding: EdgeInsets.all(cardWidth < 150 ? 10 : 12),
                      child: _SensorCard(item: item),
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _fetchData,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(loc.refresh),
            ),
          ),
        ],
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  const _SensorCard({required this.item});

  final _SensorItem item;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 110;
        final iconSize = compact ? 28.0 : 34.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: BoxDecoration(
                color: c.tealSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.icon,
                color: c.teal,
                size: iconSize * 0.55,
              ),
            ),
            const Spacer(flex: 2),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(
                color: c.textSecondary,
                fontSize: compact ? 11 : 12.5,
                height: 1.1,
              ),
            ),
            SizedBox(height: compact ? 2 : 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                item.value,
                maxLines: 1,
                style: GoogleFonts.outfit(
                  color: c.textPrimary,
                  fontSize: compact ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SensorItem {
  const _SensorItem(this.icon, this.label, this.value);
  final IconData icon;
  final String label;
  final String value;
}

class _MineAlert extends StatelessWidget {
  const _MineAlert({required this.mineDetected, required this.loc});

  final bool mineDetected;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final accent = mineDetected ? c.danger : c.success;
    final soft = mineDetected ? c.dangerSoft : c.successSoft;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: soft,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accent.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Icon(
            mineDetected
                ? Icons.warning_amber_rounded
                : Icons.verified_user_rounded,
            color: accent,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.mineDetection,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: c.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  mineDetected ? loc.mineDetected : loc.noMine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    color: accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
