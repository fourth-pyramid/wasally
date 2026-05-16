import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';


import '../bloc/brands_bloc.dart';
import '../bloc/brands_event.dart';
import '../bloc/brands_state.dart';

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
                  width: 32.r,
                  height: 32.r,
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
          BlocBuilder<BrandsBloc, BrandsState>(
            buildWhen: (previous, current) =>
                previous.productsStatus != current.productsStatus ||
                previous.products != current.products,
            builder: (context, state) {
              if (state.productsStatus == BrandProductsStatus.loading &&
                  state.products.isEmpty) {
                return const AppProductsSkeleton();
              }

              if (state.productsStatus == BrandProductsStatus.failure &&
                  state.products.isEmpty) {
                return SliverFillRemaining(
                  child: AppErrorWidget(
                    message: state.productsErrorMessage,
                    onRetry: () => context
                        .read<BrandsBloc>()
                        .add(GetBrandProductsEvent(brandId: widget.brandId)),
                  ),
                );
              }

              if (state.products.isEmpty) {
                return SliverFillRemaining(
                  child: AppEmptyState(
                    title: l10n.no_brand_products,
                    icon: Icons.inventory_2_outlined,
                  ),
                );
              }

              return AppProductsSection(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                products: state.products,
                hasMore: !state.hasReachedMax,
                isLoadingMore:
                    state.productsStatus == BrandProductsStatus.loading,
                mainAxisExtent: 240.h,
                onLoadMore: () {
                  if (state.productsStatus != BrandProductsStatus.loading) {
                    context.read<BrandsBloc>().add(
                        LoadMoreBrandProductsEvent(brandId: widget.brandId));
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
