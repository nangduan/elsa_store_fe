import 'package:injectable/injectable.dart';

import '../repositories/cart_repository.dart';
import '../../data/models/response/cart_response.dart';

@injectable
class DeleteCartItemUseCase {
  final CartRepository repository;

  DeleteCartItemUseCase(this.repository);

  Future<CartResponse?> call(int userId, int itemId) {
    return repository.deleteItem(userId, itemId);
  }
}
