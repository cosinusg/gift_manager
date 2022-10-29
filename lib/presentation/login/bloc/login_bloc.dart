import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../model/models.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {

  static final _passwordRegexp =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$'); 

  LoginBloc() : super(LoginState.initial()) {
    on<LoginLoginButtonClicked>(_loginButtonClicked);
    //on<LoginLoginButtonClicked>((e, ee) => ); //проверка типа
    on<LoginEmailChanged>(_loginEmailChanged);
    on<LoginPasswordChanged>(_loginPasswordChanged);
    on<LoginRequestErrorShowed>(_loginRequestErrorShowed);
  }

  FutureOr<void> _loginButtonClicked(
      LoginLoginButtonClicked event, Emitter<LoginState> emit) async {
    if (state.allFieldsValid) {
      final response =
          await _login(email: state.email, password: state.password);
      if (response == null) {
        emit(state.copyWith(authenticated: true));
      } else {
        switch (response) {
          case LoginError.emailNotExist:
            emit(state.copyWith(
              emailError: EmailError.notExist,
            ));
            break;
          case LoginError.wrongPassword:
            emit(state.copyWith(
              passwordError: PasswordError.wrongPassword,
            ));
            break;
          case LoginError.other:
            emit(state.copyWith(requestError: RequestError.unknown,));
            break;
        }
      }
    }
  }

  Future<LoginError?> _login(
      {required final String email, required final String password}) async {
    final successfulResponce = Random().nextBool();
    if (successfulResponce) {
      return null;
    }
    return LoginError.values[Random().nextInt(LoginError.values.length)];
  }

  FutureOr<void> _loginEmailChanged(
      LoginEmailChanged event, Emitter<LoginState> emit) {
    final newEmail = event.email;
    final newEmailValid = _emailValid(newEmail);

    emit(state.copyWith(
      email: newEmail,
      emailValid: newEmailValid,
      emailError: EmailError.noError,
      authenticated: false,
    ));
  }

  bool _emailValid(final String email) {
    return EmailValidator.validate(email);
  }

  FutureOr<void> _loginPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final newPassword = event.password;
    final newPasswordValid = _passwordValid(newPassword);

    emit(state.copyWith(
      password: newPassword,
      passwordValid: newPasswordValid,
      passwordError: PasswordError.noError,
      authenticated: false,
    ));
  }

  bool _passwordValid(final String password) {
    return _passwordRegexp.hasMatch(password);
  }

  FutureOr<void> _loginRequestErrorShowed(
      LoginRequestErrorShowed event, Emitter<LoginState> emit) {
    emit(state.copyWith(
      requestError: RequestError.noError,
    ));
  }

  //@override
  //void onEvent(LoginEvent event) {
  //  debugPrint('Login Bloc. Event $event');
  //  super.onEvent(event);
  //}
//
  //@override
  //void onTransition(Transition<LoginEvent, LoginState> transition) {
  //  debugPrint('Login Bloc. Transition $transition');
  //  super.onTransition(transition);
  //}
}

enum LoginError {
  emailNotExist,
  wrongPassword,
  other,
}
