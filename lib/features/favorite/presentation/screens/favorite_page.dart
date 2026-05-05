import 'package:wassaly/core/imports/imports.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'favorite.favorite_title'.tr(),
          style: context.typography.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_outline,
              size: 80.r,
              color: context.theme.colorScheme.primary,
            ),
            20.verticalSpace,
            Text(
              'favorite.favorite_title'.tr(),
              style: context.typography.headlineMedium,
            ),
            10.verticalSpace,
            Text(
              'favorite.favorite_subtitle'.tr(),
              style: context.typography.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
