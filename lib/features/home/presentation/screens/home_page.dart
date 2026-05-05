import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/injection/injection.dart';

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
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () => _refreshAllSections(context),
            color: cs.primary,
            backgroundColor: cs.surface,
            child: CustomScrollView(
              slivers: [
                // Sliver AppBar
                SliverAppBar(
                  floating: true,
                  snap: true,
                  backgroundColor: cs.surface,
                  elevation: 0,
                  centerTitle: true,
                  title: Image.asset(
                    'assets/images/logo.png',
                    height: 60.h,
                    cacheHeight: (60.h * 2).toInt(),
                    filterQuality: FilterQuality.high,
                  ),
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
                      child: AppErrorWidget(
                        title: 'errors.no_internet'.tr(),
                        message: state.errorMessage.isNotEmpty
                            ? state.errorMessage
                            : 'Please check your internet connection and try again.',
                        onRetry: () => _refreshAllSections(context),
                        icon: Icons.wifi_off_rounded,
                      ),
                    ),
                  ),
                ] else ...[
                  // Banner
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: HomeBanner(),
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
                    child: 12.verticalSpace,
                  ),

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
