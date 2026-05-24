import 'package:wassaly/core/imports/imports.dart';

class ServiceDetailsGallery extends StatefulWidget {
  final List<String> gallery;

  const ServiceDetailsGallery({
    super.key,
    required this.gallery,
  });

  @override
  State<ServiceDetailsGallery> createState() => _ServiceDetailsGalleryState();
}

class _ServiceDetailsGalleryState extends State<ServiceDetailsGallery> {
  final ValueNotifier<int> _imageIndex = ValueNotifier<int>(0);
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _imageIndex.dispose();
    _pageController.dispose();
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
            controller: _pageController,
            itemCount: widget.gallery.length,
            onPageChanged: (index) => _imageIndex.value = index,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () async {
                final newIndex = await AppImageFullScreenView.show(
                  context,
                  imageUrls: widget.gallery,
                  initialIndex: index,
                  heroTagBuilder: (i) =>
                      'service_image_${i}_${widget.gallery[i]}',
                );
                if (newIndex != null && mounted) {
                  _pageController.jumpToPage(newIndex);
                }
              },
              child: Hero(
                tag: 'service_image_${index}_${widget.gallery[index]}',
                child: CommonImage(
                  imageUrl: widget.gallery[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 280,
                  memCacheHeight: 280 * 2,
                ),
              ),
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
