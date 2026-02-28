import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/dio_client.dart';
import '../datasource/remote/user_api_service.dart';
import '../models/request/update_user_request.dart';
import '../models/response/user_response.dart';
import '../../domain/repositories/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserApiService apiService;
  final DioClient dioClient;

  UserRepositoryImpl(this.apiService, this.dioClient);

  @override
  Future<UserResponse?> getUserById(int id) async {
    try {
      final apiResp = await apiService.getUserById(id);
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return UserResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }

  @override
  Future<UserResponse?> updateUser(int id, UpdateUserRequest request) async {
    try {
      final apiResp = await apiService.updateUser(id, request.toJson());
      final data = apiResp.data;
      if (data is Map<String, dynamic>) {
        return UserResponse.fromJson(data);
      }
      return null;
    } on DioException catch (e) {
      throw dioClient.handleDioError(e);
    }
  }
}
