import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/app_reviews/data/datasources/app_reviews_remote_datasource.dart';
import 'package:wassaly/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:wassaly/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:wassaly/features/auth/data/datasources/fcm_token_remote_datasource.dart';
import 'package:wassaly/features/brands/data/datasources/brands_remote_datasource.dart';
import 'package:wassaly/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:wassaly/features/cart/data/datasources/cart_remote_datasource.dart';
import 'package:wassaly/features/category/data/datasources/category_remote_datasource.dart';
import 'package:wassaly/features/favorite/data/datasources/favorite_local_datasource.dart';
import 'package:wassaly/features/favorite/data/datasources/favorite_remote_datasource.dart';
import 'package:wassaly/features/home/data/datasources/home_remote_datasource.dart';
import 'package:wassaly/features/notifications/data/datasources/notification_local_datasource.dart';
import 'package:wassaly/features/notifications/data/datasources/notification_remote_datasource.dart';
import 'package:wassaly/features/offers/data/datasources/offers_remote_datasource.dart';
import 'package:wassaly/features/orders/data/datasources/orders_local_datasource.dart';
import 'package:wassaly/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:wassaly/features/product_details/data/datasources/product_details_remote_datasource.dart';
import 'package:wassaly/features/products_filter/data/datasources/products_filter_remote_datasource.dart';
import 'package:wassaly/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:wassaly/features/provider_details/data/datasources/provider_details_remote_datasource.dart';
import 'package:wassaly/features/search/data/datasources/search_remote_datasource.dart';
import 'package:wassaly/features/service_booking/data/datasources/booking_local_datasource.dart';
import 'package:wassaly/features/service_booking/data/datasources/booking_remote_datasource.dart';
import 'package:wassaly/features/service_details/data/datasources/service_details_remote_datasource.dart';
import 'package:wassaly/features/sub_category/data/datasources/sub_category_remote_datasource.dart';

void initDataSourceDependencies() {
  // DataSources
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => const AuthLocalDataSourceImpl(FlutterSecureStorage()),
    )
    ..registerLazySingleton<FcmTokenRemoteDataSource>(
      () => FcmTokenRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => ProfileRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<SubCategoryRemoteDataSource>(
      () => SubCategoryRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<CategoryRemoteDataSource>(
      () => CategoryRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<FavoriteRemoteDataSource>(
      () => FavoriteRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<ProductDetailsRemoteDataSource>(
      () => ProductDetailsRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<CartRemoteDataSource>(
      () => CartRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<CartLocalDataSource>(
      CartLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<FavoriteLocalDataSource>(
      FavoriteLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<OrdersRemoteDataSource>(
      () => OrdersRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<OrdersLocalDataSource>(
      OrdersLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<ServiceDetailsRemoteDataSource>(
      () => ServiceDetailsRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<BookingRemoteDataSource>(
      () => BookingRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<BookingLocalDataSource>(
      BookingLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<ProviderDetailsRemoteDataSource>(
      () => ProviderDetailsRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<BrandsRemoteDataSource>(
      () => BrandsRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<OffersRemoteDataSource>(
      () => OffersRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<AppReviewsRemoteDataSource>(
      () => AppReviewsRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<ProductsFilterRemoteDataSource>(
      () => ProductsFilterRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(DioService.instance),
    )
    ..registerLazySingleton<NotificationLocalDataSource>(
      NotificationLocalDataSourceImpl.new,
    );
}
