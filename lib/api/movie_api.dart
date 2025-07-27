import 'package:shartflix/api/interface/i_api_provider.dart';

class MovieApi extends ApiProvider {
  MovieApi()
    : super(
        HttpConst.moviePath,
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
      resource: 'favorites',
      cancelToken: cancelToken,
    );
    if (response.statusCode == 404) {
      return ResponseEntity.success(
        statusCode: response.statusCode,
        data: [],
      );
    } else if (response.statusCode != 200) {
      return ResponseEntity.error(
        statusCode: response.statusCode,
        message: 'Failed to fetch favorite movies',
      );
    }
    final favoriteMovies = (response.data['data'] as List)
        .map((e) => e as Map<String, dynamic>)
        .toList();

    return ResponseEntity.success(
      statusCode: response.statusCode,
      data: favoriteMovies,
    );
  }

  Future<ResponseEntity<dynamic>> getMovies({
    CancelToken? cancelToken,
  }) async {
    final response = await get(
      resource: 'list',
      cancelToken: cancelToken,
    );

    if( response.statusCode == 404) {
      return ResponseEntity.success(
        statusCode: response.statusCode,
        data: [],
      );
    }

    return ResponseEntity.success(
      statusCode: response.statusCode,
      data: response.data,
    );
  }
}
