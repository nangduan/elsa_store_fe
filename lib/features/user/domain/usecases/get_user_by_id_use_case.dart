import 'package:injectable/injectable.dart';

import '../../data/models/response/user_response.dart';
import '../repositories/user_repository.dart';

@injectable
class GetUserByIdUseCase {
  final UserRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<UserResponse?> call(int id) {
    return repository.getUserById(id);
  }
}
