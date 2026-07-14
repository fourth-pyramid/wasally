import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/provider_details/domain/entities/provider_detail_entity.dart';

class ProviderContactCard extends StatelessWidget {
  final ProviderDetailEntity provider;

  const ProviderContactCard({
    required this.provider, super.key,
  });

  Future<void> _makeCall(String phoneNumber) async {
    final launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        // Fallback for Android 11+ package visibility constraints
        await launchUrl(launchUri);
      }
    } on Object catch (e) {
      debugPrint('Error launching phone: $e');
    }
  }

  Future<void> _sendEmail(String email) async {
    final launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        // Fallback for Android 11+ package visibility constraints
        await launchUrl(launchUri);
      }
    } on Object catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final isActive = provider.user.isActive == 1;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: cs.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.03),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Contact Info Title
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.contact_phone_rounded,
                  color: cs.primary,
                  size: 20.r,
                ),
              ),
              10.horizontalSpace,
              Text(
                context.l10n.provider_details_contact_info,
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // Contact Person Banner
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHigh.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: cs.outlineVariant.withValues(alpha: 0.3),
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: cs.primary,
                    size: 20.r,
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.provider_details_contact_person,
                        style: tt.bodySmall?.copyWith(
                          color: cs.outline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        provider.user.name,
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                        ),
                        textAlign: isAr ? TextAlign.right : TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          12.verticalSpace,

          // Status & Successful Orders Badges Row
          Row(
            children: [
              // Status Badge
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFE8F5E9) // soft green
                        : const Color(0xFFFFEBEE), // soft red
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xFFC8E6C9)
                          : const Color(0xFFFFCDD2),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFF44336),
                          shape: BoxShape.circle,
                        ),
                      ),
                      8.horizontalSpace,
                      Text(
                        isActive
                            ? context.l10n.provider_details_status_active
                            : context.l10n.provider_details_status_inactive,
                        style: tt.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              12.horizontalSpace,
              // Successful Orders Badge
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: cs.secondaryContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(10.r),
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
                        size: 16.r,
                      ),
                      6.horizontalSpace,
                      Flexible(
                        child: Text(
                          context.l10n.profile_orders_count(
                            provider.successfulOrdersCount,
                          ),
                          style: tt.bodySmall?.copyWith(
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
          16.verticalSpace,
          Divider(color: cs.outlineVariant.withValues(alpha: 0.4), height: 1),
          16.verticalSpace,

          // Quick Action Contact Cards
          Row(
            children: [
              // Call Button
              Expanded(
                child: AppCard(
                  onTap: () => _makeCall(provider.user.phone),
                  color: cs.surfaceContainerHigh,
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: cs.primary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.phone_in_talk_rounded,
                          color: cs.primary,
                          size: 20.r,
                        ),
                      ),
                      8.verticalSpace,
                      Align(
                        child: Text(
                          context.l10n.provider_details_phone,
                          style: tt.bodySmall?.copyWith(
                            color: cs.outline,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      6.verticalSpace,
                      Align(
                        child: Text(
                          provider.user.phone,
                          style: tt.bodyMedium?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              12.horizontalSpace,
              // Email Button
              Expanded(
                child: AppCard(
                  onTap: () => _sendEmail(provider.user.email),
                  color: cs.surfaceContainerHigh,
                  padding: EdgeInsets.all(12.r),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: cs.secondary.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.alternate_email_rounded,
                          color: cs.secondary,
                          size: 20.r,
                        ),
                      ),
                      8.verticalSpace,
                      Align(
                        child: Text(
                          context.l10n.provider_details_email,
                          style: tt.bodySmall?.copyWith(
                            color: cs.outline,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      6.verticalSpace,
                      Align(
                        child: Text(
                          provider.user.email,
                          style: tt.bodyMedium?.copyWith(
                            color: cs.secondary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
