import 'package:showcase_tutorial/showcase_tutorial.dart';
import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_bloc.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_event.dart';
import 'package:wassaly/features/favorite/presentation/bloc/favorite_state.dart';
import 'package:wassaly/features/favorite/presentation/widgets/product_favorites_tab.dart';
import 'package:wassaly/features/favorite/presentation/widgets/service_favorites_tab.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) => const _FavoriteView();
}

class _FavoriteView extends StatefulWidget {
  const _FavoriteView();

  @override
  State<_FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<_FavoriteView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<FavoriteBloc>();
      if (bloc.state.status == FavoriteStatus.initial) {
        bloc.add(const GetFavoritesEvent());
      }
      if (bloc.state.serviceStatus == FavoriteStatus.initial) {
        bloc.add(const GetServiceFavoritesEvent());
      }

      // ponytail: Trigger favorite page showcase
      ShowCaseWidget.of(context).startShowCase([
        AppShowcaseKeys.favoriteTabs,
      ]);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          AppSliverTopBar(
            automaticallyImplyLeading: false,
            title: context.l10n.favorite_favorite_title,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: AppShowcase(
                showcaseKey: AppShowcaseKeys.favoriteTabs,
                title: context.l10n.showcase_favorite_tabs_title,
                description: context.l10n.showcase_favorite_tabs_desc,
                isLast: true,
                child: TabBar(
                  controller: _tabController,
                  labelColor: cs.primary,
                  unselectedLabelColor: cs.onSurfaceVariant,
                  indicatorColor: cs.primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(text: context.l10n.favorite_products),
                    Tab(text: context.l10n.favorite_services),
                  ],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: const [
            ProductFavoritesTab(),
            ServiceFavoritesTab(),
          ],
        ),
      ),
    );
  }
}
