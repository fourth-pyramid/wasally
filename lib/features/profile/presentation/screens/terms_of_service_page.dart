import 'package:wassaly/core/imports/imports.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text('terms_of_service.title'.tr()),
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
              'terms_of_service.last_updated'.tr(),
              'terms_of_service.last_updated_date'.tr(),
              isHighlighted: true,
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.acceptance.title'.tr(),
              'terms_of_service.acceptance.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.services.title'.tr(),
              'terms_of_service.services.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.user_responsibilities.title'.tr(),
              'terms_of_service.user_responsibilities.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.prohibited_uses.title'.tr(),
              'terms_of_service.prohibited_uses.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.intellectual_property.title'.tr(),
              'terms_of_service.intellectual_property.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.termination.title'.tr(),
              'terms_of_service.termination.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.limitation.title'.tr(),
              'terms_of_service.limitation.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.changes.title'.tr(),
              'terms_of_service.changes.content'.tr(),
            ),
            16.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.contact.title'.tr(),
              'terms_of_service.contact.content'.tr(),
            ),
            32.verticalSpace,
            _buildSection(
              context,
              'terms_of_service.footer.note'.tr(),
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
