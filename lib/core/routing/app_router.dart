import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/presentation/screens/auth_callback_page.dart';
import 'package:wassaly/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:wassaly/features/auth/presentation/screens/login_page.dart';
import 'package:wassaly/features/auth/presentation/screens/otp_verification_page.dart';
import 'package:wassaly/features/auth/presentation/screens/reset_password_page.dart';
import 'package:wassaly/features/auth/presentation/screens/signup_page.dart';
import 'package:wassaly/features/auth/presentation/screens/splash_page.dart';
import 'package:wassaly/features/cart/presentation/screens/cart_page.dart';
import 'package:wassaly/features/category/presentation/screens/category_page.dart';
import 'package:wassaly/features/favorite/presentation/screens/favorite_page.dart';
import 'package:wassaly/features/home/presentation/screens/home_page.dart';
import 'package:wassaly/features/main_layout/presentation/screens/main_layout_page.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:wassaly/features/profile/presentation/screens/add_address_page.dart';
import 'package:wassaly/features/profile/presentation/screens/addresses_page.dart';
import 'package:wassaly/features/profile/presentation/screens/edit_profile_page.dart';
import 'package:wassaly/features/profile/presentation/screens/profile_page.dart';

import '../../features/profile/presentation/screens/privacy_policy_page.dart';
import '../../features/profile/presentation/screens/terms_of_service_page.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  // Handle deep links for Google OAuth callbacks
  redirect: (context, state) {
    final uri = state.uri;

    // Convert wasly://auth/callback deep links to web routes
    if (uri.scheme == 'wasly' &&
        uri.host == 'auth' &&
        uri.path == '/callback') {
      // Fix HTML encoding in query parameters (&amp; -> &)
      final String fixedQuery = uri.query.replaceAll('&amp;', '&');
      final fixedUri =
          Uri.parse('${uri.scheme}://${uri.host}${uri.path}?$fixedQuery');

      // Build web route with query parameters
      final queryParams = <String, String>{};
      if (fixedUri.queryParameters['token'] != null) {
        queryParams['token'] = fixedUri.queryParameters['token']!;
      }
      if (fixedUri.queryParameters['user_id'] != null) {
        queryParams['id'] = fixedUri.queryParameters['user_id']!;
      }
      if (fixedUri.queryParameters['full_name'] != null) {
        queryParams['full_name'] = fixedUri.queryParameters['full_name']!;
      }
      if (fixedUri.queryParameters['email'] != null) {
        queryParams['email'] = fixedUri.queryParameters['email']!;
      }
      if (fixedUri.queryParameters['avatar'] != null) {
        queryParams['avatar'] = fixedUri.queryParameters['avatar']!;
      }

      final webUri = Uri(
        path: AppRoutes.authCallback,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      AppLogger.info(' Converting deep link to web route: $uri -> $webUri');
      return webUri.toString();
    }

    return null; // No redirect needed
  },
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.splash,
      name: 'splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
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
              path: AppRoutes.category,
              name: 'category',
              builder: (context, state) => const CategoryPage(),
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
                  path: AppRoutes.editProfile
                      .replaceFirst('${AppRoutes.profile}/', ''),
                  name: 'editProfile',
                  builder: (context, state) => BlocProvider.value(
                    value: sl<ProfileBloc>(),
                    child: const EditProfilePage(),
                  ),
                ),
                GoRoute(
                  path: AppRoutes.addresses
                      .replaceFirst('${AppRoutes.profile}/', ''),
                  name: 'addresses',
                  builder: (context, state) => BlocProvider.value(
                    value: sl<ProfileBloc>(),
                    child: const AddressesPage(),
                  ),
                  routes: [
                    GoRoute(
                      path: AppRoutes.addAddress
                          .replaceFirst('${AppRoutes.addresses}/', ''),
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
      path: AppRoutes.cart,
      name: 'cart',
      builder: (context, state) => const CartPage(),
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
  ],
);
