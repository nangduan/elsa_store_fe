class AppPreferences {
  // dummy wrapper - replace with SharedPreferences implementation
  Future<void> init() async {}
  Future<void> saveToken(String token) async {}
  Future<String?> getToken() async => null;
}
