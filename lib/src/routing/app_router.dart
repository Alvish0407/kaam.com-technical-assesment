import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/authentication/data/firebase_auth_repository.dart';
import '../features/authentication/presentation/signin_screen.dart';
import 'go_router_refresh_stream.dart';

part 'app_router.g.dart';

enum AppRoute { signIn, tasksList }

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final authRepository = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: '/signIn',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(
      authRepository.authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = authRepository.currentUser != null;
      if (isLoggedIn) {
        return '/tasks';
      } else {
        return '/signIn';
      }
    },
    routes: [
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SigninScreen(),
        ),
      ),
      GoRoute(
        path: '/tasks',
        name: AppRoute.tasksList.name,
        pageBuilder: (context, state) => NoTransitionPage(
          child: Container(),
        ),
      ),
    ],
  );
}
