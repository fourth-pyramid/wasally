import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/profile/presentation/bloc/profile/profile_bloc.dart';

class EditProfileSaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const EditProfileSaveButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (prev, curr) => prev.actionStatus != curr.actionStatus,
      builder: (context, state) {
        return AppButton(
          label: 'profile.save_changes'.tr(),
          isFullWidth: true,
          isLoading: state.actionStatus.isLoading,
          onPressed: onPressed,
        );
      },
    );
  }
}
