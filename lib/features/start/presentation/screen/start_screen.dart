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
  final Color _primaryColor = const Color(0xFFE64A19);
  final Color _accentColor = const Color(0xFF1565C0);

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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accentColor.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueAccent.withOpacity(0.05),
              ),
            ),
          ),

          // 2. Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _primaryColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 32),

                // Tên thương hiệu
                Text(
                  'ELSA',
                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 6,
                    color: _primaryColor,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'FASHION STORE',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    letterSpacing: 4,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                    backgroundColor: _primaryColor.withOpacity(0.1),
                  ),
                ),

                const SizedBox(height: 20),

                // Version number (Option)
                Text(
                  "Version 1.0.0",
                  style: TextStyle(color: Colors.grey.shade300, fontSize: 12),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}