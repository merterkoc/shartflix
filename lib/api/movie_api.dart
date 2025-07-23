import 'package:shartflix/api/interface/i_api_provider.dart';

class MovieApi extends ApiProvider {
  MovieApi()
    : super(
        HttpConst.userPath,
      );

  Future<ResponseEntity<dynamic>> favoriteMovie({
    required String favoriteId,
    CancelToken? cancelToken,
  }) async {
    return post(
      resource: 'favorite/$favoriteId',
      cancelToken: cancelToken,
    );
  }

  Future<ResponseEntity<List<dynamic>>> getFavoriteMovies({
    CancelToken? cancelToken,
  }) async {
    final response = await get(
      resource: 'favorite',
      cancelToken: cancelToken,
    );

    final favoriteMovies = (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    return ResponseEntity.success(
      statusCode: response.statusCode,

      data: favoriteMovies,
    );
  }

  Future<ResponseEntity<List<dynamic>>> getMovies({
    CancelToken? cancelToken,
  }) async {
    final response = await get(
      resource: 'list',
      cancelToken: cancelToken,
    );

    final movies = (response.data as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    return ResponseEntity.success(
      statusCode: response.statusCode,
      data: movies,
    );
  }
}
