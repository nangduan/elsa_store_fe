import 'package:injectable/injectable.dart';

import '../../data/models/request/promotion_request.dart';
import '../../data/models/response/promotion_response.dart';
import '../repositories/promotion_repository.dart';

@injectable
class UpdatePromotionUseCase {
  final PromotionRepository repository;

  UpdatePromotionUseCase(this.repository);

  Future<PromotionResponse?> call(int id, PromotionRequest request) {
    return repository.updatePromotion(id, request);
  }
}
