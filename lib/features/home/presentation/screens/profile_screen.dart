import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skeleton/core/di/injector.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Giả lập dữ liệu user từ JSON bạn cung cấp
    // Trong thực tế, bạn sẽ lấy biến này từ State Management (Bloc/Provider/GetX)
    final user = {
      "id": 2,
      "username": "user02",
      "email": "emai2@gmail.com",
      "phone": "0378847761",
      "fullName": "Lê Năng Duẫn",
      "enabled": true,
    };

    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Màu nền nhẹ nhàng
      appBar: AppBar(
        title: const Text(
          'Hồ sơ cá nhân',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 1. HEADER: Avatar & Tên chính
            Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade100,
                        child: Text(
                          _getInitials(user['fullName'] as String),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        // Nếu có link ảnh thì dùng dòng dưới:
                        // backgroundImage: NetworkImage('...'),
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
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user['fullName'] as String,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "@${user['username']}",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 2. BODY: Thông tin chi tiết
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _buildProfileItem(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    value: user['email'] as String,
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.phone_outlined,
                    title: 'Số điện thoại',
                    value: user['phone'] as String,
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.badge_outlined,
                    title: 'User ID',
                    value: '#${user['id']}',
                  ),
                  _buildDivider(),
                  _buildProfileItem(
                    icon: Icons.verified_user_outlined,
                    title: 'Trạng thái',
                    value: (user['enabled'] as bool)
                        ? 'Đang hoạt động'
                        : 'Vô hiệu hóa',
                    valueColor: (user['enabled'] as bool)
                        ? Colors.green
                        : Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // 3. FOOTER: Nút Đăng xuất
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Xử lý logic đăng xuất tại đây (Clear token, navigate to login...)
                    _showLogoutDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.red.shade200),
                    ),
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Đăng xuất',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget con hiển thị từng dòng thông tin
  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 22, color: Colors.grey.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: valueColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 1, thickness: 1, color: Colors.grey.shade100);
  }

  // Hàm lấy chữ cái đầu của tên (Ví dụ: Lê Năng Duẫn -> LD)
  String _getInitials(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    if (names.isNotEmpty) {
      initials += names[0][0]; // Chữ đầu của Họ
      if (names.length > 1) {
        initials += names[names.length - 1][0]; // Chữ đầu của Tên
      }
    }
    return initials.toUpperCase();
  }

  // Dialog xác nhận đăng xuất
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await getIt<AuthRepository>().logout();
              Navigator.pop(context);
              context.router.replaceAll([const LoginRoute()]);
            },
            child: const Text('Đồng ý', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
