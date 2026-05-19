import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_state.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/booking_card.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';

class ServiceBookingsTab extends StatefulWidget {
  const ServiceBookingsTab({super.key});

  @override
  State<ServiceBookingsTab> createState() => _ServiceBookingsTabState();
}

class _ServiceBookingsTabState extends State<ServiceBookingsTab> {
  void _onRetry() {
    context.read<OrdersBloc>().add(const GetServiceBookingsEvent());
  }

  Future<void> _onRefresh() async {
    context.read<OrdersBloc>().add(const GetServiceBookingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OrdersBloc, OrdersState,
        (OrdersStatus, PaginatedResponse<BookingEntity>, String)>(
      selector: (state) =>
          (state.serviceStatus, state.serviceBookings, state.errorMessage),
      builder: (context, data) {
        final (serviceStatus, serviceBookings, errorMessage) = data;

        if (serviceStatus == OrdersStatus.loading &&
            serviceBookings.data.isEmpty) {
          return const Center(child: AppLoading());
        }

        if (serviceStatus == OrdersStatus.failure &&
            serviceBookings.data.isEmpty) {
          return Center(
            child: AppErrorWidget(
              title: context.l10n.errors_error_occurred_title,
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : context.l10n.errors_error_occurred_message,
              onRetry: _onRetry,
            ),
          );
        }

        if (serviceBookings.data.isEmpty) {
          return AppEmptyState(
            title: context.l10n.order_no_service_bookings_title,
            subtitle: context.l10n.order_no_service_bookings_msg,
          );
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
                sliver: SliverList.builder(
                  itemCount: serviceBookings.data.length,
                  itemBuilder: (context, index) {
                    final booking = serviceBookings.data[index];
                    return BookingCard(booking: booking);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
