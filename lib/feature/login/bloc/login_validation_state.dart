part of 'login_validation_bloc.dart';

class LoginValidationState extends Equatable {
  const LoginValidationState({
    this.email = const EmailInput.pure(),
    this.password = const LoginPasswordInput.pure(),
    this.status = false,
  });

  final EmailInput email;
  final LoginPasswordInput password;
  final bool status;

  LoginValidationState copyWith({
    EmailInput? email,
    LoginPasswordInput? password,
    bool? status,
  }) {
    return LoginValidationState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [email, password, status];
}
