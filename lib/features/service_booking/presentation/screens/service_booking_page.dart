import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import '../../../service_details/domain/entities/service_detail_entity.dart';
import '../bloc/service_booking_bloc.dart';
import '../widgets/booking_address_section.dart';
import '../widgets/booking_customer_form.dart';
import '../widgets/service_summary_card.dart';

class ServiceBookingPage extends StatelessWidget {
  final ServiceDetailEntity service;
  final ServiceAvailableDayEntity? selectedDay;
  final ServiceAvailableTimeEntity? selectedTime;

  const ServiceBookingPage({
    super.key,
    required this.service,
    this.selectedDay,
    this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocProvider(
      create: (context) => sl<ServiceBookingBloc>()
        ..add(ServiceBookingInitialized(
          service: service,
          preselectedDay: selectedDay,
          preselectedTime: selectedTime,
        )),
      child: BlocListener<ServiceBookingBloc, ServiceBookingState>(
        listener: (context, state) {
          if (state.status == ServiceBookingStatus.success) {
            context.pushReplacement(
              AppRoutes.bookingSuccess,
              extra: {'booking': state.booking},
            );
          }
          if (state.status == ServiceBookingStatus.error) {
            context.showTypedSnackBar(
                state.errorMessage ?? context.l10n.errors_something_went_wrong);
          }
        },
        child: Scaffold(
          backgroundColor: cs.surface,
          appBar: AppTopBar(
            title: context.l10n.service_booking_title,
          ),
          body: BlocBuilder<ServiceBookingBloc, ServiceBookingState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(8.w, 16.h, 8.w, 16.h),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // ─── Service Summary ────────────────────────────
                        ServiceSummaryCard(service: service),
                        16.verticalSpace,

                        // ─── Customer Information ───────────────────────
                        const AppCard(
                          showShadow: true,
                          child: BookingCustomerForm(),
                        ),
                        16.verticalSpace,

                        // ─── Address Information ────────────────────────
                        const AppCard(
                          showShadow: true,
                          child: BookingAddressSection(),
                        ),
                        16.verticalSpace,

                        // ─── Booking Details Summary ────────────────────
                        AppCard(
                          showShadow: true,
                          child: Column(
                            children: [
                              _buildSummaryRow(
                                context,
                                context.l10n.service_booking_selected_day,
                                selectedDay != null
                                    ? (context.isArabic
                                        ? selectedDay!.nameAr
                                        : selectedDay!.nameEn)
                                    : '-',
                              ),
                              12.verticalSpace,
                              _buildSummaryRow(
                                context,
                                context.l10n.service_booking_selected_time,
                                selectedTime?.displayTime ?? '-',
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar:
              BlocBuilder<ServiceBookingBloc, ServiceBookingState>(
            builder: (context, state) {
              return Container(
                padding: EdgeInsets.fromLTRB(
                    16.w, 12.h, 16.w, 16.h + context.bottomPadding),
                decoration: BoxDecoration(
                  color: cs.surface,
                  boxShadow: [
                    BoxShadow(
                      color: cs.shadow.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: AppButton(
                  label: context.l10n.service_booking_confirm,
                  isFullWidth: true,
                  height: ButtonSize.large,
                  isLoading: state.status == ServiceBookingStatus.submitting,
                  onPressed: () => context
                      .read<ServiceBookingBloc>()
                      .add(ServiceBookingSubmitted()),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: context.theme.textTheme.bodyMedium
                ?.copyWith(color: context.theme.colorScheme.outline)),
        Text(value,
            style: context.theme.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
