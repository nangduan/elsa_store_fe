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
          'Quan ly cua hang',
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
            tooltip: 'Dang xuat',
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
                    'Tong quan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildStatsGrid(),
                  const SizedBox(height: 32),
                  const Text(
                    'Phan tich doanh thu',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildRevenueChart(context, state, range),
                  const SizedBox(height: 24),
                  const Text(
                    'Doanh thu theo thang',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildMonthlyRevenueChart(context),
                  const SizedBox(height: 32),
                  const Text(
                    'Quan ly',
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
        title: const Text('Dang xuat'),
        content: const Text('Ban co chac chan muon dang xuat?'),
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
              'Dong y',
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
          'Doanh so hang thang',
          '1,284',
          Icons.calendar_month,
          Colors.blue,
        ),
        _statCard('Doanh so hang tuan', '312', Icons.view_week, Colors.orange),
        _statCard('Dang xu ly', '45', Icons.autorenew, Colors.purple),
        _statCard('Da hoan thanh', '2,100', Icons.check_circle, Colors.green),
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
                state.errorMessage ?? 'Khong tai duoc doanh thu',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => _reloadRevenue(context, range),
                child: const Text('Thu lai'),
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
                  'Doanh thu 30 ngay gan nhat',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                tooltip: 'Lam moi',
                onPressed: () => _reloadRevenue(context, range),
                icon: const Icon(Icons.refresh, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              _statChip('Tong', total),
              const SizedBox(width: 8),
              _statChip('TB/Don', avg),
              const SizedBox(width: 8),
              _statChip('Don', orders.toString()),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: points.isEmpty
                ? const Center(child: Text('Chua co du lieu doanh thu'))
                : _RevenueBarChart(points: points),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueContainer({required Widget child}) {
    return Container(
      height: 200,
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
          if (state.status == RevenueStatus.loading &&
              state.timeseries == null) {
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
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 36,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.errorMessage ?? 'Khong tai duoc doanh thu',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => _reloadMonthlyRevenue(context, range),
                      child: const Text('Thu lai'),
                    ),
                  ],
                ),
              ),
            );
          }

          final points = state.timeseries?.points ?? const [];
          return _buildRevenueContainer(
            child: points.isEmpty
                ? const Center(child: Text('Chua co du lieu doanh thu'))
                : _RevenueBarChart(points: points),
          );
        },
      ),
    );
  }

  void _reloadMonthlyRevenue(BuildContext context, DateTimeRange range) {
    context.read<RevenueCubit>().loadTimeseries(
      from: _formatDate(range.start),
      to: _formatDate(range.end),
      groupBy: RevenueGroupBy.month,
      statuses: const [0, 1],
    );
  }

  DateTimeRange _yearRange() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    final end = DateTime(now.year, 12, 31);
    return DateTimeRange(start: start, end: end);
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
        _navItem(context, 'Nha cung cap', Icons.local_shipping_outlined, () {
          context.router.push(const SupplierManagementRoute());
        }),
        _navItem(context, 'Danh muc', Icons.category_outlined, () {
          context.router.push(const CategoryManagementRoute());
        }),
        _navItem(context, 'San pham', Icons.inventory_2_outlined, () {
          context.router.push(const ProductManagementRoute());
        }),
        _navItem(context, 'Khuyen mai', Icons.confirmation_number_outlined, () {
          context.router.push(const PromotionManagementRoute());
        }),
        _navItem(context, 'Don hang', Icons.receipt_long_outlined, () {
          context.router.push(const OrdersRoute());
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

class _RevenueBarChart extends StatelessWidget {
  final List<dynamic> points;

  const _RevenueBarChart({required this.points});

  @override
  Widget build(BuildContext context) {
    final values = points
        .map((item) => (item.netRevenue as num?)?.toDouble() ?? 0)
        .toList();
    final labels = points
        .map((item) => (item.period as String?) ?? '')
        .toList();

    final maxValue = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a > b ? a : b);
    final midValue = maxValue / 2;

    const double barWidth = 18.0;
    const double barGap = 12.0;
    const double labelHeight = 20.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalHeight = constraints.maxHeight;
        final chartHeight = (totalHeight - labelHeight).clamp(0.0, totalHeight);
        final contentWidth = values.isEmpty
            ? constraints.maxWidth
            : (values.length * (barWidth + barGap)).toDouble();
        final scrollWidth = contentWidth < constraints.maxWidth
            ? constraints.maxWidth
            : contentWidth;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 36,
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
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: chartHeight,
                    child: Stack(
                      children: [
                        _GridLine(top: 0),
                        _GridLine(top: chartHeight / 2),
                        _GridLine(top: chartHeight),
                        Positioned.fill(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: scrollWidth,
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: List.generate(values.length, (
                                    index,
                                  ) {
                                    final value = values[index];
                                    final height = maxValue == 0
                                        ? 0
                                        : (value / maxValue) * chartHeight;
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: index == values.length - 1
                                            ? 0
                                            : barGap,
                                      ),
                                      child: Container(
                                        width: barWidth,
                                        height: height
                                            .clamp(2, chartHeight)
                                            .toDouble(),
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: labelHeight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: scrollWidth,
                        child: Row(
                          children: List.generate(labels.length, (index) {
                            final label = labels[index];
                            return SizedBox(
                              width: barWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(right: barGap),
                                child: Text(
                                  _shortDate(label),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }),
                        ),
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
    final normalized = raw.split('T').first;
    if (normalized.length >= 10) {
      final day = normalized.substring(8, 10);
      final month = normalized.substring(5, 7);
      return '$day/$month';
    }
    if (normalized.length >= 7) {
      return normalized.substring(5, 7);
    }
    return normalized;
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
