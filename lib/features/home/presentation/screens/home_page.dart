import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/brands/presentation/widgets/brands_section.dart';
import 'package:wassaly/features/home/presentation/bloc/home_bloc.dart';
import 'package:wassaly/features/home/presentation/bloc/home_event.dart';
import 'package:wassaly/features/home/presentation/bloc/home_state.dart';
import 'package:wassaly/features/home/presentation/widgets/widgets.dart';
import 'package:wassaly/features/notifications/presentation/widgets/notification_badge_icon.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => sl<HomeBloc>()..add(HomeInitializeEvent()),
        child: const _HomeView(),
      );
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  StreamSubscription<void>? _connectivitySub;
  late final ScrollController _scrollController;
  late final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

    sl<HomeNavigationService>().scrollController = _scrollController;
    sl<HomeNavigationService>().refreshKey = _refreshIndicatorKey;

    _connectivitySub =
        sl<InternetConnectionService>().connectivityRestoredStream.listen((_) {
      if (mounted) {
        unawaited(_refreshAllSections(context));
      }
    });
  }

  @override
  void dispose() {
    sl<HomeNavigationService>().scrollController = null;
    sl<HomeNavigationService>().refreshKey = null;
    _scrollController.dispose();
    if (_connectivitySub != null) {
      unawaited(_connectivitySub?.cancel());
    }
    super.dispose();
  }

  // FIX 10: named method — no inline lambda in build()
  void _onSearchTap(BuildContext context) => context.push(AppRoutes.search);

  Future<void> _refreshAllSections(BuildContext context) async {
    final bloc = context.read<HomeBloc>();
    final startTime = DateTime.now();

    bloc.add(HomeInitializeEvent());

    // Wait for all sections to finish loading
    await bloc.stream.firstWhere(
      (state) =>
          state.bannersStatus != HomeStatus.loading &&
          state.categoriesStatus != HomeStatus.loading &&
          state.popularServicesStatus != HomeStatus.loading &&
          state.productsStatus != HomeStatus.loading,
    );

    // Ensure visibility
    final elapsed = DateTime.now().difference(startTime);
    if (elapsed < const Duration(seconds: 1)) {
      await Future<void>.delayed(const Duration(seconds: 1) - elapsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    // FIX 4: Scaffold + RefreshIndicator + CustomScrollView + static slivers
    // are OUTSIDE BlocSelector — they never change with state.
    // Only the slivers that actually react to state are inside BlocSelector.
    return Scaffold(
      backgroundColor: cs.surface,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: () => _refreshAllSections(context),
        color: cs.primary,
        backgroundColor: cs.surface,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Static AppBar — never changes
            AppSliverTopBar(
              automaticallyImplyLeading: false,
              showLogo: true,
              leading: IconButton(
                icon: Icon(
                  Icons.filter_list_rounded,
                  color: cs.primary,
                  size: 28.r,
                ),
                onPressed: () =>
                    unawaited(context.push(AppRoutes.productsFilter)),
              ),
              actions: [
                const AppNotificationBadgeIcon(),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: cs.primary,
                    size: 28.r,
                  ),
                  onPressed: () => _onSearchTap(context), // FIX 10
                ),
              ],
            ),

            // Dynamic slivers — scoped BlocSelector
            BlocSelector<HomeBloc, HomeState, (bool, bool, Failure?, String)>(
              selector: (state) => (
                state.allSectionsFailed,
                state.anySectionLoading,
                state.failure,
                state.errorMessage,
              ),
              builder: (context, data) {
                final (
                  allSectionsFailed,
                  anySectionLoading,
                  failure,
                  errorMessage
                ) = data;

                if (allSectionsFailed && !anySectionLoading) {
                  // Show global error state when all sections failed
                  return SliverMainAxisGroup(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(top: 100.h),
                        sliver: SliverFillRemaining(
                          child: failure != null
                              ? AppErrorWidget.failure(
                                  failure: failure,
                                  onRetry: () => _refreshAllSections(context),
                                )
                              : AppErrorWidget(
                                  title: context.l10n.errors_no_internet_title,
                                  message: errorMessage.isNotEmpty
                                      ? errorMessage
                                      : context.l10n.errors_no_internet_message,
                                  onRetry: () => _refreshAllSections(context),
                                  icon: Icons.wifi_off_rounded,
                                ),
                        ),
                      ),
                    ],
                  );
                }

                return SliverMainAxisGroup(
                  slivers: [
                    // Banner
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: const RepaintBoundary(child: HomeBanner()),
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
                      child: RepaintBoundary(child: MainCategoriesSection()),
                    ),

                    // Spacing
                    SliverToBoxAdapter(
                      child: 16.verticalSpace,
                    ),

                    // Offers Banner
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: GestureDetector(
                          onTap: () =>
                              unawaited(context.push(AppRoutes.offers)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: const RepaintBoundary(
                              child: CommonImage(
                                imageUrl: 'assets/images/offers.png',
                                height: 160,
                                memCacheHeight: 160 * 3,
                              ),
                            ),
                          ),
                        ),
                      ),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
