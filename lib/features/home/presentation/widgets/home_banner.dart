import 'package:carousel_slider/carousel_slider.dart';
import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/banner_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) =>
          prev.bannersStatus != curr.bannersStatus ||
          prev.banners != curr.banners,
      builder: (context, state) {
        if (state.bannersStatus == HomeStatus.loading ||
            state.bannersStatus == HomeStatus.initial) {
          final dummyBanners = List.generate(
            3,
            (index) => const BannerEntity(
              id: 0,
              title: 'Loading banner title',
              description: 'Loading banner description text here',
              image: '',
              type: 'loading',
            ),
          );

          return Skeletonizer(
            enabled: true,
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: dummyBanners.length,
                  options: CarouselOptions(
                    height: 160.h,
                    viewportFraction: 0.84,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return _buildBannerItem(
                        context, cs, tt, dummyBanners[index]);
                  },
                ),
                12.verticalSpace,
                AnimatedSmoothIndicator(
                  activeIndex: 0,
                  count: dummyBanners.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 6.h,
                    dotWidth: 6.w,
                    activeDotColor: cs.primary,
                    dotColor: cs.outlineVariant,
                    expansionFactor: 3,
                  ),
                ),
              ],
            ),
          );
        }

        if (state.banners.isEmpty) {
          return const SizedBox.shrink();
        }

        final banners = state.banners;

        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: banners.length,
              options: CarouselOptions(
                height: 160.h,
                viewportFraction: 0.84,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              itemBuilder: (context, index, realIndex) {
                return _buildBannerItem(context, cs, tt, banners[index]);
              },
            ),
            12.verticalSpace,
            AnimatedSmoothIndicator(
              activeIndex: _currentIndex,
              count: banners.length,
              effect: ExpandingDotsEffect(
                dotHeight: 6.h,
                dotWidth: 6.w,
                activeDotColor: cs.primary,
                dotColor: cs.outlineVariant,
                expansionFactor: 3,
              ),
            ),
          ],
        ).animate().fadeIn(duration: const Duration(milliseconds: 400));
      },
    );
  }

  Widget _buildBannerItem(
      BuildContext context, ColorScheme cs, TextTheme tt, BannerEntity banner) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: cs.surfaceContainerHighest,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          CommonImage(
            imageUrl: banner.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            memCacheHeight: 160 * 2,
          ),

          // Gradient Overlay
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  cs.onSurface.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  banner.title,
                  style: tt.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  banner.description,
                  style: tt.titleSmall?.copyWith(
                    color: cs.onPrimary.withValues(alpha: 0.8),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                8.verticalSpace,
                AppButton(
                  label: 'تصفح الآن',
                  onPressed: () {
                    // TODO: Navigate or perform action based on type
                  },
                  variant: ButtonVariant.success,
                  height: ButtonSize.small,
                  suffixIcon: Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: cs.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
