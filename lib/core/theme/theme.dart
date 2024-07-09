import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:producthunt/core/theme/app_palette.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    scaffoldBackgroundColor: AppPalette.beamingSun,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppPalette.greigeViolet,
      ),
    ),
  );
}
