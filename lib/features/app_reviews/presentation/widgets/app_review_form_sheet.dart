import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/app_reviews/domain/entities/app_review_entity.dart';
import 'package:wassaly/features/app_reviews/presentation/bloc/app_reviews_bloc.dart';
import 'package:wassaly/features/app_reviews/presentation/bloc/app_reviews_event.dart';

class AppReviewFormSheet extends StatefulWidget {
  final AppReviewEntity? review;

  const AppReviewFormSheet({
    super.key,
    this.review,
  });

  @override
  State<AppReviewFormSheet> createState() => _AppReviewFormSheetState();
}

class _AppReviewFormSheetState extends State<AppReviewFormSheet> {
  late final TextEditingController _commentController;
  late final ValueNotifier<int> _ratingNotifier;

  bool get _isEdit => widget.review != null;

  @override
  void initState() {
    super.initState();
    _ratingNotifier = ValueNotifier<int>(widget.review?.rating ?? 5);
    _commentController = TextEditingController(text: widget.review?.comment);
  }

  @override
  void dispose() {
    _ratingNotifier.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEdit
                ? context.l10n.product_details_edit_review
                : context.l10n.product_details_add_review,
            style: tt.titleLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          12.verticalSpace,
          ValueListenableBuilder<int>(
            valueListenable: _ratingNotifier,
            builder: (context, rating, child) => Row(
              children: List.generate(
                5,
                (index) {
                  final star = index + 1;
                  return IconButton(
                    onPressed: () => _ratingNotifier.value = star,
                    icon: Icon(
                      star <= rating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: star <= rating
                          ? context.appColors.starRating
                          : cs.outline,
                    ),
                  );
                },
              ),
            ),
          ),
          8.verticalSpace,
          TextField(
            controller: _commentController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: context.l10n.product_details_review_comment_hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          16.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: _submit,
              label: context.l10n.profile_save_changes,
              isFullWidth: true,
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final comment = _commentController.text.trim();
    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.product_details_review_comment_required),
        ),
      );
      return;
    }

    final bloc = context.read<AppReviewsBloc>();
    if (_isEdit) {
      bloc.add(
        UpdateAppReviewEvent(
          reviewId: widget.review!.id,
          rating: _ratingNotifier.value,
          comment: comment,
        ),
      );
    } else {
      bloc.add(
        AddAppReviewEvent(
          rating: _ratingNotifier.value,
          comment: comment,
        ),
      );
    }

    context.pop();
  }
}
