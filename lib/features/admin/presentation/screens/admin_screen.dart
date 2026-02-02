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

  final Color _primaryBlue = const Color(0xFF1565C0);
  final Color _primaryOrange = const Color(0xFFE64A19);

  @override
  Widget build(BuildContext context) {
    final range = _defaultRange();
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'QUẢN LÝ CỬA HÀNG',
          style: TextStyle(
            color: _primaryBlue,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none_rounded, color: Colors.grey.shade600),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Đăng xuất',
            icon: Icon(Icons.logout_rounded, color: _primaryOrange),
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
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Tổng Quan'),
                  const SizedBox(height: 16),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Phân tích doanh thu (30 ngày)'),
                  const SizedBox(height: 16),
                  _buildRevenueChart(context, state, range),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Doanh thu từng tháng'),
                  const SizedBox(height: 16),
                  _buildMonthlyRevenueChart(context),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Quản lý cửa hàng'),
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

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade800,
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
            const Text('Đăng xuất'),
          ],
        ),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
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
            child: const Text('Đăng xuất'),
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
      childAspectRatio: 1.35,
      children: [
        _statCard('Hôm nay', '4', Icons.today_rounded, _primaryBlue, isHighlight: true),
        _statCard('Tháng này', '50', Icons.calendar_month_rounded, _primaryBlue),
        _statCard('Đang xử lý', '4', Icons.pending_actions_rounded, _primaryOrange),
        _statCard('Hoàn thành', '15', Icons.check_circle_outline_rounded, Colors.green),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color, {bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isHighlight ? color : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isHighlight ? null : Border.all(color: color.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isHighlight ? Colors.white.withOpacity(0.2) : color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isHighlight ? Colors.white : color, size: 20),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isHighlight ? Colors.white : Colors.black87,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: isHighlight ? Colors.white.withOpacity(0.8) : Colors.grey.shade600,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
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
    if (state.status == RevenueStatus.loading && state.timeseries == null) {
      return _buildRevenueContainer(
        child: Center(child: CircularProgressIndicator(color: _primaryBlue)),
      );
    }

    if (state.status == RevenueStatus.failure) {
      return _buildRevenueContainer(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 36),
              const SizedBox(height: 8),
              Text(
                state.errorMessage ?? 'Lỗi tải dữ liệu',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              TextButton(
                onPressed: () => _reloadRevenue(context, range),
                child: Text('Thử lại', style: TextStyle(color: _primaryBlue)),
              ),
            ],
          ),
        ),
      );
    }

    final summary = state.summary;
    final points = state.timeseries?.points ?? const [];

    return _buildRevenueContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.bar_chart_rounded, color: _primaryBlue, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Hiệu suất',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _reloadRevenue(context, range),
                icon: Icon(Icons.refresh_rounded, size: 20, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statChip('Doanh thu', Format.formatCurrency(summary?.netRevenue), _primaryBlue),
              const SizedBox(width: 8),
              _statChip('Đơn hàng', (summary?.ordersCount ?? 0).toString(), _primaryOrange),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: points.isEmpty
                ? Center(child: Text('Chưa có dữ liệu', style: TextStyle(color: Colors.grey.shade400)))
                : _RevenueBarChart(points: points, barColor: _primaryBlue),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyRevenueChart(BuildContext context) {
    final range = _yearRange();
    return BlocProvider(
      create: (_) => getIt<RevenueCubit>()
        ..loadTimeseries(
          from: _formatDate(range.start),
          to: _formatDate(range.end),
          groupBy: RevenueGroupBy.month,
          statuses: const [0, 1],
        ),
      child: BlocBuilder<RevenueCubit, RevenueState>(
        builder: (context, state) {
          return _buildRevenueContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, color: _primaryOrange, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Biểu đồ năm nay',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: state.status == RevenueStatus.loading
                      ? Center(child: CircularProgressIndicator(color: _primaryOrange))
                      : (state.timeseries?.points.isEmpty ?? true)
                      ? Center(child: Text('Chưa có dữ liệu', style: TextStyle(color: Colors.grey.shade400)))
                      : _RevenueBarChart(points: state.timeseries!.points, barColor: _primaryOrange),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRevenueContainer({required Widget child}) {
    return Container(
      height: 320,
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
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

  DateTimeRange _yearRange() {
    final now = DateTime.now();
    return DateTimeRange(
      start: DateTime(now.year, 1, 1),
      end: DateTime(now.year, 12, 31),
    );
  }

  DateTimeRange _defaultRange() {
    final now = DateTime.now();
    final end = DateTime(now.year, now.month, now.day);
    return DateTimeRange(
      start: end.subtract(const Duration(days: 29)),
      end: end,
    );
  }

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  Widget _buildNavigationGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      children: [
        _navItem(context, 'Nhà cung cấp', Icons.local_shipping_outlined, _primaryBlue, () => context.router.push(const SupplierManagementRoute())),
        _navItem(context, 'Danh mục', Icons.category_outlined, _primaryBlue, () => context.router.push(const CategoryManagementRoute())),
        _navItem(context, 'Sản phẩm', Icons.inventory_2_outlined, _primaryBlue, () => context.router.push(const ProductManagementRoute())),
        _navItem(context, 'Khuyến mãi', Icons.local_offer_outlined, _primaryOrange, () => context.router.push(const PromotionManagementRoute())),
        _navItem(context, 'Đơn hàng', Icons.receipt_long_rounded, _primaryBlue, () => context.router.push(const OrdersRoute())),
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
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }
}

class _RevenueBarChart extends StatelessWidget {
  final List<dynamic> points;
  final Color barColor;

  const _RevenueBarChart({required this.points, required this.barColor});

  @override
  Widget build(BuildContext context) {
    final values = points
        .map((item) => (item.netRevenue as num?)?.toDouble() ?? 0.0)
        .toList();
    final labels = points
        .map((item) => (item.period as String?) ?? '')
        .toList();

    final maxValue = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a > b ? a : b);
    const double barWidth = 24.0;
    const double barGap = 16.0;
    const double labelHeight = 30.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartHeight = constraints.maxHeight - labelHeight;
        final scrollWidth = (values.length * (barWidth + barGap))
            .toDouble()
            .clamp(constraints.maxWidth, double.infinity);

        return Row(
          children: [
            SizedBox(
              width: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _AxisLabel(_formatAxisValue(maxValue)),
                  _AxisLabel(_formatAxisValue(maxValue / 2)),
                  const _AxisLabel('0'),
                  const SizedBox(height: labelHeight),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  width: scrollWidth,
                  child: Column(
                    children: [
                      SizedBox(
                        height: chartHeight,
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                3,
                                    (_) => Container(
                                  height: 1,
                                  color: Colors.grey.shade100,
                                ),
                              ),
                            ),
                            Positioned.fill(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: List.generate(values.length, (index) {
                                  final barHeight = maxValue == 0
                                      ? 0.0
                                      : (values[index] / maxValue) *
                                      chartHeight;
                                  return Container(
                                    width: barWidth,
                                    height: barHeight.clamp(4.0, chartHeight),
                                    margin: const EdgeInsets.only(
                                      right: barGap,
                                    ),
                                    decoration: BoxDecoration(
                                      color: barColor,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: labelHeight,
                        child: Row(
                          children: List.generate(labels.length, (index) {
                            return Container(
                              width: barWidth,
                              margin: const EdgeInsets.only(right: barGap),
                              child: Center(
                                child: Text(
                                  _shortDate(labels[index]),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatAxisValue(double value) {
    if (value >= 1000000) return '${(value / 1000000).toStringAsFixed(1)}M';
    if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
    return value.toStringAsFixed(0);
  }

  String _shortDate(String raw) {
    if (raw.contains('T')) raw = raw.split('T').first;
    final parts = raw.split('-');
    if (parts.length >= 3) return '${parts[2]}/${parts[1]}';
    if (parts.length == 2) return parts[1];
    return raw;
  }
}

class _AxisLabel extends StatelessWidget {
  final String text;
  const _AxisLabel(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: TextStyle(fontSize: 10, color: Colors.grey.shade400));
}