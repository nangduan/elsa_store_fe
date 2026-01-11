import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_skeleton/core/constants/format.dart';
import 'package:flutter_skeleton/features/product/data/models/response/product_variant_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../product/data/models/response/product_detail_response.dart';

import '../../core/api/app_config.dart';
import '../../core/constants/constant.dart';
import '../../core/di/injector.dart';
import '../../core/errors/app_exception.dart';
import '../cart/domain/repositories/cart_repository.dart';
import '../home/data/models/response/product_response.dart';
import '../product/presentation/cubit/product_detail_cubit.dart';

@RoutePage()
class ProductDetailFullScreen extends StatefulWidget {
  const ProductDetailFullScreen({super.key, required this.product});

  final ProductResponse product;

  @override
  State<ProductDetailFullScreen> createState() =>
      _ProductDetailFullScreenState();
}

class _ProductDetailFullScreenState extends State<ProductDetailFullScreen> {
  // State
  int _currentImageIndex = 0;

  // Dùng dynamic hoặc đúng Type Variant của bạn. Ở đây tôi dùng ProductVariant từ Detail Response
  ProductVariantResponse? _selectedVariant;

  late ProductDetailCubit _cubit;
  late PageController _pageController;
  bool _isAdding = false;

  // Cache danh sách ảnh để không bị load lại liên tục
  List<String> _cachedImages = [];

