import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';

import '../bloc/sub_category_bloc.dart';
import '../bloc/sub_category_event.dart';
import '../bloc/sub_category_state.dart';

class SubCategoryPage extends StatelessWidget {
  final SubCategoryEntity subCategory;

  const SubCategoryPage({
    super.key,
    required this.subCategory,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SubCategoryBloc>()
        ..add(FetchSubCategoryDetailEvent(subCategory.id)),
      child: Scaffold(
        backgroundColor: context.theme.colorScheme.surface,
        body: SubCategoryDetailView(subCategory: subCategory),
      ),
    );
  }
}

class SubCategoryDetailView extends StatelessWidget {
  final SubCategoryEntity subCategory;
  final bool showAppBar;
  final int crossAxisCount;
  final double? childAspectRatio;
  final double? mainAxisExtent;

  // Custom overrides for services/products
  final double? serviceChildAspectRatio;
  final double? serviceMainAxisExtent;
  final double? productChildAspectRatio;
  final double? productMainAxisExtent;

  const SubCategoryDetailView({
    super.key,
    required this.subCategory,
    this.showAppBar = true,
    this.crossAxisCount = 2,
    this.childAspectRatio,
    this.mainAxisExtent,
    this.serviceChildAspectRatio,
    this.serviceMainAxisExtent,
    this.productChildAspectRatio,
    this.productMainAxisExtent,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocBuilder<SubCategoryBloc, SubCategoryState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isLoadingMore != current.isLoadingMore ||
          previous.products != current.products ||
          previous.subCategory != current.subCategory,
      builder: (context, state) {
        if (state.status == SubCategoryStatus.failure) {
          return AppErrorWidget(
            title: context.l10n.errors_error_occurred_title,
            message: state.errorMessage.isNotEmpty
                ? state.errorMessage
                : context.l10n.errors_error_occurred_message,
            onRetry: () {
              context.read<SubCategoryBloc>().add(
                    FetchSubCategoryDetailEvent(subCategory.id),
                  );
            },
          );
        }

        final detail = state.subCategory;
        final isLoading = state.status == SubCategoryStatus.loading ||
            state.status == SubCategoryStatus.initial;

        return RefreshIndicator(
          onRefresh: () async {
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
          },
          color: cs.primary,
          backgroundColor: cs.surface,
          child: CustomScrollView(
            slivers: [
              // SliverAppBar
              if (showAppBar)
                AppSliverTopBar(
                  title: subCategory.name,
                ),

              // Services Section

              if (!isLoading && detail != null && detail.services.isNotEmpty)
                AppServicesSection(
                  services: detail.services,
                  crossAxisCount: crossAxisCount,
                  childAspectRatio:
                      serviceChildAspectRatio ?? childAspectRatio ?? 0.50,
                  mainAxisExtent: serviceMainAxisExtent ?? mainAxisExtent,
                ),

              // Services Skeleton
              if (isLoading)
                AppServicesSkeleton(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio:
                      serviceChildAspectRatio ?? childAspectRatio ?? 0.50,
                  mainAxisExtent: serviceMainAxisExtent ?? mainAxisExtent,
                ),

              // Products Section
              if (!isLoading && state.products.data.isNotEmpty)
                AppProductsSection(
                  products: state.products.data,
                  hasMore: state.hasMoreProducts,
                  isLoadingMore: state.isLoadingMore,
                  crossAxisCount: crossAxisCount,
                  childAspectRatio:
                      productChildAspectRatio ?? childAspectRatio ?? 0.65,
                  mainAxisExtent: productMainAxisExtent ?? mainAxisExtent,
                  onLoadMore: () {
                    context.read<SubCategoryBloc>().add(
                          LoadMoreProductsEvent(subCategory.id),
                        );
                  },
                ),

              // Products Skeleton
              if (isLoading)
                AppProductsSkeleton(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio:
                      productChildAspectRatio ?? childAspectRatio ?? 0.65,
                  mainAxisExtent: productMainAxisExtent ?? mainAxisExtent,
                ),

              // Empty state if no data
              if (!isLoading &&
                  detail != null &&
                  detail.services.isEmpty &&
                  state.products.data.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    title: context.l10n.home_no_services_products,
                    icon: Icons.folder_open_outlined,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
