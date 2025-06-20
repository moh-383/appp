import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

@override
Widget build(BuildContext context) {
  return Drawer(
    backgroundColor: AppColors.navBarColor,
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(color: Colors.deepPurple),
          child: Column( crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'R-Mind',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(AppLocalizations.of(context)!.robotName,

                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
        ListTile(
          leading: const Icon(Icons.home, color: AppColors.iconColor),
          title: Text(AppLocalizations.of(context)!.home, style: const TextStyle(color: AppColors.textColor)),
          onTap: () { Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, '/',(route) => false,
            );
            },
        ),
        ListTile(
          leading: const Icon(Icons.ssid_chart, color: AppColors.iconColor),
          title: Text(AppLocalizations.of(context)!.data, style: const TextStyle(color: AppColors.textColor)),
          onTap: () => Navigator.pushNamed(context, '/data'),
        ),
        ListTile(
          leading: const Icon(Icons.drive_eta, color: AppColors.iconColor),
          title: Text(AppLocalizations.of(context)!.pilot, style: const TextStyle(color: AppColors.textColor)),
          onTap: () => Navigator.pushNamed(context, '/control'),
        ),
        ListTile(
          leading: const Icon(Icons.map, color: AppColors.iconColor),
          title: Text(AppLocalizations.of(context)!.map, style: const TextStyle(color: AppColors.textColor)),
          onTap: () => Navigator.pushNamed(context, '/map'),
        ),
        ListTile(
          leading: const Icon(Icons.settings, color: AppColors.iconColor),
          title: Text(AppLocalizations.of(context)!.settings, style: const TextStyle(color: AppColors.textColor)),
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
      ],
    ),
  );
}
}