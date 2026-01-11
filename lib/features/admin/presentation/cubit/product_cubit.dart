import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/request/product_request.dart';
import '../../data/models/response/product_response.dart';
import '../../domain/usecases/create_product_use_case.dart';
import '../../domain/usecases/delete_product_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../domain/usecases/update_product_use_case.dart';

enum ProductStatus { initial, loading, success, failure }

extension ProductStatusX on ProductStatus {
  bool get isLoading => this == ProductStatus.loading;
  bool get isSuccess => this == ProductStatus.success;
  bool get isFailure => this == ProductStatus.failure;
  bool get isInitial => this == ProductStatus.initial;
}

class ProductState {
  final ProductStatus status;
  final List<ProductResponse> products;
  final String? errorMessage;

  const ProductState({
    this.status = ProductStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductResponse>? products,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@injectable
class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase _getProducts;
  final CreateProductUseCase _createProduct;
  final UpdateProductUseCase _updateProduct;
  final DeleteProductUseCase _deleteProduct;

  ProductCubit(
    this._getProducts,
    this._createProduct,
    this._updateProduct,
    this._deleteProduct,
  ) : super(const ProductState());

  Future<void> load() async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final items = await _getProducts.call();
      emit(state.copyWith(status: ProductStatus.success, products: items));
    } on AppException catch (e) {
      emit(
        state.copyWith(status: ProductStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<void> create(ProductRequest request) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _createProduct(request);
      await load();
    } on AppException catch (e) {
      emit(
        state.copyWith(status: ProductStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<void> update(int id, ProductRequest request) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _updateProduct(id, request);
      await load();
    } on AppException catch (e) {
      emit(
        state.copyWith(status: ProductStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<void> remove(int id) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      await _deleteProduct(id);
      await load();
    } on AppException catch (e) {
      emit(
        state.copyWith(status: ProductStatus.failure, errorMessage: e.message),
      );
    }
  }
}
