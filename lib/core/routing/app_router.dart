import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/screens/auth_callback_page.dart';
import 'package:wassaly/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:wassaly/features/auth/presentation/screens/login_page.dart';
import 'package:wassaly/features/auth/presentation/screens/otp_verification_page.dart';
import 'package:wassaly/features/auth/presentation/screens/reset_password_page.dart';
import 'package:wassaly/features/auth/presentation/screens/signup_page.dart';
import 'package:wassaly/features/auth/presentation/screens/splash_page.dart';
import 'package:wassaly/features/brands/presentation/pages/brand_details_page.dart';
import 'package:wassaly/features/brands/presentation/pages/brands_page.dart';
import 'package:wassaly/features/offers/presentation/pages/offers_page.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';
import 'package:wassaly/features/cart/presentation/bloc/checkout/checkout_bloc.dart';
import 'package:wassaly/features/cart/presentation/screens/cart_page.dart';
import 'package:wassaly/features/cart/presentation/screens/checkout_page.dart';
import 'package:wassaly/features/favorite/presentation/screens/favorite_page.dart';
import 'package:wassaly/features/home/presentation/screens/home_page.dart';
import 'package:wassaly/features/main_layout/presentation/screens/main_layout_page.dart';
import 'package:wassaly/features/orders/presentation/screens/orders_page.dart';
import 'package:wassaly/features/orders/presentation/bloc/order_detail/order_detail_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/order_detail/order_detail_event.dart';
import 'package:wassaly/features/orders/presentation/screens/order_details_page.dart';
import 'package:wassaly/features/orders/presentation/screens/booking_details_page.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_bloc.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_event.dart';
import 'package:wassaly/features/product_details/presentation/screens/product_details_page.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:wassaly/features/profile/presentation/screens/add_address_page.dart';
import 'package:wassaly/features/profile/presentation/screens/addresses_page.dart';
import 'package:wassaly/features/profile/presentation/screens/edit_profile_page.dart';
import 'package:wassaly/features/profile/presentation/screens/profile_page.dart';
import 'package:wassaly/features/profile/presentation/screens/terms_of_service_page.dart';
import 'package:wassaly/features/provider_details/presentation/screens/provider_details_page.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';
import 'package:wassaly/features/service_booking/presentation/screens/booking_success_page.dart';
import 'package:wassaly/features/cart/presentation/screens/order_success_page.dart';
import 'package:wassaly/features/cart/domain/entities/order_entity.dart' as cart_order;
import 'package:wassaly/features/service_booking/presentation/screens/service_booking_page.dart';
import 'package:wassaly/features/service_details/domain/entities/service_detail_entity.dart';
import 'package:wassaly/features/service_details/presentation/screens/service_details_page.dart';
import 'package:wassaly/features/sub_category/presentation/screens/sub_category_page.dart';

