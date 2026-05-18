import 'package:wassaly/core/imports/imports.dart';

import '../../bloc/checkout/checkout_bloc.dart';

class CheckoutFormSection extends StatefulWidget {
  const CheckoutFormSection({super.key});

  @override
  State<CheckoutFormSection> createState() => _CheckoutFormSectionState();
}

class _CheckoutFormSectionState extends State<CheckoutFormSection> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _regionController;

  @override
  void initState() {
    super.initState();
    final state = context.read<CheckoutBloc>().state;
    _nameController = TextEditingController(text: state.customerName);
    _phoneController = TextEditingController(text: state.customerPhone);
    _addressController = TextEditingController(text: state.customerAddress);
    _regionController = TextEditingController(text: state.region);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocListener<CheckoutBloc, CheckoutState>(
      listenWhen: (prev, curr) =>
          prev.customerName != curr.customerName ||
          prev.customerPhone != curr.customerPhone ||
          prev.customerAddress != curr.customerAddress ||
          prev.region != curr.region,
      listener: (context, state) {
        if (_nameController.text != state.customerName) {
          _nameController.text = state.customerName;
        }
        if (_phoneController.text != state.customerPhone) {
          _phoneController.text = state.customerPhone;
        }
        if (_addressController.text != state.customerAddress) {
          _addressController.text = state.customerAddress;
        }
        if (_regionController.text != state.region) {
          _regionController.text = state.region;
        }
      },
      child: BlocBuilder<CheckoutBloc, CheckoutState>(
        buildWhen: (prev, curr) =>
            prev.nameError != curr.nameError ||
            prev.phoneError != curr.phoneError ||
            prev.addressError != curr.addressError ||
            prev.governorateError != curr.governorateError ||
            prev.centerError != curr.centerError ||
            prev.governorates != curr.governorates ||
            prev.centers != curr.centers ||
            prev.addresses != curr.addresses ||
            prev.isLoadingGovernorates != curr.isLoadingGovernorates ||
            prev.isLoadingCenters != curr.isLoadingCenters ||
            prev.selectedGovernorateId != curr.selectedGovernorateId ||
            prev.selectedCenterId != curr.selectedCenterId ||
            prev.selectedAddress != curr.selectedAddress ||
            prev.status != curr.status,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Info
              Text(
                context.l10n.checkout_contact_info,
                style: context.theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              12.verticalSpace,
              AppTextField(
                label: context.l10n.checkout_customer_name,
                hint: context.l10n.checkout_customer_name_hint,
                controller: _nameController,
                onChanged: (v) => context
                    .read<CheckoutBloc>()
                    .add(CheckoutFormChanged(customerName: v)),
              ),
              16.verticalSpace,
              AppTextField(
                label: context.l10n.checkout_customer_phone,
                hint: context.l10n.checkout_customer_phone_hint,
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                onChanged: (v) => context
                    .read<CheckoutBloc>()
                    .add(CheckoutFormChanged(customerPhone: v)),
              ),
              24.verticalSpace,

              // Saved Addresses
              if (state.addresses.isNotEmpty || state.isLoadingAddresses) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.l10n.checkout_saved_addresses,
                      style: context.theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        final success =
                            await context.push(AppRoutes.addAddress);
                        if (success == true) {
                          if (context.mounted) {
                            context
                                .read<CheckoutBloc>()
                                .add(const CheckoutAddressesRefreshed());
                          }
                        }
                      },
                      icon: Icon(Icons.add, size: 18.r),
                      label: Text(context.l10n.cart_add_new_address),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,
                if (state.isLoadingAddresses)
                  const Center(child: AppLoading())
                else
                  Column(
                    children: List.generate(
                      state.addresses.length,
                      (index) {
                        final address = state.addresses[index];
                        final isSelected =
                            state.selectedAddress?.id == address.id;

                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: index == state.addresses.length - 1
                                  ? 0
                                  : 12.h),
                          child: InkWell(
                            onTap: () {
                              context
                                  .read<CheckoutBloc>()
                                  .add(CheckoutAddressSelected(address));
                            },
                            borderRadius: BorderRadius.circular(16.r),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: isSelected
                                      ? cs.primary
                                      : cs.outlineVariant,
                                  width: isSelected ? 2 : 1,
                                ),
                                color: isSelected
                                    ? cs.primaryContainer
                                        .withValues(alpha: 0.05)
                                    : cs.surface,
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color:
                                              cs.primary.withValues(alpha: 0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        )
                                      ]
                                    : null,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Radio Button
                                  Container(
                                    margin: EdgeInsets.only(top: 2.h),
                                    width: 20.r,
                                    height: 20.r,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? cs.primary
                                            : cs.onSurfaceVariant,
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Container(
                                              width: 10.r,
                                              height: 10.r,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: cs.primary,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  16.horizontalSpace,
                                  // Address Details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              address.title,
                                              style: tt.titleMedium?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: isSelected
                                                    ? cs.primary
                                                    : cs.onSurface,
                                              ),
                                            ),
                                          ],
                                        ),
                                        4.verticalSpace,
                                        Text(
                                          '${address.governorateName}، ${address.centerName}',
                                          style: tt.bodyMedium?.copyWith(
                                            color: cs.onSurface,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        4.verticalSpace,
                                        Text(
                                          address.address.cleanAddress(
                                              center: address.centerName,
                                              governorate: address.governorateName),
                                          style: tt.bodySmall?.copyWith(
                                            color: cs.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ] else if (!state.isLoadingAddresses) ...[
                // Empty state with Add button
                Center(
                  child: Column(
                    children: [
                      Text(
                        context.l10n.cart_no_addresses,
                        style:
                            tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                      ),
                      12.verticalSpace,
                      AppButton(
                        label: context.l10n.cart_add_new_address,
                        height: ButtonSize.small,
                        prefixIcon: const Icon(Icons.add),
                        onPressed: () async {
                          final success =
                              await context.push(AppRoutes.addAddress);
                          if (success == true) {
                            if (context.mounted) {
                              context
                                  .read<CheckoutBloc>()
                                  .add(const CheckoutAddressesRefreshed());
                            }
                          }
                        },
                      ),
                    ],
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
