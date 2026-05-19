import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/search/presentation/bloc/search_bloc.dart';
import 'package:wassaly/features/search/presentation/bloc/search_event.dart';
import 'package:wassaly/features/search/presentation/bloc/search_state.dart';
import 'package:wassaly/features/search/presentation/widgets/search_app_bar.dart';
import 'package:wassaly/features/search/presentation/widgets/search_results_list.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchBloc>(),
      child: const _SearchPageContent(),
    );
  }
}

class _SearchPageContent extends StatelessWidget {
  const _SearchPageContent();

  // FIX 10: named method — no inline lambda in build()
  void _onRetry(BuildContext context) =>
      context.read<SearchBloc>().add(const SearchSubmitted());

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

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
                    message: state.errorMessage.isNotEmpty
                        ? state.errorMessage
                        : context.l10n.errors_error_occurred_message,
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
              return const SliverFillRemaining(
                hasScrollBody: true,
                child: SearchResultsList(),
              );
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64.r,
            color: cs.outline,
          ),
          SizedBox(height: 16.h),
          Text(
            context.l10n.search_search_hint,
            style: tt.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return AppEmptyState(
      title: context.l10n.search_no_results_found,
      subtitle: context.l10n.search_try_different_search,
      icon: Icons.search_off,
    );
  }
}
