import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_bloc.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_event.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_state.dart';

class SubCategoryPage extends StatelessWidget {
  const SubCategoryPage({
    super.key,
    required this.subCategory,
  });

  final SubCategoryEntity subCategory;

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
  void _onLoadMore(BuildContext context) =>
      context.read<SubCategoryBloc>().add(LoadMoreProductsEvent(subCategory.id));

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
          BlocBuilder<SubCategoryBloc, SubCategoryState>(
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.isLoadingMore != current.isLoadingMore ||
                previous.products != current.products ||
                previous.subCategory != current.subCategory,
            builder: (context, state) {
              if (state.status == SubCategoryStatus.failure) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorWidget(
                    title: context.l10n.errors_error_occurred_title,
                    message: state.errorMessage.isNotEmpty
                        ? state.errorMessage
                        : context.l10n.errors_error_occurred_message,
                    onRetry: () => context
                        .read<SubCategoryBloc>()
                        .add(FetchSubCategoryDetailEvent(subCategory.id)),
                  ),
                );
              }

              final detail = state.subCategory;
              final isLoading = state.status == SubCategoryStatus.loading ||
                  state.status == SubCategoryStatus.initial;

              // FIX 3: نرجع SliverMainAxisGroup واحدة بدل ما نرجع
              // sliver منفردة — BlocBuilder بيرجع widget واحدة بس
              return SliverMainAxisGroup(
                slivers: [
                  if (isLoading ||
                      (detail != null && detail.services.isNotEmpty))
                    AppServicesSection(
                      isLoading: isLoading,
                      services: isLoading ? const [] : detail!.services,
                      crossAxisCount: crossAxisCount,
                      childAspectRatio:
                          serviceChildAspectRatio ?? childAspectRatio ?? 0.50,
                      mainAxisExtent: serviceMainAxisExtent ?? mainAxisExtent,
                    ),
                  if (isLoading || state.products.data.isNotEmpty)
                    AppProductsSection(
                      isLoading: isLoading,
                      products: isLoading ? const [] : state.products.data,
                      hasMore: isLoading ? false : state.hasMoreProducts,
                      isLoadingMore: isLoading ? false : state.isLoadingMore,
                      crossAxisCount: crossAxisCount,
                      childAspectRatio:
                          productChildAspectRatio ?? childAspectRatio ?? 0.65,
                      mainAxisExtent: productMainAxisExtent ?? mainAxisExtent,
                      // FIX 10: named method — لا closure جديدة في كل rebuild
                      onLoadMore: isLoading ? null : () => _onLoadMore(context),
                    ),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
