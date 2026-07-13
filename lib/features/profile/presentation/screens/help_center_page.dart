import 'package:showcase_tutorial/showcase_tutorial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'help_center_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(
            StorageService.instance.setHasSeenShowcase('help_center_v1', value: true),
          );
        },
        builder: Builder(
          builder: (context) => const _HelpCenterView(),
        ),
      );
}

class _HelpCenterView extends StatefulWidget {
  const _HelpCenterView();

  @override
  State<_HelpCenterView> createState() => _HelpCenterViewState();
}

class _HelpCenterViewState extends State<_HelpCenterView> {
  int? _expandedIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ShowCaseWidget.of(context).startShowCase([
          AppShowcaseKeys.helpCenterContact,
          AppShowcaseKeys.helpCenterFaq,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final faqs = <_FaqItem>[
      _FaqItem(
        question: context.l10n.profile_help_faq_q1,
        answer: context.l10n.profile_help_faq_a1,
      ),
      _FaqItem(
        question: context.l10n.profile_help_faq_q2,
        answer: context.l10n.profile_help_faq_a2,
      ),
      _FaqItem(
        question: context.l10n.profile_help_faq_q3,
        answer: context.l10n.profile_help_faq_a3,
      ),
    ];

    return Scaffold(
      backgroundColor: cs.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          AppSliverTopBar(
            title: context.l10n.profile_help_center,
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  _HeroBanner(cs: cs, tt: tt),
                  24.verticalSpace,
                  _SectionLabel(
                    label: context.l10n.profile_help_contact_support,
                    tt: tt,
                    cs: cs,
                  ),
                  8.verticalSpace,
                  AppShowcase(
                    showcaseKey: AppShowcaseKeys.helpCenterContact,
                    title: context.l10n.showcase_help_center_contact_title,
                    description: context.l10n.showcase_help_center_contact_desc,
                    child: _ContactCard(cs: cs, tt: tt),
                  ),
                  24.verticalSpace,
                  _SectionLabel(
                    label: context.l10n.profile_help_faqs,
                    tt: tt,
                    cs: cs,
                  ),
                  8.verticalSpace,
                  AppShowcase(
                    showcaseKey: AppShowcaseKeys.helpCenterFaq,
                    title: context.l10n.showcase_help_center_faq_title,
                    description: context.l10n.showcase_help_center_faq_desc,
                    isLast: true,
                    child: _FaqCard(
                      faqs: faqs,
                      cs: cs,
                      tt: tt,
                      expandedIndex: _expandedIndex,
                      onExpand: (index) => setState(
                        () => _expandedIndex = _expandedIndex == index ? null : index,
                      ),
                    ),
                  ),
                  24.verticalSpace,
                  _SectionLabel(
                    label: context.l10n.profile_help_links,
                    tt: tt,
                    cs: cs,
                  ),
                  8.verticalSpace,
                  _LinksCard(cs: cs, tt: tt),
                  32.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  const _FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.cs, required this.tt});
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) => AppCard(
        showShadow: true,
        color: cs.primary,
        child: Row(
          children: [
            Container(
              width: 52.r,
              height: 52.r,
              decoration: BoxDecoration(
                color: cs.onPrimary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.headset_mic_outlined,
                size: 26.r,
                color: cs.onPrimary,
              ),
            ),
            14.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.profile_help_center,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onPrimary,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    context.l10n.profile_help_center_description,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onPrimary.withValues(alpha: 0.85),
                      height: 1.5,
                    ),
                  ),
                  10.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: cs.onPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7.r,
                          height: 7.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4ADE80),
                            shape: BoxShape.circle,
                          ),
                        ),
                        6.horizontalSpace,
                        Text(
                          'Online now',
                          style: tt.labelSmall?.copyWith(
                            color: cs.onPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.cs, required this.tt});
  final ColorScheme cs;
  final TextTheme tt;

  Future<void> _makeCall(String phoneNumber) async {
    final launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
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
        await launchUrl(launchUri);
      }
    } on Object catch (e) {
      debugPrint('Error launching email: $e');
    }
  }

  @override
  Widget build(BuildContext context) => AppCard(
        showShadow: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              isFullWidth: true,
              label: context.l10n.profile_help_email_support,
              prefixIcon: const Icon(Icons.email_outlined, size: 18),
              onPressed: () => _sendEmail('support@wassaly.com'),
            ),
            14.verticalSpace,
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _makeCall(context.l10n.profile_help_phone_number),
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: cs.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.phone_outlined,
                        size: 18.r,
                        color: cs.onSurfaceVariant,
                      ),
                      8.horizontalSpace,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              context.l10n.profile_help_hours,
                              style: tt.labelSmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                            4.verticalSpace,
                            Text(
                              '${context.l10n.profile_help_phone}: ${context.l10n.profile_help_phone_number}',
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12.r,
                        color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.faqs,
    required this.cs,
    required this.tt,
    required this.expandedIndex,
    required this.onExpand,
  });

  final List<_FaqItem> faqs;
  final ColorScheme cs;
  final TextTheme tt;
  final int? expandedIndex;
  final void Function(int) onExpand;

  @override
  Widget build(BuildContext context) => AppCard(
        showShadow: true,
        padding: EdgeInsets.zero,
        child: Column(
          children: List.generate(faqs.length, (index) {
            final isOpen = expandedIndex == index;
            final isLast = index == faqs.length - 1;
            final faq = faqs[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => onExpand(index),
                    borderRadius: BorderRadius.vertical(
                      top: index == 0 ? Radius.circular(12.r) : Radius.zero,
                      bottom: isLast && !isOpen ? Radius.circular(12.r) : Radius.zero,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 14.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq.question,
                              style: tt.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: isOpen ? cs.primary : cs.onSurface,
                              ),
                            ),
                          ),
                          8.horizontalSpace,
                          AnimatedRotation(
                            turns: isOpen ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20.r,
                              color: isOpen ? cs.primary : cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  child: ClipRect(
                    child: Align(
                      heightFactor: isOpen ? 1 : 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 16.w,
                          right: 16.w,
                          bottom: 16.h,
                        ),
                        child: Text(
                          faq.answer,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: cs.outlineVariant.withValues(alpha: 0.5),
                  ),
              ],
            );
          }),
        ),
      );
}

