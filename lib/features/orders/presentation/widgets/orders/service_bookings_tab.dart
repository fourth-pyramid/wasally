import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_event.dart';
import 'package:wassaly/features/orders/presentation/bloc/orders_state.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/booking_card.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';

class ServiceBookingsTab extends StatelessWidget {
  const ServiceBookingsTab({super.key});

  void _onRetry(BuildContext context) {
    context.read<OrdersBloc>().add(const GetServiceBookingsEvent());
  }

  Future<void> _onRefresh(BuildContext context) async {
    context.read<OrdersBloc>().add(const GetServiceBookingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocSelector<OrdersBloc, OrdersState,
        (OrdersStatus, PaginatedResponse<BookingEntity>, String)>(
      selector: (state) =>
          (state.serviceStatus, state.serviceBookings, state.errorMessage),
      builder: (context, data) {
        final (serviceStatus, serviceBookings, errorMessage) = data;

        if (serviceStatus == OrdersStatus.failure &&
            serviceBookings.data.isEmpty) {
          return Center(
            child: AppErrorWidget(
              title: context.l10n.errors_error_occurred_title,
              message: errorMessage.isNotEmpty
                  ? errorMessage
                  : context.l10n.errors_error_occurred_message,
              onRetry: () => _onRetry(context),
            ),
          );
        }

        final showSkeleton = serviceStatus == OrdersStatus.loading &&
            serviceBookings.data.isEmpty;
        final displayBookings = showSkeleton
            ? List.generate(
                3,
                (index) => BookingEntity(
                  id: index,
                  status: 'pending',
                  problemDescription:
                      'وصف المشكلة التجريبي الخاص بالخدمة المطلوبة لمعاينتها بالتفصيل والعمل عليها بشكل كامل وسريع',
                  service: const BookingServiceEntity(
                    id: 1,
                    name:
                        'اسم خدمة تجريبي طويل جداً للمعاينة والـ skeletonizer',
                    price: 150.0,
                    image: '',
                  ),
                  provider: const BookingProviderEntity(
                    id: 1,
                    name: 'اسم مقدم الخدمة التجريبي',
                  ),
                  dayAr: 'السبت',
                  dayEn: 'Saturday',
                  time: '12:00',
                  createdAt: DateTime.now().toIso8601String(),
                  customerName: 'اسم العميل',
                  customerPhone: '01000000000',
                  governorate: 'القاهرة',
                  center: 'مدينة نصر',
                ),
              )
            : serviceBookings.data;

        return RefreshIndicator(
          onRefresh: () => _onRefresh(context),
          color: cs.primary,
          backgroundColor: cs.surface,
          child: Skeletonizer(
            enabled: showSkeleton,
            ignoreContainers: true,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverOverlapInjector(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                ),
                if (displayBookings.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: AppEmptyState(
                      title: context.l10n.order_no_service_bookings_title,
                      subtitle: context.l10n.order_no_service_bookings_msg,
                    ),
                  )
                else
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    sliver: SliverList.builder(
                      itemCount: displayBookings.length,
                      itemBuilder: (context, index) {
                        final booking = displayBookings[index];
                        return BookingCard(booking: booking);
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
