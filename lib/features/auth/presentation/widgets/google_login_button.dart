import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/presentation/bloc/google_login/google_login_bloc.dart';

class GoogleLoginButton extends StatelessWidget {
  const GoogleLoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocProvider(
      create: (_) => sl<GoogleLoginBloc>(),
      child: BlocConsumer<GoogleLoginBloc, GoogleLoginState>(
        listenWhen: (previous, current) =>
            previous.user != current.user ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.user != null) {
            context.go(AppRoutes.home);
          }
          if (state.errorMessage != null) {
            context.showErrorSnackBar(state.errorMessage!);
          }
        },
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: state.isLoading
                  ? null
                  : () {
                      context.read<GoogleLoginBloc>().add(
                            const GoogleLoginStarted(),
                          );
                    },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14.h),
                side: BorderSide(color: cs.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              icon: state.isLoading
                  ? SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.primary,
                      ),
                    )
                  : SvgPicture.asset(
                      AppAssets.googleIcon,
                      width: 24.w,
                      height: 24.h,
                      colorFilter: ColorFilter.mode(
                        cs.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
              label: Text(
                state.isLoading
                    ? 'auth.logging_in'.tr()
                    : 'auth.login_with_google'.tr(),
                style: tt.bodyLarge?.copyWith(
                  color: cs.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
