import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/core/router/shell_view/shell_view.dart';
import 'package:shartflix/feature/home/view/home_view.dart';
import 'package:shartflix/feature/login/bloc/user_bloc.dart';
import 'package:shartflix/feature/login/view/login_view.dart';
import 'package:shartflix/feature/not_found/view/not_found_view.dart';
import 'package:shartflix/feature/register/view/register_view.dart';
import 'package:shartflix/feature/upload_photo/view/upload_photo_view.dart';
import 'package:shartflix/http/dio/token_storage/token_storage.dart';

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
  notFound(path: '*'),
  register(path: '/register'),
  login(path: '/login'),
  home(path: '/home'),
  photoUpload(path: 'photo-upload');

  const AppRoute({required this.path});

  final String path;
}

class AppRouter {
  factory AppRouter() => _singleton;

  AppRouter._internal();

  static final AppRouter _singleton = AppRouter._internal();

  final GoRouter _goRouter = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: TokenStorageImpl().hasToken()
        ? AppRoute.home.path
        : AppRoute.login.path,
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
              name: state.name,
              child: const SizedBox.shrink(),
            ),
          ),
          GoRoute(
            path: AppRoute.register.path,
            name: AppRoute.register.name,
            pageBuilder: (context, state) => MaterialPage(
              name: state.name,
              child: const RegisterView(),
            ),
          ),
          GoRoute(
            path: AppRoute.login.path,
            name: AppRoute.login.name,
            pageBuilder: (context, state) => MaterialPage(
              name: state.name,
              child: const LoginView(),
            ),
          ),
          GoRoute(
            path: AppRoute.home.path,
            name: AppRoute.home.name,
            pageBuilder: (context, state) => MaterialPage(
              name: state.name,
              child: const HomeView(),
            ),
            redirect: (context, state) {
              final userState = context.read<UserBloc>().state;
              if (userState is UserRegisterSuccess &&
                  userState.user.photoUrl.isEmpty) {
                return '/home/photo-upload';
              }
              return null;
            },
            routes: [
              GoRoute(
                path: AppRoute.photoUpload.path,
                name: AppRoute.photoUpload.name,
                pageBuilder: (context, state) => MaterialPage(
                  name: state.name,
                  child: const UploadPhotoView(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      name: state.name,
      child: const NotFoundView(),
    ),
  );

  GoRouter get router => _goRouter;
}
