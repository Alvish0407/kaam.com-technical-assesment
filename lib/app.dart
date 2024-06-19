import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/routing/app_router.dart';
import 'src/utils/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp.router(
        title: 'ToDone',
        routerConfig: goRouter,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightThemeData(context),
        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          physics: AlwaysScrollableScrollPhysics(
            parent: Platform.isIOS ? const BouncingScrollPhysics() : const ClampingScrollPhysics(),
          ),
        ),
      ),
    );
  }
}
