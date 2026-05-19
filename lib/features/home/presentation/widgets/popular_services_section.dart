import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/features/home/domain/entities/sub_category_entity.dart';
import 'package:wassaly/features/home/presentation/bloc/home_bloc.dart';
import 'package:wassaly/features/home/presentation/bloc/home_state.dart';
import 'package:wassaly/features/home/presentation/widgets/service_item.dart';

class PopularServicesSection extends StatelessWidget {
  const PopularServicesSection({super.key});

  // FIX 10: named method — no new lambdas per item per BlocSelector rebuild
  void _onServiceTap(BuildContext context, SubCategoryEntity service) =>
      context.push(AppRoutes.subCategory, extra: {'subCategory': service});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocSelector<HomeBloc, HomeState,
        (HomeStatus, List<SubCategoryEntity>)>(
      selector: (state) => (state.popularServicesStatus, state.popularServices),
      builder: (context, data) {
        final (popularServicesStatus, popularServices) = data;

        if (popularServicesStatus == HomeStatus.loading ||
            popularServicesStatus == HomeStatus.initial) {
          final dummyServices = List.generate(
            5,
            (index) => const SubCategoryEntity(
              id: 0,
              name: 'خدمة',
              image: '',
            ),
          );

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
                            itemCount: dummyServices.length,
                            itemBuilder: (context, index) {
                              return ServiceItem(
                                name: dummyServices[index].name,
                                imageUrl: dummyServices[index].image,
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
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      sliver: SliverList.builder(
                        itemCount: popularServices.length,
                        itemBuilder: (context, index) {
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
