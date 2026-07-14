import 'package:wassaly/core/constants/showcase_keys.dart';
import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/service_details/domain/entities/service_detail_entity.dart';
import 'package:wassaly/features/service_details/presentation/bloc/service_details_bloc.dart';
import 'package:wassaly/features/service_details/presentation/widgets/book_service_bottom_bar.dart';
import 'package:wassaly/features/service_details/presentation/widgets/service_details_gallery.dart';
import 'package:wassaly/features/service_details/presentation/widgets/service_details_info.dart';

class ServiceDetailsContent extends StatefulWidget {
  final ServiceDetailEntity service;

  const ServiceDetailsContent({
    required this.service,
    super.key,
  });

  @override
  State<ServiceDetailsContent> createState() => _ServiceDetailsContentState();
}

class _ServiceDetailsContentState extends State<ServiceDetailsContent> {
  final ValueNotifier<ServiceAvailableDayEntity?> _selectedDayNotifier =
      ValueNotifier(null);
  final ValueNotifier<ServiceAvailableTimeEntity?> _selectedTimeNotifier =
      ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ShowCaseWidget.of(context).startShowCase([
          AppShowcaseKeys.serviceProviderCard,
          AppShowcaseKeys.serviceReviewsBtn,
        ]);
      }
    });
  }

  @override
  void dispose() {
    _selectedDayNotifier.dispose();
    _selectedTimeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ShowCaseWidget(
        showcaseId: 'service_details_v1',
        enableAutoScroll: true,
        disableBarrierInteraction: true,
        onShouldStartShowcase: (id) async =>
            !StorageService.instance.hasSeenShowcase(id!),
        onFinish: () {
          unawaited(
            StorageService.instance
                .setHasSeenShowcase('service_details_v1', value: true),
          );
        },
        builder: Builder(
          builder: (context) => BlocListener<ServiceDetailsBloc, ServiceDetailsState>(
            listenWhen: (previous, current) =>
                previous.reviewActionStatus != current.reviewActionStatus,
            listener: (context, state) {
              if (state.reviewActionStatus == ReviewActionStatus.success ||
                  state.reviewActionStatus == ReviewActionStatus.failure) {
                final message = state.reviewActionMessage ==
                        'product_details_review_created'
                    ? context.l10n.product_details_review_created
                    : state.reviewActionMessage == 'product_details_review_updated'
                        ? context.l10n.product_details_review_updated
                        : state.reviewActionMessage;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            },
            child: Scaffold(
              body: CustomScrollView(
                slivers: [
                  AppSliverTopBar(
                    title: context.l10n.service_details_title,
                  ),
                  SliverToBoxAdapter(
                    child: ServiceDetailsGallery(
                      gallery: _resolveGallery(widget.service),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: 16.verticalSpace,
                  ),
                  ServiceDetailsInfo(
                    service: widget.service,
                    onSelectionChanged: (day, time) {
                      _selectedDayNotifier.value = day;
                      _selectedTimeNotifier.value = time;
                    },
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: 100.h),
                  ),
                ],
              ),
              bottomSheet: Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: ValueListenableBuilder<ServiceAvailableTimeEntity?>(
                  valueListenable: _selectedTimeNotifier,
                  builder: (context, selectedTime, child) =>
                      ValueListenableBuilder<ServiceAvailableDayEntity?>(
                    valueListenable: _selectedDayNotifier,
                    builder: (context, selectedDay, child) => BookServiceBottomBar(
                      price: widget.service.price,
                      isEnabled: selectedDay != null && selectedTime != null,
                      onBookPressed: () {
                        unawaited(
                          context.push(
                            AppRoutes.serviceBooking,
                            extra: {
                              'service': widget.service,
                              'selectedDay': selectedDay,
                              'selectedTime': selectedTime,
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  List<String> _resolveGallery(ServiceDetailEntity service) {
    final images = List<String>.from(service.images);
    if (service.image.isNotEmpty && !images.contains(service.image)) {
      images.insert(0, service.image);
    }
    return images.isEmpty ? [service.image] : images;
  }
}
