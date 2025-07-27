enum RegisterFailure {
  unknownError('UNKNOWN_ERROR'),
  userExist('USER_EXISTS'),
  passwordTooShort('PASSWORD_TOO_SHORT'),
  noPasswordMatch('NO_PASSWORD_MATCH'),
  invalidEmail('INVALID_EMAIL_FORMAT');

  const RegisterFailure(this.value);

  final String value;

  static RegisterFailure fromCode(String value) {
    return RegisterFailure.values.firstWhere(
      (e) => e.value == value,
      orElse: () =>
          throw ArgumentError('Invalid RegisterFailure value: $value'),
    );
  }
}
