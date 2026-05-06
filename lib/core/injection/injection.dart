import 'package:get_it/get_it.dart';
import 'package:wassaly/core/imports/imports.dart';
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
import 'package:wassaly/features/favorite/data/datasources/favorite_remote_datasource.dart';
import 'package:wassaly/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:wassaly/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:wassaly/features/favorite/domain/usecases/toggle_favorite_usecase.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/sub_category/data/datasources/sub_category_remote_datasource.dart';
import 'package:wassaly/features/sub_category/data/repositories/sub_category_repository_impl.dart';
import 'package:wassaly/features/sub_category/domain/repositories/sub_category_repository.dart';
import 'package:wassaly/features/sub_category/domain/usecases/get_sub_category_detail_usecase.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_bloc.dart';

import '../../features/auth/domain/usecases/get_cached_user_usecase.dart';
import '../../features/auth/domain/usecases/google_login_usecase.dart';
import '../../features/auth/presentation/bloc/google_login/google_login_bloc.dart';
import '../../features/category/data/datasources/category_remote_datasource.dart';
import '../../features/category/data/repositories/category_repository_impl.dart';
import '../../features/category/domain/repositories/category_repository.dart';
import '../../features/category/domain/usecases/get_category_detail_usecase.dart';
import '../../features/category/presentation/bloc/category_bloc.dart';
import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_banners_usecase.dart';
import '../../features/home/domain/usecases/get_categories_usecase.dart';
import '../../features/home/domain/usecases/get_popular_services_usecase.dart';
import '../../features/home/domain/usecases/get_products_usecase.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/usecases/create_address_usecase.dart';
import '../../features/profile/domain/usecases/delete_account_usecase.dart';
import '../../features/profile/domain/usecases/delete_address_usecase.dart';
import '../../features/profile/domain/usecases/get_addresses_usecase.dart';
import '../../features/profile/domain/usecases/get_centers_usecase.dart';
import '../../features/profile/domain/usecases/get_governorates_usecase.dart';
import '../../features/profile/domain/usecases/logout_all_devices_usecase.dart';
import '../../features/profile/domain/usecases/update_address_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/presentation/bloc/profile/profile_bloc.dart';
import '../../features/profile/presentation/bloc/settings/settings_bloc.dart';
import '../../features/search/data/datasources/search_remote_datasource.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/repositories/search_repository.dart';
import '../../features/search/domain/usecases/search_products_usecase.dart';
import '../../features/search/presentation/bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Blocs
  sl.registerLazySingleton(() => SessionBloc(
        loginUseCase: sl(),
        getSavedTokenUseCase: sl(),
        getProfileUseCase: sl(),
        getCachedUserUseCase: sl(),
        logoutUseCase: sl(),
      ));
  sl.registerFactory(() => LoginBloc(
        loginUseCase: sl(),
        resendOtpUseCase: sl(),
      ));
  sl.registerFactory(() => GoogleLoginBloc(
        googleLoginUseCase: sl(),
      ));
  sl.registerFactory(() => SignupBloc(
        signupUseCase: sl(),
      ));
  sl.registerFactory(() => ForgotPasswordBloc(forgetSendOtpUseCase: sl()));
  sl.registerLazySingleton(() => ProfileBloc(
        getCachedUserUseCase: sl(),
        getProfileUseCase: sl(),
        updateProfileUseCase: sl(),
        logoutUseCase: sl(),
        logoutAllDevicesUseCase: sl(),
        deleteAccountUseCase: sl(),
        getAddressesUseCase: sl(),
        createAddressUseCase: sl(),
        getGovernoratesUseCase: sl(),
        getCentersUseCase: sl(),
        updateAddressUseCase: sl(),
        deleteAddressUseCase: sl(),
        sessionBloc: sl(),
      ));
  sl.registerLazySingleton(() => SettingsBloc(
        storage: StorageService.instance,
      ));
  sl.registerFactory(() => HomeBloc(
        getBannersUseCase: sl(),
        getCategoriesUseCase: sl(),
        getPopularServicesUseCase: sl(),
        getProductsUseCase: sl(),
      ));
  sl.registerFactory(() => SubCategoryBloc(
        getSubCategoryDetailUseCase: sl(),
      ));
  sl.registerFactory(() => CategoryBloc(
        getCategoryDetailUseCase: sl(),
      ));
  sl.registerFactory(() => SearchBloc(
        searchProductsUseCase: sl(),
      ));
  sl.registerFactory(() => FavoriteBloc(
        sl(),
        sl(),
      ));

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

  // UseCases - Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => GoogleLoginUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedTokenUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => SignupUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgetSendOtpUseCase(sl()));
  sl.registerLazySingleton(() => ForgetVerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  // UseCases - Profile
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => LogoutAllDevicesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));
  sl.registerLazySingleton(() => GetAddressesUseCase(sl()));
  sl.registerLazySingleton(() => CreateAddressUseCase(sl()));
  sl.registerLazySingleton(() => UpdateAddressUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAddressUseCase(sl()));
  sl.registerLazySingleton(() => GetGovernoratesUseCase(sl()));
  sl.registerLazySingleton(() => GetCentersUseCase(sl()));

  // UseCases - Home
  sl.registerLazySingleton(() => GetBannersUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetPopularServicesUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));

  // UseCases - SubCategory
  sl.registerLazySingleton(() => GetSubCategoryDetailUseCase(sl()));

  // UseCases - Category
  sl.registerLazySingleton(() => GetCategoryDetailUseCase(sl()));

  // UseCases - Search
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));

  // UseCases - Favorite
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(sl(), sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton<SubCategoryRepository>(
      () => SubCategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<CategoryRepository>(
      () => CategoryRepositoryImpl(sl()));
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(sl()));
  sl.registerLazySingleton<FavoriteRepository>(
      () => FavoriteRepositoryImpl(sl()));

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl(
      SecureStorageService.instance, StorageService.instance));
  sl.registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<SubCategoryRemoteDataSource>(
      () => SubCategoryRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<FavoriteRemoteDataSource>(
      () => FavoriteRemoteDataSourceImpl(DioService.instance));
}
