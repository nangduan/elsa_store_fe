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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PromotionCubit(getIt(), getIt(), getIt(), getIt())..load(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA), // Màu nền đồng bộ
        body: BlocConsumer<PromotionCubit, PromotionState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Operation failed'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
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
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
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
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => context.router.pop(),
      ),
      flexibleSpace: const FlexibleSpaceBar(
        titlePadding: EdgeInsetsDirectional.only(start: 56, bottom: 16),
        title: Text(
          'PROMOTIONS',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 1.5,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed: () => _showPromotionDialog(context),
            icon: const Icon(Icons.add_circle, color: Colors.black, size: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search promotions...',
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.black54),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade100),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionCard(BuildContext context, PromotionResponse item) {
    final isActive = item.status == 1;
    final isPercent = item.type == 2;
    // Format hiển thị giá trị: 50% hoặc $50
    final valueDisplay = isPercent
        ? '${item.value?.toStringAsFixed(0)}%'
        : '\$${item.value?.toStringAsFixed(0)}';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
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
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.black : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.local_offer_rounded,
                    color: isActive ? Colors.white : Colors.grey.shade600,
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
                              item.name ?? 'Unknown Promotion',
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _statusBadge(isActive),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description ?? 'No description',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      // Hiển thị giá trị to
                      Row(
                        children: [
                          Text(
                            valueDisplay,
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 24,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              isPercent ? 'OFF' : 'DISCOUNT',
                              style: const TextStyle(
                                color: Colors.orange,
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
              const SizedBox(
                width: 10,
                height: 20,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(10),
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
                        (constraints.constrainWidth() / 10).floor(),
                        (_) => const SizedBox(
                          width: 5,
                          height: 1,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: Colors.grey),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                width: 10,
                height: 20,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Thông tin chi tiết bên dưới
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _miniInfo(
                      Icons.confirmation_number_outlined,
                      'Code: ${item.couponCode ?? '-'}',
                    ),
                    const SizedBox(height: 6),
                    _miniInfo(
                      Icons.calendar_today_outlined,
                      '${item.startDate} - ${item.endDate}',
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildCircleAction(
                      Icons.edit_outlined,
                      Colors.blueGrey,
                      () => _showPromotionDialog(context, item: item),
                    ),
                    const SizedBox(width: 8),
                    _buildCircleAction(
                      Icons.delete_outline_rounded,
                      Colors.redAccent,
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _miniInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey.shade400),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_offer_outlined,
            size: 80,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 16),
          Text(
            'No promotions found',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
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
                item == null ? 'New Promotion' : 'Edit Promotion',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 24),
              _buildModernField(
                nameController,
                'Promotion Name',
                Icons.campaign_rounded,
              ),
              _buildModernField(
                descriptionController,
                'Description',
                Icons.description_rounded,
                maxLines: 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildModernField(
                      typeController,
                      'Type (1:Fixed, 2:%)',
                      Icons.category_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernField(
                      valueController,
                      'Value',
                      Icons.attach_money_rounded,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              _buildModernField(
                couponController,
                'Coupon Code',
                Icons.confirmation_number_rounded,
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildModernField(
                      startDateController,
                      'Start Date',
                      Icons.calendar_today_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildModernField(
                      endDateController,
                      'End Date',
                      Icons.event_rounded,
                    ),
                  ),
                ],
              ),
              _buildModernField(
                minOrderController,
                'Min Order Value',
                Icons.shopping_cart_rounded,
                keyboardType: TextInputType.number,
              ),
              _buildModernField(
                statusController,
                'Status (1:Active, 0:Inactive)',
                Icons.toggle_on_rounded,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
                    'SAVE PROMOTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
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
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PromotionResponse item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Delete Promotion?'),
        content: Text('Remove "${item.name}" from active promotions?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<PromotionCubit>().remove(item.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
