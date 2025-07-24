import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../theme/app_colors.dart';
import '../utils/app_drawer.dart';
import '../l10n/app_localizations.dart';

class CartographiePage extends StatefulWidget {
  const CartographiePage({super.key});

  @override
  State<CartographiePage> createState() => _CartographiePageState();
}

class _CartographiePageState extends State<CartographiePage> {
  double latitude = 0.0;
  double longitude = 0.0;
  int angle = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fetchGPSData(); // Appel initial
    timer = Timer.periodic(const Duration(seconds: 3), (_) => fetchGPSData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchGPSData() async {
    try {
      final response = await http.get(Uri.parse('http://<IP_DU_BACKEND>:8000/gps'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data.containsKey('error')) {
          setState(() {
            latitude = data['lat'];
            longitude = data['lon'];
            angle = data['angle'];
          });
        }
      }
    } catch (e) {
      print('Erreur de récupération GPS : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.iconColor),
      ),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Stack(
          children: [
            // Titre
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                AppLocalizations.of(context)!.mapTitle,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
            ),

            // Carte fictive avec position du robot
            Positioned.fill(
              top: 70,
              child: Center(
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyanAccent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.electric_car, size: 50, color: Colors.cyanAccent),
                            Text(
                              '$angle°',
                              style: const TextStyle(color: Colors.cyanAccent),
                            ),
                          ],
                        ),
                      ),
                      const Positioned(top: 20, left: 20, child: Icon(Icons.warning, color: Colors.yellow, size: 30)),
                      const Positioned(bottom: 10, right: 10, child: Icon(Icons.whatshot, color: Colors.red, size: 30)),
                    ],
                  ),
                ),
              ),
            ),

            // Infos textuelles
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dataRow(Icons.location_on, 'Lat: ${latitude.toStringAsFixed(5)}, Lon: ${longitude.toStringAsFixed(5)}', Colors.cyanAccent),
                  dataRow(Icons.navigation, '${AppLocalizations.of(context)!.direction}: $angle°', Colors.cyanAccent),
                  dataRow(Icons.warning, '${AppLocalizations.of(context)!.obstacles}: 2', Colors.yellow),
                  dataRow(Icons.whatshot, '${AppLocalizations.of(context)!.mines}: 1', Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dataRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
