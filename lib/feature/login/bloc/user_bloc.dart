import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:shartflix/model/dto/user/user_dto.dart';
import 'package:shartflix/repository/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  final UserRepository userRepository;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await userRepository.login(
        email: event.email,
        password: event.password,
      );
      if (response.isOk) {
        final data = response.data as Map<String, dynamic>;
        final user = UserDTO.fromJson(data['data'] as Map<String, dynamic>);
        userRepository.setToken(OAuth2Token(accessToken: user.token));
        emit(UserLoginSuccess(user: response.data));
      } else {
        emit(UserFailure(message: response.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(UserFailure(message: e.toString()));
      rethrow;
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserInitial());
    try {
      userRepository.logout();
    } catch (e) {
      emit(UserFailure(message: e.toString()));
      rethrow;
    }
  }
}
