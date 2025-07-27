import 'package:freezed_annotation/freezed_annotation.dart';

part 'pagination_dto.freezed.dart';

part 'pagination_dto.g.dart';
@freezed
@immutable
abstract class PaginationDTO with _$PaginationDTO {
  factory PaginationDTO({
    @Default(0) int totalCount,
    @Default(0) int perPage,
    @Default(0) int maxPage,
    @Default(0) int currentPage,
  }) = _PaginationDTO;

  factory PaginationDTO.fromJson(Map<String, dynamic> json) =>
      _$PaginationDTOFromJson(json);
}
