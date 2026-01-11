import '../../data/models/response/cart_response.dart';

abstract class CartRepository {
  Future<CartResponse?> getCart(int userId);
  Future<CartResponse?> addItem(int userId, int productVariantId, int quantity);
  Future<CartResponse?> updateItemQuantity(int userId, int itemId, int quantity);
  Future<CartResponse?> deleteItem(int userId, int itemId);
}
