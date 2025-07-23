import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/router/shell_view/shell_view.dart';
import 'package:shartflix/feature/login/view/login_view.dart';
import 'package:shartflix/feature/not_found/view/not_found_view.dart';
import 'package:shartflix/feature/register/view/register_view.dart';

/// Rooter Navigator Key
final GlobalKey<NavigatorState> rooterNavigatorKey =
    GlobalKey<NavigatorState>();

final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter goRouter = AppRouter().router;

/// Register the RouteObserver as a navigation observer.
final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

enum AppRoute {
  notFound(path: '*', full: '/notFound'),
  register(path: '/register', full: '/register'),
  login(path: '/login', full: '/login');

  const AppRoute({required this.path, this.full});

  final String path;
  final String? full;
}

class AppRouter {
  factory AppRouter() => _singleton;

  AppRouter._internal();

  static final AppRouter _singleton = AppRouter._internal();

  final GoRouter _goRouter = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: '/login',
    navigatorKey: rooterNavigatorKey,
    observers: [routeObserver],
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ShellView(
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              name: state.name,
              child: const SizedBox.shrink(),
            ),
          ),
          GoRoute(
            path: AppRoute.register.path,
            name: AppRoute.register.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              name: state.name,
              child: const RegisterView(),
            ),
          ),
          GoRoute(
            path: AppRoute.login.path,
            name: AppRoute.login.name,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              name: state.name,
              child: const LoginView(),
            ),
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      name: state.name,
      child: const NotFoundView(),
    ),
  );

  GoRouter get router => _goRouter;
}
