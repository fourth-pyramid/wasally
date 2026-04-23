import 'package:get_it/get_it.dart';
import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:wassaly/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:wassaly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:wassaly/features/auth/domain/repositories/auth_repository.dart';
import 'package:wassaly/features/auth/domain/usecases/forget_send_otp_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/forget_verify_otp_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/get_saved_token_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/login_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/logout_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/signup_usecase.dart';
import 'package:wassaly/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:wassaly/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:wassaly/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:wassaly/features/auth/presentation/bloc/otp_verification/otp_verification_bloc.dart';
import 'package:wassaly/features/auth/presentation/bloc/reset_password/reset_password_bloc.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/auth/presentation/bloc/signup/signup_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Blocs
  sl.registerFactory(() => SessionBloc(
        loginUseCase: sl(),
        getProfileUseCase: sl(),
        getSavedTokenUseCase: sl(),
        logoutUseCase: sl(),
      ));
  sl.registerFactory(() => LoginBloc(loginUseCase: sl()));
  sl.registerFactory(() => SignupBloc(signupUseCase: sl()));
  sl.registerFactory(() => ForgotPasswordBloc(forgetSendOtpUseCase: sl()));
  sl.registerFactoryParam<OtpVerificationBloc, String, VerificationType>(
    (email, verificationType) => OtpVerificationBloc(
      email: email,
      verificationType: verificationType,
      verifyOtpUseCase: sl(),
      forgetVerifyOtpUseCase: sl(),
      resendOtpUseCase: sl(),
    ),
  );
  sl.registerFactoryParam<ResetPasswordBloc, String, String>(
    (email, token) => ResetPasswordBloc(
      email: email,
      token: token,
      resetPasswordUseCase: sl(),
    ),
  );

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedTokenUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgetSendOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgetVerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(
      SecureStorageService.instance, StorageService.instance));
}
