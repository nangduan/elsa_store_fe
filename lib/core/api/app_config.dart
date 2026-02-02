class AppConfig {
  bool isProduction = true;
  // String baseURL = 'http://192.168.35.3:8080/elsa-store/api';
  String baseURL = 'http://192.168.1.16:8080/elsa-store/api';
  int connectTimeout = 60000;
  int receiveTimeout = 60000;
  int sendTimeout = 60000;
  String contentType = 'application/json';

  Map<String, String> standardHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static final AppConfig _instance = AppConfig._privateConstructor();

  AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }
}
