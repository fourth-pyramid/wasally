import 'package:wassaly/core/imports/imports.dart';

DateTime? _parseCreatedAt(String? createdAt) {
  if (createdAt == null) return null;
  return createdAt.toLocalDateTime();
}

Duration _calcRemaining(String? createdAt) {
  final parsed = _parseCreatedAt(createdAt);
  if (parsed == null) return Duration.zero;
  final remaining =
      parsed.add(const Duration(hours: 1)).difference(DateTime.now());
  return remaining.isNegative ? Duration.zero : remaining;
}

String _formatDuration(Duration duration) {
  if (duration.isNegative) return '00:00';
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

class AppReviewCard extends StatefulWidget {
  const AppReviewCard({
    required this.rating,
    required this.comment,
    required this.userName,
    super.key,
    this.userAvatar,
    this.isCurrentUserReview = false,
    this.canEdit = false,
    this.createdAt,
    this.onEdit,
  });

  final int rating;
  final String comment;
  final String userName;
  final String? userAvatar;
  final bool isCurrentUserReview;
  final bool canEdit;
  final String? createdAt;
  final VoidCallback? onEdit;

  @override
  State<AppReviewCard> createState() => _AppReviewCardState();
}

class _AppReviewCardState extends State<AppReviewCard> {
  Timer? _timer;
  final ValueNotifier<Duration> _remainingNotifier =
      ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void didUpdateWidget(covariant AppReviewCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.createdAt != widget.createdAt) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _remainingNotifier.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    if (!widget.isCurrentUserReview || widget.createdAt == null) {
      _remainingNotifier.value = Duration.zero;
      return;
    }

    _remainingNotifier.value = _calcRemaining(widget.createdAt);

    if (_remainingNotifier.value > Duration.zero) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        final remaining = _calcRemaining(widget.createdAt);
        _remainingNotifier.value = remaining;
        if (remaining <= Duration.zero) _timer?.cancel();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: widget.isCurrentUserReview
              ? cs.primary.withValues(alpha: 0.25)
              : cs.outlineVariant.withValues(alpha: 0.5),
          width: widget.isCurrentUserReview ? 1.2 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(cs, tt),
                10.verticalSpace,
                Text(
                  widget.comment,
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.55,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
          // شريط التعديل — يظهر فقط لصاحب المراجعة
          if (widget.isCurrentUserReview) _buildEditBar(cs, tt),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme cs, TextTheme tt) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(cs, tt),
          10.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.userName,
                        style: tt.titleSmall?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.isCurrentUserReview) ...[
                      6.horizontalSpace,
                      _OwnBadge(cs: cs, tt: tt),
                    ],
                  ],
                ),
                if (widget.createdAt != null &&
                    widget.createdAt!.trim().isNotEmpty) ...[
                  3.verticalSpace,
                  Text(
                    widget.createdAt!.to12HourFormat(),
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _buildStars(cs),
        ],
      );

  Widget _buildStars(ColorScheme cs) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsets.only(right: 1.w),
            child: Icon(
              index < widget.rating
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              size: 15.r,
              color: index < widget.rating
                  ? context.appColors.starRating
                  : cs.outlineVariant,
            ),
          ),
        ),
      );

  /// شريط التعديل الجديد — بدل PopupMenuButton
  Widget _buildEditBar(ColorScheme cs, TextTheme tt) =>
      ValueListenableBuilder<Duration>(
        valueListenable: _remainingNotifier,
        builder: (context, remaining, _) {
          final canEdit = widget.createdAt == null
              ? widget.canEdit
              : remaining > Duration.zero;
          final isExpired = !canEdit;

          return Container(
            decoration: BoxDecoration(
              color: isExpired
                  ? cs.surfaceContainerHighest.withValues(alpha: 0.3)
                  : cs.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              border: Border(
                top: BorderSide(
                  color: isExpired
                      ? cs.outlineVariant.withValues(alpha: 0.4)
                      : cs.primary.withValues(alpha: 0.15),
                  width: 0.8,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
            child: Row(
              children: [
                Icon(
                  isExpired ? Icons.lock_outline_rounded : Icons.timer_outlined,
                  size: 15.r,
                  color: isExpired
                      ? cs.onSurfaceVariant.withValues(alpha: 0.5)
                      : cs.primary,
                ),
                6.horizontalSpace,
                Expanded(
                  child: isExpired
                      ? Text(
                          context.l10n.product_details_edit_time_expired,
                          style: tt.bodySmall?.copyWith(
                            color: cs.onSurfaceVariant.withValues(alpha: 0.6),
                            fontSize: 11.sp,
                          ),
                        )
                      : Row(
                          children: [
                            Text(
                              context.l10n.product_details_review_edit_window,
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                                fontSize: 11.sp,
                              ),
                            ),
                            6.horizontalSpace,
                            Text(
                              _formatDuration(remaining),
                              style: tt.bodySmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 13.sp,
                                fontFeatures: const [
                                  FontFeature.tabularFigures(),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
                if (!isExpired) ...[
                  6.horizontalSpace,
                  _EditButton(
                    label: context.l10n.shared_edit,
                    cs: cs,
                    tt: tt,
                    onTap: widget.onEdit,
                  ),
                ],
              ],
            ),
          );
        },
      );

  Widget _buildAvatar(ColorScheme cs, TextTheme tt) {
    final hasAvatar =
        widget.userAvatar != null && widget.userAvatar!.isNotEmpty;

    if (hasAvatar) {
      return Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: cs.surfaceContainerLow,
        ),
        child: ClipOval(
          child: CommonImage(
            height: 40,
            memCacheHeight: 40 * 3,
            imageUrl: widget.userAvatar!,
          ),
        ),
      );
    }

    final initial = widget.userName.isNotEmpty
        ? widget.userName.trim()[0].toUpperCase()
        : '?';

    final avatarColor = widget.isCurrentUserReview
        ? cs.secondaryContainer
        : cs.primaryContainer;
    final avatarTextColor = widget.isCurrentUserReview
        ? cs.onSecondaryContainer
        : cs.onPrimaryContainer;

    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: avatarColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: tt.titleSmall?.copyWith(
          color: avatarTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 15.sp,
        ),
      ),
    );
  }
}

// ─── Extracted small widgets ────────────────────────────────────────────────

class _OwnBadge extends StatelessWidget {
  const _OwnBadge({required this.cs, required this.tt});
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: cs.secondaryContainer,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 10.r,
              color: cs.onSecondaryContainer,
            ),
            3.horizontalSpace,
            Text(
              context.l10n.product_details_your_review,
              style: tt.labelSmall?.copyWith(
                color: cs.onSecondaryContainer,
                fontWeight: FontWeight.w600,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      );
}

class _EditButton extends StatelessWidget {
  const _EditButton({
    required this.label,
    required this.cs,
    required this.tt,
    this.onTap,
  });
  final String label;
  final ColorScheme cs;
  final TextTheme tt;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
          decoration: BoxDecoration(
            color: cs.primary,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: cs.onPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ),
      );
}
