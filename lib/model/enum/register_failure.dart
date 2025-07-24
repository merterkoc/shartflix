enum RegisterFailure {
  unknownError('UNKNOWN_ERROR'),
  userExist('USER_EXISTS'),
  invalidEmail('INVALID_EMAIL');

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
