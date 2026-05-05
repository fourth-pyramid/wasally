import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';
import 'package:wassaly/features/profile/presentation/bloc/settings/settings_bloc.dart';

/// A wrapper to initialize the chosen State Management library.
class StateWrapper extends StatelessWidget {
  final Widget child;

  const StateWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final providers = <BlocProvider>[
      BlocProvider<SessionBloc>(
        create: (_) => sl<SessionBloc>(),
      ),
      BlocProvider<SettingsBloc>(
        create: (_) => sl<SettingsBloc>()..add(const SettingsInitialized()),
      ),
    ];

    return MultiBlocProvider(
      providers: providers,
      child: child,
    );
  }
}
