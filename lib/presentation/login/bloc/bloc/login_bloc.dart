import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginState.initial()) {
    on<LoginLoginButtonClicked>(_loginButtonClicked);
    //on<LoginLoginButtonClicked>((e, ee) => ); //проверка типа
    on<LoginEmailChanged>(_loginEmailChanged);
    on<LoginPasswordChanged>(_loginPasswordChanged);
  }

  FutureOr<void> _loginButtonClicked(
      LoginLoginButtonClicked event, Emitter<LoginState> emit) {
    if (state.passwordValid && state.emailValid) {
      emit(state.copyWith(authenticated: true));
    }
  }

  FutureOr<void> _loginEmailChanged(
      LoginEmailChanged event, Emitter<LoginState> emit) {
    final newEmail = event.email;
    final newEmailValid = newEmail.length > 4;

    emit(state.copyWith(email: newEmail, emailValid: newEmailValid));
  }

  FutureOr<void> _loginPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final newPassword = event.password;
    final newPasswordValid = newPassword.length >= 8;

    emit(
        state.copyWith(password: newPassword, passwordValid: newPasswordValid));
  }

  @override
  void onEvent(LoginEvent event) {
    debugPrint('Login Bloc. Event $event');
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<LoginEvent, LoginState> transition) {
    debugPrint('Login Bloc. Transition $transition');
    super.onTransition(transition);
  }
}
