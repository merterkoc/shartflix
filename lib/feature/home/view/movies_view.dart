import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shartflix/bloc/movie/movie_bloc.dart';
import 'package:shartflix/feature/home/widget/home_movie_card.dart';
import 'package:shartflix/ui/app_ui.dart';

class MoviesView extends StatefulWidget {
  const MoviesView({super.key});

  @override
  State<MoviesView> createState() => _MoviesViewState();
}

class _MoviesViewState extends State<MoviesView> {
  final PageController _scrollController = PageController();
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {}

  void _loadMoreMovies() {
    if (!_isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });
      _currentPage++;
      context.read<MovieBloc>().add(FetchMovies(page: _currentPage));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MovieBloc, MovieState>(
      listener: (context, state) {
        if (state.moviesResponse.status.isSuccess) {
          setState(() {
            _isLoadingMore = false;
          });
        }
      },
      builder: (context, state) {
        if (state.moviesResponse.status.isLoading && _currentPage == 1) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }

        if (state.moviesResponse.status.isError && _currentPage == 1) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  context.l10n.movie_loading_error,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  state.moviesResponse.message ?? context.l10n.error_unknown,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                AppButton.primary(
                  text: context.l10n.retry_button_label,
                  onPressed: () {
                    _currentPage = 1;
                    context.read<MovieBloc>().add(const FetchMovies());
                  },
                ),
              ],
            ),
          );
        }

        final movies = state.moviesResponse.data?.movies ?? [];

        if (movies.isEmpty && !state.moviesResponse.status.isLoading) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.movie_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'No movies found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator.adaptive(
          onRefresh: () async {
            _currentPage = 1;
            context.read<MovieBloc>().add(const FetchMovies());
          },
          child: PageView.builder(
            controller: _scrollController,
            itemCount: movies.length + (_isLoadingMore ? 1 : 0),
            onPageChanged: (index) {
              // Load more movies when user reaches near the end
              if (index >= movies.length - 3 && !_isLoadingMore) {
                _loadMoreMovies();
              }
            },
            itemBuilder: (context, index) {
              if (index == movies.length) {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }

              final movie = movies[index];
              return HomeMovieCard(
                movie: movie,
                onFavoritePressed: () {
                  context.read<MovieBloc>().add(
                    FavoriteMovie(favoriteId: movie.id!),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
