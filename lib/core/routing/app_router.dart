import 'package:go_router/go_router.dart';
import 'package:wassaly/core/routing/app_routes.dart';
import 'package:wassaly/core/routing/global_navigator.dart';
import 'package:wassaly/features/auth/presentation/screens/forgot_password_page.dart';
import 'package:wassaly/features/auth/presentation/screens/login_page.dart';
import 'package:wassaly/features/auth/presentation/screens/otp_verification_page.dart';
import 'package:wassaly/features/auth/presentation/screens/reset_password_page.dart';
import 'package:wassaly/features/auth/presentation/screens/signup_page.dart';
import 'package:wassaly/features/onboarding/presentation/screens/onboarding_page.dart';

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.onboarding,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.onboarding,
      name: 'onboarding',
      builder: (context, state) => const OnboardingPage(),
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
        final email = state.extra as String? ?? '';
        return OtpVerificationPage(email: email);
      },
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      name: 'resetPassword',
      builder: (context, state) {
        final args = state.extra as ResetPasswordArgs?;
        return ResetPasswordPage(
          email: args?.email ?? '',
          otp: args?.otp ?? '',
        );
      },
    ),
  ],
);
