import 'package:flutter/material.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}

const rubikLight = TextStyle(
  fontFamily: 'Helvetica',
  fontWeight: FontWeight.w300,
);

const rubikRegular = TextStyle(
  fontFamily: 'Helvetica',
  fontWeight: FontWeight.w400,
);

const rubikMedium = TextStyle(
  fontFamily: 'Helvetica',
  fontWeight: FontWeight.w500,
);

const rubikSemiBold = TextStyle(
  fontFamily: 'Helvetica',
  fontSize: 16,
  fontWeight: FontWeight.w600,
);
const WAPrimaryColor = Color(0xFF6C56F9);
const WAAccentColor = Color(0xFF26C884);
InputDecoration waInputDecoration(
    {IconData? prefixIcon,
    String? hint,
    String? error,
    Color? bgColor,
    Color? borderColor,
    EdgeInsets? padding}) {
  return InputDecoration(
    errorText: error,
    contentPadding:
        padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    counter: const Offstage(),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: borderColor ?? const Color(0xffe8e6ea))),
    enabledBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: borderColor ?? const Color(0xffe8e6ea)),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: Color.fromARGB(255, 231, 74, 88)),
    ),
    fillColor: bgColor ?? Colors.white,
    hintText: hint,
    prefixIcon: prefixIcon != null
        ? Icon(
            prefixIcon,
            color: Colors.black12,
          )
        : null,
    filled: true,
  );
}
