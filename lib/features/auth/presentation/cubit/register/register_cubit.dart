import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/errors/app_exception.dart';
import '../../../data/models/request/login_request.dart';
import '../../../data/models/request/register_request.dart';
import '../../../domain/usecases/login_use_case.dart';
import '../../../domain/usecases/register_use_case.dart';

part 'register_state.dart';
part 'register_cubit.freezed.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase _register;
  final LoginUseCase _login;

  RegisterCubit(this._register, this._login) : super(RegisterState());

  Future<void> register(RegisterRequest request) async {
    emit(state.copyWith(status: RegisterStatus.loading));
    try {
      await _register.call(request);
      final authResponse = await _login.call(
        LoginRequest(username: request.username, password: request.password),
      );

      if (authResponse.authenticated ?? false) {
        emit(state.copyWith(status: RegisterStatus.success));
        return;
      }

      emit(
        state.copyWith(
          status: RegisterStatus.failure,
          errorMessage: 'Dang ky thanh cong nhung dang nhap that bai',
        ),
      );
    } on AppException catch (e) {
      emit(
        state.copyWith(status: RegisterStatus.failure, errorMessage: e.message),
      );
    }
  }
}