import '../../features/category/presentation/screens/all_categories_page.dart';
import '../../features/category/presentation/screens/category_page.dart';
import '../../features/home/presentation/bloc/home_bloc.dart';
import '../../features/home/presentation/bloc/home_event.dart';
import '../../features/profile/presentation/screens/privacy_policy_page.dart';
import '../../features/search/presentation/screens/search_page.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  // Handle deep links for Google OAuth callbacks
  redirect: (context, state) {
    return DeepLinkService.instance.getRouteForDeepLink(state.uri);
  },
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => MainLayoutPage(
        navigationShell: navigationShell,
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.cart,
              name: 'cart',
              builder: (context, state) => const CartPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorite,
              name: 'favorite',
              builder: (context, state) => const FavoritePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              builder: (context, state) => BlocProvider.value(
                value: sl<ProfileBloc>()..add(const ProfileFetched()),
                child: const ProfilePage(),
              ),
              routes: [
                GoRoute(
                  path: 'edit',
                  name: 'editProfile',
                  builder: (context, state) => BlocProvider.value(
                    value: sl<ProfileBloc>(),
                    child: const EditProfilePage(),
                  ),
                ),
                GoRoute(
                  path: 'orders',
                  name: 'orders',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    final initialIndex = extra?['initialIndex'] as int? ?? 0;
                    return OrdersPage(initialIndex: initialIndex);
                  },
                ),
                GoRoute(
                  path: 'orders/details',
                  name: 'orderDetails',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    final orderId = extra?['orderId'] as int? ?? 0;
                    return BlocProvider(
                      create: (_) => sl<OrderDetailBloc>()..add(FetchOrderDetailEvent(orderId)),
                      child: OrderDetailsPage(orderId: orderId),
                    );
                  },
                ),
                GoRoute(
                  path: 'bookings/details',
                  name: 'bookingDetails',
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    final booking = extra?['booking'] as BookingEntity?;
                    if (booking == null) {
                      return Scaffold(
                        body: Center(child: Text(context.l10n.errors_something_went_wrong)),
                      );
                    }
                    return BlocProvider(
                      create: (_) => sl<BookingDetailBloc>()..add(InitializeBookingDetailEvent(booking)),
                      child: BookingDetailsPage(booking: booking),
                    );
                  },
                ),
                GoRoute(
                  path: 'addresses',
                  name: 'addresses',
                  builder: (context, state) => BlocProvider.value(
                    value: sl<ProfileBloc>(),
                    child: const AddressesPage(),
                  ),
                  routes: [
                    GoRoute(
                      path: 'add',
                      name: 'addAddress',
                      builder: (context, state) => BlocProvider.value(
                        value: sl<ProfileBloc>(),
                        child: AddAddressPage(
                          address: state.extra as AddressEntity?,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.allCategories,
      name: 'allCategories',
      builder: (context, state) => BlocProvider.value(
        value: sl<HomeBloc>()..add(GetCategoriesEvent()),
        child: const CategoriesPage(),
      ),
    ),
    GoRoute(
      path: AppRoutes.category,
      name: 'category',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final category = extra?['category'];
        if (category == null) {
          return Scaffold(
            body: Center(child: Text(context.l10n.errors_invalid_category)),
          );
        }
        return CategoryPage(category: category);
      },
    ),
    GoRoute(
      path: AppRoutes.login,
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signup,
      name: 'signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      name: 'forgotPassword',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: AppRoutes.otpVerification,
      name: 'otpVerification',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final email = extra?['email'] as String? ?? '';
        final verificationType =
            extra?['verificationType'] as VerificationType? ??
                VerificationType.register;
        return OtpVerificationPage(
          email: email,
          verificationType: verificationType,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      name: 'resetPassword',
      builder: (context, state) {
        final args = state.extra as ResetPasswordArgs?;
        return ResetPasswordPage(
          email: args?.email ?? '',
          token: args?.token ?? '',
        );
      },
    ),
    GoRoute(
      path: AppRoutes.authCallback,
      name: 'authCallback',
      builder: (context, state) {
        final queryParams = state.uri.queryParameters;
        return AuthCallbackPage(
          token: queryParams['token'],
          id: queryParams['id'],
          fullName: queryParams['full_name'],
          email: queryParams['email'],
          avatar: queryParams['avatar'],
        );
      },
    ),
    GoRoute(
      path: AppRoutes.privacyPolicy,
      name: 'privacyPolicy',
      builder: (context, state) => const PrivacyPolicyPage(),
    ),
    GoRoute(
      path: AppRoutes.termsOfService,
      name: 'termsOfService',
      builder: (context, state) => const TermsOfServicePage(),
    ),
    GoRoute(
      path: AppRoutes.subCategory,
      name: 'subCategory',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final subCategory = extra?['subCategory'];
        if (subCategory == null) {
          return Scaffold(
            body: Center(child: Text(context.l10n.errors_invalid_sub_category)),
          );
        }
        return SubCategoryPage(subCategory: subCategory);
      },
    ),
    GoRoute(
      path: AppRoutes.search,
      name: 'search',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const SearchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;
          final tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    ),
    GoRoute(
      path: AppRoutes.productDetails,
      name: 'productDetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final productId = extra?['productId'] as int? ?? 0;
        if (productId <= 0) {
          return Scaffold(
            body: Center(
              child: Text(context.l10n.errors_something_went_wrong),
            ),
          );
        }
        return ProductDetailsPage(productId: productId);
      },
    ),
    GoRoute(
      path: AppRoutes.checkout,
      name: 'checkout',
      builder: (context, state) {
        final cartState = state.extra as CartState?;
        if (cartState == null) {
          return Scaffold(
            body: Center(
              child: Text(context.l10n.errors_something_went_wrong),
            ),
          );
        }
        return BlocProvider(
          create: (_) => sl<CheckoutBloc>()
            ..add(CheckoutInitialized(cartState: cartState)),
          child: const CheckoutPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.orderSuccess,
      name: 'orderSuccess',
      builder: (context, state) {
        final order = state.extra as cart_order.OrderEntity?;
        if (order == null) {
          return Scaffold(
            body: Center(child: Text(context.l10n.errors_something_went_wrong)),
          );
        }
        return OrderSuccessPage(order: order);
      },
    ),
    GoRoute(
      path: AppRoutes.serviceDetails,
      name: 'serviceDetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final serviceId = extra?['serviceId'] as int? ?? 0;
        if (serviceId <= 0) {
          return Scaffold(
            body: Center(child: Text(context.l10n.errors_something_went_wrong)),
          );
        }
        return ServiceDetailsPage(serviceId: serviceId);
      },
    ),
    GoRoute(
      path: AppRoutes.serviceBooking,
      name: 'serviceBooking',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final service = extra?['service'] as ServiceDetailEntity?;
        final selectedDay = extra?['selectedDay'] as ServiceAvailableDayEntity?;
        final selectedTime =
            extra?['selectedTime'] as ServiceAvailableTimeEntity?;

        if (service == null) {
          return Scaffold(
            body: Center(child: Text(context.l10n.errors_something_went_wrong)),
          );
        }
        return ServiceBookingPage(
          service: service,
          selectedDay: selectedDay,
          selectedTime: selectedTime,
        );
      },
    ),
    GoRoute(
      path: AppRoutes.bookingSuccess,
      name: 'bookingSuccess',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final booking = extra?['booking'] as BookingEntity?;
        if (booking == null) {
          return Scaffold(
            body: Center(child: Text(context.l10n.errors_something_went_wrong)),
          );
        }
        return BookingSuccessPage(booking: booking);
      },
    ),
    GoRoute(
      path: AppRoutes.providerDetails,
      name: 'providerDetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final providerId = extra?['providerId'] as int? ?? 0;
        if (providerId <= 0) {
          return Scaffold(
            body: Center(child: Text(context.l10n.errors_something_went_wrong)),
          );
        }
        return ProviderDetailsPage(providerId: providerId);
      },
    ),
    GoRoute(
      path: AppRoutes.offers,
      name: 'offers',
      builder: (context, state) => const OffersPage(),
    ),
    GoRoute(
      path: AppRoutes.brands,
      name: 'brands',
      builder: (context, state) => const BrandsPage(),
    ),
    GoRoute(
      path: AppRoutes.brandDetails,
      name: 'brandDetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        final brandId = extra?['brandId'] as int? ?? 0;
        final brandName = extra?['brandName'] as String? ?? '';
        final brandImage = extra?['brandImage'] as String? ?? '';
        if (brandId <= 0) {
          return Scaffold(
            body: Center(child: Text(context.l10n.errors_something_went_wrong)),
          );
        }
        return BrandDetailsPage(
          brandId: brandId,
          brandName: brandName,
          brandImage: brandImage,
        );
      },
    ),
  ],
);
