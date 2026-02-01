import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton/core/di/injector.dart';
import 'package:flutter_skeleton/core/navigation/app_routes.dart';
import 'package:flutter_skeleton/features/auth/domain/repositories/auth_repository.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/format.dart';
import '../../../revenues/domain/entities/revenue_group_by.dart';
import '../../../revenues/presentation/cubit/revenue_cubit.dart';

@RoutePage()
class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final range = _defaultRange();
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
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              // TODO: Navigate to Settings
            },
          ),
          IconButton(
            tooltip: 'Đăng xuất',
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _showLogoutDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
        create: (_) => getIt<RevenueCubit>()
          ..loadAll(
            from: _formatDate(range.start),
            to: _formatDate(range.end),
            groupBy: RevenueGroupBy.day,
            statuses: const [0, 1],
          ),
        child: BlocBuilder<RevenueCubit, RevenueState>(
          builder: (context, state) {
            return SingleChildScrollView(
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
                  _buildRevenueChart(context, state, range),

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
            );
          },
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
            onPressed: () => Navigator.pop(context),
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

  Widget _buildRevenueChart(
    BuildContext context,
    RevenueState state,
    DateTimeRange range,
  ) {
    if (state.status == RevenueStatus.loading &&
        state.timeseries == null &&
        state.summary == null) {
      return _buildRevenueContainer(
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (state.status == RevenueStatus.failure) {
      return _buildRevenueContainer(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 36),
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'Không tải được doanh thu',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _reloadRevenue(context, range),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    final summary = state.summary;
    final points = state.timeseries?.points ?? const [];
    final total = Format.formatCurrency(summary?.netRevenue);
    final avg = Format.formatCurrency(summary?.averageOrderValue);
    final orders = summary?.ordersCount ?? 0;

    return _buildRevenueContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Doanh thu 30 ngày gần nhất",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                tooltip: 'Làm mới',
                onPressed: () => _reloadRevenue(context, range),
                icon: const Icon(Icons.refresh, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _statChip('Tổng', total),
              const SizedBox(width: 8),
              _statChip('TB/Đơn', avg),
              const SizedBox(width: 8),
              _statChip('Đơn', orders.toString()),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: points.isEmpty
                ? const Center(child: Text('Chưa có dữ liệu doanh thu'))
                : _RevenueBarChart(points: points),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueContainer({required Widget child}) {
    return Container(
      height: 300, // Tăng chiều cao lên chút để thoáng hơn
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: child,
    );
  }

  Widget _statChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
          ),
        ],
      ),
    );
  }

  void _reloadRevenue(BuildContext context, DateTimeRange range) {
    context.read<RevenueCubit>().loadAll(
      from: _formatDate(range.start),
      to: _formatDate(range.end),
      groupBy: RevenueGroupBy.day,
      statuses: const [0, 1],
    );
  }

  DateTimeRange _defaultRange() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    final start = end.subtract(const Duration(days: 29));
    return DateTimeRange(start: start, end: end);
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

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

// --- CLASS ĐỒ THỊ MỚI ĐƯỢC CẢI TIẾN ---
class _RevenueBarChart extends StatelessWidget {
  final List<dynamic> points;

  const _RevenueBarChart({required this.points});

  @override
  Widget build(BuildContext context) {
    // 1. Tính toán giá trị Max/Mid như logic cũ
    final values = points
        .map((item) => (item.netRevenue as num?)?.toDouble() ?? 0.0)
        .toList();
    final labels = points
        .map((item) => (item.period as String?) ?? '')
        .toList();

    final maxValue = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a > b ? a : b);
    final midValue = maxValue / 2;

    // Cấu hình UI
    const double barWidth = 18.0; // Chiều rộng cố định của cột
    const double barGap = 16.0; // Khoảng cách giữa các cột
    const double labelHeight = 20.0; // Chiều cao khu vực hiển thị ngày

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final chartHeight = (totalHeight - labelHeight).clamp(0.0, totalHeight);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CỘT TRỤC Y (Bên trái, cố định)
            SizedBox(
              width: 35,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _AxisLabel(_formatAxisValue(maxValue)),
                  _AxisLabel(_formatAxisValue(midValue)),
                  const _AxisLabel('0'),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // KHU VỰC BIỂU ĐỒ (Bên phải, có thể cuộn ngang)
            Expanded(
              child: Stack(
                children: [
                  // Lớp nền: Đường kẻ ngang (Grid lines)
                  Column(
                    children: [
                      _GridLine(top: 0), // Line Max
                      _GridLine(
                        top: chartHeight / 2 - 0.5,
                      ), // Line Mid (trừ nửa độ dày line)
                      _GridLine(top: chartHeight - 1), // Line 0
                    ],
                  ),

                  // Lớp dữ liệu: Các cột có thể cuộn
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    reverse:
                        true, // Để mặc định hiển thị ngày gần nhất (bên phải)
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                      ), // Padding cuối list
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: List.generate(values.length, (index) {
                          final value = values[index];
                          final label = labels[index];

                          // Tính chiều cao cột
                          final height = maxValue == 0
                              ? 0.0
                              : (value / maxValue) * chartHeight;

                          return Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 0 : barGap,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // CỘT
                                Container(
                                  width: barWidth,
                                  height: height.clamp(0.0, chartHeight),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                    // Hiệu ứng đổ bóng nhẹ cho đẹp
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(2, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                // LABEL NGÀY
                                SizedBox(
                                  height: labelHeight,
                                  width:
                                      barWidth +
                                      10, // Rộng hơn cột chút để chữ ko bị cắt
                                  child: Center(
                                    child: Text(
                                      _shortDate(label),
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatAxisValue(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return value.toStringAsFixed(0);
  }

  String _shortDate(String raw) {
    if (raw.length >= 10) {
      // Expecting yyyy-MM-dd -> lấy dd/MM
      final day = raw.substring(8, 10);
      final month = raw.substring(5, 7);
      return '$day/$month';
    }
    return raw;
  }
}

class _GridLine extends StatelessWidget {
  final double top;
  const _GridLine({required this.top});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: 0,
      right: 0,
      child: Container(height: 1, color: Colors.grey.shade200),
    );
  }
}

class _AxisLabel extends StatelessWidget {
  final String text;
  const _AxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        color: Colors.grey,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
