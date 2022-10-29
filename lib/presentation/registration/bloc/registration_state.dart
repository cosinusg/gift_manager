// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'registration_bloc.dart';

abstract class RegistrationState extends Equatable {
  const RegistrationState();
}

class RegistrationFieldsInfo extends RegistrationState {
  final String avatarLink;
  final RegistrationEmailError? emailError;
  final RegistrationPasswordError? passwordError;
  final RegistrationPasswordConfirmationError? passwordConfirmationError;
  final RegistrationNameError? nameError;
  const RegistrationFieldsInfo({
    required this.avatarLink,
    this.emailError,
    this.passwordError,
    this.passwordConfirmationError,
    this.nameError,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
        avatarLink,
        emailError,
        passwordError,
        passwordConfirmationError,
        nameError
      ];
}

class RegistrationError extends RegistrationState {
  final RequestError requestError;
  const RegistrationError(this.requestError);

  @override
  // TODO: implement props
  List<Object?> get props => [requestError];
}

class RegistrationInProgress extends RegistrationState {

  const RegistrationInProgress();

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

}