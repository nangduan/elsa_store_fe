import 'package:injectable/injectable.dart';

import '../repositories/cart_repository.dart';
import '../../data/models/response/cart_response.dart';

@injectable
class UpdateCartItemQuantityUseCase {
  final CartRepository repository;

  UpdateCartItemQuantityUseCase(this.repository);

  Future<CartResponse?> call(int userId, int itemId, int quantity) {
    return repository.updateItemQuantity(userId, itemId, quantity);
  }
}
