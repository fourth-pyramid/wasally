import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/brands/domain/entities/brand_entity.dart';
import 'package:wassaly/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:wassaly/features/brands/presentation/bloc/brands_event.dart';
import 'package:wassaly/features/brands/presentation/bloc/brands_state.dart';
import 'package:wassaly/features/brands/presentation/widgets/brand_card.dart';

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'brands_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(StorageService.instance.setHasSeenShowcase('brands_v1', value: true));
        },
        builder: Builder(
          builder: (context) => BlocProvider(
            create: (context) => sl<BrandsBloc>()..add(GetBrandsEvent()),
            child: const BrandsView(),
          ),
        ),
      );
}

class BrandsView extends StatelessWidget {
  const BrandsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          AppSliverTopBar(
            title: l10n.brands,
            pinned: true,
          ),
          BlocSelector<BrandsBloc, BrandsState, (BrandsStatus, List<BrandEntity>, String)>(
            selector: (state) => (state.status, state.brands, state.errorMessage),
            builder: (context, data) {
              final (status, brands, errorMessage) = data;

              if (status == BrandsStatus.loading || status == BrandsStatus.initial) {
                return const SliverFillRemaining(
                  child: Center(
                    child: AppLoading(),
                  ),
                );
              }

              if (status == BrandsStatus.failure) {
                return SliverFillRemaining(
                  child: AppErrorWidget(
                    message: errorMessage,
                    onRetry: () => context.read<BrandsBloc>().add(GetBrandsEvent()),
                  ),
                );
              }

              if (brands.isEmpty) {
                return SliverFillRemaining(
                  child: AppEmptyState(
                    title: l10n.no_brands,
                    icon: Icons.storefront,
                  ),
                );
              }

              if (status == BrandsStatus.success && brands.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ShowCaseWidget.of(context).startShowCase([
                      AppShowcaseKeys.brandsGrid,
                    ]);
                  }
                });
              }

              return AppSliverGrid<BrandEntity>(
                items: brands,
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                padding: EdgeInsets.all(16.r),
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                itemBuilder: (context, brand, index, wrapAnimation) {
                  final card = BrandCard(
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
                  if (index == 0) {
                    return wrapAnimation(
                      AppShowcase(
                        showcaseKey: AppShowcaseKeys.brandsGrid,
                        title: context.l10n.showcase_brands_grid_title,
                        description: context.l10n.showcase_brands_grid_desc,
                        isLast: true,
                        child: card,
                      ),
                    );
                  }
                  return wrapAnimation(card);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
