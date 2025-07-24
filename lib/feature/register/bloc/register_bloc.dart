import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:shartflix/feature/register/bloc/email_input.dart';
import 'package:shartflix/feature/register/bloc/name_input.dart';
import 'package:shartflix/feature/register/bloc/password_input.dart';

part 'register_event.dart';

part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(const RegisterState()) {
    on<RegisterNameChanged>(_onNameChanged);
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<RegisterSubmitted>(_onSubmitted);
  }

  void _onNameChanged(RegisterNameChanged event, Emitter<RegisterState> emit) {
    final name = NameInput.dirty(event.name);
    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([
          name,
          state.email,
          state.password,
          state.confirmPassword,
        ]),
      ),
    );
  }

  void _onEmailChanged(
    RegisterEmailChanged event,
    Emitter<RegisterState> emit,
  ) {
    final email = EmailInput.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([
          state.name,
          email,
          state.password,
          state.confirmPassword,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    RegisterPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final password = PasswordInput.dirty(event.password);
    final confirmPassword = PasswordInput.dirty(state.confirmPassword.value);
    emit(
      state.copyWith(
        password: password,
        confirmPassword: confirmPassword,
        status: Formz.validate([
          state.name,
          state.email,
          password,
          confirmPassword,
        ]),
      ),
    );
  }

  void _onConfirmPasswordChanged(
    RegisterConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    final confirmPassword = PasswordInput.dirty(event.confirmPassword);
    final password = state.password;
    final passwordsMatch = password.value == confirmPassword.value;
    emit(
      state.copyWith(
        confirmPassword: confirmPassword,
        status:
            Formz.validate([
              state.name,
              state.email,
              password,
              confirmPassword,
            ]) &&
            passwordsMatch,
      ),
    );
  }

  void _onSubmitted(RegisterSubmitted event, Emitter<RegisterState> emit) {
    final name = NameInput.dirty(state.name.value);
    final email = EmailInput.dirty(state.email.value);
    final password = PasswordInput.dirty(state.password.value);
    final confirmPassword = PasswordInput.dirty(state.confirmPassword.value);
    emit(
      state.copyWith(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        status: Formz.validate([
          name,
          email,
          password,
          confirmPassword,
        ]),
      ),
    );
  }
}
