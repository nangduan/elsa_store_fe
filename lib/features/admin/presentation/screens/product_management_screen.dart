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

  // Định nghĩa màu chủ đạo (Ocean Blue & Orange)
  final Color _primaryBlue = const Color(0xFF1565C0);
  final Color _primaryOrange = const Color(0xFFE64A19);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductCubit(getIt(), getIt(), getIt(), getIt())..load(),
        ),
        BlocProvider(
          create: (_) => CategoryCubit(getIt(), getIt(), getIt(), getIt())..load(),
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.grey.shade50, // Nền xám nhạt hiện đại
        body: BlocConsumer<ProductCubit, ProductState>(
          listener: (context, state) {
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Thao tác thất bại'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                // 1. App Bar (Title nằm cùng hàng)
                _buildAppBar(context),

                // 2. Search Bar
                _buildSearchBar(context),

                // 3. Content
                if (state.status.isLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: _primaryBlue),
                    ),
                  )
                else if (state.products.isEmpty)
                  SliverFillRemaining(child: _buildEmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => _buildProductCard(context, state.products[index]),
                        childCount: state.products.length,
                      ),
                    ),
                  ),

                // Padding bottom để tránh cấn nút home ảo
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,

      // Nút Back
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.grey.shade700, size: 22),
        onPressed: () => context.router.pop(),
      ),

      // Tiêu đề nằm giữa, cùng hàng
      centerTitle: true,
      title: Text(
        'QUẢN LÝ SẢN PHẨM',
        style: TextStyle(
          color: _primaryBlue,
          fontWeight: FontWeight.w900,
          fontSize: 18,
          letterSpacing: 1.0,
        ),
      ),

      // Nút Add
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: IconButton(
            tooltip: "Thêm sản phẩm",
            onPressed: () {
              final categories = context.read<CategoryCubit>().state.categories;
              _showProductDialog(context, categories: categories);
            },
            // Màu cam nổi bật cho hành động chính
            icon: Icon(Icons.add_circle_rounded, color: _primaryOrange, size: 32),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
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
              hintText: 'Tìm kiếm sản phẩm...',
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              prefixIcon: Icon(Icons.search_rounded, color: _primaryBlue),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
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
            color: _primaryBlue.withOpacity(0.08), // Shadow màu xanh nhẹ
            blurRadius: 20,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card: Category Tag & Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _primaryBlue.withOpacity(0.2)),
                        ),
                        child: Text(
                          item.categoryName?.toUpperCase() ?? 'KHÁC',
                          style: TextStyle(
                            color: _primaryBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _buildCircleAction(
                            Icons.edit_rounded,
                            Colors.blueGrey,
                                () {
                              final categories = context.read<CategoryCubit>().state.categories;
                              _showProductDialog(context, categories: categories, item: item);
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

                  const SizedBox(height: 16),

                  // Body Card: Image & Info
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: _buildProductImage(item.imageUrl),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name ?? 'Không tên',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                color: Colors.grey.shade800,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.description ?? 'Chưa có mô tả chi tiết.',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(height: 1, thickness: 0.5),
                  ),

                  // Footer Card: Price & Arrow
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giá niêm yết',
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 11,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                          Text(
                            Format.formatCurrency(item.basePrice),
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              color: _primaryOrange, // Giá tiền dùng màu Cam nổi bật
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey.shade400),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
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
    // Logic hiển thị ảnh giữ nguyên, chỉ thay đổi styling container
    if (resolved == null) {
      return Container(
        color: Colors.grey.shade100,
        child: Icon(Icons.image_outlined, color: Colors.grey.shade300, size: 30),
      );
    }
    return Image.network(
      resolved,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade100,
        child: Icon(Icons.broken_image_outlined, color: Colors.grey.shade300, size: 30),
      ),
    );
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    return "${AppConfig().baseURL}$path";
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
            child: Icon(Icons.inventory_2_outlined, size: 60, color: _primaryBlue.withOpacity(0.5)),
          ),
          const SizedBox(height: 20),
          Text(
            'Chưa có sản phẩm nào',
            style: TextStyle(
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
                fontSize: 16
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
    final descriptionController = TextEditingController(text: item?.description ?? '');
    final basePriceController = TextEditingController(text: item?.basePrice?.toStringAsFixed(0) ?? '');

    // Logic lọc category giữ nguyên
    final availableCategories = categories.where((c) => c.parentId != null).toList();
    final selectableCategories = availableCategories.isEmpty ? categories : availableCategories;
    int? selectedCategoryId = _matchCategoryId(selectableCategories, item?.categoryName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (dialogContext) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(dialogContext).viewInsets.bottom + 30,
          left: 24,
          right: 24,
          top: 32,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dialog Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item == null ? 'Thêm mới' : 'Cập nhật',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: _primaryBlue,
                    ),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: Colors.grey.shade400)
                  )
                ],
              ),
              const SizedBox(height: 24),

              _buildModernField(nameController, 'Tên sản phẩm', Icons.drive_file_rename_outline_rounded),
              _buildModernField(descriptionController, 'Mô tả', Icons.description_outlined, maxLines: 3),
              _buildModernField(basePriceController, 'Giá gốc', Icons.attach_money_rounded, keyboardType: TextInputType.number),

              // Dropdown
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: DropdownButtonFormField<int>(
                  value: selectedCategoryId,
                  icon: Icon(Icons.keyboard_arrow_down_rounded, color: _primaryBlue),
                  dropdownColor: Colors.white,
                  decoration: _fieldDecoration('Danh mục', Icons.category_outlined),
                  items: selectableCategories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name ?? '-'))).toList(),
                  onChanged: (val) => selectedCategoryId = val,
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
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
                    final name = nameController.text.trim();
                    final price = double.tryParse(basePriceController.text);
                    if (name.isNotEmpty && price != null && selectedCategoryId != null) {
                      final req = ProductRequest(
                        name: name,
                        description: descriptionController.text,
                        basePrice: price,
                        categoryId: selectedCategoryId!,
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
                    'LƯU SẢN PHẨM',
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

  Widget _buildModernField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
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
      labelStyle: TextStyle(color: Colors.grey.shade500),
      prefixIcon: Icon(icon, size: 22, color: _primaryBlue.withOpacity(0.7)),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: _primaryBlue, width: 1.5)),
    );
  }

  int? _matchCategoryId(List<CategoryResponse> categories, String? categoryName) {
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: _primaryOrange),
            const SizedBox(width: 10),
            const Text('Xác nhận xóa'),
          ],
        ),
        content: Text.rich(
            TextSpan(
                text: 'Bạn có muốn xóa ',
                style: const TextStyle(color: Colors.black87),
                children: [
                  TextSpan(text: '"${item.name}"', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' không?'),
                ]
            )
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
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
            ),
            onPressed: () {
              context.read<ProductCubit>().remove(item.id!);
              Navigator.pop(ctx);
            },
            child: const Text('Xóa ngay'),
          ),
        ],
      ),
    );
  }
}