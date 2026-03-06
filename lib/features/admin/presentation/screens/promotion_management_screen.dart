import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../data/models/request/promotion_request.dart';
import '../../data/models/response/promotion_response.dart';
import '../cubit/promotion_cubit.dart';

@RoutePage()
class PromotionManagementScreen extends StatelessWidget {
  const PromotionManagementScreen({super.key});

  final Color _primaryBlue = const Color(0xFF1964D4);
  final Color _primaryOrange = const Color(0xFFE85022);
  final Color _bgColor = const Color(0xFFFAFAFA);
  final Color _inputFillColor = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PromotionCubit(getIt(), getIt(), getIt(), getIt())..load(),
      child: Scaffold(
        backgroundColor: _bgColor,
        body: BlocConsumer<PromotionCubit, PromotionState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Thao tác thất bại'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                _buildAppBar(context),
                _buildSearchBar(),
                if (state.status.isLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: _primaryOrange),
                    ),
                  )
                else if (state.promotions.isEmpty)
                  SliverFillRemaining(child: _buildEmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildPromotionCard(
                          context,
                          state.promotions[index],
                        ),
                        childCount: state.promotions.length,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: _bgColor,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: _primaryOrange,
          size: 20,
        ),
        onPressed: () => context.router.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 16),
        title: Text(
          'KHUYẾN MÃI',
          style: TextStyle(
            color: _primaryOrange,
            fontWeight: FontWeight.w900,
            fontSize: 18,
            letterSpacing: 0.5,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () => _showPromotionDialog(context),
            icon: Icon(Icons.add_circle, color: _primaryOrange, size: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm khuyến mãi...',
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.black45),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: _primaryOrange.withOpacity(0.5)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionCard(BuildContext context, PromotionResponse item) {
    final isActive = item.status == 1;
    final isPercent = item.type == 2;
    // Format hiển thị giá trị: 50% hoặc 50,000đ
    final valueDisplay = isPercent
        ? '${item.value?.toStringAsFixed(0)}%'
        : '${item.value?.toStringAsFixed(0)} đ';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon bên trái
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xFFFCEAE8) : Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.local_offer_rounded,
                    color: isActive ? _primaryOrange : Colors.grey.shade400,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Nội dung chính
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.name ?? 'Không tên',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _statusBadge(isActive),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.description ?? 'Không có mô tả',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      // Hiển thị giá trị to
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            valueDisplay,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: isActive ? _primaryOrange : Colors.black54,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            margin: const EdgeInsets.only(bottom: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? _primaryOrange.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isPercent ? 'GIẢM %' : 'GIẢM TIỀN',
                              style: TextStyle(
                                color: isActive ? _primaryOrange : Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Phần Divider đứt đoạn (giả lập coupon)
          Row(
            children: [
              SizedBox(
                width: 12,
                height: 24,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _bgColor, // Đồng màu nền Scaffold
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(
                        (constraints.constrainWidth() / 12).floor(),
                            (_) => SizedBox(
                          width: 6,
                          height: 1.5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 12,
                height: 24,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _bgColor, // Đồng màu nền Scaffold
                    borderRadius: const BorderRadius.horizontal(
                      left: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Thông tin chi tiết bên dưới
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _miniInfo(
                      Icons.confirmation_number_outlined,
                      'Mã: ${item.couponCode ?? '-'}',
                    ),
                    const SizedBox(height: 8),
                    _miniInfo(
                      Icons.calendar_today_outlined,
                      '${item.startDate} đến ${item.endDate}',
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildCircleAction(
                      Icons.edit_outlined,
                      _primaryBlue,
                      const Color(0xFFEAF1F8),
                          () => _showPromotionDialog(context, item: item),
                    ),
                    const SizedBox(width: 8),
                    _buildCircleAction(
                      Icons.delete_outline_rounded,
                      _primaryOrange,
                      const Color(0xFFFCEAE8),
                          () => _confirmDelete(context, item),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? 'Đang chạy' : 'Tạm dừng',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black38),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleAction(IconData icon, Color iconColor, Color bgColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFFCEAE8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_offer_outlined,
              size: 64,
              color: _primaryOrange.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chưa có khuyến mãi nào',
            style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showPromotionDialog(BuildContext context, {PromotionResponse? item}) {
    final promotionCubit = context.read<PromotionCubit>();
    final nameController = TextEditingController(text: item?.name ?? '');
    final descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    final typeController = TextEditingController(
      text: item?.type?.toString() ?? '1',
    );
    final valueController = TextEditingController(
      text: item?.value == null ? '' : item!.value!.toStringAsFixed(0),
    );
    final startDateController = TextEditingController(
      text: item?.startDate ?? '',
    );
    final endDateController = TextEditingController(text: item?.endDate ?? '');
    final statusController = TextEditingController(
      text: item?.status?.toString() ?? '1',
    );
    final couponController = TextEditingController(
      text: item?.couponCode ?? '',
    );
    final minOrderController = TextEditingController(
      text: item?.minOrderValue == null
          ? ''
          : item!.minOrderValue!.toStringAsFixed(0),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item == null ? 'Thêm khuyến mãi' : 'Cập nhật khuyến mãi',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _primaryOrange,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Điền thông tin chi tiết cho chương trình khuyến mãi',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _buildModernField(
                nameController,
                'Tên chương trình',
                Icons.campaign_rounded,
              ),
              _buildModernField(
                descriptionController,
                'Mô tả chi tiết',
                Icons.description_rounded,
                maxLines: 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildModernField(
                      typeController,
                      'Loại (1: Số tiền, 2: %)',
                      Icons.category_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernField(
                      valueController,
                      'Giá trị giảm',
                      Icons.attach_money_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              _buildModernField(
                couponController,
                'Mã giảm giá (Coupon)',
                Icons.confirmation_number_rounded,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildModernField(
                      startDateController,
                      'Bắt đầu (YYYY-MM-DD)',
                      Icons.calendar_today_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernField(
                      endDateController,
                      'Kết thúc (YYYY-MM-DD)',
                      Icons.event_rounded,
                    ),
                  ),
                ],
              ),
              _buildModernField(
                minOrderController,
                'Giá trị đơn hàng tối thiểu',
                Icons.shopping_cart_rounded,
                keyboardType: TextInputType.number,
              ),
              _buildModernField(
                statusController,
                'Trạng thái (1: Hoạt động, 0: Ẩn)',
                Icons.toggle_on_rounded,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryOrange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final name = nameController.text.trim();
                    final type = int.tryParse(typeController.text.trim());
                    final value = double.tryParse(valueController.text.trim());
                    final status = int.tryParse(statusController.text.trim());
                    final minOrder = double.tryParse(
                      minOrderController.text.trim(),
                    );

                    if (name.isNotEmpty &&
                        type != null &&
                        value != null &&
                        status != null &&
                        minOrder != null) {
                      final request = PromotionRequest(
                        name: name,
                        description: descriptionController.text.trim(),
                        type: type,
                        value: value,
                        startDate: startDateController.text.trim(),
                        endDate: endDateController.text.trim(),
                        status: status,
                        couponCode: couponController.text.trim(),
                        minOrderValue: minOrder,
                      );
                      if (item?.id != null) {
                        promotionCubit.update(item!.id!, request);
                      } else {
                        promotionCubit.create(request);
                      }
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text(
                    'LƯU THÔNG TIN',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernField(
      TextEditingController controller,
      String label,
      IconData icon, {
        TextInputType? keyboardType,
        int maxLines = 1,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 15, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54, fontSize: 14),
          prefixIcon: Icon(icon, size: 22, color: Colors.black45),
          filled: true,
          fillColor: _inputFillColor,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PromotionResponse item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Xác nhận xóa',
          style: TextStyle(color: _primaryOrange, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa khuyến mãi "${item.name}"? Thao tác này không thể hoàn tác.',
          style: const TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
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
            onPressed: () {
              context.read<PromotionCubit>().remove(item.id!);
              Navigator.pop(ctx);
            },
            child: Text(
              'Xóa',
              style: TextStyle(color: _primaryOrange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}