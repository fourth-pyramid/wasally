import 'package:wassaly/core/imports/imports.dart';

import '../../../brands/presentation/widgets/brands_section.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeBloc>()
        ..add(GetBannersEvent())
        ..add(GetCategoriesEvent())
        ..add(GetPopularServicesEvent())
        ..add(GetProductsEvent()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.allSectionsFailed != current.allSectionsFailed ||
            previous.anySectionLoading != current.anySectionLoading ||
            previous.errorMessage != current.errorMessage,
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => _refreshAllSections(context),
            color: cs.primary,
            backgroundColor: cs.surface,
            child: CustomScrollView(
              slivers: [
                // Sliver AppBar
                AppSliverTopBar(
                  showLogo: true,
                  actions: [
                    IconButton(
                      icon: Icon(Icons.search, color: cs.primary),
                      onPressed: () {
                        context.push(AppRoutes.search);
                      },
                    ),
                  ],
                ),

                // Show global error state when all sections failed
                if (state.allSectionsFailed && !state.anySectionLoading) ...[
                  SliverPadding(
                    padding: EdgeInsets.only(top: 100.h),
                    sliver: SliverFillRemaining(
                      child: state.failure != null
                          ? AppErrorWidget.failure(
                              failure: state.failure!,
                              onRetry: () => _refreshAllSections(context),
                            )
                          : AppErrorWidget(
                              title: context.l10n.errors_no_internet_title,
                              message: state.errorMessage.isNotEmpty
                                  ? state.errorMessage
                                  : context.l10n.errors_no_internet_message,
                              onRetry: () => _refreshAllSections(context),
                              icon: Icons.wifi_off_rounded,
                            ),
                    ),
                  ),
                ] else ...[
                  // Banner
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: const HomeBanner(),
                    ),
                  ),
                  // Spacing
                  SliverToBoxAdapter(
                    child: 16.verticalSpace,
                  ),
                  // Popular Services
                  const PopularServicesSection(),

                  // Main Categories
                  const SliverToBoxAdapter(
                    child: MainCategoriesSection(),
                  ),

                  // Spacing
                  SliverToBoxAdapter(
                    child: 16.verticalSpace,
                  ),

                  // Brands
                  const BrandsSection(),

                  // Products
                  const ProductsSection(),

                  // Bottom spacing
                  SliverToBoxAdapter(
                    child: 24.verticalSpace,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _refreshAllSections(BuildContext context) async {
    final bloc = context.read<HomeBloc>();
    final startTime = DateTime.now();

    bloc.add(GetBannersEvent());
    bloc.add(GetCategoriesEvent());
    bloc.add(GetPopularServicesEvent());
    bloc.add(GetProductsEvent());

    // Wait for all sections to finish loading
    await bloc.stream.firstWhere((state) =>
        state.bannersStatus != HomeStatus.loading &&
        state.categoriesStatus != HomeStatus.loading &&
        state.popularServicesStatus != HomeStatus.loading &&
        state.productsStatus != HomeStatus.loading);

    // Ensure visibility
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed < const Duration(seconds: 1)) {
      await Future<void>.delayed(const Duration(seconds: 1) - elapsed);
    }
  }
}
