import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'addresses_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(StorageService.instance.setHasSeenShowcase('addresses_v1', value: true));
        },
        builder: Builder(
          builder: (context) => _AddressesView(scrollController: _scrollController),
        ),
      );
}

class _AddressesView extends StatefulWidget {
  final ScrollController scrollController;

  const _AddressesView({required this.scrollController});

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
      body: BlocSelector<ProfileBloc, ProfileState, (AppStatus, List<AddressEntity>, String?)>(
        selector: (state) => (state.addressStatus, state.addresses, state.addressError),
        builder: (context, data) {
          final (addressStatus, addresses, addressError) = data;

          if (addressStatus.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                ShowCaseWidget.of(context).startShowCase([
                  AppShowcaseKeys.addressesList,
                  AppShowcaseKeys.addAddressButton,
                ]);
              }
            });
          }

          return CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              AppSliverTopBar(
                title: context.l10n.profile_saved_addresses,
              ),
              if (addressStatus.isLoading)
                SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index.isOdd) return 16.verticalSpace;
                        return const Skeletonizer(
                          child: _AddressCard(address: _MockAddress()),
                        );
                      },
                      childCount: 3 * 2 - 1,
                    ),
                  ),
                )
              else if (addressStatus.isFailure && addressError != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: AppErrorWidget(
                      title: context.l10n.errors_error_occurred_title,
                      message: addressError.isNotEmpty ? addressError : context.l10n.errors_error_occurred_message,
                      onRetry: () => context.read<ProfileBloc>().add(const AddressesFetched()),
                    ),
                  ),
                )
              else if (addresses.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    icon: Icons.location_on_outlined,
                    title: context.l10n.profile_no_addresses,
                    subtitle: context.l10n.profile_add_address_hint,
                    actionLabel: context.l10n.profile_add_address,
                    onAction: () => unawaited(context.push(AppRoutes.addAddress)),
                  ),
                )
              else ...[
                SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index.isOdd) return 16.verticalSpace;
                        final address = addresses[index ~/ 2];
                        final card = _AddressCard(address: address);
                        if (index ~/ 2 == 0) {
                          return AppShowcase(
                            showcaseKey: AppShowcaseKeys.addressesList,
                            title: context.l10n.showcase_addresses_list_title,
                            description: context.l10n.showcase_addresses_list_desc,
                            child: card,
                          );
                        }
                        return card;
                      },
                      childCount: addresses.length * 2 - 1,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: AppShowcase(
                        showcaseKey: AppShowcaseKeys.addAddressButton,
                        title: context.l10n.showcase_add_address_button_title,
                        description: context.l10n.showcase_add_address_button_desc,
                        isLast: true,
                        child: AppButton(
                          label: context.l10n.profile_add_new_address,
                          isFullWidth: true,
                          prefixIcon: Icon(
                            Icons.add_location_alt_outlined,
                            color: cs.onPrimary,
                            size: 20.r,
                          ),
                          onPressed: () => unawaited(context.push(AppRoutes.addAddress)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressEntity address;

  const _AddressCard({required this.address});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    // Determine icon and colors based on address type
    final isHome = address.title.toLowerCase().contains('home') || address.title.toLowerCase().contains('منزل');
    final isWork = address.title.toLowerCase().contains('work') || address.title.toLowerCase().contains('عمل');

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
            '${address.address.cleanAddress(center: address.centerName, governorate: address.governorateName)} , ${address.centerName} , ${address.governorateName}',
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
                  prefixIcon: Icon(Icons.delete_outline, color: cs.error, size: 18.r),
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
                  prefixIcon: Icon(Icons.edit_outlined, color: cs.primary, size: 18.r),
                  onPressed: () {
                    unawaited(
                      context.push(
                        AppRoutes.addAddress,
                        extra: address,
                      ),
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
              context.l10n.profile_delete_address_message(addressTitle),
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

class _MockAddress extends AddressEntity {
  const _MockAddress()
      : super(
          id: '0',
          title: 'Home Address',
          address: '123 Main Street, Building 4',
          governorateId: '0',
          governorateName: 'Cairo',
          centerId: '0',
          centerName: 'Nasr City',
        );
}
