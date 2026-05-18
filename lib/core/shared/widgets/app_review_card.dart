import 'dart:async';

import 'package:wassaly/core/imports/imports.dart';

class AppReviewCard extends StatefulWidget {
  final int rating;
  final String comment;
  final String userName;
  final String? userAvatar;
  final bool isCurrentUserReview;
  final bool canEdit;
  final String? createdAt;
  final VoidCallback? onEdit;

  const AppReviewCard({
    super.key,
    required this.rating,
    required this.comment,
    required this.userName,
    this.userAvatar,
    this.isCurrentUserReview = false,
    this.canEdit = false,
    this.createdAt,
    this.onEdit,
  });

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

    _updateRemaining();
    if (_remainingNotifier.value > Duration.zero) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        _updateRemaining();
      });
    }
  }

  void _updateRemaining() {
    final parsed = _parseCreatedAt(widget.createdAt);
    if (parsed == null) {
      _remainingNotifier.value = Duration.zero;
      return;
    }

    final limit = parsed.add(const Duration(hours: 1));
    final remaining = limit.difference(DateTime.now());

    _remainingNotifier.value = remaining;

    if (_remainingNotifier.value <= Duration.zero) {
      _timer?.cancel();
    }
  }

  DateTime? _parseCreatedAt(String? createdAt) {
    if (createdAt == null) return null;
    final createdDate = DateTime.tryParse(createdAt);
    if (createdDate == null) return null;

    final hasTimezone = RegExp(r'(z|[+-]\d{2}:?\d{2})$', caseSensitive: false)
        .hasMatch(createdAt.trim());
    if (hasTimezone) {
      return createdDate.toLocal();
    }
    return DateTime.utc(
      createdDate.year,
      createdDate.month,
      createdDate.day,
      createdDate.hour,
      createdDate.minute,
      createdDate.second,
      createdDate.millisecond,
      createdDate.microsecond,
    ).toLocal();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildAvatar(cs, tt),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: tt.titleSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (widget.createdAt != null &&
                        widget.createdAt!.trim().isNotEmpty) ...[
                      2.verticalSpace,
                      Text(
                        widget.createdAt!.to12HourFormat(),
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < widget.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14.r,
                    color: index < widget.rating ? cs.secondary : cs.outline,
                  ),
                ),
              ),
              if (widget.isCurrentUserReview) ...[
                4.horizontalSpace,
                ValueListenableBuilder<Duration>(
                  valueListenable: _remainingNotifier,
                  builder: (context, remaining, child) {
                    final canEdit = widget.createdAt == null
                        ? widget.canEdit
                        : remaining > Duration.zero;
                    return PopupMenuButton<String>(
                      tooltip: context.l10n.product_details_review_options,
                      icon: Icon(
                        Icons.more_vert_rounded,
                        size: 20.r,
                        color: cs.onSurfaceVariant,
                      ),
                      onSelected: (value) {
                        if (value == 'edit' && canEdit) {
                          widget.onEdit?.call();
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem<String>(
                          value: 'edit',
                          enabled: canEdit,
                          child: widget.createdAt != null
                              ? _ReviewEditMenuItemContent(
                                  createdAt: widget.createdAt!,
                                  editText: context.l10n.shared_edit,
                                  expiredText: context
                                      .l10n.product_details_edit_time_expired,
                                  timerStyle: tt.bodySmall?.copyWith(
                                    color: cs.secondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  canEdit
                                      ? context.l10n.shared_edit
                                      : context.l10n
                                          .product_details_edit_time_expired,
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ],
          ),
          8.verticalSpace,
          Text(
            widget.comment,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(ColorScheme cs, TextTheme tt) {
    final hasAvatar =
        widget.userAvatar != null && widget.userAvatar!.isNotEmpty;

    if (hasAvatar) {
      return ClipOval(
        child: CommonImage(
          width: 32.w,
          height: 24.h,
          memCacheHeight: 32 * 3,
          imageUrl: widget.userAvatar!,
        ),
      );
    }

    return Container(
      width: 32.w,
      height: 32.h,
      decoration: BoxDecoration(
        color: cs.primary.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        widget.userName.isNotEmpty
            ? widget.userName.trim()[0].toUpperCase()
            : '?',
        style: tt.titleSmall?.copyWith(
          color: cs.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ReviewEditMenuItemContent extends StatefulWidget {
  final String createdAt;
  final String editText;
  final String expiredText;
  final TextStyle? timerStyle;

  const _ReviewEditMenuItemContent({
    required this.createdAt,
    required this.editText,
    required this.expiredText,
    this.timerStyle,
  });

  @override
  State<_ReviewEditMenuItemContent> createState() =>
      __ReviewEditMenuItemContentState();
}

class __ReviewEditMenuItemContentState
    extends State<_ReviewEditMenuItemContent> {
  Timer? _menuTimer;
  final ValueNotifier<Duration> _remainingNotifier =
      ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _menuTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateRemaining();
    });
  }

  @override
  void dispose() {
    _menuTimer?.cancel();
    _remainingNotifier.dispose();
    super.dispose();
  }

  void _updateRemaining() {
    final parsed = _parseCreatedAt(widget.createdAt);
    if (parsed == null) {
      if (mounted) {
        _remainingNotifier.value = Duration.zero;
      }
      return;
    }

    final limit = parsed.add(const Duration(hours: 1));
    final remaining = limit.difference(DateTime.now());

    if (mounted) {
      _remainingNotifier.value = remaining;
    }

    if (_remainingNotifier.value <= Duration.zero) {
      _menuTimer?.cancel();
    }
  }

  DateTime? _parseCreatedAt(String createdAt) {
    final createdDate = DateTime.tryParse(createdAt);
    if (createdDate == null) return null;

    final hasTimezone = RegExp(r'(z|[+-]\d{2}:?\d{2})$', caseSensitive: false)
        .hasMatch(createdAt.trim());
    if (hasTimezone) {
      return createdDate.toLocal();
    }
    return DateTime.utc(
      createdDate.year,
      createdDate.month,
      createdDate.day,
      createdDate.hour,
      createdDate.minute,
      createdDate.second,
      createdDate.millisecond,
      createdDate.microsecond,
    ).toLocal();
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return '00:00';
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return ValueListenableBuilder<Duration>(
      valueListenable: _remainingNotifier,
      builder: (context, remaining, child) {
        final isExpired = remaining <= Duration.zero;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isExpired ? widget.expiredText : widget.editText,
            ),
            if (!isExpired) ...[
              6.horizontalSpace,
              Text(
                '(${_formatDuration(remaining)})',
                style: widget.timerStyle ??
                    context.theme.textTheme.bodySmall?.copyWith(
                      color: cs.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              4.horizontalSpace,
              Icon(
                Icons.timer_outlined,
                size: 14.r,
                color: cs.secondary,
              ),
            ],
          ],
        );
      },
    );
  }
}
