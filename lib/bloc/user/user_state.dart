part of 'user_bloc.dart';

@immutable
class UserState extends Equatable {
  const UserState({
    required this.userResponse,
    required this.uploadProfilePictureResponse,
  });

  factory UserState.initial() {
    return UserState(
      userResponse: ResponseEntity<UserDTO>.initial(),
      uploadProfilePictureResponse: ResponseEntity<UserDTO>.initial(),
    );
  }

  final ResponseEntity<UserDTO> userResponse;
  final ResponseEntity<UserDTO> uploadProfilePictureResponse;

  UserState copyWith({
    ResponseEntity<UserDTO>? userResponse,
    ResponseEntity<UserDTO>? uploadProfilePictureResponse,
  }) {
    return UserState(
      userResponse: userResponse ?? this.userResponse,
      uploadProfilePictureResponse:
          uploadProfilePictureResponse ?? this.uploadProfilePictureResponse,
    );
  }

  @override
  List<Object?> get props => [
    userResponse,
    uploadProfilePictureResponse,
  ];
}
