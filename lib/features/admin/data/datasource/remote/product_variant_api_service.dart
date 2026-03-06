import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../../../core/shared/data/models/api_response.dart';
import '../../models/request/product_variant_request.dart';

class AdminProductVariantApiService {
  final Dio _dio;

  AdminProductVariantApiService(this._dio);

  Future<ApiResponse> getProductVariants(int productId) async {
    final response = await _dio.get(
      '/product-variants',
      queryParameters: {'productId': productId},
    );
    return _wrapResponse(response);
  }

  Future<ApiResponse> createProductVariant(ProductVariantRequest body) async {
    final payload = FormData.fromMap({
      'data': MultipartFile.fromString(
        jsonEncode(body.toJson()),
        contentType: MediaType('application', 'json'),
      ),
    });

    if (body.imagePath != null && body.imagePath!.isNotEmpty) {
      payload.files.add(
        MapEntry(
          'files',
          await MultipartFile.fromFile(
            body.imagePath!,
            filename: _fileNameFromPath(body.imagePath!),
          ),
        ),
      );
    }

    final response = await _dio.post('/product-variants', data: payload);
    return _wrapResponse(response);
  }

  Future<ApiResponse> updateProductVariant(
    int id,
    ProductVariantRequest body,
  ) async {
    final response = await _dio.put(
      '/product-variants/$id',
      data: body.toJson(),
    );
    return _wrapResponse(response);
  }

  Future<void> deleteProductVariant(int id) async {
    await _dio.delete('/product-variants/$id');
  }

  ApiResponse _wrapResponse(Response response) {
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return ApiResponse.fromJson(data);
    }
    return ApiResponse(data: data);
  }

  String _fileNameFromPath(String path) {
    final normalized = path.replaceAll('\\', '/');
    return normalized.split('/').last;
  }
}
