import 'package:injectable/injectable.dart';

import '../../data/models/response/promotion_response.dart';
import '../repositories/promotion_repository.dart';

@injectable
class GetPromotionsUseCase {
  final PromotionRepository repository;

  GetPromotionsUseCase(this.repository);

  Future<List<PromotionResponse>> call() {
    return repository.getPromotions();
  }
}
