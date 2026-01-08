import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/constants/constant.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/navigation/app_routes.dart';

@RoutePage()
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  // Giả lập việc check đăng nhập hoặc loading dữ liệu ban đầu
  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final storage = getIt<FlutterSecureStorage>();
    final token = await storage.read(key: Constants.accessToken);
    final role = await storage.read(key: Constants.role);

    if (token == null || token.isEmpty) {
      context.router.replace(const LoginRoute());
      return;
    }

    switch (role) {
      case 'CUSTOMER':
        // context.router.replace(const CustomerRoute());
        break;
      case 'ADMIN':
        context.router.replace(const AdminRoute());
        break;
      case 'STAFF':
        // context.router.replace(const EmployeeRoute());
        break;
      default:
        context.router.replace(const LoginRoute());
        break;
    }

    // Ở đây bạn có thể thêm logic check Token:
    // Nếu có token -> MainBottomNavRoute
    // Nếu không -> LoginRoute
    context.router.replace(const LoginRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Logo Branding - Đồng bộ màu Đen/Trắng
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'ELSA',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'FASHION STORE',
              style: TextStyle(
                color: Colors.grey.shade500,
                letterSpacing: 2,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Spacer(),

            // Hiệu ứng Loading nhẹ nhàng ở dưới cùng
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