class _LinksCard extends StatelessWidget {
  const _LinksCard({required this.cs, required this.tt});
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) => AppCard(
        showShadow: true,
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            _LinkTile(
              icon: Icons.shield_outlined,
              label: context.l10n.profile_help_links_privacy,
              cs: cs,
              tt: tt,
              isFirst: true,
              onTap: () => GoRouter.of(context).push(AppRoutes.privacyPolicy),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: cs.outlineVariant.withValues(alpha: 0.5),
            ),
            _LinkTile(
              icon: Icons.article_outlined,
              label: context.l10n.profile_help_links_terms,
              cs: cs,
              tt: tt,
              isLast: true,
              onTap: () => GoRouter.of(context).push(AppRoutes.termsOfService),
            ),
          ],
        ),
      );
}

class _LinkTile extends StatelessWidget {
  const _LinkTile({
    required this.icon,
    required this.label,
    required this.cs,
    required this.tt,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final ColorScheme cs;
  final TextTheme tt;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? Radius.circular(12.r) : Radius.zero,
            bottom: isLast ? Radius.circular(12.r) : Radius.zero,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, size: 18.r, color: cs.primary),
                ),
                12.horizontalSpace,
                Expanded(
                  child: Text(
                    label,
                    style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14.r,
                  color: cs.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.label,
    required this.tt,
    required this.cs,
  });

  final String label;
  final TextTheme tt;
  final ColorScheme cs;

  @override
  Widget build(BuildContext context) => Text(
        label.toUpperCase(),
        style: tt.labelSmall?.copyWith(
          color: cs.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      );
}
