import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_skeleton/core/constants/constant.dart';
import 'package:flutter_skeleton/core/di/injector.dart';

import '../enum/role_enum.dart';

class FlutterStoreCore {
  static final FlutterSecureStorage _storage = getIt<FlutterSecureStorage>();

  static Future<int?> readUserId() async {
    final raw = await _storage.read(key: Constants.userId);
    if (raw == null) return null;
    return int.tryParse(raw);
  }

  static Future<Role> readRole() async {
    final raw = await _storage.read(key: Constants.role);
    return Role.fromString(raw);
  }
}
