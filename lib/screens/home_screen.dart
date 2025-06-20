import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
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
        // IMAGE DE FOND
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset( 'assets/Rover.jpg',
            height: 430,
            fit: BoxFit.cover,
          ),
        ),

       // CONTENU
       SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.fromLTRB(40, 320, 40, 60),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Center(
                 child: Text(AppLocalizations.of(context)!.homeTitle,
                   style: TextStyle(
                     fontSize: 28,
                     fontWeight: FontWeight.bold,
                     color: AppColors.textColor,
                   ),
                 ),
               ),
               const SizedBox(height: 40),
               CustomButton(
                 text: AppLocalizations.of(context)!.pilot,
                 icon: Icons.directions_car,
                 onPressed: () {
                   Navigator.pushNamed(context, '/control');
                   },
               ),
               const SizedBox(height: 20),
               CustomButton(
                 text: AppLocalizations.of(context)!.data,
                 icon: Icons.bar_chart,
                 onPressed: () {
                   Navigator.pushNamed(context, '/data');
                   },
               ),
               const SizedBox(height: 20),
               CustomButton(
                 text: AppLocalizations.of(context)!.map,
                 icon: Icons.map,
                 onPressed: () {
                   Navigator.pushNamed(context, '/map');
                   },
               ),
             ],
           ),
         ),
       ),
      ],
    ),
  );
}
}