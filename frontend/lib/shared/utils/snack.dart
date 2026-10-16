import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

void showAppSnack(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  if (!context.mounted) return;
  final c = context.colors;
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: isError ? c.danger : c.teal,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
