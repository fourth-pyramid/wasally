import 'package:wassaly/core/imports/imports.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          AppSliverTopBar(
            title: context.l10n.privacy_policy_title,
            actions: [
              IconButton(
                icon: const Icon(Icons.open_in_new),
                tooltip: context.l10n.privacy_policy_view_online,
                onPressed: () => _launchUrl(
                  'https://wasly.bynona.store/Privacy/privacy_policy.html',
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.all(16.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSection(
                  context,
                  context.l10n.privacy_policy_last_updated,
                  context.l10n.privacy_policy_last_updated_date,
                  isHighlighted: true,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_introduction_title,
                  context.l10n.privacy_policy_introduction_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_data_collection_title,
                  context.l10n.privacy_policy_data_collection_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_data_usage_title,
                  context.l10n.privacy_policy_data_usage_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_data_sharing_title,
                  context.l10n.privacy_policy_data_sharing_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_data_security_title,
                  context.l10n.privacy_policy_data_security_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_user_rights_title,
                  context.l10n.privacy_policy_user_rights_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_third_party_title,
                  context.l10n.privacy_policy_third_party_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_children_privacy_title,
                  context.l10n.privacy_policy_children_privacy_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_international_transfers_title,
                  context.l10n.privacy_policy_international_transfers_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_changes_title,
                  context.l10n.privacy_policy_changes_content,
                ),
                16.verticalSpace,
                _buildSection(
                  context,
                  context.l10n.privacy_policy_contact_title,
                  context.l10n.privacy_policy_contact_content,
                ),
                32.verticalSpace,
                _buildFooter(context),
              ]),
            ),
          ),
        ],
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
        border: isHighlighted ? Border.all(color: cs.primary) : null,
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
          context.l10n.privacy_policy_footer_note,
          style: tt.bodySmall?.copyWith(
            color: cs.onSurface.withValues(alpha: 0.6),
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
        16.verticalSpace,
        TextButton.icon(
          onPressed: () => _launchUrl(
            'https://wasly.bynona.store/Privacy/privacy_policy.html',
          ),
          icon: Icon(
            Icons.open_in_new,
            size: 16.w,
            color: cs.primary,
          ),
          label: Text(
            context.l10n.privacy_policy_view_online,
            style: tt.bodyMedium?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        8.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () =>
                  _launchUrl('https://policies.google.com/privacy'),
              child: Text(
                context.l10n.privacy_policy_google_privacy,
                style: tt.bodySmall?.copyWith(
                  color: cs.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _launchUrl('https://policies.google.com/terms'),
              child: Text(
                context.l10n.privacy_policy_google_terms,
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
    } on Object catch (e) {
      assert(() {
        debugPrint('Error launching URL: $e');
        return true;
      }());
    }
  }
}
