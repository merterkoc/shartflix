part of 'movie_bloc.dart';

@immutable
class MovieState extends Equatable {
  const MovieState({
    required this.moviesResponse,
    required this.favoriteMoviesResponse,
  });

  factory MovieState.initial() {
    return MovieState(
      moviesResponse: ResponseEntity<PaginationMovieDTO>.initial(),
      favoriteMoviesResponse: ResponseEntity<List<MovieDTO>>.initial(),
    );
  }

  final ResponseEntity<PaginationMovieDTO> moviesResponse;
  final ResponseEntity<List<MovieDTO>> favoriteMoviesResponse;

  MovieState copyWith({
    ResponseEntity<PaginationMovieDTO>? moviesResponse,
    ResponseEntity<List<MovieDTO>>? favoriteMoviesResponse,
  }) {
    return MovieState(
      moviesResponse: moviesResponse ?? this.moviesResponse,
      favoriteMoviesResponse:
          favoriteMoviesResponse ?? this.favoriteMoviesResponse,
    );
  }

  @override
  List<Object?> get props => [
    moviesResponse,
    favoriteMoviesResponse,
  ];
}
