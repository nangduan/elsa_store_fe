import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final Color _primaryBlue = const Color(0xFF1964D4);
  final Color _bgColor = const Color(0xFFFAFAFA);
  final Color _inputFillColor = const Color(0xFFF5F5F5);

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: Text(
          'Đổi mật khẩu',
          style: TextStyle(
            color: _primaryBlue,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: _primaryBlue, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          final cubit = context.read<UserCubit>();
          final isSubmitting =
              state.actionStatus == UserActionStatus.submitting;
          final user = state.user;
          if (user == null) {
            return const Center(
              child: Text('Không tìm thấy thông tin người dùng'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đổi mật khẩu mới',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: _primaryBlue,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _oldPasswordController,
                    label: 'Mật khẩu hiện tại',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  _buildField(
                    controller: _newPasswordController,
                    label: 'Mật khẩu mới',
                    icon: Icons.lock_reset_outlined,
                    obscureText: true,
                  ),
                  _buildField(
                    controller: _confirmPasswordController,
                    label: 'Xác nhận mật khẩu mới',
                    icon: Icons.check_circle_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              final oldPass = _oldPasswordController.text
                                  .trim();
                              final newPass = _newPasswordController.text
                                  .trim();
                              final confirmPass = _confirmPasswordController
                                  .text
                                  .trim();
                              if (oldPass.isEmpty ||
                                  newPass.isEmpty ||
                                  confirmPass.isEmpty) {
                                _showSnackBar(
                                  context,
                                  'Vui lòng điền đầy đủ thông tin',
                                );
                                return;
                              }
                              if (newPass != confirmPass) {
                                _showSnackBar(
                                  context,
                                  'Mật khẩu xác nhận không khớp',
                                );
                                return;
                              }
                              final ok = await cubit.changePassword(
                                oldPassword: oldPass,
                                newPassword: newPass,
                                confirmPassword: confirmPass,
                              );
                              _showSnackBar(
                                context,
                                ok
                                    ? (cubit.state.actionMessage ??
                                          'Đổi mật khẩu thành công')
                                    : (cubit.state.actionMessage ??
                                          'Đổi mật khẩu thất bại'),
                                isError: !ok,
                              );
                              if (ok) {
                                _oldPasswordController.clear();
                                _newPasswordController.clear();
                                _confirmPasswordController.clear();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'ĐỔI MẬT KHẨU',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          prefixIcon: Icon(icon, size: 22, color: Colors.black45),
          filled: true,
          fillColor: _inputFillColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String message, {
    bool isError = true,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.redAccent : Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }
}
