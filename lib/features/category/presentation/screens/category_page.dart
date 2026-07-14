import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/category/presentation/bloc/category_bloc.dart';
import 'package:wassaly/features/category/presentation/bloc/category_event.dart';
import 'package:wassaly/features/category/presentation/bloc/category_state.dart';
import 'package:wassaly/features/category/presentation/widgets/category_side_menu.dart';
import 'package:wassaly/features/home/domain/entities/category_entity.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_bloc.dart';
import 'package:wassaly/features/sub_category/presentation/bloc/sub_category_event.dart';
import 'package:wassaly/features/sub_category/presentation/screens/sub_category_page.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({
    required this.category,
    super.key,
  });

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'category_v3',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(StorageService.instance.setHasSeenShowcase('category_v3', value: true));
        },
        builder: Builder(
          builder: (context) => BlocProvider(
            create: (context) => sl<CategoryBloc>()..add(FetchCategoryDetailEvent(category.id)),
            child: _CategoryView(category: category),
          ),
        ),
      );
}

class _CategoryView extends StatefulWidget {
  const _CategoryView({required this.category});

  final CategoryEntity category;

  @override
  State<_CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<_CategoryView> {
  bool _showcaseStarted = false;

  void _onRetry() => context.read<CategoryBloc>().add(FetchCategoryDetailEvent(widget.category.id));

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          // FIX 1: AppSliverTopBar مش بتتغير مع الـ state
          // فأخرجناها بره الـ BlocBuilder تماماً
          AppSliverTopBar(title: widget.category.name),

          // FIX 2: BlocBuilder بس على الـ sliver اللي بيتغير فعلاً
          BlocSelector<CategoryBloc, CategoryState,
              (CategoryStatus, String, List<SubCategoryEntity>, SubCategoryEntity?)>(
            selector: (state) => (
              state.status,
              state.errorMessage,
              state.subCategories.data,
              state.selectedSubCategory,
            ),
            builder: (context, data) {
              final (status, errorMessage, subCategories, selectedSubCategory) = data;

              if (status == CategoryStatus.failure) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorWidget(
                    title: context.l10n.errors_error_occurred_title,
                    message: errorMessage.isNotEmpty ? errorMessage : context.l10n.errors_error_occurred_message,
                    onRetry: _onRetry,
                  ),
                );
              }

              final isLoading = status == CategoryStatus.loading || status == CategoryStatus.initial;

              if (!isLoading && subCategories.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyState(
                    title: context.l10n.home_no_sub_categories,
                    icon: Icons.folder_open_outlined,
                  ),
                );
              }

              final displaySubCategories = isLoading && subCategories.isEmpty
                  ? List.generate(
                      8,
                      (index) => const SubCategoryEntity(
                        id: 0,
                        name: 'تصنيف تجريبي',
                        image: '',
                      ),
                    )
                  : subCategories;

              final currentSubCategory = isLoading
                  ? const SubCategoryEntity(
                      id: -1,
                      name: 'تصنيف تجريبي',
                      image: '',
                    )
                  : selectedSubCategory;

              if (status == CategoryStatus.success && subCategories.isNotEmpty && !_showcaseStarted) {
                _showcaseStarted = true;
                // ponytail: start showcase directly without redundant seen check since ShowCaseWidget handles it
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ShowCaseWidget.of(context).startShowCase([
                      AppShowcaseKeys.categorySubCategories,
                    ]);
                  }
                });
              }

              return SliverFillRemaining(
                child: Skeletonizer(
                  enabled: isLoading,
                  ignoreContainers: true,
                  child: Row(
                    children: [
                      CategorySideMenu(
                        isLoading: isLoading,
                        subCategories: displaySubCategories,
                        selectedSubCategoryId: selectedSubCategory?.id,
                      ),
                      Expanded(
                        child: currentSubCategory == null
                            ? const SizedBox.shrink()
                            : KeyedSubtree(
                                key: ValueKey(currentSubCategory.id),
                                child: BlocProvider(
                                  create: (context) {
                                    final bloc = sl<SubCategoryBloc>();
                                    if (!isLoading) {
                                      bloc.add(
                                        FetchSubCategoryDetailEvent(
                                          currentSubCategory.id,
                                        ),
                                      );
                                    }
                                    return bloc;
                                  },
                                  child: SubCategoryDetailView(
                                    subCategory: currentSubCategory,
                                    showAppBar: false,
                                    productMainAxisExtent: 230.h,
                                    serviceMainAxisExtent: 190.h,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
