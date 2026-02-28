import '../../data/models/response/user_response.dart';

enum UserStatus { initial, loading, success, failure }

enum UserActionStatus { idle, submitting, success, failure }

class UserState {
  final UserStatus status;
  final UserActionStatus actionStatus;
  final UserResponse? user;
  final String? errorMessage;
  final String? actionMessage;

  const UserState({
    this.status = UserStatus.initial,
    this.actionStatus = UserActionStatus.idle,
    this.user,
    this.errorMessage,
    this.actionMessage,
  });

  UserState copyWith({
    UserStatus? status,
    UserActionStatus? actionStatus,
    UserResponse? user,
    String? errorMessage,
    String? actionMessage,
  }) {
    return UserState(
      status: status ?? this.status,
      actionStatus: actionStatus ?? this.actionStatus,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }
}
