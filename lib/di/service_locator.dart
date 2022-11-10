import 'package:get_it/get_it.dart';
import 'package:gift_manager/data/repository/refresh_token_provider.dart';
import 'package:gift_manager/data/repository/refresh_token_repository.dart';
import 'package:gift_manager/data/repository/token_repository.dart';
import 'package:gift_manager/data/repository/user_repository.dart';
import 'package:gift_manager/data/storage/shared_preference_data.dart';

final sl = GetIt.instance;

void initServiceLocator() {
  _setupDataProviders();
  _setupRepositories();
  _setupInteractors();
  _setupComplexInteractors();
  _setupApiRelatedClasses();
  _setupBlocs();
}

// ONLY SINGTONES
void _setupDataProviders() {
  sl.registerLazySingleton(() => SharedPreferenceData());
  sl.registerLazySingleton<RefreshTokenProvider>(
      () => sl.get<SharedPreferenceData>());
}

// ONLY SINGTONES
void _setupRepositories() {
  sl.registerLazySingleton(
      () => RefreshTokenRepository(sl.get<RefreshTokenProvider>()));
  sl.registerLazySingleton(
      () => UserRepository(sl.get<SharedPreferenceData>()));
  sl.registerLazySingleton(
      () => TokenRepository(sl.get<SharedPreferenceData>()));
}

// ONLY SINGTONES
void _setupInteractors() {}

// ONLY SINGTONES
void _setupComplexInteractors() {}

// ONLY SINGTONES
void _setupApiRelatedClasses() {}

// ONLY FACTORIES
void _setupBlocs() {}
