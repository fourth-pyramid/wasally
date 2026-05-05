import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/signup/signup_bloc.dart';

class SignupTermsCheckbox extends StatelessWidget {
  final VoidCallback onTermsPressed;
  final VoidCallback onPrivacyPressed;

  const SignupTermsCheckbox({
    super.key,
    required this.onTermsPressed,
    required this.onPrivacyPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<SignupBloc, SignupState>(
      buildWhen: (previous, current) =>
          previous.isTermsAccepted != current.isTermsAccepted,
      builder: (context, state) {
        return Row(
          children: [
            Checkbox(
              value: state.isTermsAccepted,
              onChanged: (value) {
                context
                    .read<SignupBloc>()
                    .add(TermsAcceptedChanged(value ?? false));
              },
              activeColor: cs.primary,
              side: BorderSide(color: cs.outline),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    'auth.agree_to'.tr(),
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: onTermsPressed,
                    child: Text(
                      'auth.terms_of_service'.tr(),
                      style: tt.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    ' ${'auth.and'.tr()} ',
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: onPrivacyPressed,
                    child: Text(
                      'auth.privacy_policy'.tr(),
                      style: tt.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
