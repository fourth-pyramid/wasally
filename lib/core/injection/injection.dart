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
import 'package:wassaly/features/favorite/data/datasources/favorite_local_datasource.dart';
import 'package:wassaly/features/favorite/data/datasources/favorite_remote_datasource.dart';
import 'package:wassaly/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:wassaly/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:wassaly/features/favorite/domain/usecases/get_favorites_usecase.dart';
import 'package:wassaly/features/favorite/domain/usecases/get_service_favorites_usecase.dart';
import 'package:wassaly/features/favorite/domain/usecases/toggle_favorite_usecase.dart';
import 'package:wassaly/features/favorite/domain/usecases/toggle_service_favorite_usecase.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/sub_category/data/datasources/sub_category_remote_datasource.dart';
import 'package:wassaly/features/sub_category/data/repositories/sub_category_repository_impl.dart';
import 'package:wassaly/features/sub_category/domain/repositories/sub_category_repository.dart';
import 'package:wassaly/features/sub_category/domain/usecases/get_sub_category_detail_usecase.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_bloc.dart';

import '../../features/auth/domain/usecases/clear_user_session_usecase.dart';
import '../../features/auth/domain/usecases/get_cached_user_usecase.dart';
import '../../features/auth/domain/usecases/google_login_usecase.dart';
import '../../features/auth/presentation/bloc/google_login/google_login_bloc.dart';
import '../../features/cart/data/datasources/cart_local_datasource.dart';
import '../../features/cart/data/datasources/cart_remote_datasource.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_to_cart_usecase.dart';
import '../../features/cart/domain/usecases/apply_coupon_usecase.dart';
import '../../features/cart/domain/usecases/get_cart_items_usecase.dart';
import '../../features/cart/domain/usecases/get_governorates_usecase.dart';
import '../../features/cart/domain/usecases/get_user_addresses_usecase.dart';
import '../../features/cart/domain/usecases/get_user_data_usecase.dart';
import '../../features/cart/domain/usecases/place_order_usecase.dart';
import '../../features/cart/domain/usecases/remove_from_cart_usecase.dart';
import '../../features/cart/domain/usecases/update_quantity_usecase.dart';
import '../../features/cart/presentation/bloc/cart_bloc.dart';
import '../../features/cart/presentation/bloc/checkout/checkout_bloc.dart';
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
import '../../features/product_details/data/datasources/product_details_remote_datasource.dart';
import '../../features/product_details/data/repositories/product_details_repository_impl.dart';
import '../../features/product_details/domain/repositories/product_details_repository.dart';
import '../../features/product_details/domain/usecases/create_product_review_usecase.dart';
import '../../features/product_details/domain/usecases/get_product_details_usecase.dart';
import '../../features/product_details/domain/usecases/update_product_review_usecase.dart';
import '../../features/product_details/presentation/bloc/product_details_bloc.dart';
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
import '../../features/orders/data/datasources/orders_remote_datasource.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';
import '../../features/orders/domain/usecases/get_order_details_usecase.dart';
import '../../features/orders/domain/usecases/cancel_order_usecase.dart';
import '../../features/orders/domain/usecases/update_order_usecase.dart';
import '../../features/orders/domain/usecases/delete_order_usecase.dart';
import '../../features/orders/presentation/bloc/orders_bloc.dart';
import '../../features/orders/presentation/bloc/order_detail/order_detail_bloc.dart';
import '../../features/service_details/data/datasources/service_details_remote_datasource.dart';
import '../../features/service_details/data/repositories/service_details_repository_impl.dart';
import '../../features/service_details/domain/repositories/service_details_repository.dart';
import '../../features/service_details/domain/usecases/get_service_details_usecase.dart';
import '../../features/service_details/domain/usecases/toggle_service_favorite_usecase.dart'
    as detail_favorite;
