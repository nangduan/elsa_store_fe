import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../data/models/request/supplier_request.dart';
import '../../data/models/response/supplier_response.dart';
import '../cubit/supplier_cubit.dart';

@RoutePage()
class SupplierManagementScreen extends StatelessWidget {
  const SupplierManagementScreen({super.key});

  final Color _primaryBlue = const Color(0xFF1964D4);
  final Color _primaryOrange = const Color(0xFFE85022);
  final Color _bgColor = const Color(0xFFFAFAFA);
  final Color _inputFillColor = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      SupplierCubit(getIt(), getIt(), getIt(), getIt())..load(),
      child: Scaffold(
        backgroundColor: _bgColor,
        body: BlocConsumer<SupplierCubit, SupplierState>(
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
                      child: CircularProgressIndicator(color: _primaryBlue),
                    ),
                  )
                else if (state.suppliers.isEmpty)
                  SliverFillRemaining(child: _buildEmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                            _buildSupplierCard(context, state.suppliers[index]),
                        childCount: state.suppliers.length,
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
          color: _primaryBlue,
          size: 20,
        ),
        onPressed: () => context.router.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsetsDirectional.only(start: 56, bottom: 16),
        title: Text(
          'NHÀ CUNG CẤP',
          style: TextStyle(
            color: _primaryBlue,
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
            onPressed: () => _showSupplierDialog(context),
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
            hintText: 'Tìm kiếm nhà cung cấp...',
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
              borderSide: BorderSide(color: _primaryBlue.withOpacity(0.5)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupplierCard(BuildContext context, SupplierResponse item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF1F8),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.storefront_rounded,
                          color: _primaryBlue,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          item.name ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    _buildCircleAction(
                      Icons.edit_outlined,
                      _primaryBlue,
                      const Color(0xFFEAF1F8),
                          () => _showSupplierDialog(context, item: item),
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Divider(height: 1, thickness: 0.5, color: Colors.black12),
            ),
            _buildInfoRow(Icons.phone_iphone_rounded, item.phone ?? 'Chưa có SĐT'),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.alternate_email_rounded,
              item.email ?? 'Chưa có email',
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              Icons.location_on_outlined,
              item.address ?? 'Chưa có địa chỉ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black38),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCircleAction(
      IconData icon, Color iconColor, Color bgColor, VoidCallback onTap) {
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
              color: Color(0xFFEAF1F8),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: _primaryBlue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Không có nhà cung cấp nào',
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

  void _showSupplierDialog(BuildContext context, {SupplierResponse? item}) {
    final supplierCubit = context.read<SupplierCubit>();
    final nameController = TextEditingController(text: item?.name ?? '');
    final phoneController = TextEditingController(text: item?.phone ?? '');
    final addressController = TextEditingController(text: item?.address ?? '');
    final emailController = TextEditingController(text: item?.email ?? '');

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
                item == null ? 'Thêm nhà cung cấp' : 'Cập nhật thông tin',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Điền thông tin chi tiết bên dưới',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              _buildModernField(
                nameController,
                'Tên công ty',
                Icons.business_rounded,
              ),
              _buildModernField(
                phoneController,
                'Số điện thoại',
                Icons.phone_rounded,
                keyboardType: TextInputType.phone,
              ),
              _buildModernField(
                emailController,
                'Địa chỉ email',
                Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildModernField(
                addressController,
                'Địa chỉ văn phòng',
                Icons.map_rounded,
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    final request = SupplierRequest(
                      name: nameController.text.trim(),
                      phone: phoneController.text.trim(),
                      address: addressController.text.trim(),
                      email: emailController.text.trim(),
                    );
                    if (item?.id != null) {
                      supplierCubit.update(item!.id!, request);
                    } else {
                      supplierCubit.create(request);
                    }
                    Navigator.pop(dialogContext);
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

  void _confirmDelete(BuildContext context, SupplierResponse item) {
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
          'Bạn có chắc chắn muốn xóa ${item.name}? Thao tác này không thể hoàn tác.',
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
              context.read<SupplierCubit>().remove(item.id!);
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