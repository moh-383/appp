import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_joystick/flutter_joystick.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

import '../l10n/app_localizations.dart';
import '../utils/app_drawer.dart';
import '../theme/app_colors.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  static const String backendUrl = 'http://127.0.0.1:8000 ';
  static const String esp32CamUrl = 'http://172.19.218.206';

  Future<void> sendCommand(String direction) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/control/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'direction': direction}),
      );
      debugPrint('Commande envoyée: $direction | ${response.statusCode}');
    } catch (e) {
      debugPrint('Erreur commande: $e');
    }
  }

  Future<void> startArm() async {
    try {
      await http.post(Uri.parse('$backendUrl/arm/start_servo'));
    } catch (e) {
      debugPrint('Erreur startArm: $e');
    }
  }

  Future<void> stopArm() async {
    try {
      await http.post(Uri.parse('$backendUrl/arm/stop_servo'));
    } catch (e) {
      debugPrint('Erreur stopArm: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.iconColor),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                loc.controlTitle,
                style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textColor),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.blueGrey, width: 5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Mjpeg(
                stream: esp32CamUrl,
                isLive: true,
                error: (context, error, stack) => const Center(
                  child: Text('Impossible de charger la caméra', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Joystick(
                mode: JoystickMode.all,
                stick: const CircleAvatar(radius: 30, child: FlutterLogo(size: 40)),
                base: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(width: 200, height: 200, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                    Positioned(top: 15, child: Text(loc.forward, style: _joystickLabelStyle)),
                    Positioned(bottom: 15, child: Text(loc.backward, style: _joystickLabelStyle)),
                    Positioned(left: 15, child: Text(loc.left, style: _joystickLabelStyle)),
                    Positioned(right: 15, child: Text(loc.right, style: _joystickLabelStyle)),
                  ],
                ),
                listener: (details) {
                  if (details.y < -0.7) {
                    sendCommand("straight");
                  } else if (details.y > 0.7) {
                    sendCommand("back");
                  } else if (details.x < -0.7) {
                    sendCommand("left");
                  } else if (details.x > 0.7) {
                    sendCommand("right");
                  } else {
                    sendCommand("stop");
                  }
                },
              ),
            ),
            const SizedBox(height: 60),
            _buildControlButton(
              label: loc.stop,
              onPressed: () => sendCommand("stop"),
              backgroundColor: Colors.redAccent,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  static const TextStyle _joystickLabelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  Widget _buildControlButton({
    required String label,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}