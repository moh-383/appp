import 'package:appp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/app_drawer.dart';

class CartographiePage extends StatelessWidget {
  const CartographiePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent,
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
              child: Row(
                children: [
                  Text(AppLocalizations.of(context)!.mapTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            // Carte avec robot et éléments
            Positioned.fill(
              top: 70,
              child: Center(
                child: Stack(
                  children: [
                    // Carte (fictive)
                    Container(
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
                              children: const [
                                Icon(Icons.electric_car, size: 50, color: Colors.cyanAccent),
                                Text(
                                  '135°',
                                  style: TextStyle(color: Colors.cyanAccent),
                                ),
                              ],
                            ),
                          ),
                          // Obstacles
                          const Positioned(
                            top: 20,
                            left: 20,
                            child: Icon(Icons.warning, color: Colors.yellow, size: 30),
                          ),
                          const Positioned(
                            bottom: 10,
                            right: 5,
                            left: 10,
                            child: Icon(Icons.warning, color: Colors.yellow, size: 30),
                          ),
                          // Mines
                          const Positioned(
                            bottom: 25,
                            top: 10,
                            right: 115,
                            left: 15,
                            child: Icon(Icons.whatshot, color: Colors.red, size: 30),
                          ),
                        ],
                      ),
                    ),

                    // Boutons à droite
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search, color: Colors.cyanAccent),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings, color: Colors.cyanAccent),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.place, color: Colors.cyanAccent),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.cyanAccent),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Données textuelles
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dataRow(Icons.location_on, '${AppLocalizations.of(context)!.position}: 23,4,57.1', Colors.cyanAccent),
                  dataRow(Icons.navigation, '${AppLocalizations.of(context)!.direction}: 135°', Colors.cyanAccent),
                  dataRow(Icons.warning, '${AppLocalizations.of(context)!.obstacles}: 2', Colors.yellow),
                  dataRow(Icons.whatshot, '${AppLocalizations.of(context)!.mines}: 1', Colors.red),
                  dataRow(Icons.circle, '${AppLocalizations.of(context)!.area}: 35%', Colors.greenAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour afficher une ligne d'information
  Widget dataRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(color: color),
        ),
      ],
    );
  }
}