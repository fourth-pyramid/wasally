import 'package:showcase_tutorial/showcase_tutorial.dart';
import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';
import 'package:wassaly/features/sub_category/domain/entities/sub_category_detail_entity.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_bloc.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_event.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_state.dart';

final _activeMarqueeId = ValueNotifier<int?>(null);

class SubCategoryPage extends StatelessWidget {
  const SubCategoryPage({
    required this.subCategory,
    super.key,
  });

  final SubCategoryEntity subCategory;

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'subcategory_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(StorageService.instance.setHasSeenShowcase('subcategory_v1', value: true));
        },
        builder: Builder(
          builder: (context) => BlocProvider(
            create: (context) => sl<SubCategoryBloc>()..add(FetchSubCategoryDetailEvent(subCategory.id)),
            child: Scaffold(
              backgroundColor: context.theme.colorScheme.surface,
              body: SubCategoryDetailView(subCategory: subCategory),
            ),
          ),
        ),
      );
}

class SubCategoryDetailView extends StatelessWidget {
  const SubCategoryDetailView({
    required this.subCategory,
    super.key,
    this.showAppBar = true,
    this.crossAxisCount = 2,
    this.childAspectRatio,
    this.mainAxisExtent,
    this.serviceChildAspectRatio,
    this.serviceMainAxisExtent,
    this.productChildAspectRatio,
    this.productMainAxisExtent,
  });

  final SubCategoryEntity subCategory;
  final bool showAppBar;
  final int crossAxisCount;
  final double? childAspectRatio;
  final double? mainAxisExtent;
  final double? serviceChildAspectRatio;
  final double? serviceMainAxisExtent;
  final double? productChildAspectRatio;
  final double? productMainAxisExtent;

  Future<void> _onRefresh(BuildContext context) async {
    final bloc = context.read<SubCategoryBloc>();
    final startTime = DateTime.now();

    bloc.add(FetchSubCategoryDetailEvent(subCategory.id));

    await bloc.stream.firstWhere(
      (state) => state.status != SubCategoryStatus.loading,
    );

    final elapsed = DateTime.now().difference(startTime);
    if (elapsed < const Duration(seconds: 1)) {
      await Future<void>.delayed(const Duration(seconds: 1) - elapsed);
    }
  }

