import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shartflix/repository/user_repository.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<LoginRequested>(_onLoginRequested);
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
        emit(UserLoginSuccess(user: response.data));
      } else {
        emit(UserFailure(message: response.message ?? 'Login failed'));
      }
    } catch (e) {
      emit(UserFailure(message: e.toString()));
      rethrow;
    }
  }
}
