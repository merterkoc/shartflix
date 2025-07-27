import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shartflix/bloc/movie/movie_bloc.dart';
import 'package:shartflix/bloc/user/user_bloc.dart';
import 'package:shartflix/core/router/go_router.dart';
import 'package:shartflix/feature/home/widget/movie_card.dart';
import 'package:shartflix/ui/app_ui.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Completer<void>? _refreshCompleter;
  bool _isUserLoaded = false;
  bool _isFavoritesLoaded = false;

  void _checkRefreshComplete() {
    if (_isUserLoaded && _isFavoritesLoaded && _refreshCompleter != null) {
      _refreshCompleter!.complete();
      _refreshCompleter = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listenWhen: (previous, current) =>
              previous.userResponse.status != current.userResponse.status,
          listener: (context, state) {
            if (state.userResponse.status.isSuccess ||
                state.userResponse.status.isError) {
              _isUserLoaded = true;
              _checkRefreshComplete();
            }
          },
        ),
        BlocListener<MovieBloc, MovieState>(
          listenWhen: (previous, current) =>
              previous.favoriteMoviesResponse.status !=
              current.favoriteMoviesResponse.status,
          listener: (context, state) {
            if (state.favoriteMoviesResponse.status.isSuccess ||
                state.favoriteMoviesResponse.status.isError) {
              _isFavoritesLoaded = true;
              _checkRefreshComplete();
            }
          },
        ),
      ],
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  _refreshCompleter = Completer<void>();
                  _isUserLoaded = false;
                  _isFavoritesLoaded = false;

                  context.read<UserBloc>().add(const FetchUser());
                  context.read<MovieBloc>().add(const FetchFavoriteMovies());

                  return _refreshCompleter!.future;
                },
              ),
              SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.paddingSmall),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    BlocBuilder<UserBloc, UserState>(
                      buildWhen: (state, previous) =>
                          state.userResponse.status !=
                          previous.userResponse.status,
                      builder: (context, state) {
                        if (!state.userResponse.status.isSuccess &&
                            state.userResponse.data == null) {
                          return const SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        }
                        return _buildUserInfoCard(state, context);
                      },
                    ),
                    BlocBuilder<MovieBloc, MovieState>(
                      buildWhen: (state, previous) =>
                          state.favoriteMoviesResponse.status !=
                          previous.favoriteMoviesResponse.status,
                      builder: (context, state) {
                        if (!state.favoriteMoviesResponse.status.isSuccess &&
                            state.favoriteMoviesResponse.data == null) {
                          return const SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        }
                        return _buildFavoritesMoviesSection(context);
                      },
                    ),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Row _buildUserInfoCard(UserState state, BuildContext context) {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: state.userResponse.data?.photoUrl != null
              ? ClipOval(
                  child: Image.network(
                    state.userResponse.data!.photoUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.grey,
                      );
                    },
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.grey,
                ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                state.userResponse.data!.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                context.l10n.profile_view_id_label(state.userResponse.data!.id),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        AppButton.primary(
          text: context.l10n.profile_view_add_photo_button,
          onPressed: () {
            context.goNamed(AppRoute.photoUpload.name);
          },
        ),
      ],
    );
  }

  BlocBuilder<MovieBloc, MovieState> _buildFavoritesMoviesSection(
    BuildContext context,
  ) {
    return BlocBuilder<MovieBloc, MovieState>(
      buildWhen: (state, previous) =>
          state.favoriteMoviesResponse.status !=
          previous.favoriteMoviesResponse.status,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Beğenilen Filmler',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              if (state.favoriteMoviesResponse.data?.isEmpty ?? true)
                const Text(
                  'Beğenilen film bulunmamaktadır.',
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.favoriteMoviesResponse.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    final movie = state.favoriteMoviesResponse.data![index];
                    return MovieCard(
                      movie: movie,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
