import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/errors/app_exception.dart';
import '../../data/models/request/create_order_item_request.dart';
import '../../data/models/response/order_response.dart';
import '../../domain/usecases/create_order_use_case.dart';
import '../../domain/usecases/get_orders_use_case.dart';

enum OrderStatus { initial, loading, success, failure, creating }

class OrderState {
  final OrderStatus status;
  final List<OrderResponse> orders;
  final OrderResponse? lastOrder;
  final String? errorMessage;

  const OrderState({
    this.status = OrderStatus.initial,
    this.orders = const [],
    this.lastOrder,
    this.errorMessage,
  });

  OrderState copyWith({
    OrderStatus? status,
    List<OrderResponse>? orders,
    OrderResponse? lastOrder,
    String? errorMessage,
  }) {
    return OrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      lastOrder: lastOrder ?? this.lastOrder,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

@injectable
class OrderCubit extends Cubit<OrderState> {
  final GetOrdersUseCase _getOrders;
  final CreateOrderUseCase _createOrder;
  final FlutterSecureStorage _storage;

  OrderCubit(this._getOrders, this._createOrder, this._storage)
    : super(const OrderState());

  Future<void> load() async {
    emit(state.copyWith(status: OrderStatus.loading));
    final userId = await _readUserId();
    if (userId == null) {
      emit(
        state.copyWith(
          status: OrderStatus.failure,
          errorMessage: 'Thiếu thông tin người dùng',
        ),
      );
      return;
    }

    try {
      final orders = await _getOrders(userId);
      final sortedOrders = List<OrderResponse>.from(orders)
        ..sort(_compareOrderDateDesc);
      emit(state.copyWith(status: OrderStatus.success, orders: sortedOrders));
    } on AppException catch (e) {
      emit(
        state.copyWith(status: OrderStatus.failure, errorMessage: e.message),
      );
    }
  }

  Future<OrderResponse?> createOrderForItem({
    required int productVariantId,
    required int quantity,
  }) async {
    emit(state.copyWith(status: OrderStatus.creating));
    final userId = await _readUserId();
    if (userId == null) {
      final error = AppException(
        message: 'Thiếu thông tin người dùng',
        code: 0,
      );
      emit(
        state.copyWith(
          status: OrderStatus.failure,
          errorMessage: error.message,
        ),
      );
      throw error;
    }

    try {
      final order = await _createOrder(userId, [
        CreateOrderItemRequest(
          productVariantId: productVariantId,
          quantity: quantity,
        ),
      ]);
      final updatedOrders = order == null
          ? state.orders
          : [order, ...state.orders];
      emit(
        state.copyWith(
          status: OrderStatus.success,
          lastOrder: order,
          orders: updatedOrders,
        ),
      );
      return order;
    } on AppException catch (e) {
      emit(
        state.copyWith(status: OrderStatus.failure, errorMessage: e.message),
      );
      rethrow;
    }
  }

  Future<OrderResponse?> createOrderForItems(
    List<CreateOrderItemRequest> items,
  ) async {
    if (items.isEmpty) {
      final error = AppException(message: 'Giỏ hàng đang trống', code: 0);
      emit(
        state.copyWith(
          status: OrderStatus.failure,
          errorMessage: error.message,
        ),
      );
      throw error;
    }

    emit(state.copyWith(status: OrderStatus.creating));
    final userId = await _readUserId();
    if (userId == null) {
      final error = AppException(
        message: 'Thiếu thông tin người dùng',
        code: 0,
      );
      emit(
        state.copyWith(
          status: OrderStatus.failure,
          errorMessage: error.message,
        ),
      );
      throw error;
    }

    try {
      final order = await _createOrder(userId, items);
      final updatedOrders = order == null
          ? state.orders
          : [order, ...state.orders];
      emit(
        state.copyWith(
          status: OrderStatus.success,
          lastOrder: order,
          orders: updatedOrders,
        ),
      );
      return order;
    } on AppException catch (e) {
      emit(
        state.copyWith(status: OrderStatus.failure, errorMessage: e.message),
      );
      rethrow;
    }
  }

  Future<int?> _readUserId() async {
    final raw = await _storage.read(key: Constants.userId);
    if (raw == null) return null;
    return int.tryParse(raw);
  }

  int _compareOrderDateDesc(OrderResponse a, OrderResponse b) {
    final aDate = _parseOrderDate(a.orderDate);
    final bDate = _parseOrderDate(b.orderDate);
    if (aDate == null && bDate == null) return 0;
    if (aDate == null) return 1;
    if (bDate == null) return -1;
    return bDate.compareTo(aDate);
  }

  DateTime? _parseOrderDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed != null) return parsed;

    final normalized = value.replaceAll('-', '/');
    final parts = normalized.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day != null && month != null && year != null) {
        return DateTime(year, month, day);
      }
    }
    return null;
  }
}
