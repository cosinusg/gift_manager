import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_manager/data/repository/token_repository.dart';
import 'package:gift_manager/di/service_locator.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashLoaded>(_onSplashLoaded);
  }

  FutureOr<void> _onSplashLoaded(SplashLoaded event, Emitter<SplashState> emit) async {
final token = await sl.get<TokenRepository>().getItem();
if (token == null || token.isEmpty) {
  emit(SplashUnauthorized());
}
emit(SplashAuthorized());
  }
}
