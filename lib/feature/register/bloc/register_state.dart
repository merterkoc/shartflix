part of 'register_bloc.dart';

class RegisterState extends Equatable {
  const RegisterState({
    this.name = const NameInput.pure(),
    this.email = const EmailInput.pure(),
    this.password = const PasswordInput.pure(),
    this.confirmPassword = const PasswordInput.pure(),
    this.status = false,
  });

  final NameInput name;
  final EmailInput email;
  final PasswordInput password;
  final PasswordInput confirmPassword;
  final bool status;

  RegisterState copyWith({
    NameInput? name,
    EmailInput? email,
    PasswordInput? password,
    PasswordInput? confirmPassword,
    bool? status,
  }) {
    return RegisterState(
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [name, email, password, confirmPassword, status];
}
