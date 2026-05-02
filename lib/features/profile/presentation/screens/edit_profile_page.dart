import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';

import '../widgets/edit_profile/widgets.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EditProfileView();
  }
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

  File? _avatarFile;
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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  void _onAvatarPicked(File? file) {
    if (file != null) {
      setState(() => _avatarFile = file);
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text.trim();
    if (password.isNotEmpty && _currentPasswordController.text.isEmpty) {
      context.showErrorSnackBar('profile.current_password_required'.tr());
      return;
    }

    context.read<ProfileBloc>().add(ProfileUpdated(
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          avatar: _avatarFile,
          password: password.isNotEmpty ? password : null,
          currentPassword: _currentPasswordController.text.trim().isNotEmpty
              ? _currentPasswordController.text.trim()
              : null,
          passwordConfirmation:
              _passwordConfirmationController.text.trim().isNotEmpty
                  ? _passwordConfirmationController.text.trim()
                  : null,
        ));
  }

  void _showDeleteAccountDialog() {
    context
        .showConfirmationDialog(
      title: 'profile.delete_account_title'.tr(),
      message: 'profile.delete_account_message'.tr(),
      confirmText: 'profile.delete_account_confirm'.tr(),
      cancelText: 'shared.cancel'.tr(),
      isDangerous: true,
    )
        .then((confirmed) {
      if (confirmed ?? false) {
        _deleteAccount();
      }
    });
  }

  void _deleteAccount() {
    context.read<ProfileBloc>().add(const ProfileAccountDeleted());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile.edit_profile'.tr()),
        centerTitle: true,
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listenWhen: (prev, curr) =>
            (prev.user != curr.user && curr.user != null) ||
            (prev.actionStatus != curr.actionStatus &&
                curr.actionStatus.isDone),
        listener: (context, state) {
          if (_previousUser != state.user && state.user != null) {
            _nameController.text = state.user!.name ?? '';
            _phoneController.text = state.user!.phone ?? '';
          }
          _previousUser = state.user;

          if (_previousActionStatus != state.actionStatus &&
              state.actionStatus.isDone) {
            if (state.actionStatus.isSuccess) {
              // Check if this was a delete account action
              if (state.user == null) {
                // Account was deleted, clear cache and navigate to login
                StorageService.instance.clear();
                context.go(AppRoutes.login);
              } else {
                // Regular profile update
                context.showSuccessSnackBar('profile.update_success'.tr());
                context.pop();
              }
            } else if (state.actionStatus.isFailure &&
                state.actionError != null) {
              context.showErrorSnackBar(state.actionError!);
            }
          }
          _previousActionStatus = state.actionStatus;
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.pagePadding).copyWith(
            bottom: AppSpacing.xl,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                EditProfileAvatarPicker(
                  avatarFile: _avatarFile,
                  onAvatarPicked: _onAvatarPicked,
                ),
                AppSpacing.lg.kH,
                EditProfileNameField(controller: _nameController),
                AppSpacing.md.kH,
                EditProfilePhoneField(controller: _phoneController),
                AppSpacing.xl.kH,
                EditProfilePasswordSection(
                  currentPasswordController: _currentPasswordController,
                  passwordController: _passwordController,
                  passwordConfirmationController:
                      _passwordConfirmationController,
                ),
                AppSpacing.xl.kH,
                EditProfileSaveButton(onPressed: _submit),
                AppSpacing.md.kH,
                AppButton(
                  label: 'profile.delete_account'.tr(),
                  onPressed: _showDeleteAccountDialog,
                  variant: ButtonVariant.danger,
                  isFullWidth: true,
                  prefixIcon: const Icon(Icons.delete_forever),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
