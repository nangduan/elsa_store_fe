import 'package:injectable/injectable.dart';

import '../../data/models/request/promotion_request.dart';
import '../../data/models/response/promotion_response.dart';
import '../repositories/promotion_repository.dart';

@injectable
class CreatePromotionUseCase {
  final PromotionRepository repository;

  CreatePromotionUseCase(this.repository);

  Future<PromotionResponse?> call(PromotionRequest request) {
    return repository.createPromotion(request);
  }
}
