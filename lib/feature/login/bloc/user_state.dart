part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoginSuccess extends UserState {
  const UserLoginSuccess({required this.user});

  final dynamic user;

  @override
  List<Object?> get props => [user];
}

class UserFailure extends UserState {
  const UserFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
