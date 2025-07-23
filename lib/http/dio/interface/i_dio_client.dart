import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:shartflix/http/dio/interceptors/http_handler/default_http_handler.dart';

import 'package:shartflix/http/dio/model/response_entity.dart';
import 'package:shartflix/http/dio/token_storage/token_storage.dart';

/// [IDioClient] is used to handle http rest api calls.
abstract class IDioClient {
  IDioClient({
    required String url,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Interceptor? interceptor,
  }) {
    baseUrl = url;
    _dio
      ..options.baseUrl = url.endsWith('/') ? url : '$url/'
      ..options.connectTimeout = connectTimeout ?? const Duration(seconds: 20)
      ..options.receiveTimeout = receiveTimeout ?? const Duration(seconds: 20)
      ..options.responseType = ResponseType.json
      ..interceptors.add(
        LogInterceptor(
          responseBody: kDebugMode || kProfileMode,
          requestBody: kDebugMode || kProfileMode,
        ),
      )
      ..interceptors.add(interceptor ?? DefaultHttpHeaderInterceptor())
      ..interceptors.add(_fresh);
  }

  late final String baseUrl;

  final Dio _dio = Dio();

  final Fresh<OAuth2Token> _fresh = Fresh.oAuth2(
    tokenHeader: (token) {
      return {
        'Authorization': token.accessToken,
      };
    },
    tokenStorage: TokenStorageImpl(),
    shouldRefresh: (response) {
      return response?.statusCode == 401 || response?.statusCode == 403;
    },
    refreshToken: (token, client) {
      throw RevokeTokenException();
    },
  );

  /// http get call
  Future<ResponseEntity<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get<T>(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      if (response.statusCode == 200) {}
      return _handleResponse(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  /// http post call
  Future<ResponseEntity<T>> post<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  /// http put call
  Future<ResponseEntity<T>> put<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  /// http delete call
  Future<ResponseEntity<T>> delete<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseEntity<T>> patch<T>(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch<T>(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        onSendProgress: onSendProgress,
        cancelToken: cancelToken,
      );
      return _handleResponse(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  Future<ResponseEntity<T>> _handleResponse<T>(
    Response<T> response,
  ) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Future.value(
        ResponseEntity<T>.success(
          statusCode: response.statusCode!,
          data: response.data as T,
        ),
      );
    } else {
      return Future.value(
        ResponseEntity.error(
          message: response.statusMessage,
          statusCode: response.statusCode!,
          data: response.data,
        ),
      );
    }
  }

  Future<ResponseEntity<T>> _handleError<T>(
    dynamic e,
  ) {
    if (e is! DioException) {
      return Future.value(
        ResponseEntity<T>.error(
          statusCode: 601,
          message: 'Unknown error',
        ),
      );
    }
    final error = e;
    if (error.response != null) {
      final stackTrace = StackTrace.current;
      debugPrint(stackTrace.toString());
      return Future.value(
        ResponseEntity<T>.error(
          statusCode: error.response!.statusCode!,
          message: '${error.response!.statusMessage}',
          data:
              error.response!.statusCode == 200 && error.response?.data != null
              ? error.response?.data as T
              : null,
        ),
      );
    } else {
      final stackTrace = StackTrace.current;
      debugPrint(stackTrace.toString());
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return Future.value(
          ResponseEntity<T>.error(
            statusCode: 408,

            message: 'Connection timeout',
          ),
        );
      } else {
        return Future.value(
          ResponseEntity<T>.error(
            statusCode: 601,
            message: 'Unknown error',
          ),
        );
      }
    }
  }

  /// Listener for authorization status changes
  Stream<AuthenticationStatus> get authenticationStatus =>
      _fresh.authenticationStatus;

  Future<void> setToken(OAuth2Token token) => _fresh.setToken(token);

  void logout() {
    _fresh.clearToken();
  }
}
