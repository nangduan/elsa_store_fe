import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton/core/di/injector.dart';
import 'package:flutter_skeleton/core/navigation/app_routes.dart';
import 'package:flutter_skeleton/features/auth/domain/repositories/auth_repository.dart';
import 'package:intl/intl.dart';

import '../../../../core/api/dio_client.dart';
import '../../../../core/constants/format.dart';
import '../../../revenues/domain/entities/revenue_group_by.dart';
import '../../../revenues/presentation/cubit/revenue_cubit.dart';

@RoutePage()
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late final Future<DashboardOverview?> _dashboardFuture;

  final Color _primaryBlue = const Color(0xFF1964D4);
  final Color _primaryOrange = const Color(0xFFE85022);
  final Color _bgColor = const Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    _dashboardFuture = _loadDashboardOverview();
  }

  @override
  Widget build(BuildContext context) {
    final range = _defaultRange();
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'QUẢN LÝ CỬA HÀNG',
          style: TextStyle(
            color: _primaryBlue,
            fontWeight: FontWeight.w900,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black54),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFE85022)),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tổng Quan',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<DashboardOverview?>(
                    future: _dashboardFuture,
                    builder: (context, snapshot) {
                      return _buildStatsGrid(snapshot.data);
                    },
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Phân tích doanh thu (30 ngày)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  _buildRevenueChart(context, state, range),
                  const SizedBox(height: 32),
                  _buildMonthlyRevenueChart(context),
                  const SizedBox(height: 32),
                  const Text(
                    'Quản lý cửa hàng',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
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
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
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

  Widget _buildStatsGrid(DashboardOverview? overview) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _statCard(
          'Hôm nay',
          Format.formatCurrency(overview?.todayRevenue),
          Icons.calendar_today,
          Colors.white,
          _primaryBlue,
          isSolidBlue: true,
        ),
        _statCard(
          'Tháng này',
          Format.formatCurrency(overview?.monthRevenue),
          Icons.calendar_month,
          _primaryBlue,
          Colors.white,
        ),
        _statCard(
          'Đang xử lý',
          '${overview?.processingOrders ?? 0}',
          Icons.pending_actions,
          _primaryOrange,
          Colors.white,
        ),
        _statCard(
          'Hoàn thành',
          '${overview?.completedOrders ?? 0}',
          Icons.check_circle_outline,
          Colors.green,
          Colors.white,
        ),
      ],
    );
  }

  Widget _statCard(
      String title,
      String value,
      IconData icon,
      Color iconColor,
      Color bgColor, {
        bool isSolidBlue = false,
      }) {
    final textColor = isSolidBlue ? Colors.white : Colors.black87;
    final subtitleColor = isSolidBlue ? Colors.white70 : Colors.black54;
    final iconBgColor = isSolidBlue ? Colors.white.withOpacity(0.2) : iconColor.withOpacity(0.1);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (!isSolidBlue)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isSolidBlue ? Colors.white : iconColor, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(color: subtitleColor, fontSize: 13),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF1F8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.bar_chart, color: _primaryBlue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Hiệu suất',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              IconButton(
                onPressed: () => _reloadRevenue(context, range),
                icon: const Icon(Icons.refresh, size: 20, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statChip(
                'Doanh thu',
                Format.formatCurrency(summary?.netRevenue),
                isBlue: true,
              ),
              const SizedBox(width: 12),
              _statChip(
                'Đơn hàng',
                (summary?.ordersCount ?? 0).toString(),
                isBlue: false,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: points.isEmpty
                ? const Center(child: Text('Không có dữ liệu'))
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Doanh thu từng tháng',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              _buildRevenueContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: _primaryOrange, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Biểu đồ năm nay',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: state.status == RevenueStatus.loading
                          ? const Center(child: CircularProgressIndicator())
                          : (state.timeseries?.points.isEmpty ?? true)
                          ? const Center(child: Text('Không có dữ liệu'))
                          : _RevenueBarChart(points: state.timeseries!.points, barColor: _primaryOrange),
                    ),
                  ],
                ),
              ),
            ],
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
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _statChip(String label, String value, {required bool isBlue}) {
    final bgColor = isBlue ? const Color(0xFFEAF1F8) : const Color(0xFFFCEAE8);
    final textColor = isBlue ? _primaryBlue : _primaryOrange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
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

  Future<DashboardOverview?> _loadDashboardOverview() async {
    try {
      final response = await getIt<DioClient>().get('/revenues/dashboard');
      final body = response.data;
      if (body is Map<String, dynamic>) {
        final data = body['data'];
        if (data is Map<String, dynamic>) {
          return DashboardOverview.fromJson(data);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Widget _buildNavigationGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _navItem(
          context,
          'Nhà cung cấp',
          Icons.local_shipping_outlined,
          _primaryBlue,
          const Color(0xFFEAF1F8),
              () => context.router.push(const SupplierManagementRoute()),
        ),
        _navItem(
          context,
          'Danh mục',
          Icons.category_outlined,
          _primaryBlue,
          const Color(0xFFEAF1F8),
              () => context.router.push(const CategoryManagementRoute()),
        ),
        _navItem(
          context,
          'Sản phẩm',
          Icons.inventory_2_outlined,
          _primaryBlue,
          const Color(0xFFEAF1F8),
              () => context.router.push(const ProductManagementRoute()),
        ),
        _navItem(
          context,
          'Khuyến mãi',
          Icons.local_offer_outlined,
          _primaryOrange,
          const Color(0xFFFCEAE8),
              () => context.router.push(const PromotionManagementRoute()),
        ),
      ],
    );
  }

  Widget _navItem(
      BuildContext context,
      String title,
      IconData icon,
      Color iconColor,
      Color iconBgColor,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
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
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                      : (values[index] / maxValue) * chartHeight;
                                  return Container(
                                    width: barWidth,
                                    height: barHeight.clamp(4.0, chartHeight),
                                    margin: const EdgeInsets.only(right: barGap),
                                    decoration: BoxDecoration(
                                      color: barColor,
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
                                    fontSize: 10,
                                    color: Colors.black45,
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
      Text(text, style: const TextStyle(fontSize: 10, color: Colors.black26));
}

class DashboardOverview {
  final double? todayRevenue;
  final double? monthRevenue;
  final int? processingOrders;
  final int? completedOrders;

  const DashboardOverview({
    this.todayRevenue,
    this.monthRevenue,
    this.processingOrders,
    this.completedOrders,
  });

  factory DashboardOverview.fromJson(Map<String, dynamic> json) {
    return DashboardOverview(
      todayRevenue: (json['todayRevenue'] as num?)?.toDouble(),
      monthRevenue: (json['monthRevenue'] as num?)?.toDouble(),
      processingOrders: json['processingOrders'] as int?,
      completedOrders: json['completedOrders'] as int?,
    );
  }
}