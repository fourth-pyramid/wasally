import 'package:url_launcher/url_launcher.dart';
import 'package:wassaly/core/imports/imports.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('privacy_policy.title'.tr()),
        backgroundColor: cs.surface,
        foregroundColor: cs.onSurface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'privacy_policy.last_updated'.tr(),
              'privacy_policy.last_updated_date'.tr(),
              isHighlighted: true,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.introduction.title'.tr(),
              'privacy_policy.introduction.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.data_collection.title'.tr(),
              'privacy_policy.data_collection.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.data_usage.title'.tr(),
              'privacy_policy.data_usage.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.data_sharing.title'.tr(),
              'privacy_policy.data_sharing.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.data_security.title'.tr(),
              'privacy_policy.data_security.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.user_rights.title'.tr(),
              'privacy_policy.user_rights.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.third_party.title'.tr(),
              'privacy_policy.third_party.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.children_privacy.title'.tr(),
              'privacy_policy.children_privacy.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.international_transfers.title'.tr(),
              'privacy_policy.international_transfers.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.changes.title'.tr(),
              'privacy_policy.changes.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'privacy_policy.contact.title'.tr(),
              'privacy_policy.contact.content'.tr(),
            ),
            32.verticalSpace,
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content, {
    bool isHighlighted = false,
  }) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isHighlighted ? cs.primaryContainer : cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: isHighlighted ? Border.all(color: cs.primary, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isHighlighted ? cs.onPrimaryContainer : cs.onSurface,
            ),
          ),
          8.verticalSpace,
          Text(
            content,
            style: tt.bodyMedium?.copyWith(
              color: isHighlighted
                  ? cs.onPrimaryContainer
                  : cs.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Column(
      children: [
        Divider(color: cs.outline.withValues(alpha: 0.3)),
        16.verticalSpace,
        Text(
          'privacy_policy.footer.note'.tr(),
          style: tt.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        8.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () =>
                  _launchUrl('https://policies.google.com/privacy'),
              child: Text(
                'privacy_policy.google_privacy'.tr(),
                style: tt.bodySmall?.copyWith(
                  color: cs.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _launchUrl('https://policies.google.com/terms'),
              child: Text(
                'privacy_policy.google_terms'.tr(),
                style: tt.bodySmall?.copyWith(
                  color: cs.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _launchUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
