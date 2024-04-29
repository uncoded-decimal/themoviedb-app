import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wework_challenge/src/app/misc/app_colors.dart';
import 'package:wework_challenge/src/app/misc/app_textstyles.dart';

class AppTheme {
  static ThemeData defaultTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      centerTitle: false,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: AppTextStyles.light16P(color: Colors.grey.shade500),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: AppColors.homeGradientEnd,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: AppTextStyles.medium10NS(color: Colors.black),
      unselectedLabelStyle: AppTextStyles.regular10NS(color: Colors.black),
    ),
  );
}
