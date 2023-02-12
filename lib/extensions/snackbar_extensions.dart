import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/extensions/color_extensions.dart';
import 'package:maple_daily_tracker/providers/theme_settings.dart';
import 'package:provider/provider.dart';

extension ShowSnackBar on BuildContext {
  void showSnackBar({
    required String message,
    SnackBarAction? action,
    Color backgroundColor = Colors.blueAccent,
  }) {
    final themeData = this.read<ThemeSettings>();
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: themeData.primary.toLuminanceColor(),
        ),
      ),
      backgroundColor: backgroundColor,
      action: action,
    ));
  }

  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.redAccent);
  }
}
