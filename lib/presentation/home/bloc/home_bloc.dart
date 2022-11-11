// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:gift_manager/data/http/model/gift_dto.dart';
import 'package:gift_manager/data/http/model/gifts_response_dto.dart';
import 'package:gift_manager/data/http/model/user_dto.dart';
import 'package:gift_manager/data/http/unauthorized_api_service.dart';
import 'package:gift_manager/data/repository/token_repository.dart';
import 'package:gift_manager/data/repository/user_repository.dart';
import 'package:gift_manager/domain/logout_interactor.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final UserRepository userRepository;
  final LogoutInteractor logoutInteractor;
  final UnauthorizedApiService unauthorizedApiService;
  final TokenRepository tokenRepository;

  late final StreamSubscription _logoutSubscription;

  HomeBloc({
    required this.userRepository,
    required this.logoutInteractor,
    required this.unauthorizedApiService,
    required this.tokenRepository,
  }) : super(HomeInitial()) {
    on<HomePageLoaded>(_onHomePageLoaded);
    on<HomeLogoutPushed>(_onLogoutPushed);
    on<HomeExternalLogout>(_onHomeExternalLogout);
    _logoutSubscription = userRepository
        .observeItem()
        .where((user) => user == null)
        .take(1)
        .listen((event) {
      _logout();
    });
  }

  @override
  Future<void> close() {
    _logoutSubscription.cancel();
    return super.close();
  }

  FutureOr<void> _onHomePageLoaded(
      HomePageLoaded event, Emitter<HomeState> emit) async {
    final user = await userRepository.getItem();
    final token = await tokenRepository.getItem();
    if (user == null || token == null) {
      _logout();
      return;
    }
    final giftsResponse =
        await unauthorizedApiService.getAllGifts(token: token);
    final gifts =
        giftsResponse.isRight ? giftsResponse.right.gifts : const <GiftDto>[];
    emit(HomeWithUserInfo(user: user, gifts: gifts));
  }

  FutureOr<void> _onLogoutPushed(
      HomeLogoutPushed event, Emitter<HomeState> emit) async {
    await logoutInteractor.logout();
    _logout();
  }

  void _logout() {
    add(HomeExternalLogout());
  }

  FutureOr<void> _onHomeExternalLogout(
      HomeExternalLogout event, Emitter<HomeState> emit) {
    emit(HomeGoToLogin());
  }
}
