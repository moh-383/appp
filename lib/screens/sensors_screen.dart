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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade900.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Détection Mines:\nMINE DETECTEE',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDataRow('Batterie', '86%'),
            _buildDataRow('Température', '23,5°C'),
            _buildDataRow('Humidité', '45%'),
            _buildDataRow('Distance', '120 cm'),
            _buildDataRow('Subsurface', '12,8°C'),
            _buildDataRow('Pressure', '1012 hPa'),
            _buildDataRow('Motor Voltage', '7,4 V'),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Cartographie',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
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
                child: Icon(Icons.navigation, color: Colors.cyanAccent, size: 30),
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualiser'),
                  ),
                ),
                const SizedBox(width: 12),

              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}