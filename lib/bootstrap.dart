import 'package:flutter/foundation.dart';
import 'injection_container.dart' as di;

Future<void> bootstrap() async {
  // Initialize dependencies (get_it)
  await di.init();
  if (kDebugMode) {
    // Any debug-only init
  }
}
