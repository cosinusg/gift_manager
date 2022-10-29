// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'login_bloc.dart';

@immutable
abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  // TODO: implement props
  List<Object?> get props => [email];
  
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  // TODO: implement props
  List<Object?> get props => [password];
  
}

class LoginLoginButtonClicked extends LoginEvent {

  const LoginLoginButtonClicked();

  @override
  // TODO: implement props
  List<Object?> get props => [];
  
}

class LoginRequestErrorShowed extends LoginEvent {
  const LoginRequestErrorShowed();

  

  @override
  List<Object> get props => [];
}