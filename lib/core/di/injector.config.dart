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
    gh.lazySingleton<_i518.AuthRepository>(
      () => _i52.AuthRepositoryImpl(
        gh<_i189.AuthApiService>(),
        gh<_i520.DioClient>(),
        gh<_i558.FlutterSecureStorage>(),
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
    return this;
  }
}

class _$NetworkModule extends _i261.NetworkModule {}
