import 'package:auth_page/page/auth_page.dart';
import 'package:auth_page/page/home_page.dart';
import 'package:auth_page/page/verifying_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const VerifyingPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'auth',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
                child: const AuthPage(),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          },
        ),
        GoRoute(
          path: 'home',
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
                child: const HomePage(),
                transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) {
                  return FadeTransition(
                    opacity: CurveTween(curve: Curves.easeInOutCirc)
                        .animate(animation),
                    child: child,
                  );
                });
          },
        ),
      ],
    ),
  ],
);
