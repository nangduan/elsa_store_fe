// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:flutter_skeleton/core/api/dio_client.dart' as _i520;
import 'package:flutter_skeleton/core/di/network_module.dart' as _i261;
import 'package:flutter_skeleton/features/admin/data/datasource/remote/category_api_service.dart'
    as _i299;
import 'package:flutter_skeleton/features/admin/data/datasource/remote/product_api_service.dart'
    as _i888;
import 'package:flutter_skeleton/features/admin/data/datasource/remote/product_variant_api_service.dart'
    as _i91;
import 'package:flutter_skeleton/features/admin/data/datasource/remote/promotion_api_service.dart'
    as _i367;
import 'package:flutter_skeleton/features/admin/data/datasource/remote/supplier_api_service.dart'
    as _i792;
import 'package:flutter_skeleton/features/admin/data/repository/category_repository_impl.dart'
    as _i885;
import 'package:flutter_skeleton/features/admin/data/repository/product_repository_impl.dart'
    as _i316;
import 'package:flutter_skeleton/features/admin/data/repository/product_variant_repository_impl.dart'
    as _i828;
import 'package:flutter_skeleton/features/admin/data/repository/promotion_repository_impl.dart'
    as _i907;
import 'package:flutter_skeleton/features/admin/data/repository/supplier_repository_impl.dart'
    as _i210;
import 'package:flutter_skeleton/features/admin/domain/repositories/category_repository.dart'
    as _i88;
import 'package:flutter_skeleton/features/admin/domain/repositories/product_repository.dart'
    as _i195;
import 'package:flutter_skeleton/features/admin/domain/repositories/product_variant_repository.dart'
    as _i987;
import 'package:flutter_skeleton/features/admin/domain/repositories/promotion_repository.dart'
    as _i1041;
import 'package:flutter_skeleton/features/admin/domain/repositories/supplier_repository.dart'
    as _i413;
import 'package:flutter_skeleton/features/admin/domain/usecases/create_category_use_case.dart'
    as _i663;
import 'package:flutter_skeleton/features/admin/domain/usecases/create_product_use_case.dart'
    as _i1051;
import 'package:flutter_skeleton/features/admin/domain/usecases/create_product_variant_use_case.dart'
    as _i767;
import 'package:flutter_skeleton/features/admin/domain/usecases/create_promotion_use_case.dart'
    as _i152;
import 'package:flutter_skeleton/features/admin/domain/usecases/create_supplier_use_case.dart'
    as _i73;
import 'package:flutter_skeleton/features/admin/domain/usecases/delete_category_use_case.dart'
    as _i770;
import 'package:flutter_skeleton/features/admin/domain/usecases/delete_product_use_case.dart'
    as _i474;
import 'package:flutter_skeleton/features/admin/domain/usecases/delete_product_variant_use_case.dart'
    as _i119;
import 'package:flutter_skeleton/features/admin/domain/usecases/delete_promotion_use_case.dart'
    as _i721;
import 'package:flutter_skeleton/features/admin/domain/usecases/delete_supplier_use_case.dart'
    as _i244;
import 'package:flutter_skeleton/features/admin/domain/usecases/get_admin_product_variants_use_case.dart'
    as _i726;
import 'package:flutter_skeleton/features/admin/domain/usecases/get_categories_use_case.dart'
    as _i745;
import 'package:flutter_skeleton/features/admin/domain/usecases/get_products_use_case.dart'
    as _i695;
import 'package:flutter_skeleton/features/admin/domain/usecases/get_promotions_use_case.dart'
    as _i661;
import 'package:flutter_skeleton/features/admin/domain/usecases/get_suppliers_use_case.dart'
    as _i990;
import 'package:flutter_skeleton/features/admin/domain/usecases/update_category_use_case.dart'
    as _i371;
import 'package:flutter_skeleton/features/admin/domain/usecases/update_product_use_case.dart'
    as _i973;
