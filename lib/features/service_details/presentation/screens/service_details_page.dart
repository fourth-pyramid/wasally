import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';
import 'package:wassaly/features/service_details/presentation/bloc/service_details_bloc.dart';
import 'package:wassaly/features/service_details/presentation/widgets/service_details_content.dart';

class ServiceDetailsPage extends StatelessWidget {
  final int serviceId;

  const ServiceDetailsPage({
    super.key,
    required this.serviceId,
  });

  void _onRetry(BuildContext context) {
    context.read<ServiceDetailsBloc>().add(FetchServiceDetailsEvent(serviceId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ServiceDetailsBloc>()
            ..add(FetchServiceDetailsEvent(serviceId)),
        ),
        BlocProvider.value(
          value: sl<OrdersBloc>()..add(const GetServiceBookingsEvent()),
        ),
      ],
      child: BlocBuilder<ServiceDetailsBloc, ServiceDetailsState>(
        builder: (context, state) {
          if (state.status == ServiceDetailsStatus.loading) {
            return const Scaffold(body: Center(child: AppLoading()));
          }

          if (state.status == ServiceDetailsStatus.failure) {
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  AppSliverTopBar(title: context.l10n.service_details_title),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppErrorWidget(
                      message: state.errorMessage ??
                          context.l10n.errors_something_went_wrong,
                      onRetry: () => _onRetry(context),
                    ),
                  ),
                ],
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
