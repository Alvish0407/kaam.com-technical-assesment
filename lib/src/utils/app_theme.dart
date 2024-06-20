import 'package:flutter/material.dart';

import '../constants/app_sizes.dart';

abstract class AppTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.orangeAccent[700]!,
        primary: Colors.orangeAccent[700]!,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        alignLabelWithHint: true,
        fillColor: Colors.white,
        prefixIconColor: const Color(0xff8CA9C2),
        suffixIconColor: const Color(0xff8CA9C2),
        contentPadding: const EdgeInsets.all(Sizes.p16),
        hintStyle: const TextStyle(color: Color(0xff8CA9C2)).regular,
        labelStyle: const TextStyle(color: Color(0xff8CA9C2)).regular,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.p16),
          borderSide: BorderSide(color: Colors.orangeAccent[700]!),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.p16),
          borderSide: const BorderSide(color: Color(0xffE0EAF3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.p16),
          borderSide: const BorderSide(color: Color(0xff8CA9C2)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.p16),
          borderSide: const BorderSide(color: Color(0xffC32033)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Sizes.p16),
          borderSide: const BorderSide(color: Color(0x80C32033)),
        ),
      ),
    );
  }
}

extension BuildContextX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  ScaffoldMessengerState? errorSnackBar([String? text]) =>
      text == null || text.isEmpty ? null : ScaffoldMessenger.of(this)
        ?..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            backgroundColor: colorScheme.error,
            behavior: SnackBarBehavior.floating,
            content: Text(text!),
          ),
        );

  ScaffoldMessengerState successSnackBar([
    String? text,
  ]) =>
      ScaffoldMessenger.of(this)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            backgroundColor: Colors.green,
            content: Text(text ?? "Success"),
            behavior: SnackBarBehavior.floating,
          ),
        );
}

extension TextStyleX on TextStyle {
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
}