import 'package:flutter_skeleton/features/admin/domain/usecases/update_product_variant_use_case.dart'
    as _i919;
import 'package:flutter_skeleton/features/admin/domain/usecases/update_promotion_use_case.dart'
    as _i222;
import 'package:flutter_skeleton/features/admin/domain/usecases/update_supplier_use_case.dart'
    as _i1046;
import 'package:flutter_skeleton/features/admin/presentation/cubit/admin_product_variant_cubit.dart'
    as _i245;
import 'package:flutter_skeleton/features/admin/presentation/cubit/category_cubit.dart'
    as _i646;
import 'package:flutter_skeleton/features/admin/presentation/cubit/product_cubit.dart'
    as _i318;
import 'package:flutter_skeleton/features/admin/presentation/cubit/promotion_cubit.dart'
    as _i245;
import 'package:flutter_skeleton/features/admin/presentation/cubit/supplier_cubit.dart'
    as _i947;
import 'package:flutter_skeleton/features/auth/data/datasource/remote/auth_api_service.dart'
    as _i189;
import 'package:flutter_skeleton/features/auth/data/repository/auth_repository_impl.dart'
    as _i52;
import 'package:flutter_skeleton/features/auth/domain/repositories/auth_repository.dart'
    as _i518;
import 'package:flutter_skeleton/features/auth/domain/usecases/login_use_case.dart'
    as _i633;
import 'package:flutter_skeleton/features/auth/domain/usecases/logout_use_case.dart'
    as _i381;
import 'package:flutter_skeleton/features/auth/domain/usecases/register_use_case.dart'
    as _i235;
import 'package:flutter_skeleton/features/home/data/datasource/remote/home_api_service.dart'
    as _i578;
import 'package:flutter_skeleton/features/home/data/repository/home_repository_impl.dart'
    as _i466;
import 'package:flutter_skeleton/features/home/domain/repositories/home_repository.dart'
    as _i275;
import 'package:flutter_skeleton/features/home/domain/usecases/get_categories_use_case.dart'
    as _i602;
import 'package:flutter_skeleton/features/home/domain/usecases/get_products_use_case.dart'
    as _i131;
import 'package:flutter_skeleton/features/home/presentation/cubit/home_cubit.dart'
    as _i233;
import 'package:flutter_skeleton/features/product/data/datasource/remote/product_api_service.dart'
    as _i1001;
import 'package:flutter_skeleton/features/product/data/repository/product_repository_impl.dart'
    as _i511;
import 'package:flutter_skeleton/features/product/domain/repositories/product_repository.dart'
    as _i564;
import 'package:flutter_skeleton/features/product/domain/usecases/get_product_variants_use_case.dart'
    as _i983;
