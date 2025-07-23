import 'package:fresh_dio/fresh_dio.dart';
import 'package:shartflix/api/user_api.dart';
import 'package:shartflix/repository/interface/i_repository.dart';

class UserRepository extends IRepository {
  final _userApi = UserApi();

  Future<ResponseEntity<dynamic>> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) async {
    return _userApi.login(
      email: email,
      password: password,
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> register({
    required String email,
    required String password,
    required String name,
    CancelToken? cancelToken,
  }) async {
    return _userApi.register(
      email: email,
      password: password,
      name: name,
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> getUserProfile({
    CancelToken? cancelToken,
  }) async {
    return _userApi.getUserProfile(cancelToken: cancelToken);
  }

  Future<ResponseEntity<dynamic>> uploadProfilePicture({
    required String filePath,
    CancelToken? cancelToken,
  }) async {
    return _userApi.uploadProfilePicture(
      filePath: filePath,
      cancelToken: cancelToken,
    );
  }

  void setToken(OAuth2Token token) {
    _userApi.setToken(token);
  }

  void logout({
    CancelToken? cancelToken,
  }) {
    _userApi.logoutSession();
  }
}
