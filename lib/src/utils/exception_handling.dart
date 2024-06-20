import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'app_theme.dart';

extension AppAsyncValueX on AsyncValue {
  void showSnackBarOnError(BuildContext context) {
    log('\x1B[34misLoading: $isLoading, hasError: $hasError\x1B[0m');
    if (!isLoading && hasError) {
      context.errorSnackBar(error.getErrorMessage());
    }
  }
}

extension DynamicX on dynamic {
  String? getErrorMessage() {
    log('\x1B[31m$this\x1B[0m', name: 'Exception');
    return switch (this) {
      FirebaseAuthException fbAuthException => fbAuthException.message,
      _ => null,
    };
  }
}
