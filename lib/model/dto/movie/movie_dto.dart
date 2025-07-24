import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_dto.freezed.dart';

part 'movie_dto.g.dart';

@freezed
@immutable
abstract class MovieDTO with _$MovieDTO {
  factory MovieDTO({
    required String id,
    required String title,
    required String year,
    required String rated,
    required String released,
    required String runtime,
    required String genre,
    required String director,
    required String writer,
    required String actors,
    required String plot,
    required String language,
    required String country,
    required String awards,
    required String poster,
    required String metascore,
    required String imdbRating,
    required String imdbVotes,
    required String imdbID,
    required String type,
    @Default(false) bool response,
    @Default([]) List<String> images,
  }) = _MovieDTO;

  factory MovieDTO.fromJson(Map<String, dynamic> json) =>
      _$MovieDTOFromJson(json);
}
