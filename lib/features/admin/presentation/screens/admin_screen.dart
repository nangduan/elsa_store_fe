import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skeleton/core/di/injector.dart';
import 'package:flutter_skeleton/core/navigation/app_routes.dart';
import 'package:flutter_skeleton/features/auth/domain/repositories/auth_repository.dart';

@RoutePage()
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  // Định nghĩa màu sắc chủ đạo
  final Color _primaryBlue = const Color(0xFFE64A19);
  final Color _primaryOrange = const Color(0xFF1565C0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50, // Nền xám rất nhạt để làm nổi bật các card trắng
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'ELSA STORE',
          style: TextStyle(
            color: _primaryBlue,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.grey.shade600),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Đăng xuất',
            icon: Icon(Icons.logout_rounded, color: _primaryOrange),
            onPressed: () => _showLogoutDialog(context),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header chào mừng
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: _primaryBlue.withOpacity(0.1),
                  child: Icon(Icons.person, color: _primaryBlue),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "XIN CHÀO",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800
                      ),
                    ),
                    Text(
                      "Chào mừng bạn trở lại!",
                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(height: 24),

            // Section 1: Thống kê
            _buildSectionTitle("Tổng quan kinh doanh"),
            const SizedBox(height: 16),
            _buildStatsGrid(),

            const SizedBox(height: 32),

            // Section 2: Biểu đồ
            _buildSectionTitle("Phân tích doanh thu"),
            const SizedBox(height: 16),
            _buildRevenueChart(),

            const SizedBox(height: 32),

            // Section 3: Menu Quản lý
            _buildSectionTitle("Danh mục quản lý"),
            const SizedBox(height: 16),
            _buildNavigationGrid(context),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _primaryBlue, // Dùng màu xanh làm tiêu đề section
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: _primaryOrange),
            const SizedBox(width: 10),
            const Text("Đăng xuất"),
          ],
        ),
        content: const Text(
          "Bạn có chắc chắn muốn đăng xuất khỏi Admin Panel?",
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
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
            child: const Text("Đăng xuất"),
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
      // GIẢM tỉ lệ này xuống (ví dụ 1.3 hoặc 1.4) để thẻ cao hơn
      // 1.6 cũ -> quá dẹt gây lỗi overflow
      childAspectRatio: 1.35,
      children: [
        _statCard(
          'Doanh số tháng',
          '1,284',
          Icons.calendar_month_rounded,
          _primaryBlue,
          isHighLight: true,
        ),
        _statCard('Doanh số tuần', '312', Icons.trending_up_rounded, _primaryBlue),
        _statCard('Đang xử lý', '45', Icons.pending_actions_rounded, _primaryOrange),
        _statCard('Hoàn thành', '2,100', Icons.check_circle_outline_rounded, const Color(0xFF43A047)),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, {bool isHighLight = false}) {
    return Container(
      // Giảm padding từ 16 xuống 12 để tiết kiệm không gian
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isHighLight ? color : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: isHighLight ? null : Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Thay MainAxisAlignment.spaceBetween bằng Spacer để linh hoạt hơn
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHighLight ? Colors.white.withOpacity(0.2) : color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
                icon,
                color: isHighLight ? Colors.white : color,
                size: 20
            ),
          ),

          const Spacer(), // Tự động đẩy nội dung xuống dưới thay vì cố định khoảng cách

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Chỉ chiếm diện tích cần thiết
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isHighLight ? Colors.white : Colors.black87,
                  height: 1.0, // Giảm chiều cao dòng thừa để tránh bị đẩy xuống
                ),
              ),
              const SizedBox(height: 4), // Khoảng cách nhỏ cố định
              Text(
                title,
                maxLines: 1, // Giới hạn 1 dòng để không bị tràn
                overflow: TextOverflow.ellipsis, // Nếu dài quá thì hiện dấu ...
                style: TextStyle(
                    color: isHighLight ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Container(
      height: 220,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _primaryBlue,
            const Color(0xFF42A5F5), // Light Blue
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _primaryBlue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Biểu đồ tăng trưởng",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Icon(Icons.bar_chart_rounded, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "+12.5% so với tuần trước",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const Spacer(),
          // Placeholder visuals for chart
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              // Tạo các cột giả lập độ cao ngẫu nhiên
              final heights = [40.0, 60.0, 35.0, 80.0, 50.0, 90.0, 70.0];
              return Container(
                width: 30, // Độ rộng cột
                height: heights[index],
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(index == 5 ? 1.0 : 0.3), // Cột cao nhất đậm nhất
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: ["T2", "T3", "T4", "T5", "T6", "T7", "CN"]
                .map((e) => SizedBox(width: 30, child: Center(child: Text(e, style: const TextStyle(color: Colors.white70, fontSize: 10))))).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _navItem(
            context,
            'Nhà cung cấp',
            Icons.local_shipping_outlined,
            _primaryBlue, // Blue
                () => context.router.push(const SupplierManagementRoute())
        ),
        _navItem(
            context,
            'Danh mục',
            Icons.category_outlined,
            _primaryBlue, // Blue
                () => context.router.push(const CategoryManagementRoute())
        ),
        _navItem(
            context,
            'Sản phẩm',
            Icons.inventory_2_outlined,
            _primaryBlue, // Blue
                () => context.router.push(const ProductManagementRoute())
        ),
        _navItem(
            context,
            'Khuyến mãi',
            Icons.local_offer_outlined,
            _primaryOrange, // Orange (Để nổi bật tính năng Marketing)
                () => context.router.push(const PromotionManagementRoute())
        ),
      ],
    );
  }

  Widget _navItem(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.grey.shade800
              ),
            ),
          ],
        ),
      ),
    );
  }
}