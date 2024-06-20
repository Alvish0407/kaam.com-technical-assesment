import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/authentication/data/firebase_auth_repository.dart';
import '../features/authentication/presentation/signin_screen.dart';
import '../features/authentication/presentation/signup_screen.dart';
import 'go_router_refresh_stream.dart';

part 'app_router.g.dart';

enum AppRoute { signUp, signIn, todosList }

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
      final path = state.uri.path;
      if (isLoggedIn) {
        if (path.startsWith('/signUp') || path.startsWith('/signIn')) {
          return '/todos';
        }
      } else {
        if (!path.startsWith('/signIn') && !path.startsWith('/signUp')) {
          return '/signIn';
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/signIn',
        name: AppRoute.signIn.name,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signUp',
        name: AppRoute.signUp.name,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/todos',
        name: AppRoute.todosList.name,
        builder: (context, state) => Container(),
      ),
    ],
  );
}
