import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/constants.dart';
import 'package:maple_daily_tracker/extensions/color_extensions.dart';
import 'package:maple_daily_tracker/models/user.dart';
import 'package:maple_daily_tracker/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettings extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData.dark(useMaterial3: true);
  ThemeData get currentTheme => _currentTheme;

  late DatabaseService dbService;
  late User? user;
  SharedPreferences? _prefs;

  late Color primary;
  late Color secondary;

  ThemeSettings({required this.dbService, this.user}) {
    primary = Colors.blue;
    secondary = Colors.tealAccent;

    if (user != null) {
      primary = user!.primary ?? primary;
      secondary = user!.secondary ?? secondary;
    } else {
      loadPreferences();
    }

    createTheme(primary, secondary);
  }

  void loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    primary = Color(_prefs!.getInt('primary') ?? Colors.blue.value);
    secondary = Color(_prefs!.getInt('secondary') ?? Colors.tealAccent.value);
  }

  void createTheme(Color primary, Color secondary) {
    this.primary = primary;
    this.secondary = secondary;

    _currentTheme = ThemeData.dark().copyWith(
      colorScheme: ThemeData.dark()
          .colorScheme
          .copyWith(primary: primary, secondary: secondary),
      useMaterial3: true,
      dividerColor: Colors.transparent,
      appBarTheme: AppBarTheme(
          titleTextStyle: ThemeData.dark()
              .appBarTheme
              .titleTextStyle
              ?.copyWith(color: primary.toLuminanceColor()),
          backgroundColor: primary),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(24),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(primary),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all<Color>(secondary),
        checkColor:
            MaterialStateProperty.all<Color>(secondary.toLuminanceColor()),
      ),
      tabBarTheme: TabBarTheme(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            width: 3.0,
            color: secondary,
          ),
        ),
      ),
    );

    notifyListeners();
  }

  Future<void> persistColors(Color newPrimary, Color newSecondary) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }

    await _prefs!.setInt('primary', newPrimary.value);
    await _prefs!.setInt('secondary', newSecondary.value);
  }

  Future<void> changeColors(Color newPrimary, Color newSecondary) async {
    createTheme(newPrimary, newSecondary);
    await persistColors(newPrimary, newSecondary);
    await dbService.updateUserTheme(primary: newPrimary, secondary: newSecondary);
  }
}
