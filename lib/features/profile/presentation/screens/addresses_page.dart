import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';

class AddressesPage extends StatelessWidget {
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _AddressesView();
  }
}

class _AddressesView extends StatefulWidget {
  const _AddressesView();

  @override
  State<_AddressesView> createState() => _AddressesViewState();
}

class _AddressesViewState extends State<_AddressesView> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const AddressesFetched());
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile.saved_addresses'.tr()),
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (prev, curr) =>
            prev.addressStatus != curr.addressStatus ||
            prev.addresses != curr.addresses,
        builder: (context, state) {
          if (state.addressStatus.isLoading) {
            return const _AddressSkeleton();
          }

          if (state.addressStatus.isFailure && state.addressError != null) {
            return AppErrorWidget(
              title: 'profile.addresses_error'.tr(),
              message: state.addressError,
              onRetry: () =>
                  context.read<ProfileBloc>().add(const AddressesFetched()),
            );
          }

          if (state.addresses.isEmpty) {
            return AppEmptyState(
              icon: Icons.location_on_outlined,
              title: 'profile.no_addresses'.tr(),
              subtitle: 'profile.add_address_hint'.tr(),
              actionLabel: 'profile.add_address'.tr(),
              onAction: () => context.push(AppRoutes.addAddress),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(16.w),
                  itemCount: state.addresses.length,
                  separatorBuilder: (_, __) => 16.verticalSpace,
                  itemBuilder: (context, index) {
                    final address = state.addresses[index];
                    return _AddressCard(address: address);
                  },
                ),
              ),
              // Add New Address Button
              Padding(
                padding: EdgeInsets.all(16.w),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: 'profile.add_new_address'.tr(),
                    isFullWidth: true,
                    prefixIcon: Icon(
                      Icons.add_location_alt_outlined,
                      color: cs.onPrimary,
                      size: 20.r,
                    ),
                    onPressed: () => context.push(AppRoutes.addAddress),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final dynamic address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    // Determine icon and colors based on address type
    final bool isHome = address.title.toLowerCase().contains('home') ||
        address.title.toLowerCase().contains('منزل');
    final bool isWork = address.title.toLowerCase().contains('work') ||
        address.title.toLowerCase().contains('عمل');

    final iconData = isHome
        ? Icons.home_outlined
        : isWork
            ? Icons.business_center_outlined
            : Icons.location_on_outlined;
    final iconBgColor = isHome
        ? cs.secondaryContainer.withValues(alpha: 0.5)
        : isWork
            ? cs.primaryContainer.withValues(alpha: 0.4)
            : cs.primaryContainer.withValues(alpha: 0.3);
    final iconColor = isHome
        ? cs.onSecondaryContainer
        : isWork
            ? cs.primary
            : cs.primary;

    return AppCard(
      showShadow: true,
      leading: Container(
        width: 48.w,
        height: 48.w,
        decoration: BoxDecoration(
          color: iconBgColor,
          borderRadius: AppBorders.md,
        ),
        child: Icon(
          iconData,
          color: iconColor,
          size: 24.r,
        ),
      ),
      title: address.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${address.address}, ${address.governorateName}, ${address.centerName}',
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.md.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'shared.delete'.tr(),
                  color: cs.errorContainer,
                  textColor: cs.error,
                  height: ButtonSize.small,
                  isFullWidth: true,
                  prefixIcon:
                      Icon(Icons.delete_outline, color: cs.error, size: 18.r),
                  onPressed: () async {
                    final confirmed = await context.showConfirmationDialog(
                      title: 'profile.delete_address_title'.tr(),
                      message: 'profile.delete_address_message'
                          .tr(namedArgs: {'address': address.title}),
                      confirmText: 'shared.delete'.tr(),
                      cancelText: 'shared.cancel'.tr(),
                      isDangerous: true,
                    );

                    if (!context.mounted) return;

                    if (confirmed ?? false) {
                      context.read<ProfileBloc>().add(
                            AddressDeleted(addressId: address.id),
                          );
                    }
                  },
                ),
              ),
              AppSpacing.ms.horizontalSpace,
              Expanded(
                child: AppButton(
                  label: 'shared.edit'.tr(),
                  variant: ButtonVariant.secondary,
                  height: ButtonSize.small,
                  isFullWidth: true,
                  prefixIcon:
                      Icon(Icons.edit_outlined, color: cs.primary, size: 18.r),
                  onPressed: () {
                    context.push(
                      AppRoutes.addAddress,
                      extra: address,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddressSkeleton extends StatelessWidget {
  const _AddressSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.all(16.w),
      itemCount: 3,
      separatorBuilder: (_, __) => 16.verticalSpace,
      itemBuilder: (context, index) {
        return Skeletonizer(
          enabled: true,
          child: _AddressCard(address: _MockAddress()),
        );
      },
    );
  }
}

class _MockAddress {
  final String title = 'Home Address';
  final String address = '123 Main Street, Building 4';
  final String governorateName = 'Cairo';
  final String centerName = 'Nasr City';
  final int id = 0;
}
