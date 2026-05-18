import 'package:wassaly/core/imports/imports.dart';

import '../../../../profile/domain/entities/address_entity.dart';
import '../../../../profile/presentation/bloc/profile/profile_bloc.dart';
import '../../../domain/entities/order_entity.dart';
import '../../bloc/order_detail/order_detail_bloc.dart';
import '../../bloc/order_detail/order_detail_event.dart';
import '../../bloc/order_detail/order_detail_state.dart';

class UpdateOrderSheet extends StatefulWidget {
  final OrderEntity order;

  const UpdateOrderSheet({super.key, required this.order});

  @override
  State<UpdateOrderSheet> createState() => _UpdateOrderSheetState();
}

class _UpdateOrderSheetState extends State<UpdateOrderSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  AddressEntity? _selectedAddress;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.order.customerName);
    _phoneController = TextEditingController(text: widget.order.customerPhone);

    sl<ProfileBloc>().add(const AddressesFetched());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;
    final cs = context.theme.colorScheme;

    return BlocConsumer<OrderDetailBloc, OrderDetailState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == OrderActionStatus.success) {
          context.pop();
        }
      },
      builder: (context, state) {
        final isLoading = state.actionStatus == OrderActionStatus.loading;

        return Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 24.h,
            bottom: MediaQuery.viewInsetsOf(context).bottom > 0
                ? MediaQuery.viewInsetsOf(context).bottom + 16.h
                : context.bottomPadding + 16.h,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.order_update_title,
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  AppTextField(
                    controller: _nameController,
                    label: context.l10n.order_update_name_label,
                    validator: (value) => value == null || value.isEmpty
                        ? context.l10n.order_update_required
                        : null,
                  ),
                  16.verticalSpace,
                  AppTextField(
                    controller: _phoneController,
                    label: context.l10n.order_update_phone_label,
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.isEmpty
                        ? context.l10n.order_update_required
                        : null,
                  ),
                  24.verticalSpace,

                  // Saved Addresses Section
                  BlocBuilder<ProfileBloc, ProfileState>(
                    bloc: sl<ProfileBloc>(),
                    builder: (context, profileState) {
                      final addresses = profileState.addresses;
                      final isLoadingAddresses =
                          profileState.addressStatus == AppStatus.loading;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                context.l10n.checkout_saved_addresses,
                                style: tt.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              TextButton.icon(
                                onPressed: () async {
                                  final success =
                                      await context.push(AppRoutes.addAddress);
                                  if (success == true) {
                                    sl<ProfileBloc>()
                                        .add(const AddressesFetched());
                                  }
                                },
                                icon: Icon(Icons.add, size: 18.r),
                                label: Text(context.l10n.cart_add_new_address),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                          12.verticalSpace,
                          if (isLoadingAddresses)
                            const Center(child: AppLoading())
                          else if (addresses.isEmpty)
                            Center(
                              child: Text(
                                context.l10n.cart_no_addresses,
                                style: tt.bodyMedium
                                    ?.copyWith(color: cs.onSurfaceVariant),
                              ),
                            )
                          else
                            Column(
                              children: List.generate(
                                addresses.length,
                                (index) {
                                  final address = addresses[index];
                                  final isSelected =
                                      _selectedAddress?.id == address.id;

                                  return Padding(
                                    padding: EdgeInsets.only(bottom: 12.h),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _selectedAddress = address;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        padding: EdgeInsets.all(16.r),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.r),
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
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
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
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: cs.primary,
                                                        ),
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            16.horizontalSpace,
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    address.title,
                                                    style: tt.titleMedium
                                                        ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isSelected
                                                          ? cs.primary
                                                          : cs.onSurface,
                                                    ),
                                                  ),
                                                  4.verticalSpace,
                                                  Text(
                                                    '${address.governorateName}، ${address.centerName}',
                                                    style:
                                                        tt.bodyMedium?.copyWith(
                                                      color: cs.onSurface,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  4.verticalSpace,
                                                  Text(
                                                    address.address.cleanAddress(
                                                        center: address.centerName,
                                                        governorate: address.governorateName),
                                                    style:
                                                        tt.bodySmall?.copyWith(
                                                      color:
                                                          cs.onSurfaceVariant,
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
                          if (_selectedAddress == null) ...[
                            8.verticalSpace,
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: cs.surfaceContainerHighest
                                    .withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.info_outline,
                                      size: 20.r, color: cs.onSurfaceVariant),
                                  12.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                      context.l10n.order_update_current_address(
                                          widget.order.deliveryAddress.cleanAddress(
                                              center: widget.order.centerName ?? '',
                                              governorate: widget.order.governorateName ?? '')
                                      ),
                                      style: tt.bodySmall?.copyWith(
                                          color: cs.onSurfaceVariant),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      );
                    },
                  ),

                  32.verticalSpace,
                  AppButton(
                    label: context.l10n.order_update_save,
                    isLoading: isLoading,
                    isFullWidth: true,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.hideKeyboard();

                        final updateData = <String, dynamic>{
                          'customer_name': _nameController.text.trim(),
                          'customer_phone': _phoneController.text.trim(),
                        };

                        if (_selectedAddress != null) {
                          final cleaned = _selectedAddress!.address.cleanAddress(
                              center: _selectedAddress!.centerName,
                              governorate: _selectedAddress!.governorateName);
                          updateData['delivery_address'] = cleaned;
                          updateData['customer_address'] = cleaned;
                          updateData['address'] = cleaned;
                          updateData['governorate_id'] =
                              _selectedAddress!.governorateId;
                          updateData['center_id'] = _selectedAddress!.centerId;
                        } else if (widget.order.deliveryAddress != null &&
                            widget.order.deliveryAddress!.isNotEmpty) {
                          final cleaned = widget.order.deliveryAddress!.cleanAddress(
                              center: widget.order.centerName ?? '',
                              governorate: widget.order.governorateName ?? '');
                          updateData['delivery_address'] = cleaned;
                          updateData['customer_address'] = cleaned;
                          updateData['address'] = cleaned;
                          if (widget.order.governorateId != null) {
                            updateData['governorate_id'] =
                                widget.order.governorateId;
                          }
                          if (widget.order.centerId != null) {
                            updateData['center_id'] = widget.order.centerId;
                          }
                        }

                        context.read<OrderDetailBloc>().add(
                              UpdateOrderEvent(
                                widget.order.id,
                                updateData,
                              ),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
