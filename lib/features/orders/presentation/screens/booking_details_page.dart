import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/booking_details_cards.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/propose_reschedule_sheet.dart';
import 'package:wassaly/features/orders/presentation/widgets/order_details/update_booking_sheet.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_bloc.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_event.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_state.dart';

class BookingDetailsPage extends StatefulWidget {
  final BookingEntity booking;

  const BookingDetailsPage({required this.booking, super.key});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'booking_details_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async => !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(
            StorageService.instance.setHasSeenShowcase('booking_details_v1', value: true),
          );
        },
        builder: Builder(
          builder: (context) => _BookingDetailsView(
            booking: widget.booking,
            scrollController: _scrollController,
          ),
        ),
      );
}

class _BookingDetailsView extends StatefulWidget {
  final BookingEntity booking;
  final ScrollController scrollController;

  const _BookingDetailsView({
    required this.booking,
    required this.scrollController,
  });

  @override
  State<_BookingDetailsView> createState() => _BookingDetailsViewState();
}

class _BookingDetailsViewState extends State<_BookingDetailsView> {
  bool _isDeleting = false;
  bool _shouldRefresh = false;
  bool _allowPop = false;

  bool _showcaseStarted = false;

  void _maybeStartShowcase(BuildContext ctx) {
    if (_showcaseStarted) return;
    _showcaseStarted = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ctx.mounted) {
        ShowCaseWidget.of(ctx).startShowCase([
          AppShowcaseKeys.bookingDetailsStatus,
          AppShowcaseKeys.bookingDetailsProvider,
        ]);
      }
    });
  }

  void _onRetry() {
    context.read<BookingDetailBloc>().add(InitializeBookingDetailEvent(widget.booking));
  }

  Future<void> _onCancelBooking(BookingEntity booking) async {
    final confirmed = await showAppDialog<bool>(
      child: Builder(
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: 48.r,
                  color: context.theme.colorScheme.error,
                ),
                16.verticalSpace,
                Text(
                  context.l10n.booking_cancel_title,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Text(
                  context.l10n.booking_cancel_confirm_msg,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: context.l10n.shared_cancel,
                        variant: ButtonVariant.ghost,
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: AppButton(
                        isFullWidth: true,
                        label: context.l10n.booking_details_cancel_btn,
                        variant: ButtonVariant.danger,
                        onPressed: () => Navigator.of(ctx).pop(true),
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

    if (!mounted) return;

    if (confirmed ?? false) {
      context.read<BookingDetailBloc>().add(CancelBookingEvent(booking.id));
    }
  }

  Future<void> _onDeleteBooking(BookingEntity booking) async {
    final confirmed = await showAppDialog<bool>(
      child: Builder(
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.delete_outline,
                  size: 48.r,
                  color: context.theme.colorScheme.error,
                ),
                16.verticalSpace,
                Text(
                  context.l10n.booking_delete_title,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Text(
                  context.l10n.booking_delete_confirm_msg,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: context.l10n.shared_cancel,
                        variant: ButtonVariant.ghost,
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: AppButton(
                        isFullWidth: true,
                        label: context.l10n.shared_delete,
                        variant: ButtonVariant.danger,
                        onPressed: () => Navigator.of(ctx).pop(true),
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

    if (!mounted) return;

    if (confirmed ?? false) {
      setState(() {
        _isDeleting = true;
      });
      context.read<BookingDetailBloc>().add(DeleteBookingEvent(booking.id));
    }
  }

  Future<void> _onAcceptReschedule(BookingEntity booking) async {
    final confirmed = await showAppDialog<bool>(
      child: Builder(
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 48.r,
                  color: Colors.green,
                ),
                16.verticalSpace,
                Text(
                  context.l10n.booking_reschedule_accept_title,
                  style: context.theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                8.verticalSpace,
                Text(
                  context.l10n.booking_reschedule_accept_confirm,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                24.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: context.l10n.shared_cancel,
                        variant: ButtonVariant.ghost,
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: AppButton(
                        isFullWidth: true,
                        label: context.l10n.booking_reschedule_accept,
                        onPressed: () => Navigator.of(ctx).pop(true),
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

    if (!mounted) return;

    if (confirmed ?? false) {
      context.read<BookingDetailBloc>().add(
            AcceptRescheduleEvent(
              AcceptRescheduleParams(bookingId: booking.id),
            ),
          );
    }
  }

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
          listenWhen: (previous, current) => previous.actionStatus != current.actionStatus,
          listener: (context, state) {
            if (state.actionStatus == BookingActionStatus.success) {
              context.showTypedSnackBar(
                _isDeleting ? context.l10n.booking_delete_success : context.l10n.booking_details_action_success,
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
          child: CustomScrollView(
            controller: widget.scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              AppSliverTopBar(
                title: context.l10n.booking_details_title,
                onPressed: () => context.pop(_shouldRefresh),
              ),
              BlocSelector<BookingDetailBloc, BookingDetailState, (BookingDetailStatus, BookingEntity?, String)>(
                selector: (state) => (
                  state.status,
                  state.booking,
                  state.errorMessage,
                ),
                builder: (context, data) {
                  final (status, booking, errorMessage) = data;

                  if (status == BookingDetailStatus.loading && booking == null) {
                    return const SliverFillRemaining(
                      child: Center(child: AppLoading()),
                    );
                  }

                  if (status == BookingDetailStatus.failure && booking == null) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: AppErrorWidget(
                          title: context.l10n.errors_error_occurred_title,
                          message: errorMessage.isNotEmpty ? errorMessage : context.l10n.errors_error_occurred_message,
                          onRetry: _onRetry,
                        ),
                      ),
                    );
                  }

                  if (booking == null) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          context.l10n.errors_something_went_wrong,
                          style: tt.bodyLarge,
                        ),
                      ),
                    );
                  }

                  _maybeStartShowcase(context);

                  return _BookingDetailsBody(
                    booking: booking,
                    onCancel: () => _onCancelBooking(booking),
                    onDelete: () => _onDeleteBooking(booking),
                    onAcceptReschedule: () => _onAcceptReschedule(booking),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingDetailsBody extends StatelessWidget {
  final BookingEntity booking;
  final VoidCallback onCancel;
  final VoidCallback onDelete;
  final VoidCallback onAcceptReschedule;

  const _BookingDetailsBody({
    required this.booking,
    required this.onCancel,
    required this.onDelete,
    required this.onAcceptReschedule,
  });

  @override
  Widget build(BuildContext context) {
    final normStatus = booking.status.trim().toLowerCase();

    final isCancelled = normStatus.contains('cancelled') ||
        normStatus.contains('ملغي') ||
        normStatus.contains('rejected') ||
        normStatus.contains('failed');

    final isPending =
        normStatus.contains('pending') || normStatus.contains('waiting') || normStatus.contains('قيد الانتظار');

    final isCompleted =
        normStatus.contains('completed') || normStatus.contains('مكتمل') || normStatus.contains('success');

    final canDelete = isCompleted || isCancelled;
    final isRescheduleByProvider = normStatus == 'reschedule_by_provider';
    final canCancelOrUpdate = isPending;

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          // 1. Booking Status Summary Header
          AppShowcase(
            showcaseKey: AppShowcaseKeys.bookingDetailsStatus,
            title: context.l10n.showcase_booking_details_status_title,
            description: context.l10n.showcase_booking_details_status_desc,
            child: BookingHeaderCard(booking: booking, isCancelled: isCancelled),
          ),
          16.verticalSpace,

          // 2. Cancellation Alert if cancelled
          if (isCancelled) ...[
            const BookingCancelledAlert(),
            16.verticalSpace,
          ],

          // 3. Status Timeline Card
          _buildSectionHeader(context, context.l10n.booking_details_status),
          8.verticalSpace,
          AppCard(
            showShadow: true,
            padding: EdgeInsets.all(16.r),
            child: BookingTrackerWidget(status: booking.status),
          ),
          16.verticalSpace,

          // 4. Booking Info Details Card
          _buildSectionHeader(context, context.l10n.booking_details_info),
          8.verticalSpace,
          BookingServiceInfoCard(
            booking: booking,
            providerShowcaseKey: AppShowcaseKeys.bookingDetailsProvider,
          ),
          24.verticalSpace,

          // 4.5. Reschedule Details Card
          if (booking.rescheduleDetails != null) ...[
            _buildSectionHeader(context, context.l10n.booking_reschedule_title),
            8.verticalSpace,
            RescheduleDetailsCard(
              rescheduleDetails: booking.rescheduleDetails!,
              bookingStatus: booking.status,
            ),
            if (isRescheduleByProvider) ...[
              16.verticalSpace,
              BlocSelector<BookingDetailBloc, BookingDetailState, bool>(
                selector: (s) => s.actionStatus == BookingActionStatus.loading,
                builder: (context, isActionLoading) => Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: context.l10n.booking_reschedule_accept,
                        onPressed: isActionLoading ? null : onAcceptReschedule,
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: AppButton(
                        label: context.l10n.booking_reschedule_propose,
                        onPressed: isActionLoading
                            ? null
                            : () {
                                unawaited(
                                  context.showAppBottomSheet<void>(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<BookingDetailBloc>(),
                                      child: ProposeRescheduleSheet(
                                        bookingId: booking.id,
                                      ),
                                    ),
                                  ),
                                );
                              },
                        variant: ButtonVariant.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            24.verticalSpace,
          ],

          // 5. Actions Card
          if (canDelete || canCancelOrUpdate) ...[
            _buildSectionHeader(context, context.l10n.booking_details_actions),
            8.verticalSpace,
            if (canCancelOrUpdate) ...[
              BlocSelector<BookingDetailBloc, BookingDetailState, bool>(
                selector: (s) => s.actionStatus == BookingActionStatus.loading,
                builder: (context, isActionLoading) => Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: context.l10n.booking_details_cancel_btn,
                        onPressed: isActionLoading ? null : onCancel,
                        variant: ButtonVariant.danger,
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: AppButton(
                        label: context.l10n.booking_details_update_btn,
                        onPressed: isActionLoading
                            ? null
                            : () {
                                unawaited(
                                  context.showAppBottomSheet<void>(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<BookingDetailBloc>(),
                                      child: UpdateBookingSheet(booking: booking),
                                    ),
                                  ),
                                );
                              },
                        variant: ButtonVariant.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              16.verticalSpace,
            ],
            if (canDelete)
              BlocSelector<BookingDetailBloc, BookingDetailState, bool>(
                selector: (s) => s.actionStatus == BookingActionStatus.loading,
                builder: (context, isActionLoading) => AppButton(
                  label: context.l10n.booking_delete_title,
                  isFullWidth: true,
                  onPressed: isActionLoading ? null : onDelete,
                  // ponytail: danger variant for consistent red delete buttons
                  variant: ButtonVariant.danger,
                ),
              ),
            24.verticalSpace,
          ],
        ]),
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
