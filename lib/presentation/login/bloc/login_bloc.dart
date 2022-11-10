import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gift_manager/data/http/api_error_type.dart';
import 'package:gift_manager/data/http/model/api_error.dart';
import 'package:gift_manager/data/http/model/user_with_tokens_dto.dart';
import 'package:gift_manager/data/http/unauthorized_api_service.dart';
import 'package:gift_manager/data/repository/refresh_token_repository.dart';
import 'package:gift_manager/data/repository/token_repository.dart';
import 'package:gift_manager/data/repository/user_repository.dart';
import 'package:gift_manager/di/service_locator.dart';

import '../model/models.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  //static final _passwordRegexp =
  //    RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

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
      if (response.isRight) {
        final userWithTokens = response.right;
        await sl.get<UserRepository>().setItem(userWithTokens.user);
        await sl.get<TokenRepository>().setItem(userWithTokens.token);
        await sl.get<RefreshTokenRepository>()
            .setItem(userWithTokens.refreshToken);
        emit(state.copyWith(authenticated: true));
      } else {
        final apiError = response.left;
        switch (apiError.errorType) {
          case ApiErrorType.incorrectPassword:
            emit(state.copyWith(
              passwordError: PasswordError.wrongPassword,
            ));
            break;
          case ApiErrorType.notFound:
            emit(state.copyWith(
              emailError: EmailError.notExist,
            ));
            break;
          default:
            emit(state.copyWith(
              requestError: RequestError.unknown,
            ));
            break;
        }
      }
    }
  }

  Future<Either<ApiError, UserWithTokensDto>> _login(
      {required final String email, required final String password}) async {
    final response = await UnauthorizedApiService.getInstance().login(
      email: email,
      password: password,
    );
    return response;
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
    //return _passwordRegexp.hasMatch(password);
    return password.length >= 6;
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
