import 'package:flutter/material.dart';
import 'package:appp/screens/home_screen.dart';
import 'package:appp/theme/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROVER CONTROL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.navBarColor,
          selectedItemColor: AppColors.textColor,
          unselectedItemColor: AppColors.textColor,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}