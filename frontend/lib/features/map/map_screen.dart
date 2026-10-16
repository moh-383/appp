import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../core/api/rover_api.dart';
import '../../core/l10n/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/surface_panel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.api});

  final RoverApi api;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  double _latitude = 12.3714;
  double _longitude = -1.5197;
  int _angle = 0;
  int _obstacles = 0;
  int _mines = 0;
  List<LatLng> _path = [];
  List<LatLng> _minePoints = [];
  Timer? _timer;
  bool _offline = false;
  bool _follow = true;

  Future<void> _fetchData() async {
    final result = await widget.api.fetchMap();
    if (!mounted) return;
    if (!result.ok || result.data == null) {
      setState(() => _offline = true);
      return;
    }

    final body = result.data!;
    final path = <LatLng>[];
    for (final p in (body['path'] as List?) ?? []) {
      if (p is Map) {
        final lat = (p['latitude'] as num?)?.toDouble() ?? 0;
        final lon = (p['longitude'] as num?)?.toDouble() ?? 0;
        if (_isValidGps(lat, lon)) path.add(LatLng(lat, lon));
      }
    }
    final mines = <LatLng>[];
    for (final e in (body['mine_events'] as List?) ?? []) {
      if (e is Map) {
        final lat = (e['latitude'] as num?)?.toDouble() ?? 0;
        final lon = (e['longitude'] as num?)?.toDouble() ?? 0;
        if (_isValidGps(lat, lon)) mines.add(LatLng(lat, lon));
      }
    }

    final lat = (body['latitude'] as num?)?.toDouble() ?? _latitude;
    final lon = (body['longitude'] as num?)?.toDouble() ?? _longitude;

    setState(() {
      _offline = false;
      _latitude = lat;
      _longitude = lon;
      _angle = (body['angle'] as num?)?.toInt() ?? 0;
      _obstacles = (body['obstacles'] as num?)?.toInt() ?? 0;
      _mines = (body['mines'] as num?)?.toInt() ?? mines.length;
      _path = path;
      _minePoints = mines;
    });

    if (_follow && _isValidGps(lat, lon)) {
      _mapController.move(LatLng(lat, lon), 16);
    }
  }

  bool _isValidGps(double lat, double lon) =>
      !(lat == 0 && lon == 0) && lat.abs() <= 90 && lon.abs() <= 180;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final c = context.colors;
    final center = LatLng(_latitude, _longitude);

    return AppScaffold(
      title: loc.mapTitle,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      actions: [
        IconButton(
          tooltip: loc.followRover,
          onPressed: () => setState(() => _follow = !_follow),
          icon: Icon(
            _follow ? Icons.my_location : Icons.location_searching,
            color: _follow ? c.teal : c.textMuted,
          ),
        ),
      ],
      body: Column(
        children: [
          if (_offline)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: SurfacePanel(
                child: Text(
                  loc.offline,
                  style: GoogleFonts.outfit(color: c.textPrimary),
                ),
              ),
            ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 16,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.appp',
                  ),
                  if (_path.length >= 2)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: _path,
                          color: c.teal,
                          strokeWidth: 4,
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      ..._minePoints.map(
                        (m) => Marker(
                          point: m,
                          width: 36,
                          height: 36,
                          child: Icon(
                            Icons.whatshot,
                            color: c.danger,
                          ),
                        ),
                      ),
                      if (_isValidGps(_latitude, _longitude))
                        Marker(
                          point: center,
                          width: 48,
                          height: 48,
                          child: Transform.rotate(
                            angle: _angle * 3.14159 / 180,
                            child: Icon(
                              Icons.navigation,
                              color: c.accent,
                              size: 36,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SurfacePanel(
            child: Column(
              children: [
                _StatRow('GPS',
                    '${_latitude.toStringAsFixed(5)}, ${_longitude.toStringAsFixed(5)}'),
                _StatRow(loc.pathPoints, '${_path.length}'),
                _StatRow(loc.direction, '$_angle°'),
                _StatRow(loc.obstacles, '$_obstacles'),
                _StatRow(loc.mines, '$_mines'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(color: c.textSecondary),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: c.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
