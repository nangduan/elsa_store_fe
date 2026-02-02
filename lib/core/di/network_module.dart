import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../../features/admin/data/datasource/remote/product_variant_api_service.dart';
import '../../features/admin/data/datasource/remote/promotion_api_service.dart';
import '../../features/auth/data/datasource/remote/auth_api_service.dart';
import '../../features/home/data/datasource/remote/home_api_service.dart';
import '../../features/cart/data/datasource/remote/cart_api_service.dart';
import '../../features/orders/data/datasource/remote/order_api_service.dart';
import '../../features/product/data/datasource/remote/product_api_service.dart';
import '../../features/revenues/data/datasource/remote/revenue_api_service.dart';
import '../../features/admin/data/datasource/remote/category_api_service.dart';
import '../../features/admin/data/datasource/remote/product_api_service.dart';
import '../../features/admin/data/datasource/remote/supplier_api_service.dart';
import '../api/app_config.dart';
import '../api/auth_interceptor.dart';
import '../api/dio_client.dart';

@module
abstract class NetworkModule {
  @lazySingleton
  FlutterSecureStorage provideSecureStorage() => const FlutterSecureStorage();

  @lazySingleton
  Dio provideDio(FlutterSecureStorage storage) {
    final cfg = AppConfig();

    final dio = Dio(
      BaseOptions(
        baseUrl: cfg.baseURL,
        connectTimeout: Duration(milliseconds: cfg.connectTimeout),
        sendTimeout: Duration(milliseconds: cfg.sendTimeout),
        receiveTimeout: Duration(milliseconds: cfg.receiveTimeout),
        contentType: cfg.contentType,
        headers: cfg.standardHeaders,
      ),
    );

    dio.interceptors.add(AuthInterceptor(dio, storage));
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return dio;
  }

  @lazySingleton
  DioClient provideDioClient(Dio dio) => DioClient(dio);

  @lazySingleton
  AuthApiService provideAuthApiService(Dio dio) => AuthApiService(dio);

  @lazySingleton
  HomeApiService provideHomeApiService(Dio dio) => HomeApiService(dio);

  @lazySingleton
  CartApiService provideCartApiService(Dio dio) => CartApiService(dio);

  @lazySingleton
  OrderApiService provideOrderApiService(Dio dio) => OrderApiService(dio);

  @lazySingleton
  RevenueApiService provideRevenueApiService(Dio dio) =>
      RevenueApiService(dio);

  @lazySingleton
  ProductApiService provideProductApiService(Dio dio) => ProductApiService(dio);

  @lazySingleton
  SupplierApiService provideSupplierApiService(Dio dio) =>
      SupplierApiService(dio);

  @lazySingleton
  CategoryApiService provideCategoryApiService(Dio dio) =>
      CategoryApiService(dio);

  @lazySingleton
  AdminProductApiService provideAdminProductApiService(Dio dio) =>
      AdminProductApiService(dio);

  @lazySingleton
  AdminProductVariantApiService provideAdminProductVariantApiService(Dio dio) =>
      AdminProductVariantApiService(dio);

  @lazySingleton
  AdminPromotionApiService provideAdminPromotionApiService(Dio dio) =>
      AdminPromotionApiService(dio);
}
