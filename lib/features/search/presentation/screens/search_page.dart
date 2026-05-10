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

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            const SearchAppBar(),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                buildWhen: (previous, current) =>
                    previous.status != current.status ||
                    previous.products != current.products ||
                    previous.hasSearched != current.hasSearched,
                builder: (context, state) {
                  if (state.status == SearchStatus.initial) {
                    return _buildInitialState(context);
                  }

                  if (state.status == SearchStatus.loading) {
                    return const AppLoading();
                  }

                  if (state.status == SearchStatus.failure) {
                    return AppErrorWidget(
                      message: state.errorMessage,
                      onRetry: () {
                        context.read<SearchBloc>().add(const SearchSubmitted());
                      },
                    );
                  }

                  if (state.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return const SearchResultsList();
                },
              ),
            ),
          ],
        ),
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
            'search.search_hint'.tr(),
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
      title: 'search.no_results_found'.tr(),
      subtitle: 'search.try_different_search'.tr(),
      icon: Icons.search_off,
    );
  }
}
