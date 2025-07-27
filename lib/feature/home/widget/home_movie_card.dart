import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:shartflix/bloc/movie/movie_bloc.dart';
import 'package:shartflix/core/settings/settings_controller.dart';
import 'package:shartflix/model/dto/movie/movie_dto.dart';
import 'package:shartflix/ui/app_ui.dart';

class HomeMovieCard extends StatefulWidget {
  const HomeMovieCard({
    required this.movie,
    required this.onFavoritePressed,
    super.key,
  });

  final MovieDTO movie;
  final VoidCallback onFavoritePressed;

  @override
  State<HomeMovieCard> createState() => _HomeMovieCardState();
}

class _HomeMovieCardState extends State<HomeMovieCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isFavorite = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _isFavorite = widget.movie.isFavorite ?? false;

    // If already favorited, set animation to end state
    if (_isFavorite) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _animationController.value = 1.0;
      });
    }

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFavoritePressed(bool isFavorite) {
    if (isFavorite) {
      _animationController.forward();
    } else {
      _animationController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
      );
    }
    widget.onFavoritePressed();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: widget.movie.poster ?? '',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Theme.of(context).colorScheme.surface,
              child: const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Theme.of(context).colorScheme.surface,
              child: Center(
                child: Icon(
                  Icons.movie,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),

        if (GetIt.instance<SettingsController>().themeMode == Brightness.dark)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Theme.of(context).colorScheme.surface.withOpacity(0.6),
                    Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.6, 0.8, 1.0],
                ),
              ),
            ),
          )
        else
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Theme.of(context).colorScheme.surface.withOpacity(0.1),
                    Theme.of(context).colorScheme.surface.withOpacity(0.4),
                    Theme.of(context).colorScheme.surface.withOpacity(1),
                  ],
                  stops: const [0.0, 0.6, 0.8, 1.0],
                ),
              ),
            ),
          ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.paddingMedium),
              child: Align(
                alignment: Alignment.bottomRight,
                child: BlocBuilder<MovieBloc, MovieState>(
                  buildWhen: (previous, current) =>
                      previous.moviesResponse.data!.movies !=
                      current.moviesResponse.data!.movies,
                  builder: (context, state) {
                    final movie = state.moviesResponse.data!.movies!.firstWhere(
                      (m) => m.id == widget.movie.id,
                      orElse: () => widget.movie,
                    );
                    return SafeArea(
                      child: movie.isFavorite!
                          ? LogoBox(
                              onPressed: () {
                                _isFavorite = !_isFavorite;
                                _onFavoritePressed(_isFavorite);
                              },
                              height: 60,
                              width: 40,
                              child: LottieBuilder.asset(
                                'assets/lottie/heart.json',
                                width: 60,
                                height: 60,
                                controller: _animationController,
                                onLoaded: (composition) {
                                  _animationController.duration =
                                      composition.duration;
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  );
                                },
                                fit: BoxFit.contain,
                              ),
                            )
                          : LogoBox(
                              onPressed: () {
                                _isFavorite = !_isFavorite;
                                _onFavoritePressed(_isFavorite);
                              },
                              icon: Icons.favorite,
                              iconSize: 16,
                              height: 60,
                              width: 40,
                            ),
                    );
                  },
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.movie.title ?? '',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      if (widget.movie.year != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiaryContainer
                                .withValues(
                                  alpha: 0.4,
                                ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            widget.movie.year!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (widget.movie.imdbRating != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.movie.imdbRating!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Movie plot
                  if (widget.movie.plot != null &&
                      widget.movie.plot!.isNotEmpty) ...[
                    Text(
                      widget.movie.plot!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                  ],

                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (widget.movie.genre != null) ...[
                        _buildDetailChip(widget.movie.genre!),
                      ],
                      if (widget.movie.director != null) ...[
                        _buildDetailChip(widget.movie.director!),
                      ],
                      if (widget.movie.runtime != null) ...[
                        _buildDetailChip(widget.movie.runtime!),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(
          alpha: 0.7,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
