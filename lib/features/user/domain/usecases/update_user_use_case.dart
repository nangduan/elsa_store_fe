import 'package:injectable/injectable.dart';

import '../../data/models/request/update_user_request.dart';
import '../../data/models/response/user_response.dart';
import '../repositories/user_repository.dart';

@injectable
class UpdateUserUseCase {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  Future<UserResponse?> call(int id, UpdateUserRequest request) {
    return repository.updateUser(id, request);
  }
}
