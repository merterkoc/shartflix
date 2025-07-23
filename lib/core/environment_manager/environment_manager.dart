import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shartflix/core/environment_manager/env_variables.dart';

class EnvironmentManager {
  factory EnvironmentManager() {
    _instance ??= EnvironmentManager._();
    return _instance!;
  }

  EnvironmentManager._();

  late List<EnvVariables> _envVariables;
  final DotEnv _dotEnv = DotEnv();
  static EnvironmentManager? _instance;

  static Future<EnvironmentManager> get instance async =>
      EnvironmentManager._();

  Future<void> init() async {
    await _dotEnv.load(fileName: 'env/.env');
    loadConfig();
  }

  void loadConfig() {
    _envVariables = [];
    for (final element in EnvVariables.values) {
      _envVariables.add(element);
    }
  }

  String getValue(EnvVariables envVariable) {
    return _dotEnv.env[envVariable.name]!;
  }
}
