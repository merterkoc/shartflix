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
                padding: const EdgeInsets.all(AppSpacing.paddingMedium),
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
    final user = state.userResponse.data;
    if (user == null) {
      return Row(
        children: [
          const Icon(Icons.person, size: 60, color: Colors.grey),
          const SizedBox(width: 24),
          Text(context.l10n.fetch_user_failed),
        ],
      );
    }

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        BlocBuilder<UserBloc, UserState>(
          buildWhen: (state, previous) =>
              state.userResponse.data?.photoUrl !=
              previous.userResponse.data?.photoUrl,
          builder: (context, state) {
            return Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: state.userResponse.data?.photoUrl == null
                  ? Icon(
                      Icons.person,
                      size: 60,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    )
                  : ClipOval(
                      child: Image.network(
                        state.userResponse.data!.photoUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          Icons.person,
                          size: 60,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
            );
          },
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.name,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                context.l10n.profile_view_id_label(user.id),
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        AppButton.primary(
          text: context.l10n.profile_view_add_photo_button,
          onPressed: () => context.goNamed(AppRoute.photoUpload.name),
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
          child: Center(
            child: Column(
              children: [
                Text(
                  context.l10n.profile_view_favorites_label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                if (state.favoriteMoviesResponse.data?.isEmpty ?? true)
                  Text(
                    context.l10n.profile_view_favorites_empty,
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
          ),
        );
      },
    );
  }
}