import 'package:flutter_skeleton/features/product/presentation/cubit/product_variant_cubit.dart'
    as _i363;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final networkModule = _$NetworkModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => networkModule.provideSecureStorage(),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.provideDio(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i520.DioClient>(
      () => networkModule.provideDioClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i189.AuthApiService>(
      () => networkModule.provideAuthApiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i578.HomeApiService>(
      () => networkModule.provideHomeApiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1001.ProductApiService>(
      () => networkModule.provideProductApiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i792.SupplierApiService>(
      () => networkModule.provideSupplierApiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i299.CategoryApiService>(
      () => networkModule.provideCategoryApiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i888.AdminProductApiService>(
      () => networkModule.provideAdminProductApiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i91.AdminProductVariantApiService>(
      () => networkModule.provideAdminProductVariantApiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i367.AdminPromotionApiService>(
      () => networkModule.provideAdminPromotionApiService(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i195.ProductRepository>(
      () => _i316.ProductRepositoryImpl(
        gh<_i888.AdminProductApiService>(),
        gh<_i520.DioClient>(),
      ),
    );
    gh.lazySingleton<_i275.HomeRepository>(
      () => _i466.HomeRepositoryImpl(
        gh<_i578.HomeApiService>(),
        gh<_i520.DioClient>(),
      ),
    );
    gh.factory<_i602.GetCategoriesUseCase>(
      () => _i602.GetCategoriesUseCase(gh<_i275.HomeRepository>()),
    );
    gh.factory<_i131.GetProductsUseCase>(
      () => _i131.GetProductsUseCase(gh<_i275.HomeRepository>()),
    );
    gh.lazySingleton<_i987.ProductVariantRepository>(
      () => _i828.ProductVariantRepositoryImpl(
        gh<_i91.AdminProductVariantApiService>(),
        gh<_i520.DioClient>(),
      ),
    );
    gh.lazySingleton<_i1041.PromotionRepository>(
      () => _i907.PromotionRepositoryImpl(
        gh<_i367.AdminPromotionApiService>(),
        gh<_i520.DioClient>(),
      ),
    );
    gh.lazySingleton<_i413.SupplierRepository>(
      () => _i210.SupplierRepositoryImpl(
        gh<_i792.SupplierApiService>(),
        gh<_i520.DioClient>(),
      ),
    );
    gh.factory<_i1051.CreateProductUseCase>(
      () => _i1051.CreateProductUseCase(gh<_i195.ProductRepository>()),
    );
    gh.factory<_i474.DeleteProductUseCase>(
      () => _i474.DeleteProductUseCase(gh<_i195.ProductRepository>()),
    );
    gh.factory<_i695.GetProductsUseCase>(
      () => _i695.GetProductsUseCase(gh<_i195.ProductRepository>()),
    );
    gh.factory<_i973.UpdateProductUseCase>(
      () => _i973.UpdateProductUseCase(gh<_i195.ProductRepository>()),
    );
    gh.lazySingleton<_i564.ProductRepository>(
      () => _i511.ProductRepositoryImpl(
        gh<_i1001.ProductApiService>(),
        gh<_i520.DioClient>(),
      ),
    );
    gh.factory<_i767.CreateProductVariantUseCase>(
      () => _i767.CreateProductVariantUseCase(
        gh<_i987.ProductVariantRepository>(),
      ),
    );
    gh.factory<_i119.DeleteProductVariantUseCase>(
      () => _i119.DeleteProductVariantUseCase(
        gh<_i987.ProductVariantRepository>(),
      ),
    );
    gh.factory<_i726.GetAdminProductVariantsUseCase>(
      () => _i726.GetAdminProductVariantsUseCase(
        gh<_i987.ProductVariantRepository>(),
      ),
    );
    gh.factory<_i919.UpdateProductVariantUseCase>(
      () => _i919.UpdateProductVariantUseCase(
        gh<_i987.ProductVariantRepository>(),
      ),
    );
    gh.lazySingleton<_i88.CategoryRepository>(
      () => _i885.CategoryRepositoryImpl(
        gh<_i299.CategoryApiService>(),
        gh<_i520.DioClient>(),
      ),
    );
    gh.factory<_i73.CreateSupplierUseCase>(
      () => _i73.CreateSupplierUseCase(gh<_i413.SupplierRepository>()),
    );
    gh.factory<_i244.DeleteSupplierUseCase>(
      () => _i244.DeleteSupplierUseCase(gh<_i413.SupplierRepository>()),
    );
    gh.factory<_i990.GetSuppliersUseCase>(
      () => _i990.GetSuppliersUseCase(gh<_i413.SupplierRepository>()),
    );
    gh.factory<_i1046.UpdateSupplierUseCase>(
      () => _i1046.UpdateSupplierUseCase(gh<_i413.SupplierRepository>()),
    );
    gh.lazySingleton<_i518.AuthRepository>(
      () => _i52.AuthRepositoryImpl(
        gh<_i189.AuthApiService>(),
        gh<_i520.DioClient>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i245.AdminProductVariantCubit>(
      () => _i245.AdminProductVariantCubit(
        gh<_i726.GetAdminProductVariantsUseCase>(),
        gh<_i767.CreateProductVariantUseCase>(),
        gh<_i919.UpdateProductVariantUseCase>(),
        gh<_i119.DeleteProductVariantUseCase>(),
      ),
    );
    gh.factory<_i233.HomeCubit>(
      () => _i233.HomeCubit(
        gh<_i602.GetCategoriesUseCase>(),
        gh<_i131.GetProductsUseCase>(),
      ),
    );
    gh.factory<_i663.CreateCategoryUseCase>(
      () => _i663.CreateCategoryUseCase(gh<_i88.CategoryRepository>()),
    );
    gh.factory<_i770.DeleteCategoryUseCase>(
      () => _i770.DeleteCategoryUseCase(gh<_i88.CategoryRepository>()),
    );
    gh.factory<_i745.GetCategoriesUseCase>(
      () => _i745.GetCategoriesUseCase(gh<_i88.CategoryRepository>()),
    );
    gh.factory<_i371.UpdateCategoryUseCase>(
      () => _i371.UpdateCategoryUseCase(gh<_i88.CategoryRepository>()),
    );
    gh.factory<_i318.ProductCubit>(
      () => _i318.ProductCubit(
        gh<_i695.GetProductsUseCase>(),
        gh<_i1051.CreateProductUseCase>(),
        gh<_i973.UpdateProductUseCase>(),
        gh<_i474.DeleteProductUseCase>(),
      ),
    );
    gh.factory<_i947.SupplierCubit>(
      () => _i947.SupplierCubit(
        gh<_i990.GetSuppliersUseCase>(),
        gh<_i73.CreateSupplierUseCase>(),
        gh<_i1046.UpdateSupplierUseCase>(),
        gh<_i244.DeleteSupplierUseCase>(),
      ),
    );
    gh.factory<_i646.CategoryCubit>(
      () => _i646.CategoryCubit(
        gh<_i745.GetCategoriesUseCase>(),
        gh<_i663.CreateCategoryUseCase>(),
        gh<_i371.UpdateCategoryUseCase>(),
        gh<_i770.DeleteCategoryUseCase>(),
      ),
    );
    gh.factory<_i633.LoginUseCase>(
      () => _i633.LoginUseCase(gh<_i518.AuthRepository>()),
    );
    gh.factory<_i381.LogoutUseCase>(
      () => _i381.LogoutUseCase(gh<_i518.AuthRepository>()),
    );
    gh.factory<_i235.RegisterUseCase>(
      () => _i235.RegisterUseCase(gh<_i518.AuthRepository>()),
    );
    gh.factory<_i152.CreatePromotionUseCase>(
      () => _i152.CreatePromotionUseCase(gh<_i1041.PromotionRepository>()),
    );
    gh.factory<_i721.DeletePromotionUseCase>(
      () => _i721.DeletePromotionUseCase(gh<_i1041.PromotionRepository>()),
    );
    gh.factory<_i661.GetPromotionsUseCase>(
      () => _i661.GetPromotionsUseCase(gh<_i1041.PromotionRepository>()),
    );
    gh.factory<_i222.UpdatePromotionUseCase>(
      () => _i222.UpdatePromotionUseCase(gh<_i1041.PromotionRepository>()),
    );
    gh.factory<_i983.GetProductVariantsUseCase>(
      () => _i983.GetProductVariantsUseCase(gh<_i564.ProductRepository>()),
    );
    gh.factory<_i245.PromotionCubit>(
      () => _i245.PromotionCubit(
        gh<_i661.GetPromotionsUseCase>(),
        gh<_i152.CreatePromotionUseCase>(),
        gh<_i222.UpdatePromotionUseCase>(),
        gh<_i721.DeletePromotionUseCase>(),
      ),
    );
    gh.factory<_i363.ProductVariantCubit>(
      () => _i363.ProductVariantCubit(gh<_i983.GetProductVariantsUseCase>()),
    );
    return this;
  }
}

class _$NetworkModule extends _i261.NetworkModule {}
