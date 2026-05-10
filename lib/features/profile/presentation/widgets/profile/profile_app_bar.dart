import '../../../../../core/imports/imports.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 16.h,
        left: 16.w,
        right: 16.w,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.push(AppRoutes.editProfile),
            icon: Icon(Icons.edit_outlined, color: cs.primary),
            style: IconButton.styleFrom(
              backgroundColor: cs.primaryContainer.withValues(alpha: 0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                'profile.my_account'.tr(),
                style: tt.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }
}
