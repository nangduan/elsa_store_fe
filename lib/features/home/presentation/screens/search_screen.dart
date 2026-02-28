import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/api/app_config.dart';
import '../../../../core/constants/format.dart';
import '../../../../core/di/injector.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../../product/data/models/request/search_request.dart';
import '../../data/models/response/category_response.dart';
import '../../data/models/response/product_response.dart';
import '../../domain/repositories/home_repository.dart';

@RoutePage()
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _keywordController = TextEditingController();
  final _minPriceController = TextEditingController();
  final _maxPriceController = TextEditingController();

  List<CategoryResponse> _categories = [];
  int? _selectedCategoryId;
  bool _loadingCategories = true;
  bool _loadingResults = false;
  String? _errorMessage;
  List<ProductResponse> _results = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _keywordController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    try {
      final repo = getIt<HomeRepository>();
      final categories = await repo.getCategories();
      if (!mounted) return;
      setState(() {
        _categories = categories.where((e) => e.parentId != null).toList();
        _loadingCategories = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingCategories = false;
        _errorMessage = 'Không thể tải thể loại';
      });
    }
  }

  Future<void> _search() async {
    final keyword = _keywordController.text.trim();
    final minPrice = int.tryParse(_minPriceController.text.trim());
    final maxPrice = int.tryParse(_maxPriceController.text.trim());

    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      setState(() {
        _errorMessage = 'Giá tối thiểu không được lớn hơn giá tối đa';
      });
      return;
    }

    setState(() {
      _loadingResults = true;
      _errorMessage = null;
    });

    try {
      final repo = getIt<HomeRepository>();
      final request = SearchProductRequest(
        keyword: keyword.isEmpty ? null : keyword,
        page: 0,
        sizePage: 100,
        minPrice: minPrice,
        maxPrice: maxPrice,
        status: 1,
        categoryId: _selectedCategoryId,
        sortBy: 'basePrice',
        sortDir: 'asc',
      );

      final results = await repo.searchProducts(request);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loadingResults = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadingResults = false;
        _errorMessage = 'Tìm kiếm thất bại';
      });
    }
  }

  void _clearFilters() {
    _keywordController.clear();
    _minPriceController.clear();
    _maxPriceController.clear();
    setState(() {
      _selectedCategoryId = null;
      _results = [];
      _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm kiếm')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _keywordController,
            decoration: InputDecoration(
              hintText: 'Nhập từ khóa...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onSubmitted: (_) => _search(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Giá từ',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _maxPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: 'Giá đến',
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            value: _selectedCategoryId,
            items: [
              const DropdownMenuItem<int?>(
                value: null,
                child: Text('Tất cả thể loại'),
              ),
              ..._categories.map(
                (e) => DropdownMenuItem<int?>(
                  value: e.id,
                  child: Text(e.name ?? 'Không tên'),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() => _selectedCategoryId = value);
            },
            decoration: InputDecoration(
              labelText: 'Thể loại',
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _loadingResults ? null : _search,
                  child: const Text('Tìm kiếm'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _loadingResults ? null : _clearFilters,
                child: const Text('Xóa lọc'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_loadingCategories)
            const Center(child: CircularProgressIndicator())
          else if (_errorMessage != null)
            Text(_errorMessage!, style: const TextStyle(color: Colors.red))
          else if (_loadingResults)
            const Center(child: CircularProgressIndicator())
          else if (_results.isEmpty)
            const Text('Không có sản phẩm phù hợp')
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _results.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final product = _results[index];
                return _buildProductCard(context, product);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductResponse product) {
    return GestureDetector(
      onTap: () {
        context.router.push(ProductDetailFullRoute(product: product));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _buildProductImage(product.imageUrl),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name ?? '-',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            product.categoryName ?? '-',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(
            product.basePrice != null
                ? Format.formatCurrency(product.basePrice)
                : '-',
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ],
      ),
    );
    //  InkWell(
    //   onTap: () {
    //     context.router.push(ProductDetailFullRoute(product: product));
    //   },
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Expanded(
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(16),
    //           child: imgUrl == null
    //               ? Container(
    //                   color: Colors.grey.shade200,
    //                   child: const Center(
    //                     child: Icon(Icons.image_not_supported_outlined),
    //                   ),
    //                 )
    //               : Image.network(
    //                   imgUrl,
    //                   fit: BoxFit.contain,
    //                   width: double.infinity,
    //                   errorBuilder: (_, __, ___) => Container(
    //                     color: Colors.grey.shade200,
    //                     child: const Center(
    //                       child: Icon(Icons.broken_image_outlined),
    //                     ),
    //                   ),
    //                 ),
    //         ),
    //       ),
    //       const SizedBox(height: 8),
    //       Text(
    //         product.name ?? 'Tên sản phẩm',
    //         maxLines: 2,
    //         overflow: TextOverflow.ellipsis,
    //       ),
    //       Text(
    //         Format.formatCurrency(product.basePrice ?? 0),
    //         style: const TextStyle(fontWeight: FontWeight.bold),
    //       ),
    //     ],
    //   ),
    // );
  }

  Widget _buildProductImage(String? imageUrl) {
    final resolved = _resolveImageUrl(imageUrl);
    if (resolved == null) {
      return const Center(
        child: Icon(Icons.shopping_bag_outlined, color: Colors.grey, size: 40),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        resolved,
        fit: BoxFit.fitWidth,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) {
          return const Center(
            child: Icon(
              Icons.shopping_bag_outlined,
              color: Colors.grey,
              size: 40,
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
}
