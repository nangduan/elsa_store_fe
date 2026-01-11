import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/errors/app_exception.dart';
import '../../data/models/response/cart_response.dart';
import '../../domain/usecases/add_cart_item_use_case.dart';
import '../../domain/usecases/delete_cart_item_use_case.dart';
import '../../domain/usecases/get_cart_use_case.dart';
import '../../domain/usecases/update_cart_item_quantity_use_case.dart';

enum CartStatus { initial, loading, success, failure, updating }

class CartState {
  final CartStatus status;
  final CartResponse? cart;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.errorMessage,
  });

  CartState copyWith({
    CartStatus? status,
    CartResponse? cart,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@injectable
class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCart;
  final AddCartItemUseCase _addItem;
  final UpdateCartItemQuantityUseCase _updateItem;
  final DeleteCartItemUseCase _deleteItem;
  final FlutterSecureStorage _storage;

  CartCubit(
    this._getCart,
    this._addItem,
    this._updateItem,
    this._deleteItem,
    this._storage,
  ) : super(const CartState());

  Future<void> load() async {
    emit(state.copyWith(status: CartStatus.loading));
    final userId = await _readUserId();
    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Thiếu thông tin người dùng',
        ),
      );
      return;
    }

    try {
      final cart = await _getCart(userId);
      emit(state.copyWith(status: CartStatus.success, cart: cart));
    } on AppException catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<void> addItem(int productVariantId, {int quantity = 1}) async {
    emit(state.copyWith(status: CartStatus.updating));
    final userId = await _readUserId();
    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Thiếu thông tin người dùng',
        ),
      );
      return;
    }

    try {
      final cart = await _addItem(userId, productVariantId, quantity);
      emit(state.copyWith(status: CartStatus.success, cart: cart));
    } on AppException catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<void> updateItemQuantity(int itemId, int quantity) async {
    emit(state.copyWith(status: CartStatus.updating));
    final userId = await _readUserId();
    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Thiếu thông tin người dùng',
        ),
      );
      return;
    }

    try {
      final cart = await _updateItem(userId, itemId, quantity);
      emit(state.copyWith(status: CartStatus.success, cart: cart));
    } on AppException catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<void> deleteItem(int itemId) async {
    emit(state.copyWith(status: CartStatus.updating));
    final userId = await _readUserId();
    if (userId == null) {
      emit(
        state.copyWith(
          status: CartStatus.failure,
          errorMessage: 'Thiếu thông tin người dùng',
        ),
      );
      return;
    }

    try {
      final cart = await _deleteItem(userId, itemId);
      emit(state.copyWith(status: CartStatus.success, cart: cart));
    } on AppException catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<int?> _readUserId() async {
    final raw = await _storage.read(key: Constants.userId);
    if (raw == null) return null;
    return int.tryParse(raw);
  }
}
