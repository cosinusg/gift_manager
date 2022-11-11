// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:gift_manager/data/http/model/user_dto.dart';
import 'package:gift_manager/data/repository/user_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;

  HomeBloc({
    required this.userRepository,
  }) : super(HomeInitial()) {
    on<HomePageLoaded>(_onHomePageLoaded);
    on<HomeLogoutPushed>(_onLogoutPushed);
  }

  FutureOr<void> _onHomePageLoaded(
      HomePageLoaded event, Emitter<HomeState> emit) async {
    final user = await userRepository.getItem();
    if (user == null) {
      _logout();
      return;
    }
    emit(HomeWithUser(user));
  }

  FutureOr<void> _onLogoutPushed(
      HomeLogoutPushed event, Emitter<HomeState> emit) async {}

  void _logout() {}
}
