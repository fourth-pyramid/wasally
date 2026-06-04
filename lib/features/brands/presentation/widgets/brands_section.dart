import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/brands/domain/entities/brand_entity.dart';
import 'package:wassaly/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:wassaly/features/brands/presentation/bloc/brands_event.dart';
import 'package:wassaly/features/brands/presentation/bloc/brands_state.dart';
import 'package:wassaly/features/brands/presentation/widgets/brand_card.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => sl<BrandsBloc>()..add(GetBrandsEvent()),
        child: const _BrandsSectionView(),
      );
}

class _BrandsSectionView extends StatelessWidget {
  const _BrandsSectionView();

  static const _dummyBrands = [
    BrandEntity(id: 0, name: 'اسم الماركة', image: ''),
    BrandEntity(id: 0, name: 'اسم الماركة', image: ''),
    BrandEntity(id: 0, name: 'اسم الماركة', image: ''),
    BrandEntity(id: 0, name: 'اسم الماركة', image: ''),
    BrandEntity(id: 0, name: 'اسم الماركة', image: ''),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocSelector<BrandsBloc, BrandsState,
        (BrandsStatus, List<BrandEntity>)>(
      selector: (state) => (state.status, state.brands),
      builder: (context, data) {
        final (status, brands) = data;

        if (status == BrandsStatus.loading || status == BrandsStatus.initial) {
          return SliverToBoxAdapter(
            child: RepaintBoundary(
              child: Skeletonizer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Text(
                        l10n.brands,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ),
                    12.verticalSpace,
                    SizedBox(
                      height: 100.h,
                      child: CustomScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            sliver: SliverList.builder(
                              itemCount: _dummyBrands.length,
                              itemBuilder: (context, index) => BrandCard(
                                brand: _dummyBrands[index],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (status == BrandsStatus.failure) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        } else if (brands.isEmpty && status == BrandsStatus.success) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }

        return SliverToBoxAdapter(
          child: RepaintBoundary(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Text(
                    l10n.brands,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),
                // 4.verticalSpace,
                SizedBox(
                  height: 100.h,
                  child: CustomScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        sliver: SliverList.builder(
                          itemCount: brands.length,
                          itemBuilder: (context, index) {
                            final brand = brands[index];
                            return BrandCard(
                              brand: brand,
                              onTap: () {
                                unawaited(
                                  context.push(
                                    AppRoutes.brandDetails,
                                    extra: {
                                      'brandId': brand.id,
                                      'brandName': brand.name,
                                      'brandImage': brand.image,
                                    },
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(
                  delay: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 400),
                ),
          ),
        );
      },
    );
  }
}
