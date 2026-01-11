import 'package:flutter/material.dart';

import 'di/injector.dart';

Future<void> configSetup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencyInjection();
}

Future<void> initDependencyInjection() async {
  await configureDependencies();
}
