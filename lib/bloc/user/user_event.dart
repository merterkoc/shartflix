part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUser extends UserEvent {
  const FetchUser();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends UserEvent {
  const LoginRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequested extends UserEvent {
  const RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  @override
  List<Object?> get props => [name, email, password, confirmPassword];
}

class UploadProfilePictureRequested extends UserEvent {
  const UploadProfilePictureRequested({required this.file});

  final File file;

  @override
  List<Object?> get props => [file];
}

class LogoutRequested extends UserEvent {
  const LogoutRequested();

  @override
  List<Object?> get props => [];
}
