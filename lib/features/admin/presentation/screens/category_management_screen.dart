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

  final Color _primaryBlue = const Color(0xFF1565C0);
  final Color _primaryOrange = const Color(0xFFE64A19);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(getIt(), getIt(), getIt(), getIt())..load(),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: BlocConsumer<CategoryCubit, CategoryState>(
          listener: (context, state) {},
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                _buildAppBar(context, state.categories),
                _buildSearchBar(),
                if (state.status.isLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: _primaryBlue,
                        strokeWidth: 3,
                      ),
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
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, List<CategoryResponse> categories) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.grey.shade700,
          size: 22,
        ),
        onPressed: () => context.router.pop(),
      ),
      centerTitle: true,
      title: Text(
        'TẤT CẢ DANH MỤC',
        style: TextStyle(
          color: _primaryBlue,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: 1.0,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            onPressed:
                () => _showCategoryDialog(context, categories: categories),
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: _primaryOrange,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm kiếm danh mục...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded, color: _primaryBlue),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
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
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _primaryBlue.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 5),
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
                color:
                isSubCategory
                    ? Colors.grey.shade50
                    : _primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                isSubCategory
                    ? Icons.subdirectory_arrow_right_rounded
                    : Icons.layers_rounded,
                color: isSubCategory ? Colors.grey.shade600 : _primaryBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name ?? 'Không có tên',
                    style: TextStyle(
                      fontWeight:
                      isSubCategory ? FontWeight.w600 : FontWeight.w800,
                      fontSize: 16,
                      color: Colors.grey.shade900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (isSubCategory)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _primaryBlue.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Thuộc: ${item.parentName ?? 'Gốc'}',
                        style: TextStyle(
                          color: _primaryBlue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Danh mục gốc',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Row(
              children: [
                _buildCircleAction(
                  Icons.edit_rounded,
                  Colors.blueGrey,
                      () => _showCategoryDialog(
                    context,
                    categories: allCategories,
                    item: item,
                  ),
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
    );
  }

  Widget _buildCircleAction(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: _primaryBlue.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.category_outlined,
              size: 60,
              color: _primaryBlue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Chưa có danh mục nào',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 16,
              fontWeight: FontWeight.w500,
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
      builder:
          (dialogContext) => StatefulBuilder(
        builder:
            (context, setState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom + 30,
            left: 24,
            right: 24,
            top: 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item == null ? 'Thêm mới' : 'Chỉnh sửa',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: _primaryBlue,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: _inputDecoration(
                  'Tên danh mục',
                  Icons.drive_file_rename_outline_rounded,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonFormField<int?>(
                  value: parentId,
                  dropdownColor: Colors.white,
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: _primaryBlue,
                  ),
                  decoration: _inputDecoration(
                    'Danh mục cha (Tùy chọn)',
                    Icons.account_tree_rounded,
                    isDropdown: true,
                  ),
                  items: [
                    const DropdownMenuItem<int?>(
                      value: null,
                      child: Text('Danh mục gốc (Không có cha)'),
                    ),
                    ...categories
                        .where(
                          (c) =>
                      c.parentId == null && c.id != item?.id,
                    )
                        .map(
                          (c) => DropdownMenuItem<int?>(
                        value: c.id,
                        child: Text(c.name ?? '-'),
                      ),
                    ),
                  ],
                  onChanged: (val) => setState(() => parentId = val),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: _primaryBlue.withOpacity(0.4),
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
                    'LƯU THAY ĐỔI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      String label,
      IconData icon, {
        bool isDropdown = false,
      }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey.shade500),
      prefixIcon: Icon(
        icon,
        size: 22,
        color: _primaryBlue.withOpacity(0.7),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: _primaryBlue, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _confirmDelete(BuildContext context, CategoryResponse item) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: _primaryOrange),
            const SizedBox(width: 10),
            const Text('Xác nhận xóa'),
          ],
        ),
        content: Text.rich(
          TextSpan(
            text: 'Bạn có chắc chắn muốn xóa danh mục ',
            style: const TextStyle(color: Colors.black87),
            children: [
              TextSpan(
                text: '"${item.name}"',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(text: ' không?'),
            ],
          ),
        ),
        actionsPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: () {
              context.read<CategoryCubit>().remove(item.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Xóa ngay'),
          ),
        ],
      ),
    );
  }
}