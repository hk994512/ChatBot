import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UIHelpers {
  static text(
    String text, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
  }) {
    return Text(
      text,
      style: GoogleFonts.mooli(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
