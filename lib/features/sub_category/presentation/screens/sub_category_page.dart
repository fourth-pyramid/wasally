import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';

import '../bloc/sub_category_bloc.dart';
import '../bloc/sub_category_event.dart';
import '../bloc/sub_category_state.dart';
import '../widgets/widgets.dart';

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
      child: _SubCategoryView(subCategory: subCategory),
    );
  }
}

class _SubCategoryView extends StatelessWidget {
  final SubCategoryEntity subCategory;

  const _SubCategoryView({required this.subCategory});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocBuilder<SubCategoryBloc, SubCategoryState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.isLoadingMore != current.isLoadingMore ||
            previous.products != current.products,
        builder: (context, state) {
          if (state.status == SubCategoryStatus.failure) {
            return AppErrorWidget(
              title: 'errors.something_went_wrong'.tr(),
              message: state.errorMessage,
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
                await Future<void>.delayed(
                    const Duration(seconds: 1) - elapsed);
              }
            },
            color: cs.primary,
            backgroundColor: cs.surface,
            child: CustomScrollView(
              slivers: [
                // SliverAppBar
                SliverAppBar(
                  backgroundColor: cs.surface,
                  elevation: 0,
                  centerTitle: true,
                  floating: true,
                  foregroundColor: cs.primary,
                  title: Text(
                    subCategory.name,
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cs.primary,
                    ),
                  ),
                ),

                // Services Section
                if (!isLoading && detail != null && detail.services.isNotEmpty)
                  ServicesSection(services: detail.services),

                // Products Section
                if (!isLoading && state.products.data.isNotEmpty)
                  ProductsSection(
                    products: state.products.data,
                    hasMore: state.hasMoreProducts,
                    isLoadingMore: state.isLoadingMore,
                    subCategoryId: subCategory.id,
                  ),

                // Products Skeleton
                if (isLoading) const ProductsSkeleton(),

                // Empty state if no data
                if (!isLoading &&
                    detail != null &&
                    detail.services.isEmpty &&
                    state.products.data.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyState(
                      title: 'home.no_services_products'.tr(),
                      icon: Icons.folder_open_outlined,
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
