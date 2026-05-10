import 'package:wassaly/core/imports/imports.dart';

class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: AppCard(
        showShadow: true,
        onTap: () {},
        leading: Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            Icons.inventory_2_outlined,
            color: cs.primary,
          ),
        ),
        title: 'profile.my_orders'.tr(),
        subtitle: 'profile.orders_count'.plural(3, args: [3.toString()]),
        trailing: Icon(
          Icons.chevron_right,
          color: cs.onSurfaceVariant,
        ),
        child: const SizedBox.shrink(),
      ),
    );
  }
}
