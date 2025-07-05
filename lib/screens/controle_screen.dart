import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../utils/app_drawer.dart';

class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🔹 Titre de la page
              Center(
                child: Text(
                  loc.controlTitle, // Ajouté
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textColor,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Zone caméra
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.buttonColor, width: 4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.videocam, color: Colors.black26, size: 50),
                    const SizedBox(height: 8),
                    Text(
                      loc.cameraView,
                      style: const TextStyle(
                        color: AppColors.textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // 🔹 Joystick
              Center(
                child: Joystick(
                  mode: JoystickMode.all,
                  stick: const CircleAvatar(
                    radius: 30,
                    child: FlutterLogo(size: 40),
                  ),
                  base: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Positioned(
                        top: 15,
                        child: Text(loc.forward, style: _joystickLabelStyle),
                      ),
                      Positioned(
                        bottom: 15,
                        child: Text(loc.backward, style: _joystickLabelStyle),
                      ),
                      Positioned(
                        left: 15,
                        child: Text(loc.left, style: _joystickLabelStyle),
                      ),
                      Positioned(
                        right: 15,
                        child: Text(loc.right, style: _joystickLabelStyle),
                      ),
                    ],
                  ),
                  listener: (details) {
                    debugPrint('x: ${details.x}, y: ${details.y}');
                  },
                ),
              ),

              const SizedBox(height: 60),

              // 🔹 Boutons
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 16,
                children: [
                  _buildControlButton(
                    label: loc.stop,
                    onPressed: () => debugPrint('Stop pressed'),
                    backgroundColor: Colors.redAccent,
                    textColor: Colors.white,
                  ),
                  _buildControlButton(
                    label: loc.reset,
                    onPressed: () => debugPrint('Reset pressed'),
                    backgroundColor: AppColors.buttonColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ],
          ),
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
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}