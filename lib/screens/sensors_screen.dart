import 'package:flutter/material.dart';

void main() {
  runApp(const CapteursApp());
}

class CapteursApp extends StatelessWidget {
  const CapteursApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Données Capteurs',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const DonneesCapteursPage(),
    );
  }
}

class DonneesCapteursPage extends StatelessWidget {
  const DonneesCapteursPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: const Text('Données + Capteurs'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔴 Zone stylée de détection de mine
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                border: Border.all(color: Colors.redAccent, width: 2),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.4),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.redAccent, size: 36),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Détection de Mines',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '⚠ MINE DÉTECTÉE',
                          style: TextStyle(
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

            // 🧾 Lignes de données avec icônes
            _buildDataRow(Icons.battery_full, 'Batterie', '86%'),
            _buildDataRow(Icons.thermostat, 'Température', '23,5°C'),
            _buildDataRow(Icons.water_drop, 'Humidité', '45%'),
            _buildDataRow(Icons.straighten, 'Distance', '120 cm'),
            _buildDataRow(Icons.landscape, 'Subsurface', '12,8°C'),
            _buildDataRow(Icons.speed, 'Pression', '1012 hPa'),
            _buildDataRow(Icons.electric_bolt, 'Motor Voltage', '7,4 V'),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Cartographie',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // 🗺 Carte stylisée
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
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
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualiser'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 🧩 Widget avec icône + texte + valeur
  static Widget _buildDataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}