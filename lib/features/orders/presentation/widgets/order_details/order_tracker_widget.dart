import 'package:wassaly/core/imports/imports.dart';

class _TimelineStep {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const _TimelineStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class OrderTrackerWidget extends StatelessWidget {
  final String status;

  const OrderTrackerWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    final List<_TimelineStep> steps = [
      _TimelineStep(
        title: context.l10n.order_status_pending,
        description: context.l10n.order_tracker_pending_desc,
        icon: Icons.access_time_filled_rounded,
        color: Colors.orange,
      ),
      _TimelineStep(
        title: context.l10n.order_status_accepted,
        description: context.l10n.order_tracker_accepted_desc,
        icon: Icons.check_circle_rounded,
        color: Colors.blue,
      ),
      _TimelineStep(
        title: context.l10n.order_status_processing,
        description: context.l10n.order_tracker_processing_desc,
        icon: Icons.inventory_2_rounded,
        color: Colors.cyan,
      ),
      _TimelineStep(
        title: context.l10n.order_status_shipped,
        description: context.l10n.order_tracker_shipped_desc,
        icon: Icons.local_shipping_rounded,
        color: Colors.indigo,
      ),
      _TimelineStep(
        title: context.l10n.order_status_delivered,
        description: context.l10n.order_tracker_delivered_desc,
        icon: Icons.stars_rounded,
        color: Colors.green,
      ),
    ];

    final normStatus = status.trim().toLowerCase();
    int currentStep = -1;
    bool isCancelled = false;

    if (normStatus.contains('pending') ||
        normStatus.contains('waiting') ||
        normStatus.contains('قيد الانتظار')) {
      currentStep = 0;
    } else if (normStatus.contains('accepted') ||
        normStatus.contains('تم القبول') ||
        normStatus.contains('confirmed')) {
      currentStep = 1;
    } else if (normStatus.contains('processing') ||
        normStatus.contains('جاري التجهيز') ||
        normStatus.contains('جاري التحضير') ||
        normStatus.contains('قيد المعالجة')) {
      currentStep = 2;
    } else if (normStatus.contains('shipped') ||
        normStatus.contains('تم الشحن')) {
      currentStep = 3;
    } else if (normStatus.contains('delivered') ||
        normStatus.contains('completed') ||
        normStatus.contains('تم التوصيل') ||
        normStatus.contains('مكتمل') ||
        normStatus.contains('success')) {
      currentStep = 4;
    } else if (normStatus.contains('cancelled') ||
        normStatus.contains('ملغي') ||
        normStatus.contains('rejected') ||
        normStatus.contains('failed')) {
      isCancelled = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length, (index) {
        final step = steps[index];

        // A step is completed if currentStep is greater than or equal to index, and NOT cancelled
        final bool isCompleted = !isCancelled && currentStep >= index;
        final bool isCurrent = !isCancelled && currentStep == index;

        final double opacity = isCompleted ? 1.0 : 0.4;
        final Color activeColor = isCompleted
            ? step.color
            : cs.onSurfaceVariant.withValues(alpha: 0.3);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left: Stepper Line & Indicator Dot
              SizedBox(
                width: 32.r,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Vertical Connecting Line
                    if (index < steps.length - 1)
                      Positioned(
                        top: 32.r,
                        bottom: 0,
                        child: Container(
                          width: 2.w,
                          margin: EdgeInsets.symmetric(vertical: 4.h),
                          color: !isCancelled && currentStep > index
                              ? steps[index + 1].color
                              : cs.outlineVariant.withValues(alpha: 0.4),
                        ),
                      ),
                    // Step Indicator Dot
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 32.r,
                      height: 32.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCurrent
                            ? activeColor.withValues(alpha: 0.15)
                            : Colors.transparent,
                        border: Border.all(
                          color: activeColor,
                          width: isCurrent ? 2 : 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          isCompleted ? Icons.check : step.icon,
                          size: 16.r,
                          color: activeColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              16.horizontalSpace,
              // Right: Step Details Text
              Expanded(
                child: Opacity(
                  opacity: opacity,
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: index == steps.length - 1 ? 0 : 20.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.title,
                          style: tt.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isCompleted
                                ? cs.onSurface
                                : cs.onSurfaceVariant,
                          ),
                        ),
                        4.verticalSpace,
                        Text(
                          step.description,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
