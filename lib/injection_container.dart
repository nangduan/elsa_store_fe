import 'package:get_it/get_it.dart';
import 'features/auth/presentation/controllers/login_controller.dart';
import 'features/home/presentation/controllers/home_controller.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Controllers / Providers
  sl.registerFactory(() => LoginController());
  sl.registerFactory(() => HomeController());
  // Repositories / Data sources could be registered here
}
