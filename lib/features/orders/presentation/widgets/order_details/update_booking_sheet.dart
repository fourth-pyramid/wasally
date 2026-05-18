import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_booking/domain/entities/booking_entity.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_bloc.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_event.dart';
import 'package:wassaly/features/service_booking/presentation/bloc/booking_detail/booking_detail_state.dart';

class UpdateBookingSheet extends StatefulWidget {
  final BookingEntity booking;

  const UpdateBookingSheet({super.key, required this.booking});

  @override
  State<UpdateBookingSheet> createState() => _UpdateBookingSheetState();
}

class _UpdateBookingSheetState extends State<UpdateBookingSheet> {
  late final TextEditingController _phoneController;
  late final TextEditingController _problemController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: widget.booking.customerPhone);
    _problemController = TextEditingController(text: widget.booking.problemDescription);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.theme.textTheme;

    return BlocConsumer<BookingDetailBloc, BookingDetailState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus,
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
                    context.l10n.booking_update_title,
                    style: tt.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  24.verticalSpace,
                  AppTextField(
                    controller: _phoneController,
                    label: context.l10n.booking_update_phone_label,
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? context.l10n.order_update_required
                        : null,
                  ),
                  16.verticalSpace,
                  AppTextField(
                    controller: _problemController,
                    label: context.l10n.booking_update_problem_label,
                    maxLines: 4,
                    validator: (value) => value == null || value.trim().isEmpty
                        ? context.l10n.order_update_required
                        : null,
                  ),
                  32.verticalSpace,
                  AppButton(
                    label: context.l10n.booking_update_save,
                    isLoading: isLoading,
                    isFullWidth: true,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.hideKeyboard();

                        context.read<BookingDetailBloc>().add(
                              UpdateBookingEvent(
                                UpdateBookingParams(
                                  bookingId: widget.booking.id,
                                  problemDescription: _problemController.text.trim(),
                                  customerPhone: _phoneController.text.trim(),
                                ),
                              ),
                            );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
