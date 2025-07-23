import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:shartflix/core/router/go_router.dart';
import 'package:shartflix/http/dio/dio_client.dart';

mixin AuthenticationRouterListener {
  static AuthenticationStatus _currentAuthenticationStatus =
      AuthenticationStatus.initial;
  static late StreamSubscription<AuthenticationStatus> _subscription;
  static final StreamController<AuthenticationStatus>
  _authenticationStatusController =
      StreamController<AuthenticationStatus>.broadcast();
  static DioClient dioClient = DioClient();

  static void listen() {
    _subscription = dioClient.authenticationStatus.listen(
      onAuthenticationChanged,
    );
  }

  static void onAuthenticationChanged(
    AuthenticationStatus authenticationStatus,
  ) {
    _currentAuthenticationStatus = authenticationStatus;
    if (authenticationStatus == AuthenticationStatus.authenticated) {
      debugPrint('Authenticated');
      if (!goRouter.state.fullPath!.contains(AppRoute.home.name)) {
        goRouter.go(AppRoute.home.path);
      }
    } else if (authenticationStatus == AuthenticationStatus.unauthenticated) {
      debugPrint('Unauthenticated');
      goRouter.goNamed(AppRoute.login.name);
    }
    _authenticationStatusController.add(authenticationStatus);
  }

  static void dispose() {
    _subscription.cancel();
  }

  static AuthenticationStatus get currentAuthenticationStatus =>
      _currentAuthenticationStatus;

  Stream<AuthenticationStatus> get authenticationStatusStream =>
      _authenticationStatusController.stream;
}
