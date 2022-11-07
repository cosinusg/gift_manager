import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gift_manager/data/storage/shared_preference_data.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<SplashLoaded>(_onSplashLoaded);
  }

  FutureOr<void> _onSplashLoaded(SplashLoaded event, Emitter<SplashState> emit) async {
final token = await SharedPreferenceData.getInstance().getToken();
if (token == null || token.isEmpty) {
  emit(SplashUnauthorized());
}
emit(SplashAuthorized());
  }
}
