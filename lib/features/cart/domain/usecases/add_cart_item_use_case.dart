import 'package:injectable/injectable.dart';

import '../repositories/cart_repository.dart';
import '../../data/models/response/cart_response.dart';

@injectable
class AddCartItemUseCase {
  final CartRepository repository;

  AddCartItemUseCase(this.repository);

  Future<CartResponse?> call(int userId, int productVariantId, int quantity) {
    return repository.addItem(userId, productVariantId, quantity);
  }
}
