import 'dart:io';

import 'package:dio/dio.dart';

/// [DefaultHttpHeaderInterceptor] is used to send default http headers during
/// network request.
class DefaultHttpHeaderInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    final lang = Platform.localeName.replaceAll('_', '-');
    final locale = Platform.localeName.split('_')[1];
    options.headers.addAll({
      'Content-Type': 'application/json',
      'platform': 2,
      'language': lang,
      'country': locale,
    });
    handler.next(options);
  }
}
