import 'package:wassaly/core/imports/imports.dart';
import '../bloc/service_details_bloc.dart';
import '../widgets/service_details_content.dart';

class ServiceDetailsPage extends StatelessWidget {
  final int serviceId;

  const ServiceDetailsPage({
    super.key,
    required this.serviceId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ServiceDetailsBloc>()..add(FetchServiceDetailsEvent(serviceId)),
      child: BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
        builder: (context, state) {
          if (state.status == ServiceDetailsStatus.loading) {
            return const Scaffold(body: Center(child: AppLoading()));
          }

          if (state.status == ServiceDetailsStatus.failure) {
            return Scaffold(
              appBar: AppTopBar(title: context.l10n.service_details_title),
              body: AppErrorWidget(
                message: state.errorMessage ??
                    context.l10n.errors_something_went_wrong,
                onRetry: () => context
                    .read<ServiceDetailsBloc>()
                    .add(FetchServiceDetailsEvent(serviceId)),
              ),
            );
          }

          if (state.status == ServiceDetailsStatus.success &&
              state.service != null) {
            return ServiceDetailsContent(service: state.service!);
          }

          return const Scaffold(body: SizedBox.shrink());
        },
      ),
    );
  }
}
