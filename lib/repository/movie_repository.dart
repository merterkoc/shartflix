import 'package:shartflix/api/movie_api.dart';
import 'package:shartflix/repository/interface/i_repository.dart';

class MovieRepository extends IRepository {
  final _userApi = MovieApi();

  Future<ResponseEntity<dynamic>> getMovies({
    required String genre,
    required int page,
    CancelToken? cancelToken,
  }) async {
    return _userApi.getMovies(
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> getFavoriteMovies({
    CancelToken? cancelToken,
  }) async {
    return _userApi.getFavoriteMovies(
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<dynamic>> favoriteMovie({
    required String favoriteId,
    CancelToken? cancelToken,
  }) async {
    return _userApi.favoriteMovie(
      favoriteId: favoriteId,
      cancelToken: cancelToken,
    );
  }
}
