part of 'movie_bloc.dart';

sealed class MovieEvent extends Equatable {
  const MovieEvent();
}

class FetchMovies extends MovieEvent {
  const FetchMovies({
    this.page = 1,
    this.genre = 'all',
  });

  final int page;
  final String genre;

  @override
  List<Object?> get props => [page, genre];
}

class FetchFavoriteMovies extends MovieEvent {
  const FetchFavoriteMovies();

  @override
  List<Object?> get props => [];
}
