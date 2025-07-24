part of 'login_validation_bloc.dart';

abstract class LoginValidationEvent extends Equatable {
  const LoginValidationEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginValidationEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginValidationEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object?> get props => [password];
}
