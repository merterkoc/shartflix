import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shartflix/model/dto/movie/movie_dto.dart';
import 'package:shartflix/model/dto/pagination/pagination_dto.dart';

part 'pagination_movie_dto.freezed.dart';

part 'pagination_movie_dto.g.dart';

@freezed
@immutable
abstract class PaginationMovieDTO with _$PaginationMovieDTO {
  factory PaginationMovieDTO({
    List<MovieDTO>? movies,
    PaginationDTO? pagination,
  }) = _PaginationMovieDTO;

  factory PaginationMovieDTO.fromJson(Map<String, dynamic> json) =>
      _$PaginationMovieDTOFromJson(json);
}

