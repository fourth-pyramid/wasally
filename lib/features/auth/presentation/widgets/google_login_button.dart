import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/google_login/google_login_bloc.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

class GoogleLoginButton extends StatefulWidget {
  const GoogleLoginButton({super.key});

  @override
  State<GoogleLoginButton> createState() => _GoogleLoginButtonState();
}

class _GoogleLoginButtonState extends State<GoogleLoginButton>
    with WidgetsBindingObserver {
  GoogleLoginBloc? _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When app resumes and still loading, user likely cancelled
      if (_bloc?.state.isLoading ?? false) {
        // Small delay to allow deep link callback to process first
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && (_bloc?.state.isLoading ?? false)) {
            _bloc?.add(const GoogleLoginCancelled());
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocProvider(
      create: (_) {
        _bloc = sl<GoogleLoginBloc>();
        return _bloc!;
      },
      child: BlocConsumer<GoogleLoginBloc, GoogleLoginState>(
        listenWhen: (previous, current) =>
            previous.user != current.user ||
            previous.errorMessage != current.errorMessage,
        listener: (context, state) {
          if (state.user != null) {
            sl<SessionBloc>().add(SessionUserUpdated(state.user!));
            context.go(AppRoutes.home);
          }
          if (state.errorMessage != null) {
            context.showTypedSnackBar(state.errorMessage!,
                type: SnackBarType.error);
          }
        },
        builder: (context, state) {
          return AppButton(
            label: context.l10n.auth_login_with_google,
            onPressed: state.isLoading
                ? null
                : () {
                    context.read<GoogleLoginBloc>().add(
                          const GoogleLoginStarted(),
                        );
                  },
            color: cs.surface,
            variant: ButtonVariant.outline,
            isLoading: state.isLoading,
            isFullWidth: true,
            height: ButtonSize.medium,
            prefixIcon: state.isLoading
                ? null
                : CommonImage(
                    imageUrl: AppAssets.googleIcon,
                    width: 24,
                    height: 24,
                    color: cs.onSurface,
                  memCacheHeight: 24 * 2,
                  ),
            textColor: cs.onSurface,
          );
        },
      ),
    );
  }
}
