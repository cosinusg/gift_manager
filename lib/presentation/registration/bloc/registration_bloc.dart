import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gift_manager/data/http/model/api_error.dart';
import 'package:gift_manager/data/http/model/create_account_request_dto.dart';
import 'package:gift_manager/data/http/model/user_with_tokens_dto.dart';
import 'package:gift_manager/data/http/unauthorized_api_service.dart';
import 'package:gift_manager/data/model/request_error.dart';
import 'package:gift_manager/data/repository/refresh_token_repository.dart';
import 'package:gift_manager/data/repository/token_repository.dart';
import 'package:gift_manager/data/repository/user_repository.dart';
import 'package:gift_manager/data/storage/shared_preference_data.dart';
import 'package:gift_manager/di/service_locator.dart';
import 'package:gift_manager/presentation/registration/model/errors.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  static const _defaultAvatarKey = 'test';
  static final _registrationPasswordRegexp = RegExp(r'^[a-zA-Z0-9]+$');
  static String _avatarBuilder(final String key) =>
      "https://avatars.dicebear.com/api/croodles/$key.svg";
  String _avatarKey = _defaultAvatarKey;

  String _email = '';
  bool _highLightEmailError = false;
  RegistrationEmailError? _emailError = RegistrationEmailError.empty;

  String _password = '';
  bool _highLightPasswordError = false;
  RegistrationPasswordError? _passwordError = RegistrationPasswordError.empty;

  String _passwordConfirmation = '';
  bool _highLightPasswordConfirmationError = false;
  RegistrationPasswordConfirmationError? _passwordConfirmationError =
      RegistrationPasswordConfirmationError.empty;

  String _name = '';
  bool _highLightNameError = false;
  RegistrationNameError? _nameError = RegistrationNameError.empty;

  RegistrationBloc()
      : super(RegistrationFieldsInfo(
            avatarLink: _avatarBuilder(_defaultAvatarKey))) {
    on<RegistrationChangeAvatar>(_onChangeAvatar);
    on<RegistrationEmailChanged>(_onEmailChanged);
    on<RegistrationEmailFocusLost>(_onEmailFocusLost);
    on<RegistrationPasswordChanged>(_onPasswordChanged);
    on<RegistrationPasswordFocusLost>(_onPasswordFocusLost);
    on<RegistrationPasswordConfirmationChanged>(_onPasswordConfirmationChanged);
    on<RegistrationPasswordConfirmationFocusLost>(
        _onPasswordConfirmationFocusLost);
    on<RegistrationNameChanged>(_onNameChanged);
    on<RegistrationNameFocusLost>(_onNameFocusLost);
    on<RegistrationCreateAccount>(_onCreateAccount);
  }

  FutureOr<void> _onChangeAvatar(final RegistrationChangeAvatar event,
      final Emitter<RegistrationState> emit) {
    _avatarKey = Random().nextInt(1000000).toString();
    //emit(RegistrationFieldsInfo(avatarLink: _avatarBuilder(_avatarKey)));
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onEmailChanged(
      RegistrationEmailChanged event, Emitter<RegistrationState> emit) {
    _email = event.email;
    _emailError = _validateEmail();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onEmailFocusLost(
      RegistrationEmailFocusLost event, Emitter<RegistrationState> emit) {
    _highLightEmailError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordChanged(
      RegistrationPasswordChanged event, Emitter<RegistrationState> emit) {
    _password = event.password;
    _passwordError = _validatePassword();
    _passwordConfirmationError = _validateConfirmationPassword();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordFocusLost(
      RegistrationPasswordFocusLost event, Emitter<RegistrationState> emit) {
    _highLightPasswordError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordConfirmationChanged(
      RegistrationPasswordConfirmationChanged event,
      Emitter<RegistrationState> emit) {
    _passwordConfirmation = event.passwordConfirmation;
    _passwordConfirmationError = _validateConfirmationPassword();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordConfirmationFocusLost(
      RegistrationPasswordConfirmationFocusLost event,
      Emitter<RegistrationState> emit) {
    _highLightPasswordConfirmationError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onNameChanged(
      RegistrationNameChanged event, Emitter<RegistrationState> emit) {
    _name = event.name;
    _nameError = _validateName();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onNameFocusLost(
      RegistrationNameFocusLost event, Emitter<RegistrationState> emit) {
    _highLightNameError = true;
    emit(_calculateFieldsInfo());
  }

  RegistrationFieldsInfo _calculateFieldsInfo() {
    return RegistrationFieldsInfo(
      avatarLink: _avatarBuilder(_avatarKey),
      emailError: _highLightEmailError ? _emailError : null,
      passwordError: _highLightPasswordError ? _passwordError : null,
      passwordConfirmationError: _highLightPasswordConfirmationError
          ? _passwordConfirmationError
          : null,
      nameError: _highLightNameError ? _nameError : null,
    );
  }

  RegistrationEmailError? _validateEmail() {
    if (_email.isEmpty) {
      return RegistrationEmailError.empty;
    }
    if (!EmailValidator.validate(_email)) {
      return RegistrationEmailError.invalid;
    }
    return null;
  }

  RegistrationPasswordError? _validatePassword() {
    if (_password.isEmpty) {
      return RegistrationPasswordError.empty;
    }
    if (_password.length < 6) {
      return RegistrationPasswordError.tooShort;
    }
    if (!_registrationPasswordRegexp.hasMatch(_password)) {
      return RegistrationPasswordError.wrongSymbols;
    }
    return null;
  }

  RegistrationPasswordConfirmationError? _validateConfirmationPassword() {
    if (_passwordConfirmation.isEmpty) {
      return RegistrationPasswordConfirmationError.empty;
    }
    if (_passwordConfirmation != _password) {
      return RegistrationPasswordConfirmationError.different;
    }
    return null;
  }

  RegistrationNameError? _validateName() {
    if (_name.isEmpty) {
      return RegistrationNameError.empty;
    }
    return null;
  }

  FutureOr<void> _onCreateAccount(
      RegistrationCreateAccount event, Emitter<RegistrationState> emit) async {
    _highLightEmailError = true;
    _highLightPasswordError = true;
    _highLightPasswordConfirmationError = true;
    _highLightNameError = true;
    emit(_calculateFieldsInfo());
    final _haveError = _emailError != null ||
        _passwordError != null ||
        _passwordConfirmationError != null ||
        _nameError != null;
    if (_haveError) {
      return;
    }
    emit(RegistrationInProgress());
    final response = await _register();
    if (response.isRight) {
      final userWithTokens = response.right;
      await sl.get<UserRepository>().setItem(userWithTokens.user);
      await sl.get<TokenRepository>().setItem(userWithTokens.token);
      await sl.get<RefreshTokenRepository>()
          .setItem(userWithTokens.refreshToken);
      emit(RegistrationComplete());
    } else {
      // TODO
    }
  }

  Future<Either<ApiError, UserWithTokensDto>> _register() async {
    final response = await UnauthorizedApiService.getInstance().register(
      email: _email,
      password: _password,
      name: _name,
      avatarUrl: _avatarBuilder(_avatarKey),
    );
    await Future.delayed(Duration(seconds: 2));
    return response;
  }
}
