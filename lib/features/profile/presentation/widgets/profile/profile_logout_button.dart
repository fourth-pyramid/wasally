import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

class ProfileLogoutButton extends StatelessWidget {
  final VoidCallback onLogoutAllDevices;

  const ProfileLogoutButton({required this.onLogoutAllDevices, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.pagePadding),
      child: AppButton(
        label: 'profile.logout'.tr(),
        variant: ButtonVariant.danger,
        isFullWidth: true,
        prefixIcon: Icon(Icons.logout,
            size: 20.r, color: context.theme.colorScheme.onError),
        onPressed: () => _showLogoutDialog(context),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => _LogoutChoiceDialog(),
    );

    if (!context.mounted) return;

    if (result != null) {
      switch (result) {
        case 'this_device':
          context.read<SessionBloc>().add(const SessionLogoutRequested());
          break;
        case 'all_devices':
          onLogoutAllDevices();
          break;
      }
    }
  }
}

class _LogoutChoiceDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.logout,
              size: 48.r,
              color: cs.error,
            ),
            16.verticalSpace,
            Text(
              'profile.logout_title'.tr(),
              style: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              'profile.logout_choice_message'.tr(),
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'profile.logout_this_device'.tr(),
                variant: ButtonVariant.danger,
                onPressed: () => Navigator.of(context).pop('this_device'),
              ),
            ),
            12.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'profile.logout_all_devices'.tr(),
                variant: ButtonVariant.danger,
                onPressed: () => Navigator.of(context).pop('all_devices'),
              ),
            ),
            12.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: AppButton(
                label: 'shared.cancel'.tr(),
                variant: ButtonVariant.secondary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
