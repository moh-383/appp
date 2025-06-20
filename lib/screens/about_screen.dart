import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.about, style: TextStyle(color: AppColors.textColor)),
        iconTheme: const IconThemeData(color: AppColors.iconColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(AppLocalizations.of(context)!.aboutTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textColor),
            ),
            const SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.aboutDescription,
              style: const TextStyle(fontSize: 16, color: AppColors.textColor),
            ),
          ],
        ),
      ),
    );
  }
}