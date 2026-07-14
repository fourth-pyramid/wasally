import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/service_booking_bloc.dart';
import 'package:wassaly/features/service_booking/presentation/widgets/booking_address_section.dart';
import 'package:wassaly/features/service_booking/presentation/widgets/booking_customer_form.dart';
import 'package:wassaly/features/service_booking/presentation/widgets/booking_problem_section.dart';
import 'package:wassaly/features/service_booking/presentation/widgets/service_summary_card.dart';
import 'package:wassaly/features/service_details/domain/entities/service_detail_entity.dart';

class ServiceBookingPage extends StatelessWidget {
  final ServiceDetailEntity service;
  final ServiceAvailableDayEntity? selectedDay;
  final ServiceAvailableTimeEntity? selectedTime;

  const ServiceBookingPage({
    required this.service,
    super.key,
    this.selectedDay,
    this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return ShowCaseWidget(
      showcaseId: 'service_booking_v1',
      enableAutoScroll: true,
      disableBarrierInteraction: true,
      onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
      onFinish: () {
        unawaited(StorageService.instance.setHasSeenShowcase('service_booking_v1', value: true));
      },
      builder: Builder(
        builder: (context) => BlocProvider(
          create: (context) => sl<ServiceBookingBloc>()
            ..add(
              ServiceBookingInitialized(
                service: service,
                preselectedDay: selectedDay,
                preselectedTime: selectedTime,
              ),
            ),
          child: BlocConsumer<ServiceBookingBloc, ServiceBookingState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status || (prev.errorMessage != curr.errorMessage && curr.errorMessage != null),
            listener: (context, state) {
              if (state.status == ServiceBookingStatus.success) {
                context.pushReplacement(
                  AppRoutes.bookingSuccess,
                  extra: {'booking': state.booking},
                );
              } else if (state.status == ServiceBookingStatus.error && state.errorMessage != null) {
                context.showTypedSnackBar(state.errorMessage!);
              }
            },
            buildWhen: (prev, curr) {
              final prevShowLoading = prev.status == ServiceBookingStatus.loading && prev.governorates.isEmpty;
              final currShowLoading = curr.status == ServiceBookingStatus.loading && curr.governorates.isEmpty;
              if (prevShowLoading != currShowLoading) return true;

              final prevShowError = prev.status == ServiceBookingStatus.error && prev.governorates.isEmpty;
              final currShowError = curr.status == ServiceBookingStatus.error && curr.governorates.isEmpty;
              if (prevShowError != currShowError) return true;

              final prevHasContent = prev.governorates.isNotEmpty;
              final currHasContent = curr.governorates.isNotEmpty;
              if (prevHasContent != currHasContent) return true;

              return false;
            },
            builder: (context, state) {
              final isLoading = state.status == ServiceBookingStatus.loading && state.governorates.isEmpty;

              final isError = state.status == ServiceBookingStatus.error && state.governorates.isEmpty;

              if (!isLoading && !isError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    ShowCaseWidget.of(context).startShowCase([
                      AppShowcaseKeys.serviceBookingAddress,
                      AppShowcaseKeys.serviceBookingConfirm,
                    ]);
                  }
                });
              }

              return Scaffold(
                backgroundColor: cs.surface,
                body: CustomScrollView(
                  slivers: [
                    AppSliverTopBar(
                      title: context.l10n.service_booking_title,
                    ),
                    if (isLoading)
                      const SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: AppLoading()),
                      )
                    else if (isError)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: AppErrorWidget(
                            title: context.l10n.errors_error_occurred_title,
                            message: state.errorMessage ?? context.l10n.errors_error_occurred_message,
                            onRetry: () {
                              context.read<ServiceBookingBloc>().add(
                                    ServiceBookingInitialized(
                                      service: service,
                                      preselectedDay: selectedDay,
                                      preselectedTime: selectedTime,
                                    ),
                                  );
                            },
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 120.h),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            ServiceSummaryCard(service: service),
                            16.verticalSpace,
                            AppCard(
                              showShadow: true,
                              title: context.l10n.service_booking_customer_info,
                              child: const BookingCustomerForm(),
                            ),
                            16.verticalSpace,
                            AppCard(
                              showShadow: true,
                              title: context.l10n.service_booking_problem,
                              child: const BookingProblemSection(),
                            ),
                            16.verticalSpace,
                            AppShowcase(
                              showcaseKey: AppShowcaseKeys.serviceBookingAddress,
                              title: context.l10n.showcase_service_booking_address_title,
                              description: context.l10n.showcase_service_booking_address_desc,
                              child: const AppCard(
                                showShadow: true,
                                child: BookingAddressSection(),
                              ),
                            ),
                            16.verticalSpace,
                            AppCard(
                              showShadow: true,
                              child: Column(
                                children: [
                                  _buildSummaryRow(
                                    context,
                                    context.l10n.service_booking_selected_day,
                                    selectedDay != null
                                        ? (context.isArabic ? selectedDay!.nameAr : selectedDay!.nameEn)
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
                ),
                bottomSheet: (!isLoading && !isError)
                    ? AppShowcase(
                        showcaseKey: AppShowcaseKeys.serviceBookingConfirm,
                        title: context.l10n.showcase_service_booking_confirm_title,
                        description: context.l10n.showcase_service_booking_confirm_desc,
                        isLast: true,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                            16.w,
                            12.h,
                            16.w,
                            context.bottomPadding + 12.h,
                          ),
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
                          child: BlocSelector<ServiceBookingBloc, ServiceBookingState, (bool, bool)>(
                            selector: (state) => (
                              state.isFormValid,
                              state.status == ServiceBookingStatus.submitting,
                            ),
                            builder: (context, data) {
                              final (isFormValid, isSubmitting) = data;

                              return AppButton(
                                label: context.l10n.service_booking_confirm,
                                isFullWidth: true,
                                height: ButtonSize.large,
                                isLoading: isSubmitting,
                                onPressed: (!isFormValid || isSubmitting)
                                    ? null
                                    : () => context.read<ServiceBookingBloc>().add(ServiceBookingSubmitted()),
                              );
                            },
                          ),
                        ),
                      )
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.theme.textTheme.bodyMedium?.copyWith(color: context.theme.colorScheme.outline),
          ),
          Text(
            value,
            style: context.theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      );
}
