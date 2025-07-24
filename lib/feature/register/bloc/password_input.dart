import 'package:formz/formz.dart';

enum PasswordValidationError { empty, tooShort }

class PasswordInput extends FormzInput<String, PasswordValidationError> {
  const PasswordInput.pure() : super.pure('');

  const PasswordInput.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    return value.length < 6 ? PasswordValidationError.tooShort : null;
  }
}
