// lib/auth_use_case_provider.dart
import 'package:flutter/foundation.dart';
import 'package:todovalidate/data/repositories/firebase_auth_repository.dart';
import 'package:todovalidate/domain/repositories/auth_repository.dart';
import 'package:todovalidate/domain/usecases/auth/register_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/login_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/logout_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/reset_password_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/get_user_profile_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/save_user_profile_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/update_verified_email_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/get_current_user_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/get_or_create_user_profile_usecase.dart';
import 'package:todovalidate/domain/usecases/auth/get_username_usecase.dart';
import 'package:todovalidate/core/injection_container.dart';

final authRepository = FirebaseAuthRepository();

final registerUseCase = RegisterUseCase(authRepository);
final loginUseCase = LoginUseCase(authRepository);
final logoutUseCase = LogoutUseCase(authRepository);
final resetPasswordUseCase = ResetPasswordUseCase(authRepository);
final getUserProfileUseCase = GetUserProfileUseCase(authRepository);
final saveUserProfileUseCase = SaveUserProfileUseCase(authRepository);
final updateVerifiedEmailUseCase = UpdateVerifiedEmailUseCase(authRepository);
final getCurrentUserUseCase = GetCurrentUserUseCase(authRepository);
final getOrCreateUserProfileUseCase = GetOrCreateUserProfileUseCase(authRepository);
final getUsernameUseCase = GetUsernameUseCase();

void registerAuthDependencies() {
  serviceLocator.registerLazySingleton<AuthRepository>(() => authRepository);
  serviceLocator.registerLazySingleton<RegisterUseCase>(() => registerUseCase);
  serviceLocator.registerLazySingleton<LoginUseCase>(() => loginUseCase);
  serviceLocator.registerLazySingleton<LogoutUseCase>(() => logoutUseCase);
  serviceLocator.registerLazySingleton<ResetPasswordUseCase>(() => resetPasswordUseCase);
  serviceLocator.registerLazySingleton<GetUserProfileUseCase>(() => getUserProfileUseCase);
  serviceLocator.registerLazySingleton<SaveUserProfileUseCase>(() => saveUserProfileUseCase);
  serviceLocator.registerLazySingleton<UpdateVerifiedEmailUseCase>(() => updateVerifiedEmailUseCase);
  serviceLocator.registerLazySingleton<GetCurrentUserUseCase>(() => getCurrentUserUseCase);
  serviceLocator.registerLazySingleton<GetOrCreateUserProfileUseCase>(() => getOrCreateUserProfileUseCase);
  serviceLocator.registerLazySingleton<GetUsernameUseCase>(() => getUsernameUseCase);

  debugPrint('Auth use cases initialized successfully');
}