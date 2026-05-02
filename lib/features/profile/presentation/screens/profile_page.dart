import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_app_bar.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_logout_button.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_settings_section.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_stats_card.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_support_section.dart';

import '../widgets/profile/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) =>
            prev.actionStatus != curr.actionStatus && curr.actionStatus.isDone,
        listener: (context, state) {
          if (state.actionStatus.isSuccess) {
            if (state.user == null) {
              context.go(AppRoutes.login);
            } else {
              context.showSuccessSnackBar('profile.action_success'.tr());
            }
          } else if (state.actionStatus.isFailure &&
              state.actionError != null) {
            context.showErrorSnackBar(state.actionError!);
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const ProfileAppBar(),
                  AppSpacing.md.verticalSpace,
                  const ProfileHeader(),
                  AppSpacing.md.verticalSpace,
                  const ProfileStatsCard(),
                  AppSpacing.md.verticalSpace,
                  const ProfileSettingsSection(),
                  AppSpacing.md.verticalSpace,
                  const ProfileSupportSection(),
                  AppSpacing.md.verticalSpace,
                  ProfileLogoutButton(
                    onLogoutAllDevices: () => context
                        .read<ProfileBloc>()
                        .add(const ProfileLoggedOutAllDevices()),
                  ),
                  AppSpacing.md.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
