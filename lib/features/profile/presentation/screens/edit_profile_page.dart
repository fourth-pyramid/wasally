import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:wassaly/features/profile/presentation/widgets/edit_profile/widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'edit_profile_v2',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(
            StorageService.instance.setHasSeenShowcase('edit_profile_v2', value: true),
          );
        },
        builder: Builder(
          builder: (context) => const _EditProfileView(),
        ),
      );
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _currentPasswordController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmationController;

  final ValueNotifier<File?> _avatarFileNotifier = ValueNotifier(null);
  UserEntity? _previousUser;
  var _previousActionStatus = AppStatus.initial;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _currentPasswordController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmationController = TextEditingController();

    // Fetch user data from the existing bloc
    final bloc = context.read<ProfileBloc>();
    if (bloc.state.user != null) {
      // Populate controllers with existing data
      _nameController.text = bloc.state.user!.name ?? '';
      _phoneController.text = bloc.state.user!.phone ?? '';
      _previousUser = bloc.state.user;
    } else {
      bloc.add(const ProfileFetched());
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ShowCaseWidget.of(context).startShowCase([
          AppShowcaseKeys.editProfileForm,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _avatarFileNotifier.dispose();
    super.dispose();
  }

  void _onAvatarPicked(File? file) {
    if (file != null) {
      _avatarFileNotifier.value = file;
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text.trim();
    if (password.isNotEmpty && _currentPasswordController.text.isEmpty) {
      context.showTypedSnackBar(
        context.l10n.profile_current_password_required,
        type: SnackBarType.error,
      );
      return;
    }

    context.read<ProfileBloc>().add(
          ProfileUpdated(
            fullName: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            avatar: _avatarFileNotifier.value,
            password: password.isNotEmpty ? password : null,
            currentPassword:
                _currentPasswordController.text.trim().isNotEmpty ? _currentPasswordController.text.trim() : null,
            passwordConfirmation: _passwordConfirmationController.text.trim().isNotEmpty
                ? _passwordConfirmationController.text.trim()
                : null,
          ),
        );
  }

  void _showDeleteAccountBottomSheet() {
    unawaited(
      context.showAppBottomSheet<bool>(
        builder: (bottomSheetContext) {
          final cs = bottomSheetContext.theme.colorScheme;
          final tt = bottomSheetContext.theme.textTheme;
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.warning_rounded,
                    color: cs.error,
                    size: 48.sp,
                  ),
                  16.verticalSpace,
                  Text(
                    context.l10n.profile_delete_account_title,
                    style: tt.headlineSmall?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  8.verticalSpace,
                  Text(
                    context.l10n.profile_delete_account_message,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  16.verticalSpace,
                  AppButton(
                    label: context.l10n.profile_delete_account_confirm,
                    onPressed: () {
                      bottomSheetContext.pop(true);
                    },
                    variant: ButtonVariant.danger,
                    isFullWidth: true,
                  ),
                ],
              ),
            ),
          );
        },
      ).then((confirmed) {
        if (confirmed ?? false) {
          _deleteAccount();
        }
      }),
    );
  }

  void _deleteAccount() {
    context.read<ProfileBloc>().add(const ProfileAccountDeleted());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocListener<ProfileBloc, ProfileState>(
          listenWhen: (prev, curr) =>
              (prev.user != curr.user && curr.user != null) ||
              (prev.actionStatus != curr.actionStatus && curr.actionStatus.isDone),
          listener: (context, state) {
            if (_previousUser != state.user && state.user != null) {
              _nameController.text = state.user!.name ?? '';
              _phoneController.text = state.user!.phone ?? '';
            }
            _previousUser = state.user;

            if (_previousActionStatus != state.actionStatus && state.actionStatus.isDone) {
              if (state.actionStatus.isSuccess) {
                if (state.user == null) {
                  // Account deleted or logged out — navigation is handled by
                  // SessionListenerWrapper via SessionLogoutRequested. Do nothing here.
                } else {
                  // Regular profile update
                  context.showTypedSnackBar(
                    context.l10n.profile_update_success,
                    type: SnackBarType.success,
                  );
                  try {
                    if (context.mounted && context.canPop()) {
                      context.pop();
                    }
                  } on Exception catch (_) {}
                }
              } else if (state.actionStatus.isFailure && state.actionError != null) {
                context.showTypedSnackBar(
                  state.actionError!,
                  type: SnackBarType.error,
                );
              }
            }
            _previousActionStatus = state.actionStatus;
          },
          child: CustomScrollView(
            slivers: [
              AppSliverTopBar(
                title: context.l10n.profile_edit_profile,
              ),
              SliverPadding(
                padding: EdgeInsets.all(16.w).copyWith(
                  bottom: 16.h,
                ),
                sliver: SliverToBoxAdapter(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppShowcase(
                          showcaseKey: AppShowcaseKeys.editProfileForm,
                          title: context.l10n.showcase_edit_profile_form_title,
                          description: context.l10n.showcase_edit_profile_form_desc,
                          isLast: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ValueListenableBuilder<File?>(
                                valueListenable: _avatarFileNotifier,
                                builder: (context, avatarFile, child) => EditProfileAvatarPicker(
                                  avatarFile: avatarFile,
                                  onAvatarPicked: _onAvatarPicked,
                                ),
                              ),
                              8.verticalSpace,
                              EditProfileNameField(controller: _nameController),
                              8.verticalSpace,
                              EditProfilePhoneField(controller: _phoneController),
                            ],
                          ),
                        ),
                        16.verticalSpace,
                        EditProfilePasswordSection(
                          currentPasswordController: _currentPasswordController,
                          passwordController: _passwordController,
                          passwordConfirmationController: _passwordConfirmationController,
                        ),
                        16.verticalSpace,
                        EditProfileSaveButton(onPressed: _submit),
                        8.verticalSpace,
                        AppButton(
                          label: context.l10n.profile_delete_account,
                          onPressed: _showDeleteAccountBottomSheet,
                          variant: ButtonVariant.danger,
                          isFullWidth: true,
                          prefixIcon: Icon(
                            Icons.delete_forever,
                            // ponytail: explicit color to match danger variant
                            color: context.theme.colorScheme.onError,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