import '../../features/service_details/domain/usecases/create_service_review_usecase.dart';
import '../../features/service_details/domain/usecases/update_service_review_usecase.dart';
import '../../features/service_details/presentation/bloc/service_details_bloc.dart';
import '../../features/service_booking/data/datasources/booking_remote_datasource.dart';
import '../../features/service_booking/data/repositories/booking_repository_impl.dart';
import '../../features/service_booking/domain/repositories/booking_repository.dart';
import '../../features/service_booking/domain/usecases/create_booking_usecase.dart';
import '../../features/service_booking/domain/usecases/get_my_bookings_usecase.dart';
import '../../features/service_booking/domain/usecases/update_booking_usecase.dart';
import '../../features/service_booking/domain/usecases/cancel_booking_usecase.dart';
import '../../features/service_booking/domain/usecases/delete_booking_usecase.dart';
import '../../features/service_booking/presentation/bloc/service_booking_bloc.dart';
import '../../features/service_booking/presentation/bloc/booking_detail/booking_detail_bloc.dart';
import '../../features/provider_details/data/datasources/provider_details_remote_datasource.dart';
import '../../features/provider_details/data/repositories/provider_details_repository_impl.dart';
import '../../features/provider_details/domain/repositories/provider_details_repository.dart';
import '../../features/provider_details/domain/usecases/get_provider_details_usecase.dart';
import '../../features/provider_details/presentation/bloc/provider_details_bloc.dart';
import '../../features/brands/data/datasources/brands_remote_datasource.dart';
import '../../features/brands/data/repositories/brands_repository_impl.dart';
import '../../features/brands/domain/repositories/brands_repository.dart';
import '../../features/brands/domain/usecases/get_brand_products_usecase.dart';
import '../../features/brands/domain/usecases/get_brands_usecase.dart';
import '../../features/brands/presentation/bloc/brands_bloc.dart';
import '../../features/offers/data/datasources/offers_remote_datasource.dart';
import '../../features/offers/data/repositories/offers_repository_impl.dart';
import '../../features/offers/domain/repositories/offers_repository.dart';
import '../../features/offers/domain/usecases/get_offers_use_case.dart';
import '../../features/offers/presentation/bloc/offers_bloc.dart';

final sl = GetIt.instance;

