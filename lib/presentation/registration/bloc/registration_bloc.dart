import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_manager/data/model/request_error.dart';
import 'package:gift_manager/presentation/registration/model/errors.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  static const _defaultAvatarKey = 'test';
  static final _registrationPasswordRegexp = RegExp(r'^[a-zA-Z0-9]+$');
  static String _avatarBuilder(final String key) =>
      'https://avatars.dicebear.com/api/croodles/$key.svg';
  String _avatarKey = _defaultAvatarKey;

  String _email = '';
  bool _highLightEmailError = false;
  RegistrationEmailError? _emailError = RegistrationEmailError.empty;

  String _password = '';
  bool _highLightPasswordError = false;
  RegistrationPasswordError? _passwordError = RegistrationPasswordError.empty;

  String _passwordConfirmation = '';
  bool _highLightPasswordConfirmationError = false;
  RegistrationPasswordConfirmationError? _passwordConfirmationError = RegistrationPasswordConfirmationError.empty;

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
    on<RegistrationPasswordConfirmationFocusLost>(_onPasswordConfirmationFocusLost);
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

  FutureOr<void> _onEmailFocusLost(RegistrationEmailFocusLost event, Emitter<RegistrationState> emit) {
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

  FutureOr<void> _onPasswordFocusLost(RegistrationPasswordFocusLost event, Emitter<RegistrationState> emit) {
    _highLightPasswordError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordConfirmationChanged(
      RegistrationPasswordConfirmationChanged event, Emitter<RegistrationState> emit) {
    _passwordConfirmation = event.passwordConfirmation;
    _passwordConfirmationError = _validateConfirmationPassword();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onPasswordConfirmationFocusLost(RegistrationPasswordConfirmationFocusLost event, Emitter<RegistrationState> emit) {
    _highLightPasswordConfirmationError = true;
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onNameChanged(
      RegistrationNameChanged event, Emitter<RegistrationState> emit) {
    _name = event.name;
    _nameError = _validateName();
    emit(_calculateFieldsInfo());
  }

  FutureOr<void> _onNameFocusLost(RegistrationNameFocusLost event, Emitter<RegistrationState> emit) {
    _highLightNameError = true;
    emit(_calculateFieldsInfo());
  }

  RegistrationFieldsInfo _calculateFieldsInfo() {
    return RegistrationFieldsInfo(
      avatarLink: _avatarBuilder(_avatarKey),
      emailError: _highLightEmailError ? _emailError : null,
      passwordError: _highLightPasswordError ? _passwordError : null,
      passwordConfirmationError: _highLightPasswordConfirmationError ? _passwordConfirmationError : null,
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

  FutureOr<void> _onCreateAccount(RegistrationCreateAccount event, Emitter<RegistrationState> emit) {
    _highLightEmailError = true;
    _highLightPasswordError = true;
    _highLightPasswordConfirmationError = true;
    _highLightNameError = true;
    emit(_calculateFieldsInfo());
  }
}
