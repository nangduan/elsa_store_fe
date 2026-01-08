import '../../data/models/request/promotion_request.dart';
import '../../data/models/response/promotion_response.dart';

abstract class PromotionRepository {
  Future<List<PromotionResponse>> getPromotions();
  Future<PromotionResponse?> createPromotion(PromotionRequest request);
  Future<PromotionResponse?> updatePromotion(int id, PromotionRequest request);
  Future<void> deletePromotion(int id);
}
