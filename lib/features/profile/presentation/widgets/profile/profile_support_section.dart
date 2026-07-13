import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_menu_tile.dart';

class ProfileSupportSection extends StatelessWidget {
  const ProfileSupportSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(start: 8.w, bottom: 8.h),
            child: Text(
              context.l10n.profile_support_and_privacy,
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
          AppCard(
            showShadow: true,
            child: Column(
              children: [
                ProfileMenuTile(
                  icon: Icons.help_outline,
                  title: context.l10n.profile_help_center,
                  onTap: () => unawaited(context.push(AppRoutes.helpCenter)),
                ),
                ProfileMenuTile(
                  icon: Icons.reviews_outlined,
                  title: context.l10n.profile_app_reviews,
                  onTap: () => unawaited(context.push(AppRoutes.appReviews)),
                ),
                ProfileMenuTile(
                  icon: Icons.privacy_tip_outlined,
                  title: context.l10n.profile_privacy_policy,
                  onTap: () => unawaited(
                    GoRouter.of(context).push(AppRoutes.privacyPolicy),
                  ),
                ),
                ProfileMenuTile(
                  icon: Icons.play_circle_outline,
                  title: context.l10n.profile_restart_tour,
                  onTap: () async {
                    // ponytail: Clear tour flags and show confirmation snackbar
                    await StorageService.instance.clearShowcaseSeenFlags();
                    if (context.mounted) {
                      context.showTypedSnackBar(
                        context.l10n.profile_restart_tour_success,
                        type: SnackBarType.success,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
