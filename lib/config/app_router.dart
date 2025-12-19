import 'package:go_router/go_router.dart';

import '../core/widgets/main_bottom_nav.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/payment_screen.dart';
import '../features/auth/presentation/screens/product_detail_screen.dart';
import '../features/auth/presentation/screens/ready_card_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/start_screen.dart';


final GoRouter router = GoRouter(
  initialLocation: '/start',
  routes: [
    GoRoute(path: '/', redirect: (_, __) => '/start'),

    GoRoute(path: '/start', builder: (_, __) => const StartScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    GoRoute(path: '/ready', builder: (_, __) => const ReadyCardScreen()),
    GoRoute(path: '/main', builder: (_, __) => const MainBottomNav()),
  ],
);
