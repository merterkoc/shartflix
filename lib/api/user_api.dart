import 'package:shartflix/api/interface/i_api_provider.dart';

class UserApi extends ApiProvider {
  UserApi()
    : super(
        HttpConst.userPath,
      );

  Future<ResponseEntity<dynamic>> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async {
    return post(
      resource: 'login',
      data: {
        'email': email,
        'password': password,
      },
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> register({
    required String email,
    required String password,
    required String name,
    CancelToken? cancelToken,
  }) async {
    return post(
      resource: 'register',
      data: {
        'email': email,
        'password': password,
        'name': name,
      },
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> getUserProfile({
    CancelToken? cancelToken,
  }) async {
    return get(
      resource: 'profile',
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> uploadProfilePicture({
    required String filePath,
    CancelToken? cancelToken,
  }) async {
    return post(
      resource: 'upload_photo',
      data: {
        'file': filePath,
      },
      cancelToken: cancelToken,
    );
  }

  void logoutSession({
    CancelToken? cancelToken,
  })  {
     logout();
  }
}
