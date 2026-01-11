import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skeleton/core/di/injector.dart';
import 'package:flutter_skeleton/core/navigation/app_routes.dart';
import 'package:flutter_skeleton/features/auth/domain/repositories/auth_repository.dart';

@RoutePage()
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Quản lý cửa hàng',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          // Nút Settings (Giữ nguyên)
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Navigate to Settings
            },
          ),
          // --- [NEW] NÚT LOGOUT ---
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _showLogoutDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tổng quan",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatsGrid(),

            const SizedBox(height: 32),

            const Text(
              "Phân tích doanh thu",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRevenueChart(),

            const SizedBox(height: 32),

            const Text(
              "Quản lý",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildNavigationGrid(context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đăng xuất"),
        content: const Text(
          "Bạn có chắc chắn muốn đăng xuất khỏi Admin Panel?",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Đóng dialog
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              getIt<AuthRepository>()
                  .logout(
                    onSuccess: () =>
                        context.router.replaceAll([const LoginRoute()]),
                  )
                  .onError((error, stackTrace) {
                    Navigator.pop(context);
                  });
            },
            child: const Text(
              "Đồng ý",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      childAspectRatio: 1.5,
      children: [
        _statCard(
          'Doanh số hàng tháng',
          '1,284',
          Icons.calendar_month,
          Colors.blue,
        ),
        _statCard('Doanh số hàng tuần', '312', Icons.view_week, Colors.orange),
        _statCard('Đang xử lý', '45', Icons.autorenew, Colors.purple),
        _statCard('Đã hoàn thành', '2,100', Icons.check_circle, Colors.green),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget hiển thị biểu đồ (Placeholder)
  Widget _buildRevenueChart() {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Doanh thu hàng tuần",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                "+12.5%",
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          // dùng package fl_chart
          const Center(child: Text("Hiện chưa có doanh thu nào")),
          const Spacer(),
        ],
      ),
    );
  }

  // Widget điều hướng đến các màn hình quản lý
  Widget _buildNavigationGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _navItem(context, 'Nhà cung cấp', Icons.local_shipping_outlined, () {
          context.router.push(const SupplierManagementRoute());
        }),
        _navItem(context, 'Danh mục', Icons.category_outlined, () {
          context.router.push(const CategoryManagementRoute());
        }),
        _navItem(context, 'Sản phẩm', Icons.inventory_2_outlined, () {
          context.router.push(const ProductManagementRoute());
        }),
        _navItem(context, 'Khuyến mãi', Icons.confirmation_number_outlined, () {
          context.router.push(const PromotionManagementRoute());
        }),
      ],
    );
  }

  Widget _navItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.black,
              radius: 24,
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
