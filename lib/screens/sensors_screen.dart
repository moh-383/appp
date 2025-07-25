import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../l10n/app_localizations.dart';
import '../utils/app_drawer.dart';

class DonneesCapteursPage extends StatefulWidget {
  const DonneesCapteursPage({super.key});

  @override
  State<DonneesCapteursPage> createState() => _DonneesCapteursPageState();
}

class _DonneesCapteursPageState extends State<DonneesCapteursPage> {
  Map<String, dynamic> capteurs = {
    "mine": false,
    "temperature": "--",
    "humidity": "--",
    "gas": "--",
    "distance": "--",
    "motion": "--",
    "magnetic_field": "--",
    "metal": "--",
  };

  Timer? _timer;
  final String backendUrl = 'http://127.0.0.1:8000/map/'; // ← Modifie ici

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/sensors/'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          capteurs = {
            "mine": data['mine_status'] == "Mine détectée",
            ...data['sensor_data'],
          };
        });
      }
    } catch (e) {
      print('Erreur fetchData: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => fetchData());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.data),
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMineAlert(capteurs['mine']),
            const SizedBox(height: 16),
            _buildDataRow(Icons.thermostat, "Température", capteurs['temperature'].toString()),
            _buildDataRow(Icons.water_drop, "Humidité", capteurs['humidity'].toString()),
            _buildDataRow(Icons.cloud, "Gaz", capteurs['gas'].toString()),
            _buildDataRow(Icons.straighten, "Distance", capteurs['distance'].toString()),
            _buildDataRow(Icons.directions_run, "Mouvement", capteurs['motion'].toString()),
            _buildDataRow(Icons.explore, "Champ magnétique", capteurs['magnetic_field'].toString()),
            _buildDataRow(Icons.build_circle, "Métal détecté", capteurs['metal'].toString()),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: fetchData,
                    icon: const Icon(Icons.refresh),
                    label: Text(AppLocalizations.of(context)!.refresh),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMineAlert(bool mineDetected) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mineDetected ? Colors.red[700] : Colors.green[700],
        border: Border.all(
          color: mineDetected ? Colors.redAccent : Colors.greenAccent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: mineDetected ? Colors.redAccent : Colors.greenAccent,
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: mineDetected ? Colors.redAccent : Colors.greenAccent,
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.mineDetection,
                  style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  mineDetected ? AppLocalizations.of(context)!.mineDetected : AppLocalizations.of(context)!.noMine,
                  style: TextStyle(fontSize: 18, color: mineDetected ? Colors.red : Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
          ),
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }
}
