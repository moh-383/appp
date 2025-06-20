import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../utils/app_drawer.dart';
import '../utils/language_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: const TextStyle(color: AppColors.textColor),
        ),
        iconTheme: const IconThemeData(color: AppColors.iconColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // Connexion
            Text(
              AppLocalizations.of(context)!.connect,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.connectionInstructions,
              style: const TextStyle(fontSize: 16, color: AppColors.textColor),
            ),
            const SizedBox(height: 30),

            // Langue
            Text(
              AppLocalizations.of(context)!.language,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: languageProvider.locale.languageCode == 'en'
                  ? 'English'
                  : 'Français',
              icon: const Icon(Icons.arrow_drop_down),
              items: ['Français', 'English']
                  .map((lang) => DropdownMenuItem(
                value: lang,
                child: Text(lang,
                    style: const TextStyle(color: AppColors.textColor)),
              ))
                  .toList(),
              onChanged: (value) {
                if (value == 'English') {
                  languageProvider.setLocale(const Locale('en'));
                } else {
                  languageProvider.setLocale(const Locale('fr'));
                }
              },
              dropdownColor: AppColors.background,
            ),
            const SizedBox(height: 30),

            // À propos
            ListTile(
              leading:
              const Icon(Icons.info_outline, color: AppColors.iconColor),
              title: Text(
                AppLocalizations.of(context)!.about,
                style: const TextStyle(fontSize: 18, color: AppColors.textColor),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}