import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton/core/constants/format.dart';

import '../../../../core/api/app_config.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../../core/di/injector.dart';
import '../../data/models/request/product_request.dart';
import '../../data/models/response/product_response.dart';
import '../../data/models/response/category_response.dart';
import '../cubit/category_cubit.dart';
import '../cubit/product_cubit.dart';

@RoutePage()
class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ProductCubit(getIt(), getIt(), getIt(), getIt())..load(),
        ),
        BlocProvider(
          create: (_) =>
              CategoryCubit(getIt(), getIt(), getIt(), getIt())..load(),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Thao tác thất bại'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    return _buildAppBar(context);
                  },
                ),
                _buildSearchBar(context),
                if (state.status.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    ),
                  )
                else if (state.products.isEmpty)
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
                            _buildProductCard(context, state.products[index]),
                        childCount: state.products.length,
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
          'SẢN PHẨM',
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
            onPressed: () {
              final categories = context.read<CategoryCubit>().state.categories;
              _showProductDialog(context, categories: categories);
            },
            icon: const Icon(Icons.add_circle, color: Colors.black, size: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm hàng tồn...',
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

  Widget _buildProductCard(BuildContext context, ProductResponse item) {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (item.id != null) {
                context.router.push(
                  ProductVariantManagementRoute(
                    productId: item.id!,
                    productName: item.name,
                    description: item.description,
                    basePrice: item.basePrice,
                    categoryName: item.categoryName,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.categoryName?.toUpperCase() ?? 'GENERAL',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _buildCircleAction(
                            Icons.edit_outlined,
                            Colors.blueGrey,
                            () {
                              final categories = context
                                  .read<CategoryCubit>()
                                  .state
                                  .categories;
                              _showProductDialog(
                                context,
                                categories: categories,
                                item: item,
                              );
                            },
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
                  const SizedBox(height: 12),
                  _buildProductImage(item.imageUrl),
                  const SizedBox(height: 12),
                  Text(
                    item.name ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description ?? 'Chưa có mô tả',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1, thickness: 0.5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giá gốc',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            Format.formatCurrency(item.basePrice),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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

  Widget _buildProductImage(String? imageUrl) {
    final resolved = _resolveImageUrl(imageUrl);
    if (resolved == null) {
      return Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.grey,
            size: 36,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        resolved,
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.grey,
                size: 36,
              ),
            ),
          );
        },
      ),
    );
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return null;
    }

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    final baseUrl = "${AppConfig().baseURL}$path";
    return baseUrl;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 16),
          Text(
            'Kho hàng trống',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(
    BuildContext context, {
    required List<CategoryResponse> categories,
    ProductResponse? item,
  }) {
    final productCubit = context.read<ProductCubit>();
    final nameController = TextEditingController(text: item?.name ?? '');
    final descriptionController = TextEditingController(
      text: item?.description ?? '',
    );
    final basePriceController = TextEditingController(
      text: item?.basePrice?.toStringAsFixed(0) ?? '',
    );
    final availableCategories = categories
        .where((c) => c.parentId != null)
        .toList();
    final selectableCategories = availableCategories.isEmpty
        ? categories
        : availableCategories;
    int? selectedCategoryId = _matchCategoryId(
      selectableCategories,
      item?.categoryName,
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
                item == null ? 'Sản phẩm mới' : 'Chỉnh sửa sản phẩm',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 24),
              _buildModernField(
                nameController,
                'Tên sản phẩm',
                Icons.drive_file_rename_outline,
              ),
              _buildModernField(
                descriptionController,
                'Mô tả',
                Icons.description_outlined,
                maxLines: 3,
              ),
              _buildModernField(
                basePriceController,
                'Giá gốc',
                Icons.payments_outlined,
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<int>(
                value: selectedCategoryId,
                decoration: _fieldDecoration(
                  'Danh mục',
                  Icons.category_outlined,
                ),
                items: selectableCategories
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name ?? '-'),
                      ),
                    )
                    .toList(),
                onChanged: (val) => selectedCategoryId = val,
              ),
              const SizedBox(height: 32),
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
                    final price = double.tryParse(basePriceController.text);
                    if (name.isNotEmpty &&
                        price != null &&
                        selectedCategoryId != null) {
                      final req = ProductRequest(
                        name: name,
                        description: descriptionController.text,
                        basePrice: price,
                        categoryId: selectedCategoryId!,
                      );
                      if (item?.id != null)
                        productCubit.update(item!.id!, req);
                      else
                        productCubit.create(req);
                      Navigator.pop(dialogContext);
                    }
                  },
                  child: const Text(
                    'LƯU SẢN PHẨM',
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
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: _fieldDecoration(label, icon),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }

  int? _matchCategoryId(
    List<CategoryResponse> categories,
    String? categoryName,
  ) {
    if (categoryName == null) return null;
    try {
      return categories.firstWhere((c) => c.name == categoryName).id;
    } catch (_) {
      return null;
    }
  }

  void _confirmDelete(BuildContext context, ProductResponse item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Xác nhận xóa'),
        content: Text('Xóa "${item.name}" khỏi danh mục?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductCubit>().remove(item.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
