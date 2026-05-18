import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_bloc.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_event.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_state.dart';

import '../widgets/order_details/booking_details_cards.dart';
import '../widgets/order_details/update_booking_sheet.dart';

class BookingDetailsPage extends StatefulWidget {
  final BookingEntity booking;

  const BookingDetailsPage({super.key, required this.booking});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  bool _isDeleting = false;
  bool _shouldRefresh = false;
  bool _allowPop = false;

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return PopScope<bool?>(
      canPop: _allowPop || !_shouldRefresh,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        setState(() {
          _allowPop = true;
        });
        context.pop(_shouldRefresh);
      },
      child: Scaffold(
        body: BlocListener<BookingDetailBloc, BookingDetailState>(
          listenWhen: (previous, current) =>
              previous.actionStatus != current.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == BookingActionStatus.success) {
              context.showTypedSnackBar(
                _isDeleting
                    ? context.l10n.booking_delete_success
                    : context.l10n.booking_details_action_success,
                type: SnackBarType.success,
              );
              if (_isDeleting) {
                context.pop(true);
              } else {
                setState(() {
                  _shouldRefresh = true;
                });
              }
            } else if (state.actionStatus == BookingActionStatus.failure) {
              setState(() {
                _isDeleting = false;
              });
              context.showTypedSnackBar(
                state.actionErrorMessage,
                type: SnackBarType.error,
              );
            }
          },
          child: BlocBuilder<BookingDetailBloc, BookingDetailState>(
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.booking != current.booking ||
                previous.errorMessage != current.errorMessage,
            builder: (context, state) {
              if (state.status == BookingDetailStatus.loading &&
                  state.booking == null) {
                return const Center(child: AppLoading());
              }

              if (state.status == BookingDetailStatus.failure &&
                  state.booking == null) {
                return Center(
                  child: AppErrorWidget(
                    title: context.l10n.errors_error_occurred_title,
                    message: state.errorMessage.isNotEmpty
                        ? state.errorMessage
                        : context.l10n.errors_error_occurred_message,
                    onRetry: () => context
                        .read<BookingDetailBloc>()
                        .add(InitializeBookingDetailEvent(widget.booking)),
                  ),
                );
              }

              final booking = state.booking;
              if (booking == null) {
                return Center(
                  child: Text(
                    context.l10n.errors_something_went_wrong,
                    style: tt.bodyLarge,
                  ),
                );
              }

              final normStatus = booking.status.trim().toLowerCase();
              final isCancelled = normStatus.contains('cancelled') ||
                  normStatus.contains('ملغي') ||
                  normStatus.contains('rejected') ||
                  normStatus.contains('failed');

              final isPending = normStatus.contains('pending') ||
                  normStatus.contains('waiting') ||
                  normStatus.contains('قيد الانتظار');

              final isCompleted = normStatus.contains('completed') ||
                  normStatus.contains('مكتمل') ||
                  normStatus.contains('success');

              final canDelete = isCompleted ||
                  isCancelled ||
                  normStatus.contains('accepted') ||
                  normStatus.contains('confirmed') ||
                  normStatus.contains('تم القبول') ||
                  normStatus.contains('مؤكد');
              final canCancelOrUpdate = isPending;

              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  AppSliverTopBar(
                    title: context.l10n.booking_details_title,
                    onPressed: () => context.pop(_shouldRefresh),
                  ),
                  SliverPadding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // 1. Booking Status Summary Header
                        BookingHeaderCard(
                            booking: booking, isCancelled: isCancelled),
                        16.verticalSpace,

                        // 2. Cancellation Alert if cancelled
                        if (isCancelled) ...[
                          const BookingCancelledAlert(),
                          16.verticalSpace,
                        ],

                        // 3. Status Timeline Card
                        _buildSectionHeader(
                            context, context.l10n.booking_details_status),
                        8.verticalSpace,
                        AppCard(
                          showShadow: true,
                          padding: EdgeInsets.all(16.r),
                          child: BookingTrackerWidget(status: booking.status),
                        ),
                        16.verticalSpace,

                        // 4. Booking Info Details Card
                        _buildSectionHeader(
                            context, context.l10n.booking_details_info),
                        8.verticalSpace,
                        BookingServiceInfoCard(booking: booking),
                        24.verticalSpace,

                        // 5. Actions Card
                        if (canDelete || canCancelOrUpdate) ...[
                          _buildSectionHeader(
                              context, context.l10n.booking_details_actions),
                          8.verticalSpace,
                          if (canCancelOrUpdate) ...[
                            BlocSelector<BookingDetailBloc, BookingDetailState,
                                bool>(
                              selector: (s) =>
                                  s.actionStatus == BookingActionStatus.loading,
                              builder: (context, isActionLoading) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        label: context
                                            .l10n.booking_details_cancel_btn,
                                        onPressed: isActionLoading
                                            ? null
                                            : () async {
                                                final confirmed =
                                                    await showAppDialog<bool>(
                                                        child: Builder(
                                                  builder: (ctx) => Dialog(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16.r),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(24.w),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            size: 48.r,
                                                            color: context
                                                                .theme
                                                                .colorScheme
                                                                .error,
                                                          ),
                                                          16.verticalSpace,
                                                          Text(
                                                            context.l10n
                                                                .booking_cancel_title,
                                                            style: context
                                                                .theme
                                                                .textTheme
                                                                .headlineSmall
                                                                ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: context
                                                                  .theme
                                                                  .colorScheme
                                                                  .onSurface,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          8.verticalSpace,
                                                          Text(
                                                            context.l10n
                                                                .booking_cancel_confirm_msg,
                                                            style: context
                                                                .theme
                                                                .textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                              color: context
                                                                  .theme
                                                                  .colorScheme
                                                                  .onSurfaceVariant,
                                                            ),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          24.verticalSpace,
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    AppButton(
                                                                  label: context
                                                                      .l10n
                                                                      .shared_cancel,
                                                                  variant:
                                                                      ButtonVariant
                                                                          .ghost,
                                                                  isFullWidth:
                                                                      false,
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              ctx)
                                                                          .pop(
                                                                              false),
                                                                ),
                                                              ),
                                                              12.horizontalSpace,
                                                              Expanded(
                                                                child:
                                                                    AppButton(
                                                                  isFullWidth:
                                                                      true,
                                                                  label: context
                                                                      .l10n
                                                                      .booking_details_cancel_btn,
                                                                  variant:
                                                                      ButtonVariant
                                                                          .danger,
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              ctx)
                                                                          .pop(
                                                                              true),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ));

                                                if (!context.mounted) return;

                                                if (confirmed ?? false) {
                                                  context
                                                      .read<BookingDetailBloc>()
                                                      .add(CancelBookingEvent(
                                                          booking.id));
                                                }
                                              },
                                        variant: ButtonVariant.danger,
                                      ),
                                    ),
                                    8.horizontalSpace,
                                    Expanded(
                                      child: AppButton(
                                        label: context
                                            .l10n.booking_details_update_btn,
                                        onPressed: isActionLoading
                                            ? null
                                            : () {
                                                context
                                                    .showAppBottomSheet<void>(
                                                  builder: (_) =>
                                                      BlocProvider.value(
                                                    value: context.read<
                                                        BookingDetailBloc>(),
                                                    child: UpdateBookingSheet(
                                                        booking: booking),
                                                  ),
                                                );
                                              },
                                        variant: ButtonVariant.secondary,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            16.verticalSpace,
                          ],
                          if (canDelete)
                            BlocSelector<BookingDetailBloc, BookingDetailState,
                                bool>(
                              selector: (s) =>
                                  s.actionStatus == BookingActionStatus.loading,
                              builder: (context, isActionLoading) {
                                return AppButton(
                                  label: context.l10n.booking_delete_title,
                                  isFullWidth: true,
                                  onPressed: isActionLoading
                                      ? null
                                      : () async {
                                          final confirmed =
                                              await showAppDialog<bool>(
                                            child: Builder(
                                              builder: (ctx) => Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.r),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.all(24.w),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Icons.delete_outline,
                                                        size: 48.r,
                                                        color: context.theme
                                                            .colorScheme.error,
                                                      ),
                                                      16.verticalSpace,
                                                      Text(
                                                        context.l10n
                                                            .booking_delete_title,
                                                        style: context
                                                            .theme
                                                            .textTheme
                                                            .headlineSmall
                                                            ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: context
                                                              .theme
                                                              .colorScheme
                                                              .onSurface,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      8.verticalSpace,
                                                      Text(
                                                        context.l10n
                                                            .booking_delete_confirm_msg,
                                                        style: context
                                                            .theme
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                          color: context
                                                              .theme
                                                              .colorScheme
                                                              .onSurfaceVariant,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      24.verticalSpace,
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: AppButton(
                                                              label: context
                                                                  .l10n
                                                                  .shared_cancel,
                                                              variant:
                                                                  ButtonVariant
                                                                      .ghost,
                                                              isFullWidth:
                                                                  false,
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          ctx)
                                                                      .pop(
                                                                          false),
                                                            ),
                                                          ),
                                                          12.horizontalSpace,
                                                          Expanded(
                                                            child: AppButton(
                                                              isFullWidth: true,
                                                              label: context
                                                                  .l10n
                                                                  .shared_delete,
                                                              variant:
                                                                  ButtonVariant
                                                                      .danger,
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          ctx)
                                                                      .pop(
                                                                          true),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );

                                          if (!context.mounted) return;

                                          if (confirmed ?? false) {
                                            setState(() {
                                              _isDeleting = true;
                                            });
                                            context
                                                .read<BookingDetailBloc>()
                                                .add(DeleteBookingEvent(
                                                    booking.id));
                                          }
                                        },
                                  variant: ButtonVariant.outline,
                                  textColor: context.theme.colorScheme.error,
                                );
                              },
                            ),
                          24.verticalSpace,
                        ],
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final tt = context.theme.textTheme;
    final cs = context.theme.colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Text(
        title,
        style: tt.titleMedium?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
