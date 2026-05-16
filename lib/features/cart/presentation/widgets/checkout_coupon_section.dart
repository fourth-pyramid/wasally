import 'package:wassaly/core/imports/core_imports.dart';
import 'package:wassaly/core/imports/packages_imports.dart';

import '../bloc/checkout/checkout_bloc.dart';

class CheckoutCouponSection extends StatefulWidget {
  const CheckoutCouponSection({super.key});

  @override
  State<CheckoutCouponSection> createState() => _CheckoutCouponSectionState();
}

class _CheckoutCouponSectionState extends State<CheckoutCouponSection> {
  late final TextEditingController _couponController;

  @override
  void initState() {
    super.initState();
    _couponController = TextEditingController();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listenWhen: (prev, curr) =>
          prev.couponError != curr.couponError && curr.couponError != null,
      listener: (context, state) {
        if (state.couponError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.couponError!),
              backgroundColor: cs.error,
            ),
          );
        }
      },
      buildWhen: (prev, curr) =>
          prev.appliedCoupon != curr.appliedCoupon ||
          prev.couponError != curr.couponError ||
          prev.isApplyingCoupon != curr.isApplyingCoupon ||
          prev.status != curr.status,
      builder: (context, state) {
        final isSubmitting = state.status == CheckoutStatus.submitting;
        final hasCoupon = state.appliedCoupon != null;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AppTextField(
                    label:
                        '${context.l10n.checkout_coupon_code} (${context.l10n.shared_optional})',
                    hint:
                        '${context.l10n.checkout_coupon_code} (${context.l10n.shared_optional})',
                    controller: _couponController,
                    enabled: !isSubmitting && !hasCoupon,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.discount_outlined),
                    onChanged: (v) => context
                        .read<CheckoutBloc>()
                        .add(CheckoutFormChanged(couponCode: v)),
                  ),
                ),
                8.horizontalSpace,
                if (!hasCoupon)
                  AppButton(
                    label: context.l10n.checkout_apply_coupon,
                    isLoading: state.isApplyingCoupon,
                    onPressed: isSubmitting || state.isApplyingCoupon
                        ? null
                        : () {
                            final code = _couponController.text.trim();
                            if (code.isNotEmpty) {
                              context
                                  .read<CheckoutBloc>()
                                  .add(CheckoutCouponApplied(code));
                            }
                          },
                  )
                else
                  AppButton(
                    label: context.l10n.checkout_remove_coupon,
                    variant: ButtonVariant.outline,
                    onPressed: isSubmitting
                        ? null
                        : () {
                            _couponController.clear();
                            context
                                .read<CheckoutBloc>()
                                .add(const CheckoutCouponRemoved());
                          },
                  ),
              ],
            ),
            if (hasCoupon) ...[
              8.verticalSpace,
              Row(
                children: [
                  Icon(Icons.check_circle_outline,
                      color: cs.primary, size: 16.r),
                  6.horizontalSpace,
                  Text(
                    state.appliedCoupon!.title,
                    style: TextStyle(
                      color: cs.primary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
