import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';

class AddAddressPage extends StatelessWidget {
  final AddressEntity? address;

  const AddAddressPage({this.address, super.key});

  @override
  Widget build(BuildContext context) {
    return _AddAddressView(address: address);
  }
}

class _AddAddressView extends StatefulWidget {
  final AddressEntity? address;

  const _AddAddressView({this.address});

  @override
  State<_AddAddressView> createState() => _AddAddressViewState();
}

class _AddAddressViewState extends State<_AddAddressView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedGovernorateId;
  String? _selectedCenterId;

  bool get _isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProfileBloc>();
    bloc.add(const GovernoratesFetched());

    if (_isEditing) {
      _titleController.text = widget.address!.title;
      _addressController.text = widget.address!.address;
      _selectedGovernorateId = widget.address!.governorateId;
      _selectedCenterId = widget.address!.centerId;
      bloc.add(CentersFetched(widget.address!.governorateId));
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGovernorateId == null) {
      context.showErrorSnackBar('profile.select_governorate'.tr());
      return;
    }
    if (_selectedCenterId == null) {
      context.showErrorSnackBar('profile.select_center'.tr());
      return;
    }

    if (_isEditing) {
      context.read<ProfileBloc>().add(AddressUpdated(
            addressId: widget.address!.id,
            title: _titleController.text.trim(),
            address: _addressController.text.trim(),
            governorateId: _selectedGovernorateId!,
            centerId: _selectedCenterId!,
          ));
    } else {
      context.read<ProfileBloc>().add(AddressCreated(
            title: _titleController.text.trim(),
            address: _addressController.text.trim(),
            governorateId: _selectedGovernorateId!,
            centerId: _selectedCenterId!,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'profile.edit_address'.tr() : 'profile.add_address'.tr(),
        ),
        centerTitle: true,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) =>
            prev.addressStatus != curr.addressStatus &&
            curr.addressStatus.isDone,
        listener: (context, state) {
          if (state.addressStatus.isSuccess) {
            context.showSuccessSnackBar(
              _isEditing
                  ? 'profile.address_updated'.tr()
                  : 'profile.address_added'.tr(),
            );
            context.pop();
          } else if (state.addressStatus.isFailure &&
              state.addressError != null) {
            context.showErrorSnackBar(state.addressError!);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.pagePadding),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  label: 'profile.address_title'.tr(),
                  hint: 'profile.address_title_hint'.tr(),
                  controller: _titleController,
                  prefixIcon: const Icon(Icons.label_outline),
                  validator: (v) =>
                      v!.isEmpty ? 'profile.title_required'.tr() : null,
                ),
                AppSpacing.md.verticalSpace,
                AppTextField(
                  label: 'profile.address_details'.tr(),
                  hint: 'profile.address_details_hint'.tr(),
                  controller: _addressController,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                  maxLines: 3,
                  validator: (v) =>
                      v!.isEmpty ? 'profile.address_required'.tr() : null,
                ),
                AppSpacing.md.verticalSpace,
                _buildGovernorateDropdown(context),
                AppSpacing.md.verticalSpace,
                _buildCenterDropdown(context),
                AppSpacing.xl.verticalSpace,
                BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (prev, curr) =>
                      prev.addressStatus != curr.addressStatus,
                  builder: (context, state) {
                    return AppButton(
                      label: 'profile.save_address'.tr(),
                      isFullWidth: true,
                      isLoading: state.addressStatus.isLoading,
                      onPressed: _submit,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGovernorateDropdown(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) =>
          prev.governorateStatus != curr.governorateStatus ||
          prev.governorates != curr.governorates,
      builder: (context, state) {
        if (state.governorateStatus.isFailure &&
            state.governorateError != null) {
          return AppDropdown<String>(
            label: 'profile.governorate'.tr(),
            prefixIcon: const Icon(Icons.map_outlined),
            value: null,
            items: const [],
            enabled: false,
            suffixIcon: Icon(
              Icons.error_outline,
              color: context.theme.colorScheme.error,
            ),
          );
        }

        return AppDropdown<String>(
          label: 'profile.governorate'.tr(),
          prefixIcon: const Icon(Icons.map_outlined),
          value: _selectedGovernorateId,
          menuMaxHeight: 300.h,
          isExpanded: false,
          alignment: AlignmentDirectional.centerStart,
          items: state.governorates.map((g) {
            return DropdownMenuItem(
              value: g.id,
              child: Text(g.name),
            );
          }).toList(),
          onChanged: state.governorateStatus.isLoading
              ? null
              : (value) {
                  setState(() {
                    _selectedGovernorateId = value;
                    _selectedCenterId = null;
                  });
                  if (value != null) {
                    context.read<ProfileBloc>().add(CentersFetched(value));
                  }
                },
          validator: (v) =>
              v == null ? 'profile.select_governorate'.tr() : null,
          enabled: !state.governorateStatus.isLoading,
          suffixIcon: state.governorateStatus.isLoading
              ? SizedBox(
                  width: 12.w,
                  height: 12.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.theme.colorScheme.primary,
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildCenterDropdown(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) =>
          prev.centerStatus != curr.centerStatus ||
          prev.centers != curr.centers,
      builder: (context, state) {
        final hasGovernorate = _selectedGovernorateId != null;
        final isLoading = state.centerStatus.isLoading;
        final isDisabled = !hasGovernorate || isLoading;

        return AppDropdown<String>(
          label: 'profile.center'.tr(),
          prefixIcon: const Icon(Icons.location_city_outlined),
          value: _selectedCenterId,
          enabled: !isDisabled && state.centers.isNotEmpty,
          menuMaxHeight: 300.h,
          isExpanded: false,
          alignment: AlignmentDirectional.centerStart,
          items: state.centers.map((c) {
            return DropdownMenuItem(
              value: c.id,
              child: Text(c.name),
            );
          }).toList(),
          onChanged: isDisabled
              ? null
              : (value) {
                  setState(() {
                    _selectedCenterId = value;
                  });
                },
          validator: (v) => v == null ? 'profile.select_center'.tr() : null,
          suffixIcon: isLoading
              ? SizedBox(
                  width: 12.w,
                  height: 12.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.theme.colorScheme.primary,
                  ),
                )
              : null,
        );
      },
    );
  }
}
