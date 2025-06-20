import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/app_drawer.dart';

class DonneesCapteursPage extends StatelessWidget {
  const DonneesCapteursPage({super.key});

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
            // 🔴 Zone de détection de mine
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[700],
                border: Border.all(color: Colors.redAccent, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.redAccent, size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.mineDetection,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          AppLocalizations.of(context)!.mineDetected,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 🧾 Données capteurs
            _buildDataRow(Icons.battery_full, AppLocalizations.of(context)!.battery, '86%'),
            _buildDataRow(Icons.thermostat, AppLocalizations.of(context)!.temperature, '23,5°C'),
            _buildDataRow(Icons.water_drop, AppLocalizations.of(context)!.humidity, '45%'),
            _buildDataRow(Icons.straighten, AppLocalizations.of(context)!.distance, '120 cm'),
            _buildDataRow(Icons.landscape, AppLocalizations.of(context)!.altitude, '12,8 m'),
            _buildDataRow(Icons.speed, AppLocalizations.of(context)!.pressure, '1012 hPa'),
            _buildDataRow(Icons.electric_bolt, AppLocalizations.of(context)!.voltage, '7,4 V'),

            const SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.map,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Ajout couleur lisible
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 🗺 Carte stylisée
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  colors: [Colors.blueGrey, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.navigation,
                    color: Colors.cyanAccent, size: 30),
              ),
            ),

            const Spacer(),

            // 🔘 Bouton Actualiser
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Action pour rafraîchir les données
                    },
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

  static Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }
}