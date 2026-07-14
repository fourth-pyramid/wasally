import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_details/domain/entities/service_detail_entity.dart';

class ServiceProviderCard extends StatelessWidget {
  final ServiceProviderEntity provider;

  const ServiceProviderCard({
    required this.provider,
    super.key,
  });

  Future<void> _makeCall(String phoneNumber) async {
    final launchUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(launchUri);
    } on Exception catch (e) {
      assert(() {
        debugPrint('Could not launch call: $e');
        return true;
      }());
    }
  }

  Future<void> _sendEmail(String email) async {
    final launchUri = Uri(scheme: 'mailto', path: email);
    try {
      await launchUrl(launchUri);
    } on Exception catch (e) {
      assert(() {
        debugPrint('Could not launch email: $e');
        return true;
      }());
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isActive = provider.user.isActive == 1;

    return AppCard(
      showShadow: true,
      color: cs.surfaceContainerLow,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          // ── Top Section ──────────────────────────────────────────
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.push(
                AppRoutes.providerDetails,
                extra: {'providerId': provider.id},
              ),
              child: Padding(
                padding: EdgeInsets.all(12.r),
                child: Row(
                  children: [
                    // Avatar
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: cs.outlineVariant.withValues(alpha: 0.5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: cs.shadow.withValues(alpha: 0.04),
                            blurRadius: 4.r,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CommonImage(
                        imageUrl: provider.user.avatar ?? provider.cover,
                        width: 60,
                        height: 60,
                        memCacheHeight: 60 * 2,
                        borderRadius: BorderRadius.circular(11.r),
                        enableFullScreenView: true,
                        heroTag: 'service_provider_avatar_${provider.id}',
                      ),
                    ),
                    14.horizontalSpace,

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            provider.title,
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                          ),
                          6.verticalSpace,
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: cs.tertiaryContainer,
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(
                                    color: cs.tertiary.withValues(alpha: 0.2),
                                    width: 0.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: cs.tertiary,
                                      size: 14.r,
                                    ),
                                    2.horizontalSpace,
                                    Text(
                                      provider.averageRating.toString(),
                                      style: tt.labelSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: cs.onTertiaryContainer,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              8.horizontalSpace,
                              Flexible(
                                child: Text(
                                  '(${provider.reviewsCount} ${context.l10n.product_details_reviews})',
                                  style: tt.bodySmall?.copyWith(
                                    color: cs.outline,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Divider(color: cs.outlineVariant.withValues(alpha: 0.3), height: 1),

          // ── Bottom Section ───────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Status & Orders Badges
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isActive
                              ? cs.primaryContainer.withValues(alpha: 0.3)
                              : cs.errorContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: isActive
                                ? cs.primary.withValues(alpha: 0.2)
                                : cs.error.withValues(alpha: 0.2),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 6.r,
                              height: 6.r,
                              decoration: BoxDecoration(
                                color: isActive ? cs.primary : cs.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            6.horizontalSpace,
                            Text(
                              isActive
                                  ? context.l10n.provider_details_status_active
                                  : context
                                      .l10n.provider_details_status_inactive,
                              style: tt.labelMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isActive ? cs.primary : cs.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        decoration: BoxDecoration(
                          color: cs.secondaryContainer.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: cs.secondary.withValues(alpha: 0.2),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: cs.secondary,
                              size: 14.r,
                            ),
                            6.horizontalSpace,
                            Flexible(
                              child: Text(
                                context.l10n.profile_orders_count(
                                  provider.successfulOrdersCount,
                                ),
                                style: tt.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.onSecondaryContainer,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                12.verticalSpace,

                // Description
                if (provider.serviceDescription.trim().isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: cs.surfaceContainerHigh.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: cs.outlineVariant.withValues(alpha: 0.2),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: cs.primary,
                          size: 16.r,
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: Text(
                            provider.serviceDescription,
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.verticalSpace,
                ],

                // ── Action Buttons ───────────────────────────────
                Row(
                  children: [
                    // Call Button
                    Expanded(
                      child: _ActionButton(
                        onTap: () => _makeCall(provider.user.phone),
                        icon: Icons.phone_in_talk_rounded,
                        label: context.l10n.provider_details_quick_call,
                        iconColor: cs.primary,
                        labelColor: cs.primary,
                        backgroundColor:
                            cs.primaryContainer.withValues(alpha: 0.3),
                        splashColor: cs.primary.withValues(alpha: 0.12),
                      ),
                    ),
                    12.horizontalSpace,
                    // Email Button
                    Expanded(
                      child: _ActionButton(
                        onTap: () => _sendEmail(provider.user.email),
                        icon: Icons.alternate_email_rounded,
                        label: context.l10n.provider_details_email_action,
                        iconColor: cs.secondary,
                        labelColor: cs.secondary,
                        backgroundColor:
                            cs.secondaryContainer.withValues(alpha: 0.3),
                        splashColor: cs.secondary.withValues(alpha: 0.12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Reusable Action Button ─────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color labelColor;
  final Color backgroundColor;
  final Color splashColor;

  const _ActionButton({
    required this.onTap,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.labelColor,
    required this.backgroundColor,
    required this.splashColor,
  });

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: splashColor,
          highlightColor: splashColor.withValues(alpha: 0.5),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 18.r),
                8.horizontalSpace,
                Flexible(
                  child: Text(
                    label,
                    style: tt.labelLarge?.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
