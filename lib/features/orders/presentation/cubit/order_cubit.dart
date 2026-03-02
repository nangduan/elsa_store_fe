import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_skeleton/core/enum/role_enum.dart';
import 'package:flutter_skeleton/core/storage/flutter_store_core.dart';
import 'package:flutter_skeleton/features/orders/domain/usecases/get_orders_by_user_use_case%20copy.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/app_exception.dart';
import '../../data/models/request/create_order_item_request.dart';
import '../../data/models/response/order_response.dart';
import '../../domain/usecases/create_order_use_case.dart';
import '../../domain/usecases/get_orders_use_case.dart';
import '../../domain/usecases/update_order_status_use_case.dart';

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
  final GetOrdersByUserUseCase _getOrdersByUserUseCase;
  final CreateOrderUseCase _createOrder;
  final UpdateOrderStatusUseCase _updateOrderStatus;

  OrderCubit(
    this._getOrders,
    this._getOrdersByUserUseCase,
    this._createOrder,
    this._updateOrderStatus,
  ) : super(const OrderState());

  Future<void> load() async {
    emit(state.copyWith(status: OrderStatus.loading));
    final role = await FlutterStoreCore.readRole();
    late final List<OrderResponse> orders;
    if (role.isAdmin) {
      orders = await _getOrders.call();
    } else {
      final userId = await FlutterStoreCore.readUserId();
      orders = await _getOrdersByUserUseCase.call(userId ?? 0);
    }

    try {
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
    final userId = await FlutterStoreCore.readUserId();
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
      final order = await _createOrder.call(userId, [
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
    final userId = await FlutterStoreCore.readUserId();
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
      final order = await _createOrder.call(userId, items);
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

  Future<OrderResponse?> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final updated = await _updateOrderStatus.call(orderId, status);
      if (updated != null) {
        emit(state.copyWith(orders: _replaceOrder(updated)));
      } else {
        emit(state.copyWith(orders: _replaceOrderStatus(orderId, status)));
      }
      return updated;
    } on AppException catch (e) {
      emit(state.copyWith(errorMessage: e.message));
      rethrow;
    }
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
    final trimmed = value.trim();
    final parsed = DateTime.tryParse(trimmed);
    if (parsed != null) return parsed;

    if (trimmed.contains(' ') && trimmed.contains('-')) {
      final normalizedIso = trimmed.replaceFirst(' ', 'T');
      final parsedIso = DateTime.tryParse(normalizedIso);
      if (parsedIso != null) return parsedIso;
    }

    final normalized = trimmed.replaceAll('-', '/');
    final partsWithTime = normalized.split(' ');
    final parts = normalized.split('/');
    if (parts.length == 3) {
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2].split(' ').first);
      if (day != null && month != null && year != null) {
        int hour = 0;
        int minute = 0;
        int second = 0;
        if (partsWithTime.length > 1) {
          final timeParts = partsWithTime[1].split(':');
          if (timeParts.isNotEmpty) hour = int.tryParse(timeParts[0]) ?? 0;
          if (timeParts.length > 1) {
            minute = int.tryParse(timeParts[1]) ?? 0;
          }
          if (timeParts.length > 2) {
            second = int.tryParse(timeParts[2]) ?? 0;
          }
        }
        return DateTime(year, month, day, hour, minute, second);
      }
    }
    return null;
  }

  List<OrderResponse> _replaceOrder(OrderResponse updated) {
    final orders = List<OrderResponse>.from(state.orders);
    final index = orders.indexWhere((order) => order.id == updated.id);
    if (index >= 0) {
      orders[index] = updated;
    } else {
      orders.insert(0, updated);
    }
    return orders;
  }

  List<OrderResponse> _replaceOrderStatus(int orderId, String status) {
    return state.orders
        .map(
          (order) => order.id == orderId
              ? OrderResponse(
                  id: order.id,
                  code: order.code,
                  orderDate: order.orderDate,
                  totalAmount: order.totalAmount,
                  finalAmount: order.finalAmount,
                  status: status,
                  paymentMethod: order.paymentMethod,
                  paymentStatus: order.paymentStatus,
                  paymentUrl: order.paymentUrl,
                  items: order.items,
                )
              : order,
        )
        .toList();
  }
}