void initDependencies() {
  // Blocs
  sl.registerLazySingleton(() => SessionBloc(
        loginUseCase: sl(),
        getSavedTokenUseCase: sl(),
        getProfileUseCase: sl(),
        getCachedUserUseCase: sl(),
        logoutUseCase: sl(),
        clearUserSessionUseCase: sl(),
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
  sl.registerLazySingleton(() => FavoriteBloc(
        sl(),
        sl(),
        sl(),
        sl(),
      ));
  sl.registerFactory(() => ProductDetailsBloc(
        getProductDetailsUseCase: sl(),
        getSubCategoryDetailUseCase: sl(),
        createProductReviewUseCase: sl(),
        updateProductReviewUseCase: sl(),
      ));
  sl.registerLazySingleton(() => CartBloc(
        getCartItemsUseCase: sl(),
        addToCartUseCase: sl(),
        removeFromCartUseCase: sl(),
        updateQuantityUseCase: sl(),
      ));

  sl.registerLazySingleton(() => OrdersBloc(
        getOrdersUseCase: sl(),
        getMyBookingsUseCase: sl(),
      ));

  sl.registerFactory(() => OrderDetailBloc(
        getOrderDetailsUseCase: sl(),
        cancelOrderUseCase: sl(),
        updateOrderUseCase: sl(),
        deleteOrderUseCase: sl(),
      ));

  sl.registerFactory(() => CheckoutBloc(
        placeOrderUseCase: sl(),
        applyCouponUseCase: sl(),
        getGovernoratesUseCase: sl(),
        getCentersUseCase: sl(),
        getUserDataUseCase: sl(),
        getUserAddressesUseCase: sl(),
        ordersBloc: sl(),
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

  // Service Details
  sl.registerFactory(() => ServiceDetailsBloc(
        getServiceDetailsUseCase: sl(),
        toggleServiceFavoriteUseCase: sl(),
        createServiceReviewUseCase: sl(),
        updateServiceReviewUseCase: sl(),
      ));

  // Service Booking
  sl.registerFactory(() => ServiceBookingBloc(
        createBookingUseCase: sl(),
        getGovernoratesUseCase: sl(),
        getCentersUseCase: sl(),
        getUserDataUseCase: sl(),
        getUserAddressesUseCase: sl(),
        ordersBloc: sl(),
      ));

  sl.registerFactory(() => BookingDetailBloc(
        cancelBookingUseCase: sl(),
        updateBookingUseCase: sl(),
        deleteBookingUseCase: sl(),
        ordersBloc: sl(),
      ));

  sl.registerFactory(() => ProviderDetailsBloc(
        getProviderDetailsUseCase: sl(),
      ));

  // Brands
  sl.registerFactory(() => BrandsBloc(
        sl(),
        sl(),
      ));

  // Offers
  sl.registerFactory(() => OffersBloc(
        sl(),
      ));

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
  sl.registerLazySingleton(() => GetServiceFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => ToggleServiceFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
  sl.registerLazySingleton(() => CreateProductReviewUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductReviewUseCase(sl()));

  // UseCases - Cart
  sl.registerLazySingleton(() => GetCartItemsUseCase(sl()));
  sl.registerLazySingleton(() => AddToCartUseCase(sl()));
  sl.registerLazySingleton(() => RemoveFromCartUseCase(sl()));
  sl.registerLazySingleton(() => UpdateQuantityUseCase(sl()));
  sl.registerLazySingleton(() => GetUserDataUseCase(sl()));
  sl.registerLazySingleton(() => GetUserAddressesUseCase(sl()));
  sl.registerLazySingleton(() => GetCartGovernoratesUseCase(sl()));
  sl.registerLazySingleton(() => ApplyCouponUseCase(sl()));
  sl.registerLazySingleton(() => PlaceOrderUseCase(sl()));

  // UseCases - Auth (new)
  sl.registerLazySingleton(() => ClearUserSessionUseCase(sl()));

  // UseCases - Orders
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(sl()));
  sl.registerLazySingleton(() => CancelOrderUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderUseCase(sl()));
  sl.registerLazySingleton(() => DeleteOrderUseCase(sl()));

  // UseCases - Service Details
  sl.registerLazySingleton(() => GetServiceDetailsUseCase(sl()));
  sl.registerLazySingleton(
      () => detail_favorite.ToggleServiceFavoriteUseCase(sl()));
  sl.registerLazySingleton(() => CreateServiceReviewUseCase(sl()));
  sl.registerLazySingleton(() => UpdateServiceReviewUseCase(sl()));

  // UseCases - Service Booking
  sl.registerLazySingleton(() => CreateBookingUseCase(sl()));
  sl.registerLazySingleton(() => GetMyBookingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateBookingUseCase(sl()));
  sl.registerLazySingleton(() => CancelBookingUseCase(sl()));
  sl.registerLazySingleton(() => DeleteBookingUseCase(sl()));

  // UseCases - Provider Details
  sl.registerLazySingleton(() => GetProviderDetailsUseCase(sl()));

  // UseCases  // Brands
  sl.registerLazySingleton(() => GetBrandsUseCase(sl()));
  sl.registerLazySingleton(() => GetBrandProductsUseCase(sl()));

  // Offers
  sl.registerLazySingleton(() => GetOffersUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(sl(), sl(), sl(), sl()));
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
  sl.registerLazySingleton<ProductDetailsRepository>(
      () => ProductDetailsRepositoryImpl(sl()));
  sl.registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(sl(), sl()));

  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));

  sl.registerLazySingleton<ServiceDetailsRepository>(
      () => ServiceDetailsRepositoryImpl(sl()));
  sl.registerLazySingleton<BookingRepository>(
      () => BookingRepositoryImpl(sl()));
  sl.registerLazySingleton<ProviderDetailsRepository>(
      () => ProviderDetailsRepositoryImpl(sl()));
  sl.registerLazySingleton<BrandsRepository>(
      () => BrandsRepositoryImpl(sl()));
  sl.registerLazySingleton<OffersRepository>(
      () => OffersRepositoryImpl(sl()));

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
  sl.registerLazySingleton<ProductDetailsRemoteDataSource>(
      () => ProductDetailsRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSourceImpl(StorageService.instance));
  sl.registerLazySingleton<FavoriteLocalDataSource>(
      () => FavoriteLocalDataSourceImpl(StorageService.instance));

  sl.registerLazySingleton<OrdersRemoteDataSource>(
      () => OrdersRemoteDataSourceImpl(DioService.instance));

  sl.registerLazySingleton<ServiceDetailsRemoteDataSource>(
      () => ServiceDetailsRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<ProviderDetailsRemoteDataSource>(
      () => ProviderDetailsRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<BrandsRemoteDataSource>(
      () => BrandsRemoteDataSourceImpl(DioService.instance));
  sl.registerLazySingleton<OffersRemoteDataSource>(
      () => OffersRemoteDataSourceImpl(DioService.instance));
}
