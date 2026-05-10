import 'package:wassaly/core/imports/imports.dart';

class ProductDetailsGallery extends StatefulWidget {
  final List<String> gallery;

  const ProductDetailsGallery({
    super.key,
    required this.gallery,
  });

  @override
  State<ProductDetailsGallery> createState() => _ProductDetailsGalleryState();
}

class _ProductDetailsGalleryState extends State<ProductDetailsGallery> {
  final ValueNotifier<int> _imageIndex = ValueNotifier<int>(0);

  @override
  void dispose() {
    _imageIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Column(
      children: [
        SizedBox(
          height: 280.h,
          child: PageView.builder(
            itemCount: widget.gallery.length,
            onPageChanged: (index) => _imageIndex.value = index,
            itemBuilder: (context, index) => CommonImage(
              imageUrl: widget.gallery[index],
              fit: BoxFit.fitHeight,
              width: double.infinity,
              height: 280,
              memCacheHeight: 280 * 3,
            ),
          ),
        ),
        8.verticalSpace,
        ValueListenableBuilder<int>(
          valueListenable: _imageIndex,
          builder: (_, active, __) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.gallery.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: EdgeInsets.symmetric(horizontal: 3.w),
                width: active == index ? 18.w : 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: active == index
                      ? cs.primary
                      : cs.outlineVariant.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
