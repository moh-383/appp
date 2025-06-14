import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1B1D),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),

            // IMAGE DU ROVER
            Image.asset(
              'assets/images/Rover.jpg', 
              height: 250,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // TITRE
            const Text(
              'ROVER CONTROL',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            // BUTTONS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  _buildButton(context, Icons.drive_eta, 'Piloter le Rover'),
                  _buildButton(context, Icons.sensors, 'Voir les données capteurs'),
                  _buildButton(context, Icons.map, 'Cartographie du terrain'),
                ],
              ),
            ),

            const Spacer(),

            // A PROPOS
            const Text(
              'À propos\nProjet Rover 2025\nÉquipe X',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),

      // NAVIGATION BASSE
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF2B2B2E),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.ssid_chart), label: 'Données'),
          BottomNavigationBarItem(icon: Icon(Icons.drive_eta), label: 'Contrôle'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Carte'),
        ],
        currentIndex: 0,
        onTap: (index) {
          // Navigation à gérer plus tard
        },
      ),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () {
          // Action à définir
        },
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

