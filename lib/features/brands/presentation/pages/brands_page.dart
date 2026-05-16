import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import '../../domain/entities/brand_entity.dart';
import '../bloc/brands_bloc.dart';
import '../bloc/brands_event.dart';
import '../bloc/brands_state.dart';
import '../widgets/brand_card.dart';

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BrandsBloc>()..add(GetBrandsEvent()),
      child: const BrandsView(),
    );
  }
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
          BlocBuilder<BrandsBloc, BrandsState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              if (state.status == BrandsStatus.loading ||
                  state.status == BrandsStatus.initial) {
                return const SliverFillRemaining(
                  child: Center(
                    child: AppLoading(),
                  ),
                );
              }

              if (state.status == BrandsStatus.failure) {
                return SliverFillRemaining(
                  child: AppErrorWidget(
                    message: state.errorMessage,
                    onRetry: () =>
                        context.read<BrandsBloc>().add(GetBrandsEvent()),
                  ),
                );
              }

              if (state.brands.isEmpty) {
                return SliverFillRemaining(
                  child: AppEmptyState(
                    title: l10n.no_brands,
                    icon: Icons.storefront,
                  ),
                );
              }

              return AppSliverGrid<BrandEntity>(
                items: state.brands,
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                padding: EdgeInsets.all(16.r),
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                itemBuilder: (context, brand, index, wrapAnimation) {
                  return wrapAnimation(
                    BrandCard(
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
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
