enum LoginFailure {
  unknownError('UNKNOWN_ERROR'),
  invalidCredentials('INVALID_CREDENTIALS');

  const LoginFailure(this.value);

  final String value;

  static LoginFailure fromCode(String value) {
    return LoginFailure.values.firstWhere(
      (e) => e.value == value,
      orElse: () =>
          throw ArgumentError('Invalid LoginFailure value: $value'),
    );
  }
}
