import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/search/presentation/bloc/search_bloc.dart';
import 'package:wassaly/features/search/presentation/bloc/search_event.dart';
import 'package:wassaly/features/search/presentation/bloc/search_state.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Size get preferredSize => Size.fromHeight(80.h);

  @override
  Widget build(BuildContext context) {
    return AppTopBar(
      titleWidget: Expanded(
        child: BlocBuilder<SearchBloc, SearchState>(
          buildWhen: (previous, current) => previous.query != current.query,
          builder: (context, state) {
            return AppTextField(
              suffixIcon: const Icon(Icons.search),
              autofocus: true,
              onChanged: (value) {
                context.read<SearchBloc>().add(SearchQueryChanged(value));
              },
              onFieldSubmitted: (_) {
                context.read<SearchBloc>().add(const SearchSubmitted());
              },
              hint: context.l10n.search_search_hint,
            );
          },
        ),
      ),
    );
  }
}
