import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:shartflix/model/dto/user/user_dto.dart';
import 'package:shartflix/model/enum/register_failure.dart';
import 'package:shartflix/repository/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<RegisterRequested>(_onRegisterRequested);
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

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await userRepository.register(
        email: event.email,
        password: event.password,
        name: event.name,
      );
      if (response.isOk) {
        final data = response.data as Map<String, dynamic>;
        final user = UserDTO.fromJson(data['data'] as Map<String, dynamic>);
        userRepository.setToken(OAuth2Token(accessToken: user.token));
        emit(UserRegisterSuccess(user: user));
      } else {
        emit(
          UserRegisterFailure(
            message: response.message ?? 'Register failed',
            registerFailure: RegisterFailure.fromCode(
              response.message ?? 'UNKNOWN_ERROR',
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        UserRegisterFailure(
          message: e.toString(),
          registerFailure: RegisterFailure.unknownError,
        ),
      );
      rethrow;
    }
  }
}
