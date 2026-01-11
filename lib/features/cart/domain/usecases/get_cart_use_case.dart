import 'package:injectable/injectable.dart';

import '../repositories/cart_repository.dart';
import '../../data/models/response/cart_response.dart';

@injectable
class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  Future<CartResponse?> call(int userId) {
    return repository.getCart(userId);
  }
}
