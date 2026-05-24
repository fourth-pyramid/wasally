import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';
import 'package:wassaly/features/home/presentation/bloc/home_bloc.dart';
import 'package:wassaly/features/home/presentation/bloc/home_event.dart';
import 'package:wassaly/features/home/presentation/bloc/home_state.dart';
import 'package:wassaly/features/home/presentation/widgets/service_item.dart';

class PopularServicesSection extends StatefulWidget {
  const PopularServicesSection({super.key});

  static const _dummyServices = [
    SubCategoryEntity(id: 0, name: 'خدمة', image: ''),
    SubCategoryEntity(id: 0, name: 'خدمة', image: ''),
    SubCategoryEntity(id: 0, name: 'خدمة', image: ''),
    SubCategoryEntity(id: 0, name: 'خدمة', image: ''),
    SubCategoryEntity(id: 0, name: 'خدمة', image: ''),
  ];

  @override
  State<PopularServicesSection> createState() => _PopularServicesSectionState();
}

class _PopularServicesSectionState extends State<PopularServicesSection> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeBloc>().add(LoadMorePopularServicesEvent());
    }
  }

  void _onServiceTap(BuildContext context, SubCategoryEntity service) =>
      context.push(AppRoutes.subCategory, extra: {'subCategory': service});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocSelector<HomeBloc, HomeState,
        (HomeStatus, PaginatedResponse<SubCategoryEntity>, bool)>(
      selector: (state) => (
        state.popularServicesStatus,
        state.popularServices,
        state.isPopularServicesLoadingMore
      ),
      builder: (context, data) {
        final (
          popularServicesStatus,
          popularServicesPaginated,
          isPopularServicesLoadingMore
        ) = data;

        final popularServices = popularServicesPaginated.data;

        if (popularServicesStatus == HomeStatus.loading ||
            popularServicesStatus == HomeStatus.initial) {
          return SliverToBoxAdapter(
            child: Skeletonizer(
              enabled: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text(
                      context.l10n.home_popular_services,
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  SizedBox(
                    height: 100.h,
                    child: CustomScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          sliver: SliverList.builder(
                            itemCount: PopularServicesSection._dummyServices.length,
                            itemBuilder: (context, index) {
                              return ServiceItem(
                                name: PopularServicesSection._dummyServices[index].name,
                                imageUrl: PopularServicesSection._dummyServices[index].image,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (popularServicesStatus == HomeStatus.failure) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        } else if (popularServices.isEmpty &&
            popularServicesStatus == HomeStatus.success) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  context.l10n.home_popular_services,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
              12.verticalSpace,
              SizedBox(
                height: 100.h,
                child: CustomScrollView(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      sliver: SliverList.builder(
                        itemCount: popularServices.length +
                            (isPopularServicesLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= popularServices.length) {
                            return Container(
                              width: 80.w,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator.adaptive(),
                            );
                          }

                          final service = popularServices[index];
                          return ServiceItem(
                            name: service.name,
                            imageUrl: service.image,
                            onTap: () => _onServiceTap(context, service),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(milliseconds: 400),
              ),
        );
      },
    );
  }
}
