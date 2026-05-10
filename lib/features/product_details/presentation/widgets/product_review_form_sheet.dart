import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/product_detail_entity.dart';
import '../bloc/product_details_bloc.dart';
import '../bloc/product_details_event.dart';

class ProductReviewFormSheet extends StatefulWidget {
  final int productId;
  final ProductDetailReviewEntity? review;

  const ProductReviewFormSheet({
    super.key,
    required this.productId,
    this.review,
  });

  @override
  State<ProductReviewFormSheet> createState() => _ProductReviewFormSheetState();
}

class _ProductReviewFormSheetState extends State<ProductReviewFormSheet> {
  late final TextEditingController _commentController;
  late int _rating;

  bool get _isEdit => widget.review != null;

  @override
  void initState() {
    super.initState();
    _rating = widget.review?.rating ?? 5;
    _commentController = TextEditingController(text: widget.review?.comment);
  }

  @override
  void dispose() {
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
                ? 'product_details.edit_review'.tr()
                : 'product_details.add_review'.tr(),
            style: tt.titleLarge?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          12.verticalSpace,
          Row(
            children: List.generate(
              5,
              (index) {
                final star = index + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = star),
                  icon: Icon(
                    star <= _rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    color: star <= _rating ? cs.secondary : cs.outline,
                  ),
                );
              },
            ),
          ),
          8.verticalSpace,
          TextField(
            controller: _commentController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'product_details.review_comment_hint'.tr(),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          16.verticalSpace,
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submit,
              child: Text('profile.save_changes'.tr()),
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
        SnackBar(content: Text('product_details.review_comment_required'.tr())),
      );
      return;
    }

    final bloc = context.read<ProductDetailsBloc>();
    if (_isEdit) {
      bloc.add(
        UpdateProductReviewEvent(
          productId: widget.productId,
          reviewId: widget.review!.id,
          rating: _rating,
          comment: comment,
        ),
      );
    } else {
      bloc.add(
        CreateProductReviewEvent(
          productId: widget.productId,
          rating: _rating,
          comment: comment,
        ),
      );
    }

    Navigator.of(context).pop();
  }
}
