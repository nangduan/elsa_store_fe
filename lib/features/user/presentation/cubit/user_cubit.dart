import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_skeleton/features/user/presentation/cubit/user_state.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constant.dart';
import '../../../../core/errors/app_exception.dart';
import '../../data/models/request/update_user_request.dart';
import '../../domain/usecases/change_password_use_case.dart';
import '../../domain/usecases/get_user_by_id_use_case.dart';
import '../../domain/usecases/update_user_use_case.dart';

@injectable
class UserCubit extends Cubit<UserState> {
  final GetUserByIdUseCase _getUserById;
  final UpdateUserUseCase _updateUser;
  final ChangePasswordUseCase _changePassword;
  final FlutterSecureStorage _storage;

  UserCubit(
    this._getUserById,
    this._updateUser,
    this._changePassword,
    this._storage,
  ) : super(const UserState());

  Future<void> load() async {
    emit(state.copyWith(status: UserStatus.loading, errorMessage: null));
    final userId = await _readUserId();
    if (userId == null) {
      emit(
        state.copyWith(
          status: UserStatus.failure,
          errorMessage: 'Thiếu thông tin người dùng',
        ),
      );
      return;
    }

    try {
      final user = await _getUserById(userId);
      if (user == null) {
        emit(
          state.copyWith(
            status: UserStatus.failure,
            errorMessage: 'Không tìm thấy người dùng',
          ),
        );
        return;
      }
      emit(state.copyWith(status: UserStatus.success, user: user));
    } on AppException catch (e) {
      emit(state.copyWith(status: UserStatus.failure, errorMessage: e.message));
    }
  }

  Future<bool> updateProfile({
    required String email,
    required String phone,
    required String fullName,
  }) async {
    final user = state.user;
    if (user == null || user.id == null) {
      emit(
        state.copyWith(
          actionStatus: UserActionStatus.failure,
          actionMessage: 'Thiếu thông tin người dùng',
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        actionStatus: UserActionStatus.submitting,
        actionMessage: null,
      ),
    );

    try {
      final updated = await _updateUser(
        user.id!,
        UpdateUserRequest(
          username: user.username,
          email: email,
          phone: phone,
          fullName: fullName,
          enabled: user.enabled ?? true,
        ),
      );
      if (updated == null) {
        emit(
          state.copyWith(
            actionStatus: UserActionStatus.failure,
            actionMessage: 'Cập nhật thất bại',
          ),
        );
        return false;
      }
      emit(
        state.copyWith(
          user: updated,
          actionStatus: UserActionStatus.success,
          actionMessage: 'Cập nhật thành công',
        ),
      );
      return true;
    } on AppException catch (e) {
      emit(
        state.copyWith(
          actionStatus: UserActionStatus.failure,
          actionMessage: e.message,
        ),
      );
      return false;
    }
  }

  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final user = state.user;
    if (user == null || user.id == null) {
      emit(
        state.copyWith(
          actionStatus: UserActionStatus.failure,
          actionMessage: 'Thiếu thông tin người dùng',
        ),
      );
      return false;
    }

    emit(
      state.copyWith(
        actionStatus: UserActionStatus.submitting,
        actionMessage: null,
      ),
    );

    try {
      final updated = await _changePassword(
        user.id!,
        UpdateUserRequest(
          username: user.username,
          email: user.email,
          phone: user.phone,
          fullName: user.fullName,
          enabled: user.enabled ?? true,
          oldPassword: oldPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );
      if (updated == null) {
        emit(
          state.copyWith(
            actionStatus: UserActionStatus.failure,
            actionMessage: 'Đổi mật khẩu thất bại',
          ),
        );
        return false;
      }
      emit(
        state.copyWith(
          user: updated,
          actionStatus: UserActionStatus.success,
          actionMessage: 'Đổi mật khẩu thành công',
        ),
      );
      return true;
    } on AppException catch (e) {
      emit(
        state.copyWith(
          actionStatus: UserActionStatus.failure,
          actionMessage: e.message,
        ),
      );
      return false;
    }
  }

  Future<int?> _readUserId() async {
    final raw = await _storage.read(key: Constants.userId);
    if (raw == null) return null;
    return int.tryParse(raw);
  }
}
