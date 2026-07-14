import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/domain/entities/address_entity.dart';
import 'package:wassaly/features/profile/domain/entities/center_entity.dart';
import 'package:wassaly/features/profile/domain/entities/governorate_entity.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';

class AddAddressPage extends StatelessWidget {
  final AddressEntity? address;

  const AddAddressPage({this.address, super.key});

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'add_address_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(StorageService.instance.setHasSeenShowcase('add_address_v1', value: true));
        },
        builder: Builder(
          builder: (context) => _AddAddressView(address: address),
        ),
      );
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

  final ValueNotifier<String?> _selectedGovernorateId = ValueNotifier(null);
  final ValueNotifier<String?> _selectedCenterId = ValueNotifier(null);

  bool get _isEditing => widget.address != null;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProfileBloc>()..add(const GovernoratesFetched());

    if (_isEditing) {
      _titleController.text = widget.address!.title;
      _addressController.text = widget.address!.address;
      _selectedGovernorateId.value = widget.address!.governorateId;
      _selectedCenterId.value = widget.address!.centerId;
      bloc.add(CentersFetched(widget.address!.governorateId));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ShowCaseWidget.of(context).startShowCase([
          AppShowcaseKeys.addAddressForm,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _addressController.dispose();
    _selectedGovernorateId.dispose();
    _selectedCenterId.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGovernorateId.value == null) {
      context.showTypedSnackBar(
        context.l10n.profile_select_governorate,
        type: SnackBarType.error,
      );
      return;
    }
    if (_selectedCenterId.value == null) {
      context.showTypedSnackBar(
        context.l10n.profile_select_center,
        type: SnackBarType.error,
      );
      return;
    }

    if (_isEditing) {
      context.read<ProfileBloc>().add(
            AddressUpdated(
              addressId: widget.address!.id,
              title: _titleController.text.trim(),
              address: _addressController.text.trim(),
              governorateId: _selectedGovernorateId.value!,
              centerId: _selectedCenterId.value!,
            ),
          );
    } else {
      context.read<ProfileBloc>().add(
            AddressCreated(
              title: _titleController.text.trim(),
              address: _addressController.text.trim(),
              governorateId: _selectedGovernorateId.value!,
              centerId: _selectedCenterId.value!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Scaffold(
          body: BlocListener<ProfileBloc, ProfileState>(
            listenWhen: (prev, curr) =>
                prev.addressStatus != curr.addressStatus &&
                curr.addressStatus.isDone,
            listener: (context, state) {
              if (state.addressStatus.isSuccess) {
                context
                  ..showTypedSnackBar(
                    _isEditing
                        ? context.l10n.profile_address_updated
                        : context.l10n.profile_address_added,
                    type: SnackBarType.success,
                  )
                  ..pop(true);
              } else if (state.addressStatus.isFailure &&
                  state.addressError != null) {
                context.showTypedSnackBar(
                  state.addressError!,
                  type: SnackBarType.error,
                );
              }
            },
            child: CustomScrollView(
              slivers: [
                AppSliverTopBar(
                  title: _isEditing
                      ? context.l10n.profile_edit_address
                      : context.l10n.profile_add_address,
                ),
                SliverPadding(
                  padding: EdgeInsets.all(16.w),
                  sliver: SliverToBoxAdapter(
                    child: AppShowcase(
                      showcaseKey: AppShowcaseKeys.addAddressForm,
                      title: context.l10n.showcase_add_address_form_title,
                      description: context.l10n.showcase_add_address_form_desc,
                      isLast: true,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            AppTextField(
                              label: context.l10n.profile_address_title,
                              hint: context.l10n.profile_address_title_hint,
                              controller: _titleController,
                              prefixIcon: const Icon(Icons.label_outline),
                              validator: (v) => v!.isEmpty
                                  ? context.l10n.profile_title_required
                                  : null,
                            ),
                          16.verticalSpace,
                          AppTextField(
                            label: context.l10n.profile_address_details,
                            hint: context.l10n.profile_address_details_hint,
                            controller: _addressController,
                            prefixIcon: const Icon(Icons.location_on_outlined),
                            maxLines: 3,
                            validator: (v) => v!.isEmpty
                                ? context.l10n.profile_address_required
                                : null,
                          ),
                          16.verticalSpace,
                          _buildGovernorateDropdown(context),
                          16.verticalSpace,
                          _buildCenterDropdown(context),
                          32.verticalSpace,
                          BlocSelector<ProfileBloc, ProfileState, AppStatus>(
                            selector: (state) => state.addressStatus,
                            builder: (context, addressStatus) => AppButton(
                              label: context.l10n.profile_save_address,
                              isFullWidth: true,
                              isLoading: addressStatus.isLoading,
                              onPressed: _submit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
            ),
          ),
        ),
      );

  Widget _buildGovernorateDropdown(BuildContext context) => BlocSelector<
          ProfileBloc,
          ProfileState,
          (AppStatus, List<GovernorateEntity>, String?)>(
        selector: (state) => (
          state.governorateStatus,
          state.governorates,
          state.governorateError
        ),
        builder: (context, data) {
          final (governorateStatus, governorates, governorateError) = data;

          if (governorateStatus.isFailure && governorateError != null) {
            return AppDropdown<String>(
              label: context.l10n.profile_governorate,
              prefixIcon: const Icon(Icons.map_outlined),
              items: const [],
              enabled: false,
              suffixIcon: Icon(
                Icons.error_outline,
                color: context.theme.colorScheme.error,
              ),
            );
          }

          return ValueListenableBuilder<String?>(
            valueListenable: _selectedGovernorateId,
            builder: (context, selectedGovernorateId, child) =>
                AppDropdown<String>(
              label: context.l10n.profile_governorate,
              prefixIcon: const Icon(Icons.map_outlined),
              value: selectedGovernorateId,
              menuMaxHeight: 300.h,
              isExpanded: false,
              items: governorates
                  .map(
                    (g) => DropdownMenuItem(
                      value: g.id,
                      child: Text(g.name),
                    ),
                  )
                  .toList(),
              onChanged: governorateStatus.isLoading
                  ? null
                  : (value) {
                      _selectedGovernorateId.value = value;
                      _selectedCenterId.value = null;
                      if (value != null) {
                        context.read<ProfileBloc>().add(CentersFetched(value));
                      }
                    },
              validator: (v) =>
                  v == null ? context.l10n.profile_select_governorate : null,
              enabled: !governorateStatus.isLoading,
              suffixIcon: governorateStatus.isLoading
                  ? const AppLoading(size: 12, strokeWidth: 2)
                  : null,
            ),
          );
        },
      );

  Widget _buildCenterDropdown(BuildContext context) =>
      BlocSelector<ProfileBloc, ProfileState, (AppStatus, List<CenterEntity>)>(
        selector: (state) => (state.centerStatus, state.centers),
        builder: (context, data) {
          final (centerStatus, centers) = data;
          return ValueListenableBuilder<String?>(
            valueListenable: _selectedGovernorateId,
            builder: (context, selectedGovernorateId, child) {
              final hasGovernorate = selectedGovernorateId != null;
              final isLoading = centerStatus.isLoading;
              final isDisabled = !hasGovernorate || isLoading;

              return ValueListenableBuilder<String?>(
                valueListenable: _selectedCenterId,
                builder: (context, selectedCenterId, child) =>
                    AppDropdown<String>(
                  label: context.l10n.profile_center,
                  prefixIcon: const Icon(Icons.location_city_outlined),
                  value: selectedCenterId,
                  enabled: !isDisabled && centers.isNotEmpty,
                  menuMaxHeight: 300.h,
                  isExpanded: false,
                  items: centers
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(c.name),
                        ),
                      )
                      .toList(),
                  onChanged: isDisabled
                      ? null
                      : (value) {
                          _selectedCenterId.value = value;
                        },
                  validator: (v) =>
                      v == null ? context.l10n.profile_select_center : null,
                  suffixIcon: isLoading
                      ? const AppLoading(size: 12, strokeWidth: 2)
                      : null,
                ),
              );
            },
          );
        },
      );
}
