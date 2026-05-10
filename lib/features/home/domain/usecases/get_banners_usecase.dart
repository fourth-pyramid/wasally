import 'package:wassaly/core/imports/imports.dart';
import '../entities/banner_entity.dart';
import '../repositories/home_repository.dart';

class GetBannersUseCase {
  final HomeRepository _repository;

  const GetBannersUseCase(this._repository);

  Future<Either<Failure, List<BannerEntity>>> call() async {
    return await _repository.getBanners();
  }
}
