import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/banner_entity.dart';
import 'package:wassaly/features/home/presentation/bloc/home_bloc.dart';
import 'package:wassaly/features/home/presentation/bloc/home_state.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  static const _dummyBanners = [
    BannerEntity(
      id: 0,
      title: 'Loading banner title',
      description: 'Loading banner description text here',
      image: '',
      type: 'loading',
    ),
    BannerEntity(
      id: 0,
      title: 'Loading banner title',
      description: 'Loading banner description text here',
      image: '',
      type: 'loading',
    ),
    BannerEntity(
      id: 0,
      title: 'Loading banner title',
      description: 'Loading banner description text here',
      image: '',
      type: 'loading',
    ),
  ];

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  final _currentIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocSelector<HomeBloc, HomeState, (HomeStatus, List<BannerEntity>)>(
      selector: (state) => (state.bannersStatus, state.banners),
      builder: (context, data) {
        final (bannersStatus, banners) = data;

        if (bannersStatus == HomeStatus.loading ||
            bannersStatus == HomeStatus.initial) {
          return Skeletonizer(
            child: Column(
              children: [
                CarouselSlider.builder(
                  itemCount: HomeBanner._dummyBanners.length,
                  options: CarouselOptions(
                    height: 160.h,
                    viewportFraction: 0.84,
                    enlargeCenterPage: true,
                  ),
                  itemBuilder: (context, index, realIndex) => _buildBannerItem(
                    context,
                    cs,
                    tt,
                    HomeBanner._dummyBanners[index],
                  ),
                ),
                12.verticalSpace,
                AnimatedSmoothIndicator(
                  activeIndex: 0,
                  count: HomeBanner._dummyBanners.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 6.h,
                    dotWidth: 6.w,
                    activeDotColor: cs.primary,
                    dotColor: cs.outlineVariant,
                  ),
                ),
              ],
            ),
          );
        }

        if (banners.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: banners.length,
              options: CarouselOptions(
                height: 160.h,
                viewportFraction: 0.84,
                enlargeCenterPage: true,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  _currentIndexNotifier.value = index;
                },
              ),
              itemBuilder: (context, index, realIndex) =>
                  _buildBannerItem(context, cs, tt, banners[index]),
            ),
            12.verticalSpace,
            ValueListenableBuilder<int>(
              valueListenable: _currentIndexNotifier,
              builder: (context, currentIndex, _) => AnimatedSmoothIndicator(
                activeIndex: currentIndex,
                count: banners.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 6.h,
                  dotWidth: 6.w,
                  activeDotColor: cs.primary,
                  dotColor: cs.outlineVariant,
                ),
              ),
            ),
          ],
        ).animate().fadeIn(duration: const Duration(milliseconds: 400));
      },
    );
  }

  Widget _buildBannerItem(
    BuildContext context,
    ColorScheme cs,
    TextTheme tt,
    BannerEntity banner,
  ) =>
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: cs.surfaceContainerHighest,
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            CommonImage(
              imageUrl: banner.image,
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
                    label: context.l10n.home_browse_now,
                    onPressed: () {
                      switch (banner.type) {
                        case 'product_page':
                          unawaited(context.push(AppRoutes.search));
                          break;
                        case 'coupon_page':
                          unawaited(context.push(AppRoutes.offers));
                          break;
                        case 'home_page':
                        default:
                          // Do nothing for home_page or unknown types
                          break;
                      }
                    },
                    variant: ButtonVariant.success,
                    height: ButtonSize.small,
                    suffixIcon: Icon(
                      Icons.arrow_forward,
                      size: 14.r,
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
