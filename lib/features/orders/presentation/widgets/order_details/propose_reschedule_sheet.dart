import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_bloc.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_event.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_state.dart';
import 'package:wassaly/features/service_details/domain/entities/service_detail_entity.dart';

class ProposeRescheduleSheet extends StatefulWidget {
  final int bookingId;

  const ProposeRescheduleSheet({required this.bookingId, super.key});

  @override
  State<ProposeRescheduleSheet> createState() => _ProposeRescheduleSheetState();
}

class _ProposeRescheduleSheetState extends State<ProposeRescheduleSheet> {
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ServiceAvailableDayEntity? _selectedDay;
  ServiceAvailableTimeEntity? _selectedTime;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<BookingDetailBloc>();
    final serviceId = bloc.state.booking?.service.id;
    if (serviceId != null) {
      bloc.add(LoadAvailableDaysEvent(serviceId));
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocConsumer<BookingDetailBloc, BookingDetailState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus ||
          previous.isLoadingDays != current.isLoadingDays ||
          previous.loadDaysError != current.loadDaysError ||
          previous.availableDays != current.availableDays,
      listener: (context, state) {
        if (state.actionStatus == BookingActionStatus.success) {
          context.pop();
        }
      },
      builder: (context, state) {
        final isLoading = state.actionStatus == BookingActionStatus.loading;

        return Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 24.h,
            bottom: MediaQuery.viewInsetsOf(context).bottom > 0
                ? MediaQuery.viewInsetsOf(context).bottom + 16.h
                : context.bottomPadding + 16.h,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    context.l10n.booking_reschedule_propose_title,
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  if (state.isLoadingDays) ...[
                    const Center(child: AppLoading()),
                    24.verticalSpace,
                  ] else if (state.loadDaysError.isNotEmpty) ...[
                    Text(
                      state.loadDaysError,
                      style: tt.bodyMedium?.copyWith(color: cs.error),
                      textAlign: TextAlign.center,
                    ),
                    24.verticalSpace,
                  ] else ...[
                    // Day selection
                    Text(
                      context.l10n.booking_reschedule_propose_day_label,
                      style:
                          tt.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    12.verticalSpace,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: state.availableDays.map((day) {
                          final isSelected = _selectedDay?.id == day.id;
                          return Padding(
                            padding: EdgeInsetsDirectional.only(end: 8.w),
                            child: ChoiceChip(
                              label: Text(
                                context.isArabic ? day.nameAr : day.nameEn,
                              ),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedDay = selected ? day : null;
                                  _selectedTime = null;
                                });
                              },
                              selectedColor: cs.primary,
                              labelStyle: TextStyle(
                                color: isSelected ? cs.onPrimary : cs.onSurface,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (_selectedDay != null) ...[
                      16.verticalSpace,
                      Text(
                        context.l10n.booking_reschedule_propose_time_label,
                        style: tt.titleSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      12.verticalSpace,
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: _selectedDay!.availableTimes.map((time) {
                          final isSelected = _selectedTime?.id == time.id;
                          return ChoiceChip(
                            label: Text(time.displayTime),
                            selected: isSelected,
                            onSelected: (selected) {
                              setState(() {
                                _selectedTime = selected ? time : null;
                              });
                            },
                            selectedColor: cs.primaryContainer,
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? cs.onPrimaryContainer
                                  : cs.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    24.verticalSpace,
                    AppTextField(
                      controller: _noteController,
                      label: context.l10n.booking_reschedule_propose_note_label,
                      hint: context.l10n.booking_reschedule_propose_note_hint,
                      maxLines: 3,
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                              ? context.l10n.booking_reschedule_note_required
                              : null,
                    ),
                    32.verticalSpace,
                    AppButton(
                      label: context.l10n.booking_reschedule_propose_submit,
                      isLoading: isLoading,
                      isFullWidth: true,
                      onPressed: () {
                        if (_selectedDay == null) {
                          context.showTypedSnackBar(
                            context.l10n.booking_reschedule_day_required,
                            type: SnackBarType.warning,
                          );
                          return;
                        }
                        if (_selectedTime == null) {
                          context.showTypedSnackBar(
                            context.l10n.booking_reschedule_time_required,
                            type: SnackBarType.warning,
                          );
                          return;
                        }
                        if (!_formKey.currentState!.validate()) return;

                        context.hideKeyboard();
                        context.read<BookingDetailBloc>().add(
                              ProposeRescheduleEvent(
                                ProposeRescheduleParams(
                                  bookingId: widget.bookingId,
                                  suggestedDayId: _selectedDay!.id,
                                  suggestedTimeId: _selectedTime!.id,
                                  rescheduleNote: _noteController.text.trim(),
                                ),
                              ),
                            );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
