import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:file_picker/file_picker.dart';
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

  final Color _primaryOrange = const Color(0xFFE85022);
  final Color _inputFillColor = const Color(0xFFF5F5F5);

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
        backgroundColor: _primaryOrange, // Nền cam theo thiết kế
        body: BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Thao tác thất bại'),
                  backgroundColor: Colors.white,
                  action: SnackBarAction(
                    label: 'Đóng',
                    textColor: _primaryOrange,
                    onPressed: () {},
                  ),
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
                BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    return _buildAppBar(context);
                  },
                ),
                _buildSearchBar(context),
                if (state.status.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
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
      expandedHeight: 70.0, // Rút gọn chiều cao theo thiết kế
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white, // AppBar trắng
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
          size: 20,
        ),
        onPressed: () => context.router.pop(),
      ),
      title: const Text(
        'SẢN PHẨM',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: 1.0,
        ),
      ),
      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: InkWell(
            onTap: () {
              final categories = context.read<CategoryCubit>().state.categories;
              _showProductDialog(context, categories: categories);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 22),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        color: _primaryOrange,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Tìm kiếm hàng tồn...',
            hintStyle: const TextStyle(color: Colors.black38, fontSize: 15),
            prefixIcon: const Icon(Icons.search_rounded, color: Colors.black45),
            filled: true,
            fillColor: Colors.white, // Input trắng
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30), // Bo tròn hoàn toàn
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductResponse item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card (Danh mục + Actions)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
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
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _buildCircleAction(
                            Icons.edit_outlined,
                            const Color(0xFF6B7280),
                            const Color(0xFFF3F4F6),
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
                          const SizedBox(width: 10),
                          _buildCircleAction(
                            Icons.delete_outline_rounded,
                            const Color(0xFFEF4444),
                            const Color(0xFFFEE2E2),
                                () => _confirmDelete(context, item),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Image
                _buildProductImage(item.imageUrl),

                // Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.description ?? 'Sở hữu ngay siêu phẩm chính hãng tại cửa hàng. Uy tín, tận tâm và luôn đảm bảo 100% chất lượng.',
                        style: const TextStyle(color: Colors.black45, fontSize: 13, height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(height: 1, thickness: 0.5, color: Colors.black12),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Giá gốc',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Format.formatCurrency(item.basePrice),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 20,
                                  color: Colors.black,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCircleAction(IconData icon, Color iconColor, Color bgColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
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

  Widget _buildProductImage(String? imageUrl) {
    final resolved = _resolveImageUrl(imageUrl);
    if (resolved == null) {
      return Container(
        height: 180,
        width: double.infinity,
        color: Colors.white,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: Colors.black12,
            size: 48,
          ),
        ),
      );
    }

    return Image.network(
      resolved,
      height: 180,
      width: double.infinity,
      fit: BoxFit.contain, // Phù hợp với hiển thị giày trong ảnh thiết kế
      errorBuilder: (_, __, ___) {
        return Container(
          height: 180,
          width: double.infinity,
          color: Colors.white,
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.black12,
              size: 48,
            ),
          ),
        );
      },
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: Colors.white70,
          ),
          SizedBox(height: 16),
          Text(
            'Kho hàng trống',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
    String? selectedImagePath;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setModalState) => Container(
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: _primaryOrange,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Điền thông tin chi tiết cho sản phẩm',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
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
                  icon: const Icon(Icons.expand_more_rounded, color: Colors.black45),
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
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
                const SizedBox(height: 16),
                if (selectedImagePath != null)
                  _buildSelectedImagePreview(selectedImagePath!)
                else if (item?.imageUrl != null && item!.imageUrl!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: _buildProductImage(item.imageUrl),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryOrange,
                      side: BorderSide(color: _primaryOrange.withOpacity(0.5)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      final pickedPath = result?.files.single.path;
                      if (pickedPath == null || pickedPath.isEmpty) {
                        return;
                      }
                      setModalState(() => selectedImagePath = pickedPath);
                    },
                    icon: const Icon(Icons.photo_library_outlined),
                    label: Text(
                      selectedImagePath == null ? 'Chọn ảnh sản phẩm' : 'Thay đổi ảnh',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
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
                      final price = double.tryParse(basePriceController.text);
                      if (name.isNotEmpty &&
                          price != null &&
                          selectedCategoryId != null) {
                        if (item == null && selectedImagePath == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Vui lòng chọn ảnh sản phẩm'),
                              backgroundColor: Colors.redAccent,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                          return;
                        }

                        final req = ProductRequest(
                          name: name,
                          description: descriptionController.text,
                          basePrice: price,
                          categoryId: selectedCategoryId!,
                          imagePath: selectedImagePath,
                        );
                        if (item?.id != null) {
                          productCubit.update(item!.id!, req);
                        } else {
                          productCubit.create(req);
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
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.file(
        File(imagePath),
        height: 140,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: _inputFillColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: Colors.black26,
                size: 36,
              ),
            ),
          );
        },
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
        decoration: _fieldDecoration(label, icon),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon) {
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
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Xác nhận xóa',
          style: TextStyle(color: _primaryOrange, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa "${item.name}" khỏi kho hàng? Thao tác này không thể hoàn tác.',
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
              backgroundColor: const Color(0xFFFEE2E2),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.read<ProductCubit>().remove(item.id!);
              Navigator.pop(ctx);
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Color(0xFFEF4444), fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}