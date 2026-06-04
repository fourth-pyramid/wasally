import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/category_entity.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/products_filter/domain/entities/product_filter_params.dart';
import 'package:wassaly/features/products_filter/presentation/bloc/products_filter_bloc.dart';
import 'package:wassaly/features/products_filter/presentation/bloc/products_filter_event.dart';
import 'package:wassaly/features/products_filter/presentation/bloc/products_filter_state.dart';
import 'package:wassaly/features/products_filter/presentation/screens/filter_options_sheet.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class ProductsFilterPage extends StatelessWidget {
  final ProductFilterParams? initialParams;

  const ProductsFilterPage({
    super.key,
    this.initialParams,
  });

  void _openFilterSheet(
    BuildContext context,
    ProductFilterParams params,
    List<CategoryEntity> categories,
  ) {
    unawaited(
      context.showAppBottomSheet<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<ProductsFilterBloc>(),
          child: FilterOptionsSheet(
            initialParams: params,
            categories: categories,
            onApply: (newParams) {
              context.read<ProductsFilterBloc>().add(
                    FilterProductsEvent(params: newParams),
                  );
            },
          ),
        ),
      ),
    );
  }

  void _removeCategory(ProductsFilterBloc bloc) {
    final updated = bloc.state.params.copyWith(clearCategory: true);
    bloc.add(FilterProductsEvent(params: updated));
  }

  void _removePrice(ProductsFilterBloc bloc) {
    final updated = ProductFilterParams(
      categoryId: bloc.state.params.categoryId,
      specialOffers: bloc.state.params.specialOffers,
      ratings: bloc.state.params.ratings,
      sort: bloc.state.params.sort,
    );
    bloc.add(FilterProductsEvent(params: updated));
  }

  void _removeRating(ProductsFilterBloc bloc) {
    final updated = ProductFilterParams(
      categoryId: bloc.state.params.categoryId,
      minPrice: bloc.state.params.minPrice,
      maxPrice: bloc.state.params.maxPrice,
      specialOffers: bloc.state.params.specialOffers,
      sort: bloc.state.params.sort,
    );
    bloc.add(FilterProductsEvent(params: updated));
  }

  void _removeSpecialOffers(ProductsFilterBloc bloc) {
    final updated = ProductFilterParams(
      categoryId: bloc.state.params.categoryId,
      minPrice: bloc.state.params.minPrice,
      maxPrice: bloc.state.params.maxPrice,
      ratings: bloc.state.params.ratings,
      sort: bloc.state.params.sort,
    );
    bloc.add(FilterProductsEvent(params: updated));
  }

  void _removeSort(ProductsFilterBloc bloc) {
    final updated = ProductFilterParams(
      categoryId: bloc.state.params.categoryId,
      minPrice: bloc.state.params.minPrice,
      maxPrice: bloc.state.params.maxPrice,
      ratings: bloc.state.params.ratings,
      specialOffers: bloc.state.params.specialOffers,
    );
    bloc.add(FilterProductsEvent(params: updated));
  }

  String _getSortLabel(BuildContext context, String sort) => switch (sort) {
        'price_asc' => context.l10n.filter_sort_price_asc,
        'price_desc' => context.l10n.filter_sort_price_desc,
        'rating_desc' => context.l10n.filter_sort_rating_desc,
        'newest' => context.l10n.filter_sort_newest,
        _ => sort,
      };

  Widget _buildFilterChips(
    BuildContext context,
    ProductFilterParams params,
    List<CategoryEntity> categories,
  ) {
    final cs = context.theme.colorScheme;
    final bloc = context.read<ProductsFilterBloc>();
    final chips = <Widget>[];

    // Category Chip
    if (params.categoryId != null && categories.isNotEmpty) {
      final cat = categories.firstWhere(
        (c) => c.id == params.categoryId,
        orElse: () => const CategoryEntity(id: 0, name: '', image: ''),
      );
      if (cat.id != 0) {
        chips.add(
          InputChip(
            label: Text(cat.name),
            onDeleted: () => _removeCategory(bloc),
            deleteIconColor: cs.primary,
          ),
        );
      }
    }

    // Price Chip
    if (params.minPrice != null || params.maxPrice != null) {
      final minStr = params.minPrice?.toStringAsFixed(0) ?? '0';
      final maxStr = params.maxPrice?.toStringAsFixed(0) ?? '∞';
      chips.add(
        InputChip(
          label: Text('$minStr - $maxStr ${context.l10n.shared_currency_egp}'),
          onDeleted: () => _removePrice(bloc),
          deleteIconColor: cs.primary,
        ),
      );
    }

    // Ratings Chip
    if (params.ratings != null && params.ratings!.isNotEmpty) {
      final ratingsStr = params.ratings!.join(', ');
      chips.add(
        InputChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(ratingsStr),
              2.horizontalSpace,
              Icon(Icons.star_rounded, size: 14.r, color: cs.secondary),
            ],
          ),
          onDeleted: () => _removeRating(bloc),
          deleteIconColor: cs.primary,
        ),
      );
    }

    // Special Offers Chip
    if (params.specialOffers ?? false) {
      chips.add(
        InputChip(
          label: Text(context.l10n.filter_special_offers),
          onDeleted: () => _removeSpecialOffers(bloc),
          deleteIconColor: cs.primary,
        ),
      );
    }

    // Sort Chip
    if (params.sort != null) {
      chips.add(
        InputChip(
          label: Text(_getSortLabel(context, params.sort!)),
          onDeleted: () => _removeSort(bloc),
          deleteIconColor: cs.primary,
        ),
      );
    }

    if (chips.isEmpty) return const SliverToBoxAdapter();

    return SliverToBoxAdapter(
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (_, __) => 8.horizontalSpace,
          itemBuilder: (_, index) => chips[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocProvider(
      create: (context) => sl<ProductsFilterBloc>()
        ..add(const FetchFilterCategoriesEvent())
        ..add(
          FilterProductsEvent(
            params: initialParams ?? const ProductFilterParams(),
          ),
        ),
      child: BlocSelector<ProductsFilterBloc, ProductsFilterState,
          (AppStatus, ProductFilterParams, List<CategoryEntity>)>(
        selector: (state) => (state.status, state.params, state.categories),
        builder: (context, data) {
          final (status, params, categories) = data;

          return Scaffold(
            backgroundColor: cs.surface,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _openFilterSheet(context, params, categories),
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              child: Icon(
                Icons.filter_list_rounded,
                size: 28.r,
              ),
            ),
            body: CustomScrollView(
              slivers: [
                AppSliverTopBar(
                  title: context.l10n.filter_title,
                  actions: [
                    if (!params.isEmpty)
                      IconButton(
                        icon: Icon(Icons.refresh_rounded, color: cs.primary),
                        onPressed: () => context
                            .read<ProductsFilterBloc>()
                            .add(const ResetFiltersEvent()),
                      ),
                  ],
                ),
                _buildFilterChips(context, params, categories),
                if (status.isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: AppLoading(),
                    ),
                  )
                else if (status.isFailure)
                  SliverFillRemaining(
                    child: Center(
                      child: BlocSelector<ProductsFilterBloc,
                          ProductsFilterState, String?>(
                        selector: (state) => state.errorMessage,
                        builder: (context, errorMessage) => AppErrorWidget(
                          message: errorMessage ??
                              context.l10n.errors_something_went_wrong,
                          onRetry: () => context.read<ProductsFilterBloc>().add(
                                FilterProductsEvent(params: params),
                              ),
                        ),
                      ),
                    ),
                  )
                else if (status.isSuccess)
                  BlocSelector<ProductsFilterBloc, ProductsFilterState,
                      (List<ProductEntity>, bool, bool)>(
                    selector: (state) => (
                      state.products,
                      state.hasMore,
                      state.isLoadMoreLoading,
                    ),
                    builder: (context, data) {
                      final (products, hasMore, isLoadMoreLoading) = data;

                      if (products.isEmpty) {
                        return SliverFillRemaining(
                          child: Center(
                            child: AppEmptyState(
                              title: context.l10n.filter_no_products,
                              subtitle:
                                  context.l10n.search_try_different_search,
                              icon: Icons.filter_alt_off_rounded,
                            ),
                          ),
                        );
                      }

                      return SliverMainAxisGroup(
                        slivers: [
                          AppSliverGrid<ProductEntity>(
                            items: products,
                            hasMore: hasMore,
                            onLoadMore: () {
                              context.read<ProductsFilterBloc>().add(
                                    FilterProductsEvent(
                                      params: params,
                                      isLoadMore: true,
                                    ),
                                  );
                            },
                            itemBuilder:
                                (context, product, index, wrapAnimation) =>
                                    wrapAnimation(
                              AppUnifiedCard(
                                id: product.id,
                                title: product.name,
                                description: product.description,
                                image: product.image,
                                price:
                                    product.discountedPrice.toStringAsFixed(0),
                                originalPrice: product.hasOffer
                                    ? (double.tryParse(product.price) ?? 0)
                                        .toStringAsFixed(0)
                                    : null,
                                discountPercentage: product.hasOffer
                                    ? product.discountPercentage
                                    : null,
                                rating: product.averageRating,
                                reviewCount: product.reviewCount,
                                isFavorite: product.isFavorite,
                                activeIdNotifier: _activeMarqueeId,
                                onTap: () => context.push(
                                  AppRoutes.productDetails,
                                  extra: {'productId': product.id},
                                ),
                              ),
                            ),
                          ),
                          if (isLoadMoreLoading)
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 24.h),
                                child: const Center(
                                  child: AppLoading(),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  )
                else
                  SliverFillRemaining(
                    child: Center(
                      child: AppEmptyState(
                        title: context.l10n.filter_title,
                        subtitle: context.l10n.search_search_hint,
                        icon: Icons.filter_alt_rounded,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
