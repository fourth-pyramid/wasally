import 'package:wassaly/core/imports/imports.dart';

import '../../domain/entities/sub_category_entity.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'service_item.dart';

class PopularServicesSection extends StatelessWidget {
  const PopularServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.theme.colorScheme;
    final tt = context.theme.textTheme;

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.popularServicesStatus != current.popularServicesStatus ||
          previous.popularServices != current.popularServices,
      builder: (context, state) {
        if (state.popularServicesStatus == HomeStatus.loading ||
            state.popularServicesStatus == HomeStatus.initial) {
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
                      'home.popular_services'.tr(),
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                  ),
                  12.verticalSpace,
                  SizedBox(
                    height: 100.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
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
          );
        } else if (state.popularServicesStatus == HomeStatus.failure) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        } else if (state.popularServices.isEmpty &&
            state.popularServicesStatus == HomeStatus.success) {
          return const SliverToBoxAdapter(
            child: SizedBox.shrink(),
          );
        }

        final services = state.popularServices;

        return SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  'home.popular_services'.tr(),
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.primary,
                  ),
                ),
              ),
              12.verticalSpace,
              SizedBox(
                height: 100.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return ServiceItem(
                      name: service.name,
                      imageUrl: service.image,
                      onTap: () => context.push(
                        AppRoutes.subCategory,
                        extra: {'subCategory': service},
                      ),
                    );
                  },
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
