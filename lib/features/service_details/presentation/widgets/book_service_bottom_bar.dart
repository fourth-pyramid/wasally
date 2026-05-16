import 'package:wassaly/core/imports/imports.dart';

class BookServiceBottomBar extends StatelessWidget {
  final num price;
  final VoidCallback? onBookPressed;
  final bool isEnabled;

  const BookServiceBottomBar({
    super.key,
    required this.price,
    this.onBookPressed,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      padding:
          EdgeInsets.fromLTRB(16.w, 12.h, 16.w, context.bottomPadding + 12.h),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.cart_total,
                style: tt.bodySmall?.copyWith(color: cs.outline),
              ),
              Text(
                '$price ${context.l10n.common_currency}',
                style: tt.titleLarge?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          24.horizontalSpace,
          Expanded(
            child: AppButton(
              label: context.l10n.service_details_book_now,
              onPressed: isEnabled ? onBookPressed : null,
            ),
          ),
        ],
      ),
    );
  }
}
