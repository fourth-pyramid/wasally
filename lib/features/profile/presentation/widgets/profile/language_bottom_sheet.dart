import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/presentation/bloc/settings/settings_bloc.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<SettingsBloc, SettingsState>(
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
                    onTap: () {
                      if (state.language != 'ar') {
                        context
                            .read<SettingsBloc>()
                            .add(const LanguageToggled());
                      }
                      context.pop();
                    },
                  ),
                  16.verticalSpace,
                  _LanguageOption(
                    title: 'profile.english'.tr(),
                    subtitle: 'en',
                    isSelected: state.language == 'en',
                    onTap: () {
                      if (state.language != 'en') {
                        context
                            .read<SettingsBloc>()
                            .add(const LanguageToggled());
                      }
                      context.pop();
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
