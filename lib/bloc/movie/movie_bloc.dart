import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:shartflix/api/interface/i_api_provider.dart';
import 'package:shartflix/model/dto/movie/movie_dto.dart';
import 'package:shartflix/model/dto/pagination_movie/pagination_movie_dto.dart';
import 'package:shartflix/repository/movie_repository.dart';

part 'movie_event.dart';

part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc(this.movieRepository) : super(MovieState.initial()) {
    on<FetchMovies>(_onFetchMovies);
    on<FetchFavoriteMovies>(_onFetchFavoriteMovies);
    on<FavoriteMovie>(_onFavoriteMovie, transformer: sequential());
  }

  final MovieRepository movieRepository;

  Future<void> _onFetchMovies(
    FetchMovies event,
    Emitter<MovieState> emit,
  ) async {
    if (event.page == 1) {
      emit(
        state.copyWith(
          moviesResponse: ResponseEntity<PaginationMovieDTO>.loading(),
        ),
      );
    }

    try {
      final response = await movieRepository.getMovies(
        genre: event.genre,
        page: event.page,
      );
      if (response.isOk) {
        final data = response.data as Map<String, dynamic>;
        final paginationMovieDTO = PaginationMovieDTO.fromJson(
          data['data'] as Map<String, dynamic>,
        );

        final newMovies = List<MovieDTO>.from(
          paginationMovieDTO.movies!.map((item) => item),
        ).toList();

        // If it's the first page, replace movies, otherwise append
        final currentMovies = state.moviesResponse.data?.movies ?? <MovieDTO>[];
        final updatedMovies = event.page == 1
            ? newMovies
            : [...currentMovies, ...newMovies];

        emit(
          state.copyWith(
            moviesResponse: ResponseEntity<PaginationMovieDTO>.success(
              data: PaginationMovieDTO(
                movies: updatedMovies,
                pagination: paginationMovieDTO.pagination,
              ),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            moviesResponse: ResponseEntity<PaginationMovieDTO>.error(
              message: response.message ?? 'FETCH_MOVIES_FAILED',
              statusCode: response.statusCode,
            ),
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          moviesResponse: ResponseEntity<PaginationMovieDTO>.error(
            message: e.toString(),
          ),
        ),
      );
      rethrow;
    }
  }

  Future<void> _onFetchFavoriteMovies(
    FetchFavoriteMovies event,
    Emitter<MovieState> emit,
  ) async {
    emit(
      state.copyWith(
        favoriteMoviesResponse: ResponseEntity<List<MovieDTO>>.loading(
          data: state.favoriteMoviesResponse.data,
        ),
      ),
    );

    try {
      final response = await movieRepository.getFavoriteMovies();
      if (response.isOk) {
        final data = response.data as List<dynamic>;
        final movies = List<MovieDTO>.from(
          data.map(
            (item) => MovieDTO.fromJson(item as Map<String, dynamic>),
          ),
        ).toList();
        emit(
          state.copyWith(
            favoriteMoviesResponse: ResponseEntity<List<MovieDTO>>.success(
              data: movies,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            favoriteMoviesResponse: ResponseEntity<List<MovieDTO>>.error(
              message: response.message ?? 'FETCH_FAVORITE_MOVIES_FAILED',
              statusCode: response.statusCode,
            ),
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          favoriteMoviesResponse: ResponseEntity<List<MovieDTO>>.error(
            message: e.toString(),
          ),
        ),
      );
      rethrow;
    }
  }

  Future<void> _onFavoriteMovie(
    FavoriteMovie event,
    Emitter<MovieState> emit,
  ) async {
    final lastMovieResponse = state.moviesResponse;
    final movieListData = lastMovieResponse.data;

    if (movieListData?.movies == null) return;

    final updatedMovies = movieListData!.movies!.map((movie) {
      return movie.id == event.favoriteId
          ? movie.copyWith(isFavorite: !movie.isFavorite!)
          : movie;
    }).toList();

    emit(
      state.copyWith(
        moviesResponse: ResponseEntity.success(
          data: movieListData.copyWith(
            movies: updatedMovies,
          ),
        ),
      ),
    );

    try {
      final response = await movieRepository.favoriteMovie(
        favoriteId: event.favoriteId,
      );
      if (response.isOk) {
        add(const FetchFavoriteMovies());
      } else {
        emit(
          state.copyWith(
            moviesResponse: ResponseEntity<PaginationMovieDTO>.error(
              data: lastMovieResponse.data,
              statusCode: response.statusCode,
            ),
          ),
        );
      }
    } on Exception {
      emit(
        state.copyWith(
          moviesResponse: ResponseEntity<PaginationMovieDTO>.error(
            data: lastMovieResponse.data,
            statusCode: 200,
          ),
        ),
      );
      rethrow;
    }
  }
}
