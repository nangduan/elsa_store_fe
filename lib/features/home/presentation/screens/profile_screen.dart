import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton/core/di/injector.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../user/presentation/cubit/user_cubit.dart';
import '../../../user/presentation/cubit/user_state.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  final Color _primaryBlue = const Color(0xFF1964D4);
  final Color _primaryOrange = const Color(0xFFE85022);
  final Color _bgColor = const Color(0xFFFAFAFA);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<UserCubit>()..load(),
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: AppBar(
          title: Text(
            'HỒ SƠ CÁ NHÂN',
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
            onPressed: () => context.router.pop(),
          ),
        ),
        body: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state.status == UserStatus.loading) {
              return Center(
                child: CircularProgressIndicator(color: _primaryBlue),
              );
            }

            if (state.status == UserStatus.failure) {
              return RefreshIndicator(
                onRefresh: () => context.read<UserCubit>().load(),
                color: _primaryBlue,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 120),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFCEAE8),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.error_outline,
                              size: 48,
                              color: _primaryOrange,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.errorMessage ?? 'Không tải được hồ sơ',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: _primaryBlue,
                            ),
                            onPressed: () => context.read<UserCubit>().load(),
                            child: const Text(
                              'Thử lại',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            final user = state.user;
            final fullName = user?.fullName ?? '-';
            final username = user?.username ?? '-';
            final email = user?.email ?? '-';
            final phone = user?.phone ?? '-';
            final enabled = user?.enabled ?? false;

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 54,
                                backgroundColor: const Color(0xFFEAF1F8),
                                child: Text(
                                  _getInitials(fullName),
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w900,
                                    color: _primaryBlue,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _primaryOrange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          fullName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@$username',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildProfileItem(
                          icon: Icons.email_outlined,
                          title: 'Email',
                          value: email,
                          iconColor: _primaryBlue,
                          iconBgColor: const Color(0xFFEAF1F8),
                        ),
                        _buildDivider(),
                        _buildProfileItem(
                          icon: Icons.phone_outlined,
                          title: 'Số điện thoại',
                          value: phone,
                          iconColor: _primaryBlue,
                          iconBgColor: const Color(0xFFEAF1F8),
                        ),
                        _buildDivider(),
                        _buildProfileItem(
                          icon: Icons.verified_user_outlined,
                          title: 'Trạng thái',
                          value: enabled ? 'Đang hoạt động' : 'Vô hiệu hóa',
                          valueColor: enabled ? Colors.green : Colors.red,
                          iconColor: enabled ? Colors.green : Colors.red,
                          iconBgColor: enabled
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: user == null
                                ? null
                                : () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<UserCubit>(),
                                        child: const EditProfileScreen(),
                                      ),
                                    ),
                                  ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _primaryBlue,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Chỉnh sửa thông tin',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            onPressed: user == null
                                ? null
                                : () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<UserCubit>(),
                                        child: const ChangePasswordScreen(),
                                      ),
                                    ),
                                  ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _primaryBlue,
                              side: BorderSide(
                                color: _primaryBlue.withOpacity(0.3),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: const Text(
                              'Đổi mật khẩu',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton.icon(
                            onPressed: () => _showLogoutDialog(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFCEAE8),
                              foregroundColor: _primaryOrange,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            icon: const Icon(Icons.logout),
                            label: const Text(
                              'ĐĂNG XUẤT',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
    required Color iconColor,
    required Color iconBgColor,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: valueColor ?? Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200);
  }

  String _getInitials(String name) {
    List<String> names = name.trim().split(' ');
    String initials = '';
    if (names.isNotEmpty) {
      initials += names[0][0];
      if (names.length > 1) {
        initials += names[names.length - 1][0];
      }
    }
    return initials.toUpperCase();
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Đăng xuất',
          style: TextStyle(color: _primaryOrange, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất không?',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFCEAE8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () async {
              await getIt<AuthRepository>().logout();
              if (context.mounted) {
                Navigator.pop(context);
                context.router.replaceAll([const LoginRoute()]);
              }
            },
            child: Text(
              'Đăng xuất',
              style: TextStyle(
                color: _primaryOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
