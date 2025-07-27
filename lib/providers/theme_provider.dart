import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gender_features.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme = ThemeData(
    primarySwatch: Colors.purple,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
  );
  String _userGender = '';
  Map<String, FeatureConfig> _features = {};

  ThemeData get currentTheme => _currentTheme;
  String get userGender => _userGender;
  Map<String, FeatureConfig> get features => _features;

  ThemeProvider() {
    _loadUserGender();
  }

  Future<void> _loadUserGender() async {
    final prefs = await SharedPreferences.getInstance();
    _userGender = prefs.getString('user_gender') ?? '';

    if (_userGender.isNotEmpty) {
      _updateThemeAndFeatures();
    }
  }

  Future<void> setUserGender(String gender) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_gender', gender);

    _userGender = gender;
    _updateThemeAndFeatures();
  }

  void _updateThemeAndFeatures() {
    // Update features based on user gender
    _features = GenderFeatures.getFeatures(_userGender);

    // Update theme based on target gender (opposite interface)
    final targetColor = _userGender == 'male' ? Colors.pink : Colors.blue;

    _currentTheme = ThemeData(
      primarySwatch: _userGender == 'male' ? Colors.pink : Colors.blue,
      colorScheme: ColorScheme.fromSeed(
        seedColor: targetColor,
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: targetColor,
        foregroundColor: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: targetColor,
          foregroundColor: Colors.white,
        ),
      ),
    );

    notifyListeners();
  }
}
