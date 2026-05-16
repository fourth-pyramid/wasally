import 'package:wassaly/core/imports/imports.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppTopBar(
        title: context.l10n.terms_of_service_title,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              context.l10n.terms_of_service_last_updated,
              context.l10n.terms_of_service_last_updated_date,
              isHighlighted: true,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_acceptance_title,
              context.l10n.terms_of_service_acceptance_content,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_services_title,
              context.l10n.terms_of_service_services_content,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_user_responsibilities_title,
              context.l10n.terms_of_service_user_responsibilities_content,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_prohibited_uses_title,
              context.l10n.terms_of_service_prohibited_uses_content,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_intellectual_property_title,
              context.l10n.terms_of_service_intellectual_property_content,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_termination_title,
              context.l10n.terms_of_service_termination_content,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_limitation_title,
              context.l10n.terms_of_service_limitation_content,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_changes_title,
              context.l10n.terms_of_service_changes_content,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_contact_title,
              context.l10n.terms_of_service_contact_content,
            ),
            32.verticalSpace,
            _buildSection(
              context,
              context.l10n.terms_of_service_footer_note,
              '',
              isFooter: true,
            ),
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
    bool isFooter = false,
  }) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isHighlighted
            ? cs.primaryContainer
            : isFooter
                ? cs.surfaceContainerHighest
                : cs.surfaceContainerLow,
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
          if (content.isNotEmpty) ...[
            8.verticalSpace,
            Text(
              content,
              style: tt.bodyMedium?.copyWith(
                color: isHighlighted
                    ? cs.onPrimaryContainer.withValues(alpha: .8)
                    : cs.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
