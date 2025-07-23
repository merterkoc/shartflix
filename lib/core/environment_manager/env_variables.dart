// ignore_for_file: constant_identifier_names
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvVariables {
  BASE_URL('BASE_URL');

  const EnvVariables(this.name);

  final String name;
}
