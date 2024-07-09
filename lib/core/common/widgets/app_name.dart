import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:producthunt/core/theme/app_palette.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'ProductHunt.',
      style: GoogleFonts.barlow(
        color: AppPalette.midnightExpress,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        letterSpacing: -1.5,
      ),
    );
  }
}