  // FIX 10: named method بدل lambda inline في build — مش بتتعمل instance جديدة في كل rebuild
  void _onLoadMore(BuildContext context) => context.read<SubCategoryBloc>().add(LoadMoreProductsEvent(subCategory.id));

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    // FIX 1: RefreshIndicator و CustomScrollView و AppSliverTopBar
    // مش بيتغيروا مع الـ state — أخرجناهم بره الـ BlocBuilder
    return RefreshIndicator(
      onRefresh: () => _onRefresh(context),
      color: cs.primary,
      backgroundColor: cs.surface,
      child: CustomScrollView(
        slivers: [
          if (showAppBar) AppSliverTopBar(title: subCategory.name),

          // FIX 2: BlocBuilder بس على الـ slivers اللي بتتغير
          BlocSelector<SubCategoryBloc, SubCategoryState,
              (SubCategoryStatus, String, SubCategoryDetailEntity?, PaginatedResponse<ProductEntity>, bool, bool)>(
            selector: (state) => (
              state.status,
              state.errorMessage,
              state.subCategory,
              state.products,
              state.hasMoreProducts,
              state.isLoadingMore,
            ),
            builder: (context, data) {
              final (status, errorMessage, detail, products, hasMoreProducts, isLoadingMore) = data;

              if (status == SubCategoryStatus.failure) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorWidget(
                    title: context.l10n.errors_error_occurred_title,
                    message: errorMessage.isNotEmpty ? errorMessage : context.l10n.errors_error_occurred_message,
                    onRetry: () => context.read<SubCategoryBloc>().add(FetchSubCategoryDetailEvent(subCategory.id)),
                  ),
                );
              }

              final isLoading = status == SubCategoryStatus.loading || status == SubCategoryStatus.initial;

              if (status == SubCategoryStatus.success &&
                  (products.data.isNotEmpty || (detail != null && detail.services.isNotEmpty))) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ShowCaseWidget.of(context).startShowCase([
                      AppShowcaseKeys.subCategoryProducts,
                    ]);
                  }
                });
              }

              return SliverMainAxisGroup(
                slivers: [
                  if (isLoading || (detail != null && detail.services.isNotEmpty))
                    AppUnifiedSection<ServiceEntity>(
                      isLoading: isLoading,
                      items: isLoading ? const [] : detail!.services,
                      dummyItems: const [
                        ServiceEntity(
                          id: 1,
                          title: 'خدمة',
                          description: '',
                          price: 0,
                          isFavorite: false,
                        ),
                        ServiceEntity(
                          id: 2,
                          title: 'خدمة',
                          description: '',
                          price: 0,
                          isFavorite: false,
                        ),
                      ],
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: serviceChildAspectRatio ?? childAspectRatio ?? 0.50,
                      mainAxisExtent: 190.h,
                      itemBuilder: (context, service, index, wrapAnimation) {
                        final card = AppUnifiedCard(
                          id: service.id,
                          type: UnifiedItemType.service,
                          title: service.title,
                          description: service.description,
                          image: service.image,
                          price: service.price.toString(),
                          isFavorite: service.isFavorite,
                          activeIdNotifier: _activeMarqueeId,
                          onTap: () => context.push(
                            AppRoutes.serviceDetails,
                            extra: {'serviceId': service.id},
                          ),
                        );
                        if (index == 0 && products.data.isEmpty) {
                          return wrapAnimation(
                            AppShowcase(
                              showcaseKey: AppShowcaseKeys.subCategoryProducts,
                              title: context.l10n.showcase_subcategory_products_title,
                              description: context.l10n.showcase_subcategory_products_desc,
                              isLast: true,
                              child: card,
                            ),
                          );
                        }
                        return wrapAnimation(card);
                      },
                    ),
                  if (isLoading || products.data.isNotEmpty)
                    AppUnifiedSection<ProductEntity>(
                      isLoading: isLoading,
                      items: isLoading ? const [] : products.data,
                      dummyItems: const [
                        ProductEntity(
                          id: 1,
                          name: 'منتج',
                          image: '',
                          price: '0',
                          description: '',
                          offers: [],
                          reviews: [],
                          isFavorite: false,
                        ),
                      ],
                      hasMore: !isLoading && hasMoreProducts,
                      isLoadingMore: !isLoading && isLoadingMore,
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: productChildAspectRatio ?? childAspectRatio ?? 0.65,
                      mainAxisExtent: productMainAxisExtent ?? mainAxisExtent,
                      onLoadMore: isLoading ? null : () => _onLoadMore(context),
                      itemBuilder: (context, product, index, wrapAnimation) {
                        final card = AppUnifiedCard(
                          id: product.id,
                          title: product.name,
                          description: product.description,
                          image: product.image,
                          price: product.discountedPrice.toStringAsFixed(0),
                          originalPrice:
                              product.hasOffer ? (double.tryParse(product.price) ?? 0).toStringAsFixed(0) : null,
                          discountPercentage: product.hasOffer ? product.discountPercentage : null,
                          rating: product.averageRating,
                          reviewCount: product.reviewCount,
                          isFavorite: product.isFavorite,
                          activeIdNotifier: _activeMarqueeId,
                          onTap: () => context.push(
                            AppRoutes.productDetails,
                            extra: {'productId': product.id},
                          ),
                        );
                        if (index == 0) {
                          return wrapAnimation(
                            AppShowcase(
                              showcaseKey: AppShowcaseKeys.subCategoryProducts,
                              title: context.l10n.showcase_subcategory_products_title,
                              description: context.l10n.showcase_subcategory_products_desc,
                              isLast: true,
                              child: card,
                            ),
                          );
                        }
                        return wrapAnimation(card);
                      },
                    ),
                  if (!isLoading && detail != null && detail.services.isEmpty && products.data.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppEmptyState(
                        title: context.l10n.home_no_services_products,
                        icon: Icons.folder_open_outlined,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
