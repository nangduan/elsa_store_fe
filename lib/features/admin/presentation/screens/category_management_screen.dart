import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injector.dart';
import '../../data/models/request/category_request.dart';
import '../../data/models/response/category_response.dart';
import '../cubit/category_cubit.dart';

@RoutePage()
class CategoryManagementScreen extends StatelessWidget {
  const CategoryManagementScreen({super.key});

  final Color _primaryBlue = const Color(0xFF1964D4);
  final Color _primaryOrange = const Color(0xFFE85022);
  final Color _bgColor = const Color(0xFFFAFAFA);
  final Color _inputFillColor = const Color(0xFFF5F5F5);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(getIt(), getIt(), getIt(), getIt())..load(),
      child: Scaffold(
        backgroundColor: _bgColor,
        body: BlocConsumer<CategoryCubit, CategoryState>(
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
                _buildAppBar(context, state.categories),
                _buildSearchBar(),
                if (state.status.isLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: _primaryBlue),
                    ),
                  )
                else if (state.categories.isEmpty)
                  SliverFillRemaining(child: _buildEmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildCategoryCard(
                          context,
                          state.categories[index],
                          state.categories,
                        ),
                        childCount: state.categories.length,
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

  Widget _buildAppBar(BuildContext context, List<CategoryResponse> categories) {
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
          'DANH MỤC',
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
            onPressed: () =>
                _showCategoryDialog(context, categories: categories),
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
            hintText: 'Tìm kiếm danh mục...',
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

  Widget _buildCategoryCard(
      BuildContext context,
      CategoryResponse item,
      List<CategoryResponse> allCategories,
      ) {
    final isSubCategory = item.parentId != null;

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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isSubCategory ? Colors.grey.shade50 : const Color(0xFFEAF1F8),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSubCategory
                    ? Icons.subdirectory_arrow_right_rounded
                    : Icons.category_rounded,
                color: isSubCategory ? Colors.black45 : _primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? '-',
                    style: TextStyle(
                      fontWeight: isSubCategory
                          ? FontWeight.w600
                          : FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  if (isSubCategory)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF1F8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Thuộc: ${item.parentName ?? 'Không rõ'}',
                        style: TextStyle(
                          color: _primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  else
                    Text(
                      'Danh mục gốc',
                      style: TextStyle(
                        color: Colors.black38,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                _buildCircleAction(
                  Icons.edit_outlined,
                  _primaryBlue,
                  const Color(0xFFEAF1F8),
                      () => _showCategoryDialog(
                    context,
                    categories: allCategories,
                    item: item,
                  ),
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
              Icons.category_outlined,
              size: 64,
              color: _primaryBlue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Chưa có danh mục nào',
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

  void _showCategoryDialog(
      BuildContext context, {
        required List<CategoryResponse> categories,
        CategoryResponse? item,
      }) {
    final categoryCubit = context.read<CategoryCubit>();
    final nameController = TextEditingController(text: item?.name ?? '');
    int? parentId = item?.parentId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item == null ? 'Thêm danh mục mới' : 'Cập nhật danh mục',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: _primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Điền thông tin chi tiết cho danh mục sản phẩm',
                style: TextStyle(color: Colors.black54, fontSize: 14),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                decoration: _inputDecoration(
                  'Tên danh mục',
                  Icons.drive_file_rename_outline,
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<int?>(
                value: parentId,
                icon: const Icon(Icons.expand_more_rounded, color: Colors.black45),
                style: const TextStyle(fontSize: 15, color: Colors.black87),
                decoration: _inputDecoration(
                  'Danh mục cha (Tùy chọn)',
                  Icons.account_tree_outlined,
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Danh mục cha (Gốc)'),
                  ),
                  ...categories
                      .where((c) => c.parentId == null && c.id != item?.id)
                      .map(
                        (c) => DropdownMenuItem<int?>(
                      value: c.id,
                      child: Text(c.name ?? '-'),
                    ),
                  ),
                ],
                onChanged: (val) => setState(() => parentId = val),
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
                    final request = CategoryRequest(
                      name: nameController.text.trim(),
                      parentId: parentId,
                    );
                    if (item?.id != null) {
                      categoryCubit.update(item!.id!, request);
                    } else {
                      categoryCubit.create(request);
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

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
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
    );
  }

  void _confirmDelete(BuildContext context, CategoryResponse item) {
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
          'Bạn có chắc chắn muốn xóa danh mục "${item.name}"? Thao tác này không thể hoàn tác.',
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
              context.read<CategoryCubit>().remove(item.id!);
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