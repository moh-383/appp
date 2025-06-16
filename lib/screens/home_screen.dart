import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // IMAGE DE FOND (avec hauteur contrôlée)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/Rover.jpg',
              height: 430, // Contrôle de la hauteur
              fit: BoxFit.cover,
            ),
          ),

          // CONTENU AVANT-PLAN
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 320, 40, 60), // Positionne les éléments en dessous de l’image
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'ROVER CONTROL',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  CustomButton(
                    text: 'Piloter le Rover',
                    icon: Icons.directions_car,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Voir les données capteurs',
                    icon: Icons.bar_chart,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Cartographie du terrain',
                    icon: Icons.map,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'A propos\nProjet Rover 2025\nÉquipe X',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: AppColors.textColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // NAVIGATION BASSE
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.navBarColor,
        selectedItemColor: AppColors.textColor,
        unselectedItemColor: AppColors.textColor,
        currentIndex: 0,
        onTap: (index) {}, // À remplir plus tard
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ssid_chart),
            label: 'Données',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_eta),
            label: 'Contrôle',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Carte',
          ),
        ],
      ),
    );
  }
}