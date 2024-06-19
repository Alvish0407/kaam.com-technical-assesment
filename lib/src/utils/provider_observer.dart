import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    log('\x1B[32mInitialized Provider $provider with $value\x1B[0m', name: "Observer");
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    log('\x1B[37mDisposed Provider $provider\x1B[0m', name: "Observer");
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    log(
      '\x1B[36mUpdated Provider $provider from $previousValue to $newValue\x1B[0m',
      name: "Observer",
    );
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    log('\x1B[31mFail Provider $provider threw $error at $stackTrace\x1B[0m', name: "Observer");
  }
}
