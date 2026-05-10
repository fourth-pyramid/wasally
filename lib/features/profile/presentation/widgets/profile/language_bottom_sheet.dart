import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/presentation/bloc/settings/settings_bloc.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (prev, curr) => prev.language != curr.language,
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Text(
                    'profile.language'.tr(),
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            16.verticalSpace,

            // Language options
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  _LanguageOption(
                    title: 'profile.arabic'.tr(),
                    subtitle: 'ar',
                    isSelected: state.language == 'ar',
                    onTap: () async {
                      final currentContext = context;
                      if (state.language != 'ar') {
                        final confirmed =
                            await _showLanguageChangeDialog(currentContext);
                        if ((confirmed ?? false) && currentContext.mounted) {
                          currentContext
                              .read<SettingsBloc>()
                              .add(const LanguageToggled());
                        }
                      }
                      if (currentContext.mounted) {
                        currentContext.pop();
                      }
                    },
                  ),
                  16.verticalSpace,
                  _LanguageOption(
                    title: 'profile.english'.tr(),
                    subtitle: 'en',
                    isSelected: state.language == 'en',
                    onTap: () async {
                      final currentContext = context;
                      if (state.language != 'en') {
                        final confirmed =
                            await _showLanguageChangeDialog(currentContext);
                        if ((confirmed ?? false) && currentContext.mounted) {
                          currentContext
                              .read<SettingsBloc>()
                              .add(const LanguageToggled());
                        }
                      }
                      if (currentContext.mounted) {
                        currentContext.pop();
                      }
                    },
                  ),
                ],
              ),
            ),

            32.verticalSpace,
          ],
        );
      },
    );
  }

  Future<bool?> _showLanguageChangeDialog(BuildContext context) async {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return await showAppDialog<bool>(
      child: AlertDialog(
        title: Text(
          'profile.language_change_title'.tr(),
          style: tt.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: cs.onSurface,
          ),
        ),
        content: Text(
          'profile.language_change_message'.tr(),
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurface,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(
              'profile.language_change_cancel'.tr(),
              style: TextStyle(
                color: cs.onSurface,
              ),
            ),
          ),
          AppButton(
              label: 'profile.language_change_confirm'.tr(),
              onPressed: () => context.pop(true)),
        ],
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? cs.primary : cs.outlineVariant,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
          color: isSelected ? cs.primaryContainer : cs.surface,
        ),
        child: Row(
          children: [
            Icon(
              Icons.language_outlined,
              color: isSelected ? cs.primary : cs.onSurfaceVariant,
              size: 24.r,
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? cs.primary : cs.onSurface,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    subtitle,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: cs.primary,
                size: 24.r,
              ),
          ],
        ),
      ),
    );
  }
}
