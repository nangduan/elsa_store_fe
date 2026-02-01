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
                    'Tổng quan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  const Text(
                    'Phân tích doanh thu 30 ngày gần nhất',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildRevenueChart(context, state, range),
                  const SizedBox(height: 24),
                  const Text(
                    'Doanh thu từng tháng',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildMonthlyRevenueChart(context),
                  const SizedBox(height: 32),
                  const Text(
                    'Quản lý',
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
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuát?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huy', style: TextStyle(color: Colors.grey)),
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
              'Đồng ý',
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
        _statCard('Doanh số hôm nay', '312', Icons.calendar_month, Colors.blue),
        _statCard(
          'Doanh số tháng này',
          '1,284',
          Icons.view_week,
          Colors.orange,
        ),
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
    if (state.status == RevenueStatus.loading && state.timeseries == null) {
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
                state.errorMessage ?? 'Lỗi tải dữ liệu',
                style: const TextStyle(color: Colors.grey),
              ),
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

    return _buildRevenueContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hiệu suất bán hàng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => _reloadRevenue(context, range),
                icon: const Icon(Icons.refresh, size: 18),
              ),
            ],
          ),
          Row(
            children: [
              _statChip('Tổng', Format.formatCurrency(summary?.netRevenue)),
              const SizedBox(width: 8),
              _statChip('Đơn', (summary?.ordersCount ?? 0).toString()),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: points.isEmpty
                ? const Center(child: Text('Không có dữ liệu'))
                : _RevenueBarChart(points: points),
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
                const Text(
                  'Biểu đồ theo tháng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: state.status == RevenueStatus.loading
                      ? const Center(child: CircularProgressIndicator())
                      : (state.timeseries?.points.isEmpty ?? true)
                      ? const Center(child: Text('Không có dữ liệu'))
                      : _RevenueBarChart(points: state.timeseries!.points),
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
      height: 280,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
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
        _navItem(
          context,
          'Nhà cung cấp',
          Icons.local_shipping_outlined,
          () => context.router.push(const SupplierManagementRoute()),
        ),
        _navItem(
          context,
          'Danh mục',
          Icons.category_outlined,
          () => context.router.push(const CategoryManagementRoute()),
        ),
        _navItem(
          context,
          'Sản phẩm',
          Icons.inventory_2_outlined,
          () => context.router.push(const ProductManagementRoute()),
        ),
        _navItem(
          context,
          'Khuyến mãi',
          Icons.confirmation_number_outlined,
          () => context.router.push(const PromotionManagementRoute()),
        ),
        _navItem(
          context,
          'Đơn hàng',
          Icons.receipt_long_outlined,
          () => context.router.push(const OrdersRoute()),
        ),
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

class _RevenueBarChart extends StatelessWidget {
  final List<dynamic> points;

  const _RevenueBarChart({required this.points});

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
    const double barWidth = 20.0;
    const double barGap = 12.0;
    const double labelHeight = 30.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartHeight = constraints.maxHeight - labelHeight;
        final scrollWidth = (values.length * (barWidth + barGap))
            .toDouble()
            .clamp(constraints.maxWidth, double.infinity);

        return Row(
          children: [
            // Y-Axis
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
            // Chart Content
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: scrollWidth,
                  child: Column(
                    children: [
                      // Bars
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
                                      color: Colors.black,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // X-Axis Labels
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
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Colors.grey,
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
    if (parts.length >= 3) return '${parts[2]}/${parts[1]}'; // dd/MM
    if (parts.length == 2) return parts[1]; // MM
    return raw;
  }
}

class _AxisLabel extends StatelessWidget {
  final String text;
  const _AxisLabel(this.text);
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey));
}
