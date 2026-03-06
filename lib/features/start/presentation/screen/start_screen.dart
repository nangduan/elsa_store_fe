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
  final Color _primaryBlue = const Color(0xFF1964D4);
  final Color _primaryOrange = const Color(0xFFE85022);
  final Color _bgColor = const Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

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
        context.router.replace(const MainBottomNavRoute());
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          // Background họa tiết vòng tròn đồng bộ với màn hình Đăng ký/Đăng nhập
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFEAF1F8), // Light Blue
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFCEAE8), // Light Orange
              ),
            ),
          ),

          // Nội dung chính
          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // Logo Branding - Đổ bóng và bo góc hiện đại
                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: _primaryOrange,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryOrange.withOpacity(0.3),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_rounded,
                    size: 72,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 32),

                Text(
                  'ELSA',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                    color: _primaryBlue,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: _primaryBlue.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'CỬA HÀNG THỜI TRANG',
                    style: TextStyle(
                      color: _primaryBlue,
                      letterSpacing: 2.5,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                // Loading Indicator đồng màu
                SizedBox(
                  width: 44,
                  height: 44,
                  child: CircularProgressIndicator(
                    strokeWidth: 3.5,
                    color: _primaryOrange,
                    backgroundColor: _primaryOrange.withOpacity(0.15),
                  ),
                ),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }
}