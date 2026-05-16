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
      appBar: AppTopBar(
        title: context.l10n.profile_saved_addresses,
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
            return Center(
              child: AppErrorWidget(
                title: context.l10n.errors_error_occurred_title,
                message: state.addressError?.isNotEmpty ?? false
                    ? state.addressError
                    : context.l10n.errors_error_occurred_message,
                onRetry: () =>
                    context.read<ProfileBloc>().add(const AddressesFetched()),
              ),
            );
          }

          if (state.addresses.isEmpty) {
            return AppEmptyState(
              icon: Icons.location_on_outlined,
              title: context.l10n.profile_no_addresses,
              subtitle: context.l10n.profile_add_address_hint,
              actionLabel: context.l10n.profile_add_address,
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
                    label: context.l10n.profile_add_new_address,
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
          borderRadius: BorderRadius.circular(12.r),
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
            '${address.address} , ${address.centerName} , ${address.governorateName}',
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          16.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: context.l10n.shared_delete,
                  color: cs.errorContainer,
                  textColor: cs.error,
                  height: ButtonSize.small,
                  isFullWidth: true,
                  prefixIcon:
                      Icon(Icons.delete_outline, color: cs.error, size: 18.r),
                  onPressed: () async {
                    final confirmed = await showAppDialog<bool>(
                      child: _DeleteAddressDialog(addressTitle: address.title),
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
              16.horizontalSpace,
              Expanded(
                child: AppButton(
                  label: context.l10n.shared_edit,
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

class _DeleteAddressDialog extends StatelessWidget {
  final String addressTitle;

  const _DeleteAddressDialog({required this.addressTitle});

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
              Icons.delete_outline,
              size: 48.r,
              color: cs.error,
            ),
            16.verticalSpace,
            Text(
              context.l10n.profile_delete_address_title,
              style: tt.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            8.verticalSpace,
            Text(
              'profile.delete_address_message',
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: context.l10n.shared_cancel,
                    variant: ButtonVariant.ghost,
                    isFullWidth: false,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: AppButton(
                    isFullWidth: true,
                    label: context.l10n.shared_delete,
                    variant: ButtonVariant.danger,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
