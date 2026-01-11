import 'package:injectable/injectable.dart';

import '../repositories/promotion_repository.dart';

@injectable
class DeletePromotionUseCase {
  final PromotionRepository repository;

  DeletePromotionUseCase(this.repository);

  Future<void> call(int id) {
    return repository.deletePromotion(id);
  }
}
