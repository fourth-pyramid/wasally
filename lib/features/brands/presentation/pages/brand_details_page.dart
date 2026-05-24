import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/brands/presentation/bloc/brands_bloc.dart';
import 'package:wassaly/features/brands/presentation/bloc/brands_event.dart';
import 'package:wassaly/features/brands/presentation/bloc/brands_state.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';

class BrandDetailsPage extends StatelessWidget {
  final int brandId;
  final String brandName;
  final String brandImage;

  const BrandDetailsPage({
    super.key,
    required this.brandId,
    required this.brandName,
    required this.brandImage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<BrandsBloc>()..add(GetBrandProductsEvent(brandId: brandId)),
      child: BrandDetailsView(
        brandId: brandId,
        brandName: brandName,
        brandImage: brandImage,
      ),
    );
  }
}

class BrandDetailsView extends StatefulWidget {
  final int brandId;
  final String brandName;
  final String brandImage;

  const BrandDetailsView({
    super.key,
    required this.brandId,
    required this.brandName,
    required this.brandImage,
  });

  @override
  State<BrandDetailsView> createState() => _BrandDetailsViewState();
}

class _BrandDetailsViewState extends State<BrandDetailsView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context
          .read<BrandsBloc>()
          .add(LoadMoreBrandProductsEvent(brandId: widget.brandId));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          AppSliverTopBar(
            titleWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 32.w,
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    shape: BoxShape.circle,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: CommonImage(
                    imageUrl: widget.brandImage,
                    fit: BoxFit.contain,
                  ),
                ),
                8.horizontalSpace,
                Text(
                  widget.brandName,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ],
            ),
          ),
          BlocSelector<BrandsBloc, BrandsState,
              (BrandProductsStatus, List<ProductEntity>, bool, String)>(
            selector: (state) => (
              state.productsStatus,
              state.products,
              state.hasReachedMax,
              state.productsErrorMessage,
            ),
            builder: (context, data) {
              final (
                productsStatus,
                products,
                hasReachedMax,
                productsErrorMessage
              ) = data;

              final isLoading = productsStatus == BrandProductsStatus.loading &&
                  products.isEmpty;

              if (isLoading || products.isNotEmpty) {
                return AppProductsSection(
                  isLoading: isLoading,
                  products: isLoading ? const [] : products,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  hasMore: isLoading ? false : !hasReachedMax,
                  isLoadingMore: isLoading
                      ? false
                      : (productsStatus == BrandProductsStatus.loading),
                  mainAxisExtent: 240.h,
                  onLoadMore: isLoading
                      ? null
                      : () {
                          if (productsStatus != BrandProductsStatus.loading) {
                            context.read<BrandsBloc>().add(
                                LoadMoreBrandProductsEvent(
                                    brandId: widget.brandId));
                          }
                        },
                );
              }

              if (productsStatus == BrandProductsStatus.failure) {
                return SliverFillRemaining(
                  child: AppErrorWidget(
                    message: productsErrorMessage,
                    onRetry: () => context
                        .read<BrandsBloc>()
                        .add(GetBrandProductsEvent(brandId: widget.brandId)),
                  ),
                );
              }

              return SliverFillRemaining(
                child: AppEmptyState(
                  title: l10n.no_brand_products,
                  icon: Icons.inventory_2_outlined,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
