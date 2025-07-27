import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shartflix/model/dto/movie/movie_dto.dart';

class MovieCard extends StatelessWidget {
  const MovieCard({required this.movie, super.key});

  final MovieDTO movie;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              imageUrl: movie.poster ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              errorWidget: (context, url, error) => Center(
                child: Icon(
                  Icons.error,
                  color: Theme.of(context).colorScheme.error,
                  size: 48,
                ),
              ),
            ),
          ),
        ),
        Text(
          movie.title ?? '',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          movie.director ?? '',
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
