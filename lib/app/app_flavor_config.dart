enum Flavor { dev, production }

class FlavorValues {
  FlavorValues({required this.appName, required this.apiBaseUrl});

  final String apiBaseUrl;
  final String appName;
}

class FlavorConfig {
  factory FlavorConfig({
    required Flavor flavor,
    required FlavorValues values,
  }) {
    return _instance = FlavorConfig._internal(flavor, values);
  }

  FlavorConfig._internal(this.flavor, this.values);

  final Flavor flavor;
  final FlavorValues values;

  static late FlavorConfig _instance;
  static FlavorConfig get instance {
    return _instance;
  }

  static bool isProduction() => _instance.flavor == Flavor.production;
  static bool isDevelopment() => _instance.flavor == Flavor.dev;
}