  @override
  void initState() {
    super.initState();
    _cubit = getIt<ProductDetailCubit>()..load(widget.product.id);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Hàm tổng hợp tất cả ảnh (Ảnh chính + Ảnh variant) vào một list duy nhất
  void _updateCachedImages(ProductDetailResponse? detail) {
    if (_cachedImages.isNotEmpty) {
      return;
    }

    List<String> images = [];

    // 1. Thêm ảnh từ API detail
    if (detail?.images != null && detail!.images.isNotEmpty) {
      images.addAll(detail.images);
    } else if (detail?.imageUrl != null) {
      images.add(detail!.imageUrl!);
    } else if (widget.product.imageUrl != null) {
      images.add(widget.product.imageUrl!);
    }

    // 2. Thêm ảnh từ các variant (nếu ảnh đó chưa có trong list)
    if (detail?.productVariants != null) {
      for (var variant in detail!.productVariants) {
        if (variant.imageUrl != null && !images.contains(variant.imageUrl)) {
          images.add(variant.imageUrl!);
        }
      }
    }

    _cachedImages = images.toSet().toList(); // Loại bỏ trùng lặp
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state.status == ProductDetailStatus.initial ||
                state.status == ProductDetailStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.black),
              );
            }

            final detail = state.product;

            // Cập nhật danh sách ảnh 1 lần khi có dữ liệu
            _updateCachedImages(detail);

            // Logic hiển thị giá
            final displayPrice =
                _selectedVariant?.price ??
                detail?.basePrice ??
                widget.product.basePrice ??
                0;

            final name = detail?.name ?? widget.product.name ?? 'Tên sản phẩm';
            final description =
                detail?.description ??
                widget.product.description ??
                'No description available.';
            final category =
                detail?.categoryName ??
                widget.product.categoryName ??
                'FASHION';

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // 1. HEADER ẢNH (SLIDER)
                    SliverAppBar(
                      expandedHeight: MediaQuery.of(context).size.height * 0.4,
                      pinned: true,
                      backgroundColor: Colors.white,
                      leading: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: Colors.black,
                            ),
                            onPressed: () => context.router.pop(),
                          ),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildImageGallery(_cachedImages),
                      ),
                    ),

                    // 2. BODY INFO
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Category Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                category.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Product Name
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Price
                            Text(
                              Format.formatCurrency(displayPrice),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 24),
                            const Divider(height: 1),
                            const SizedBox(height: 24),

                            // Variations Section
                            _buildSectionTitle('Biến thể'),
                            const SizedBox(height: 12),
                            _buildVariationsList(
                              state.product?.productVariants ?? [],
                            ),

                            const SizedBox(height: 24),

                            // Description Section
                            _buildSectionTitle('Mô tả'),
                            const SizedBox(height: 8),
                            Text(
                              description,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                height: 1.6,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 24),
                            // Details Section
                            _buildSectionTitle('Details'),
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              'SKU',
                              _selectedVariant?.sku ?? 'Không có',
                            ),
                            _buildDetailRow('Condition', 'New in Box'),

                            // Padding để không bị che bởi button bottom
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // 3. BOTTOM BUTTON
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomAction(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // --- WIDGET COMPONENTS ---

  Widget _buildImageGallery(List<String> images) {
    if (images.isEmpty) {
      return Container(
        color: Colors.grey.shade100,
        child: const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 50,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: images.length,
          onPageChanged: (index) {
            setState(() {
              _currentImageIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final imgUrl = _resolveImageUrl(images[index]);
            if (imgUrl == null) return const SizedBox();
            return Image.network(
              imgUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Center(
                child: Icon(Icons.broken_image, color: Colors.grey),
              ),
            );
          },
        ),
        // Dots Indicator
        if (images.length > 1)
          Positioned(
            bottom: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: images.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentImageIndex == entry.key ? 20 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentImageIndex == entry.key
                        ? Colors.black
                        : Colors.grey.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildVariationsList(List<ProductVariantResponse> variants) {
    if (variants.isEmpty) return const Text("Không có tùy chọn");

    // [FIX 1] Tăng height từ 100 lên 110 để tránh lỗi overflow
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: variants.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final variant = variants[i];
          final isSelected = _selectedVariant?.id == variant.id;
          final imgUrl = _resolveImageUrl(variant.imageUrl);

          return GestureDetector(
            onTap: () {
              setState(() {
                // Logic chọn/bỏ chọn
                if (isSelected) {
                  _selectedVariant = null;
                } else {
                  _selectedVariant = variant;

                  // Tìm ảnh tương ứng và scroll tới đó
                  if (variant.imageUrl != null) {
                    final index = _cachedImages.indexOf(variant.imageUrl!);
                    if (index != -1) {
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  }
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey.shade200,
                  width: isSelected ? 2 : 1,
                ),
                color: isSelected ? Colors.white : Colors.grey.shade50,
              ),
              child: Column(
                children: [
                  // Ảnh thumbnail
                  Expanded(
                    flex: 5, // [FIX 2] Tăng flex cho ảnh
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                      child: imgUrl != null
                          ? Image.network(
                              imgUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (_, __, ___) =>
                                  Container(color: Colors.grey.shade200),
                            )
                          : Container(
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.inventory_2_outlined,
                                size: 20,
                              ),
                            ),
                    ),
                  ),
                  // Thông tin Text
                  Expanded(
                    flex: 4, // [FIX 3] Dành nhiều không gian hơn cho Text
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 2, // [FIX 4] Giảm padding vertical
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            variant.size ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isSelected ? Colors.black : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            variant.color ?? '',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.favorite_border),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_selectedVariant == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Vui lòng chọn biến thể (Màu/Kích cỡ)'),
                      ),
                    );
                    return;
                  }
                  _addToCart();
                },
                child: const Text(
                  'THÊM VÀO GIỎ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- HELPERS ---

  Future<void> _addToCart() async {
    if (_isAdding || _selectedVariant?.id == null) return;

    setState(() => _isAdding = true);
    try {
      final storage = getIt<FlutterSecureStorage>();
      final userIdRaw = await storage.read(key: Constants.userId);
      final userId = int.tryParse(userIdRaw ?? '');
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Thiếu thông tin người dùng')),
        );
        return;
      }

      await getIt<CartRepository>().addItem(
        userId,
        _selectedVariant!.id!,
        1,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã thêm vào giỏ hàng')),
      );
    } on AppException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  String? _resolveImageUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return "${AppConfig().baseURL}$path";
  }
}
