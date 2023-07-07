class Config {
  static final Config _instance = Config._();
  factory Config() => _getInstance();
  static Config get instance => _getInstance();
  Config._();

  static Config _getInstance() {
    return _instance;
  }

  static bool isInfiniteNumberVersion = true; // Unlimited frequency. Development and use
  static String appName = 'SHIKSHA BOT (BETA)';
  static String contactEmail = 'mgcshiksha@gmail.com';
}
