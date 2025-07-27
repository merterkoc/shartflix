import 'package:formz/formz.dart';

enum LoginPasswordValidationError { empty }

class LoginPasswordInput
    extends FormzInput<String, LoginPasswordValidationError> {
  const LoginPasswordInput.pure() : super.pure('');

  const LoginPasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  LoginPasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return LoginPasswordValidationError.empty;
    }
    return null;
  }
}
