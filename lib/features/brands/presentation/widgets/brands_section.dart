import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import '../../domain/entities/brand_entity.dart';
import '../bloc/brands_bloc.dart';
import '../bloc/brands_event.dart';
import '../bloc/brands_state.dart';
import 'brand_card.dart';

class BrandsSection extends StatelessWidget {
  const BrandsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BrandsBloc>()..add(GetBrandsEvent()),
      child: const _BrandsSectionView(),
    );
  }
}

class _BrandsSectionView extends StatelessWidget {
  const _BrandsSectionView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<BrandsBloc, BrandsState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.brands != current.brands,
      builder: (context, state) {
        if (state.status == BrandsStatus.loading ||
            state.status == BrandsStatus.initial) {
          final dummyBrands = List.generate(
            5,
            (index) => const BrandEntity(
              id: 0,
              name: 'اسم الماركة',
              image: '',
            ),
          );

          return SliverToBoxAdapter(
            child: Skeletonizer(
              enabled: true,
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
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      itemCount: dummyBrands.length,
                      itemBuilder: (context, index) {
                        return BrandCard(
                          brand: dummyBrands[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (state.status == BrandsStatus.failure) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        } else if (state.brands.isEmpty &&
            state.status == BrandsStatus.success) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }

        final brands = state.brands;

        return SliverToBoxAdapter(
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: brands.length,
                  itemBuilder: (context, index) {
                    final brand = brands[index];
                    return BrandCard(
                      brand: brand,
                      onTap: () {
                        context.push(
                          AppRoutes.brandDetails,
                          extra: {
                            'brandId': brand.id,
                            'brandName': brand.name,
                            'brandImage': brand.image
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ).animate().fadeIn(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 400),
              ),
        );
      },
    );
  }
}
