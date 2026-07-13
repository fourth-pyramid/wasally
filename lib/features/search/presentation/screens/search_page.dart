import 'package:showcase_tutorial/showcase_tutorial.dart';
import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/search/presentation/bloc/search_bloc.dart';
import 'package:wassaly/features/search/presentation/bloc/search_event.dart';
import 'package:wassaly/features/search/presentation/bloc/search_state.dart';
import 'package:wassaly/features/search/presentation/widgets/search_app_bar.dart';
import 'package:wassaly/features/search/presentation/widgets/search_results_list.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => sl<SearchBloc>(),
        child: ShowCaseWidget(
          showcaseId: 'search_v1',
          enableAutoScroll: true,
          disableBarrierInteraction: true,
          onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
          onFinish: () {
            // ponytail: Persist search tour completion
            unawaited(StorageService.instance.setHasSeenShowcase('search_v1', value: true));
          },
          builder: Builder(
            builder: (context) => const _SearchPageContent(),
          ),
        ),
      );
}

class _SearchPageContent extends StatelessWidget {
  const _SearchPageContent();

  // FIX 10: named method — no inline lambda in build()
  void _onRetry(BuildContext context) => context.read<SearchBloc>().add(const SearchSubmitted());

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    // ponytail: Trigger search showcase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        ShowCaseWidget.of(context).startShowCase([
          AppShowcaseKeys.searchField,
        ]);
      }
    });

    // FIX 4: Scaffold + CustomScrollView + SearchAppBar (const) are OUTSIDE
    // BlocBuilder — they never change with search state.
    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: [
          // Static AppBar — never changes
          const SearchAppBar(),

          // Dynamic content — scoped BlocBuilder
          BlocBuilder<SearchBloc, SearchState>(
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.products != current.products ||
                previous.hasSearched != current.hasSearched,
            builder: (context, state) {
              if (state.status == SearchStatus.initial) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildInitialState(context),
                );
              }
              if (state.status == SearchStatus.loading) {
                return const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: AppLoading()),
                );
              }
              if (state.status == SearchStatus.failure) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorWidget(
                    title: context.l10n.errors_error_occurred_title,
                    message:
                        state.errorMessage.isNotEmpty ? state.errorMessage : context.l10n.errors_error_occurred_message,
                    onRetry: () => _onRetry(context), // FIX 10
                  ),
                );
              }
              if (state.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(context),
                );
              }
              return const SearchResultsList();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    final tt = context.theme.textTheme;
    final cs = context.theme.colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(24),
          vertical: context.h(40),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with soft glowing background
            Container(
              padding: EdgeInsets.all(context.r(28)),
              decoration: BoxDecoration(
                color: cs.primary.withValues(alpha: 0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_rounded,
                size: context.r(72),
                color: cs.primary,
              ),
            )
                .animate()
                .scale(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutBack,
                )
                .fadeIn(),

            context.vS(32),

            // Welcoming Title
            Text(
              context.l10n.search_initial_title,
              style: tt.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ).animate().slideY(begin: 0.2, duration: const Duration(milliseconds: 400)).fadeIn(),

            context.vS(8),

            // Subtitle
            Text(
              context.l10n.search_initial_subtitle,
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .slideY(
                  begin: 0.3,
                  delay: const Duration(milliseconds: 100),
                  duration: const Duration(milliseconds: 400),
                )
                .fadeIn(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) => AppEmptyState(
        title: context.l10n.search_no_results_found,
        subtitle: context.l10n.search_try_different_search,
        icon: Icons.search_off,
      );
}
