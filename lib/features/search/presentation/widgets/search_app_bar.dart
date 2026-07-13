import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/search/presentation/bloc/search_bloc.dart';
import 'package:wassaly/features/search/presentation/bloc/search_event.dart';
import 'package:wassaly/features/search/presentation/bloc/search_state.dart';

class SearchAppBar extends StatefulWidget {
  const SearchAppBar({super.key});

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final currentQuery = context.read<SearchBloc>().state.query;
    _controller = TextEditingController(text: currentQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocListener<SearchBloc, SearchState>(
      listenWhen: (previous, current) => previous.query != current.query,
      listener: (context, state) {
        if (_controller.text != state.query) {
          _controller.text = state.query;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: state.query.length),
          );
        }
      },
      child: AppSliverTopBar(
        centerTitle: false,
        titleWidget: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 6.h,
          ),
          child: AppShowcase(
            showcaseKey: AppShowcaseKeys.searchField,
            title: context.l10n.showcase_search_field_title,
            description: context.l10n.showcase_search_field_desc,
            isLast: true,
            child: AppTextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.search,
              onFieldSubmitted: (value) {
                context.read<SearchBloc>().add(const SearchSubmitted());
              },
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchQueryChanged(value));
              },
              hint: context.l10n.search_search_hint,
              prefixIcon: Icon(
                Icons.search,
                color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                size: 22.r,
              ),
              suffixIcon: ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, child) {
                  if (value.text.isEmpty) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () {
                      _controller.clear();
                      context.read<SearchBloc>().add(const SearchCleared());
                    },
                    child: Icon(
                      Icons.clear,
                      color: cs.onSurfaceVariant.withValues(alpha: 0.7),
                      size: 20.r,
                    ),
                  );
                },
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 8.h,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
