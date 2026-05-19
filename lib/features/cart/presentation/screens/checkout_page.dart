import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_event.dart';
import 'package:wassaly/features/cart/presentation/bloc/cart_state.dart';
import 'package:wassaly/features/cart/presentation/bloc/checkout/checkout_bloc.dart';
import 'package:wassaly/features/cart/presentation/widgets/checkout/checkout_bottom_sheet.dart';
import 'package:wassaly/features/cart/presentation/widgets/checkout/checkout_coupon_section.dart';
import 'package:wassaly/features/cart/presentation/widgets/checkout/checkout_form_section.dart';
import 'package:wassaly/features/cart/presentation/widgets/checkout/checkout_order_summary_section.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;

    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status ||
          (prev.errorMessage != curr.errorMessage && curr.errorMessage != null),
      listener: (context, state) {
        if (state.status == CheckoutStatus.success) {
          // Refresh cart items after successful order
          context.read<CartBloc>().add(const LoadCartItemsEvent());

          // Navigate to order confirmation
          if (context.mounted) {
            context.pushReplacement(
              AppRoutes.orderSuccess,
              extra: state.placedOrder,
            );
          }
        } else if (state.status == CheckoutStatus.error &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: cs.error,
            ),
          );
        }
      },
      buildWhen: (prev, curr) {
        // Rebuild only when major structural page state transitions happen
        final prevShowLoading =
            prev.status == CheckoutStatus.loading && prev.governorates.isEmpty;
        final currShowLoading =
            curr.status == CheckoutStatus.loading && curr.governorates.isEmpty;
        if (prevShowLoading != currShowLoading) return true;

        final prevShowError =
            prev.status == CheckoutStatus.error && prev.governorates.isEmpty;
        final currShowError =
            curr.status == CheckoutStatus.error && curr.governorates.isEmpty;
        if (prevShowError != currShowError) return true;

        // Transitioning from loading/error to content or vice versa
        final prevHasContent = prev.governorates.isNotEmpty;
        final currHasContent = curr.governorates.isNotEmpty;
        if (prevHasContent != currHasContent) return true;

        return false;
      },
      builder: (context, state) {
        // Show full-screen loading while loading governorates initially
        final isLoading = state.status == CheckoutStatus.loading &&
            state.governorates.isEmpty;

        // Show error if governorates failed to load
        final isError =
            state.status == CheckoutStatus.error && state.governorates.isEmpty;

        return Scaffold(
          backgroundColor: cs.surface,
          body: CustomScrollView(
            slivers: [
              AppSliverTopBar(
                title: context.l10n.checkout_title,
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
                      message: state.errorMessage ??
                          context.l10n.errors_error_occurred_message,
                      onRetry: () {
                        final cartState = context.read<CheckoutBloc>().state;
                        context.read<CheckoutBloc>().add(
                              CheckoutInitialized(
                                  cartState: cartState as CartState),
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
                      // ─── Shipping Address Form ────────────────────────────
                      const AppCard(
                        showShadow: true,
                        child: CheckoutFormSection(),
                      ),
                      16.verticalSpace,

                      // ─── Coupon Section ───────────────────────────────────
                      AppCard(
                        showShadow: true,
                        title: context.l10n.checkout_coupon_code,
                        child: const CheckoutCouponSection(),
                      ),
                      16.verticalSpace,

                      // ─── Order Summary ────────────────────────────────────
                      const AppCard(
                        showShadow: true,
                        child: CheckoutOrderSummarySection(),
                      ),
                    ]),
                  ),
                ),
            ],
          ),
          bottomSheet:
              (!isLoading && !isError) ? const CheckoutBottomSheet() : null,
        );
      },
    );
  }
}
