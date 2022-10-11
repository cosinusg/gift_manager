// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'package:equatable/equatable.dart';

part of 'login_bloc.dart';

class LoginState extends Equatable {
  final String email;
  final EmailError emailError;
  final String password;
  final PasswordError passwordError;
  final bool emailValid;
  final bool passwordValid;
  final bool authenticated;

  const LoginState({
    required this.email,
    required this.emailError,
    required this.password,
    required this.passwordError,
    required this.emailValid,
    required this.passwordValid,
    required this.authenticated,
  });

  factory LoginState.initial() => const LoginState(
        email: '',
        emailError: EmailError.noError,
        password: '',
        passwordError: PasswordError.noError,
        emailValid: false,
        passwordValid: false,
        authenticated: false,
      );

  LoginState copyWith({
    final String? email,
    final EmailError? emailError,
    final String? password,
    final PasswordError? passwordError,
    final bool? emailValid,
    final bool? passwordValid,
    final bool? authenticated,
  }) {
    return LoginState(
      email: email ?? this.email,
      emailError: emailError ?? this.emailError,
      password: password ?? this.password,
      passwordError: passwordError ?? this.passwordError,
      emailValid: emailValid ?? this.emailValid,
      passwordValid: passwordValid ?? this.passwordValid,
      authenticated: authenticated ?? this.authenticated,
    );
  }

  @override
  List<Object> get props {
    return [
      email,
      emailError,
      password,
      passwordError,
      emailValid,
      passwordValid,
      authenticated,
    ];
  }
}

//class LoginInitial extends LoginState {
//  @override
//  // TODO: implement props
//  List<Object?> get props => [];
//
//}
