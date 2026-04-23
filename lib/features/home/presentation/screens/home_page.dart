import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/injection/injection.dart';
import 'package:wassaly/features/auth/presentation/bloc/session/session_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SessionBloc>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<SessionBloc>().add(const SessionLogoutRequested());
            },
          ),
        ],
      ),
      body: BlocListener<SessionBloc, SessionState>(
        listener: (context, state) {
          if (state is SessionUnauthenticated) {
            context.go(AppRoutes.login);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_shipping,
                size: 80.r,
                color: context.colors.primary,
              ),
              20.verticalSpace,
              Text(
                'Welcome to وصّلي',
                style: context.typography.headlineMedium,
              ),
              10.verticalSpace,
              Text(
                'You are authenticated!',
                style: context.typography.bodyLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
