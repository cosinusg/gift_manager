// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object?> get props => [];
}

class HomeWithUser extends HomeState {
  final UserDto user;
  HomeWithUser(
    this.user,
  );
  
  @override
  List<Object?> get props => [user];
}
