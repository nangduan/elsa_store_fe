import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton/features/auth/data/models/request/login_request.dart';
import 'dart:ui'; // Cần thiết cho BackdropFilter nếu muốn hiệu ứng kính

import '../../../../core/di/injector.dart';
import '../../../../core/navigation/app_routes.dart';
// import '../../../widgets/text_field_widget.dart'; // Tạm thời comment để dùng style mới
import '../../domain/usecases/login_use_case.dart';
import '../cubit/login/login_cubit.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  final Color _primaryColor = const Color(0xFFE64A19);
  final Color _accentColor = const Color(0xFF1565C0);

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => LoginCubit(getIt<LoginUseCase>()),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status.isSuccess) {
              final role = state.authResponse?.role?.toUpperCase();
              if (role == 'ADMIN') {
                context.router.replace(const AdminRoute());
              } else {
                context.router.replace(const MainBottomNavRoute());
              }
            }
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Đăng nhập thất bại'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            }
          },
          builder: (context, state) {
            return Stack(
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
                  top: 100,
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

                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header Section
                            const SizedBox(height: 20),
                            Icon(Icons.storefront_rounded, size: 60, color: _primaryColor),
                            const SizedBox(height: 24),
                            Text(
                              'Xin chào!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: _primaryColor,
                                letterSpacing: -0.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Đăng nhập để có trải nghiệm tốt nhất',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 48),

                            // Input Section
                            _buildModernTextField(
                              controller: _usernameController,
                              hint: 'Tên đăng nhập',
                              icon: Icons.person_rounded,
                            ),
                            const SizedBox(height: 20),
                            _buildModernTextField(
                              controller: _passwordController,
                              hint: 'Mật khẩu',
                              icon: Icons.lock_rounded,
                              isPassword: true,
                              isVisible: _isPasswordVisible,
                              onVisibilityToggle: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.grey.shade600,
                                ),
                                child: const Text(
                                  'Quên mật khẩu?',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Login Button
                            SizedBox(
                              height: 58,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _primaryColor,
                                  foregroundColor: Colors.white,
                                  elevation: 5,
                                  shadowColor: _primaryColor.withOpacity(0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: state.status.isLoading
                                    ? null
                                    : () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginCubit>().login(
                                      LoginRequest(
                                        username: _usernameController.text,
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                                child: state.status.isLoading
                                    ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : const Text(
                                  'ĐĂNG NHẬP',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 40),

                            // Divider with text "Or continue with"
                            Row(
                              children: [
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Text(
                                    "hoặc tiếp tục với",
                                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                                  ),
                                ),
                                Expanded(child: Divider(color: Colors.grey.shade300)),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Social Buttons (Placeholder)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildSocialButton(Icons.g_mobiledata, Colors.redAccent),
                                const SizedBox(width: 20),
                                _buildSocialButton(Icons.facebook, Colors.blue),
                                const SizedBox(width: 20),
                                _buildSocialButton(Icons.apple, Colors.black),
                              ],
                            ),

                            const SizedBox(height: 40),

                            // Footer: Register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Chưa có tài khoản? ",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                                GestureDetector(
                                  onTap: () => context.router.push(const RegisterRoute()),
                                  child: Text(
                                    'Đăng ký ngay',
                                    style: TextStyle(
                                      color: _accentColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Widget Social Button nhỏ gọn
  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.grey.shade50,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]
      ),
      child: IconButton(
        icon: Icon(icon, color: color),
        onPressed: () {},
      ),
    );
  }

  // Widget TextField Modern (Thay thế cho TextFieldWidget cũ để đẹp hơn)
  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // Nền xám nhạt
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !isVisible,
        style: const TextStyle(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: Colors.grey.shade500),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              color: Colors.grey.shade500,
            ),
            onPressed: onVisibilityToggle,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none, // Loại bỏ viền mặc định
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.black, width: 1.5), // Viền khi focus
          ),
          filled: true,
          fillColor: Colors.transparent, // Dùng màu của Container
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$hint không được để trống';
          }
          return null;
        },
      ),
    );
  }
}