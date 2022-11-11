// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:gift_manager/data/repository/token_repository.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final TokenRepository tokenRepository;
  SplashBloc({
    required this.tokenRepository,
  }) : super(SplashInitial()) {
    on<SplashLoaded>(_onSplashLoaded);
  }

  FutureOr<void> _onSplashLoaded(
      SplashLoaded event, Emitter<SplashState> emit) async {
    final token = await tokenRepository.getItem();
    if (token == null || token.isEmpty) {
      emit(SplashUnauthorized());
      return;
    }
    emit(SplashAuthorized());
  }
}
