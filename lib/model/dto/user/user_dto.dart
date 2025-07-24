import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';

part 'user_dto.g.dart';

@freezed
@immutable
abstract class UserDTO with _$UserDTO {
  factory UserDTO({
    required String id,
    required String name,
    required String email,
    required String photoUrl,
    required String token,
  }) = _UserDTO;

  factory UserDTO.fromJson(Map<String, dynamic> json) =>
      _$UserDTOFromJson(json);
}
