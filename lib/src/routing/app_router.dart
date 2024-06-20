import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/authentication/data/firebase_auth_repository.dart';
import '../features/authentication/presentation/signin_screen.dart';
import 'go_router_refresh_stream.dart';

part 'app_router.g.dart';

enum AppRoute { signUp, signIn, tasksList }

final _rootNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  // rebuild GoRouter when app startup state changes
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return GoRouter(
    initialLocation: '/signIn',
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: GoRouterRefreshStream(
      firebaseAuth.authStateChanges(),
    ),
    redirect: (context, state) {
      final isLoggedIn = firebaseAuth.currentUser != null;
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
        builder: (context, state) => const SigninScreen(),
      ),
      GoRoute(
        path: '/signUp',
        name: AppRoute.signUp.name,
        builder: (context, state) => Container(),
      ),
      GoRoute(
        path: '/tasks',
        name: AppRoute.tasksList.name,
        builder: (context, state) => Container(),
      ),
    ],
  );
}
