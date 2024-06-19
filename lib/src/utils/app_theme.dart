import 'package:flutter/material.dart';

abstract class AppTheme {
  static ThemeData lightThemeData(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.yellow[800]!,
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
            behavior: SnackBarBehavior.floating,
            content: Text(text ?? "Success"),
          ),
        );

  ScaffoldMessengerState infoSnackBar([
    String? text,
  ]) =>
      ScaffoldMessenger.of(this)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            showCloseIcon: true,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.yellow[700],
            content: Text(text ?? "Info"),
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
