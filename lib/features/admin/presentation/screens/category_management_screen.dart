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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CategoryCubit(getIt(), getIt(), getIt(), getIt())..load(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
              size: 20,
            ),
            onPressed: () => context.router.pop(),
          ),
          title: const Text(
            'CATEGORIES',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            BlocBuilder<CategoryCubit, CategoryState>(
              builder: (context, state) {
                return IconButton(
                  onPressed: () => _showCategoryDialog(
                    context,
                    categories: state.categories,
                  ),
                  icon: const Icon(
                    Icons.add_box_rounded,
                    color: Colors.black,
                    size: 28,
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state.status.isLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            if (state.categories.isEmpty) {
              return _buildEmptyState();
            }

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final item = state.categories[index];
                return _buildCategoryCard(context, item, state.categories);
              },
            );
          },
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSubCategory ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: isSubCategory
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        children: [
          // Icon đại diện cho Category
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSubCategory ? Colors.white : Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isSubCategory
                  ? Icons.subdirectory_arrow_right_rounded
                  : Icons.category_rounded,
              color: isSubCategory ? Colors.black : Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Thông tin Category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name ?? '-',
                  style: TextStyle(
                    fontWeight: isSubCategory
                        ? FontWeight.w500
                        : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (!isSubCategory) const SizedBox(height: 4),
                if (!isSubCategory)
                  Text(
                    'Root Category',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                if (isSubCategory)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Parent: ${item.parentName ?? 'N/A'}',
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Actions
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: Colors.blueGrey),
            onPressed: () => _showCategoryDialog(
              context,
              categories: allCategories,
              item: item,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_sweep_outlined,
              color: Colors.redAccent,
            ),
            onPressed: () => _confirmDelete(context, item),
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
    final nameController = TextEditingController(text: item?.name ?? '');
    int? parentId = item?.parentId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item == null ? 'New Category' : 'Edit Category',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Tên Category
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Chọn Parent Category
              DropdownButtonFormField<int?>(
                value: parentId,
                decoration: InputDecoration(
                  labelText: 'Parent Category (Optional)',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('No Parent (Root)'),
                  ),
                  ...categories
                      .where(
                        (c) => c.id != item?.id,
                      ) // Không cho phép chọn chính mình làm cha
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
                height: 54,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    final request = CategoryRequest(
                      name: nameController.text.trim(),
                      parentId: parentId,
                    );
                    if (item?.id != null) {
                      context.read<CategoryCubit>().update(item!.id!, request);
                    } else {
                      context.read<CategoryCubit>().create(request);
                    }
                    Navigator.pop(dialogContext);
                  },
                  child: const Text(
                    'SAVE CATEGORY',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Các Widget phụ trợ (EmptyState, ConfirmDelete...) giống màn hình Supplier
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(
            'No categories found',
            style: TextStyle(color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, CategoryResponse item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category?'),
        content: Text(
          'This will remove "${item.name}". Make sure no products are linked to it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<CategoryCubit>().remove(item.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
