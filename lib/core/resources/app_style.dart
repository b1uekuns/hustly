import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_color.dart';

class AppStyle {
  AppStyle(this.context);

  BuildContext? context;

  static TextStyle def = GoogleFonts.lato(
    fontSize: 16,
    color: AppColor.black,
    fontWeight: FontWeight.w500,
  );
}

extension ExtendedTextStyle on TextStyle {
  TextStyle get light {
    return copyWith(fontWeight: FontWeight.w300);
  }

  TextStyle get thin {
    return copyWith(fontWeight: FontWeight.w100);
  }

  TextStyle get extraLight {
    return copyWith(fontWeight: FontWeight.w200);
  }

  TextStyle get regular {
    return copyWith(fontWeight: FontWeight.w400);
  }

  TextStyle get medium {
    return copyWith(fontWeight: FontWeight.w500);
  }

  TextStyle get bold {
    return copyWith(fontWeight: FontWeight.w700);
  }

  TextStyle get bold1 {
    return copyWith(fontWeight: FontWeight.w900);
  }

  TextStyle get italic {
    return copyWith(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic);
  }

  TextStyle colors(Color color) {
    return copyWith(color: color);
  }

  TextStyle size(double size) {
    return copyWith(fontSize: size);
  }

  TextStyle underline({Color color = Colors.black, double thickness = 1}) {
    return copyWith(
      decoration: TextDecoration.underline,
      decorationColor: color,
      decorationThickness: thickness,
    );
  }

  TextStyle lineThrough({Color color = Colors.black, double thickness = 0.5}) {
    return copyWith(
      decoration: TextDecoration.lineThrough,
      decorationColor: color,
      decorationThickness: thickness,
    );
  }

  TextStyle boldItalic({Color? color, double? fontSize}) {
    return copyWith(
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.italic,
      color: color,
      fontSize: fontSize,
    );
  }
}
