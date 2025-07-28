part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();
}

class FetchMovies extends MovieEvent {
  const FetchMovies({
    this.page = 1,
  });

  final int page;

  @override
  List<Object?> get props => [page];
}

class FetchFavoriteMovies extends MovieEvent {
  const FetchFavoriteMovies();

  @override
  List<Object?> get props => [];
}

class FavoriteMovie extends MovieEvent {
  const FavoriteMovie({
    required this.favoriteId,
  });

  final String favoriteId;

  @override
  List<Object?> get props => [favoriteId];
}
