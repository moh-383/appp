import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 361,
      height: 53,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        icon: Icon(icon, color: AppColors.iconColor),
        label: Text(
          text,
          style: const TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}