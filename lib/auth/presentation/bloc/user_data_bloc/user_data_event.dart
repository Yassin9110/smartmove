part of 'user_data_bloc.dart';

@immutable
abstract class UserEvent {}

class SetUserEvent extends UserEvent {
  final UserModel userModel;

  SetUserEvent({required this.userModel});
}
class UpdateUserEvent extends UserEvent {
  final UserModel userModel;

  UpdateUserEvent({required this.userModel});
}

class GetUserEvent extends UserEvent {}