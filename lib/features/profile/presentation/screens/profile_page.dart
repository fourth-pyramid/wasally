import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_logout_button.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_settings_section.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_stats_card.dart';
import 'package:wassaly/features/profile/presentation/widgets/profile/profile_support_section.dart';

import '../widgets/profile/profile_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: sl<OrdersBloc>()
            ..add(const GetOrdersEvent())
            ..add(const GetServiceBookingsEvent()),
        ),
      ],
      child: const _ProfileView(),
    );
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
              context.read<OrdersBloc>().add(const ResetOrdersEvent());
              context.go(AppRoutes.login);
            } else {
              context.showTypedSnackBar(context.l10n.profile_action_success,
                  type: SnackBarType.success);
            }
          } else if (state.actionStatus.isFailure &&
              state.actionError != null) {
            context.showTypedSnackBar(state.actionError!,
                type: SnackBarType.error);
          }
        },
        child: CustomScrollView(
          slivers: [
            AppSliverTopBar(
              title: context.l10n.profile_my_account,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => context.push(AppRoutes.editProfile),
                  icon: Icon(Icons.edit_outlined, color: cs.primary),
                  style: IconButton.styleFrom(
                    backgroundColor: cs.primaryContainer.withValues(alpha: 0.3),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                ),
                16.horizontalSpace,
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  16.verticalSpace,
                  const ProfileHeader(),
                  16.verticalSpace,
                  const ProfileStatsCard(),
                  16.verticalSpace,
                  const ProfileSettingsSection(),
                  16.verticalSpace,
                  const ProfileSupportSection(),
                  16.verticalSpace,
                  ProfileLogoutButton(
                    onLogoutAllDevices: () => context
                        .read<ProfileBloc>()
                        .add(const ProfileLoggedOutAllDevices()),
                  ),
                  16.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
