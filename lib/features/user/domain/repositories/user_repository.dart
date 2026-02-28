import '../../data/models/request/update_user_request.dart';
import '../../data/models/response/user_response.dart';

abstract class UserRepository {
  Future<UserResponse?> getUserById(int id);
  Future<UserResponse?> updateUser(int id, UpdateUserRequest request);
}
