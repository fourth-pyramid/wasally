import 'package:wassaly/core/imports/imports.dart';
import '../entities/sub_category_entity.dart';
import '../repositories/home_repository.dart';

class GetPopularServicesUseCase {
  final HomeRepository repository;

  GetPopularServicesUseCase(this.repository);

  Future<Either<Failure, List<SubCategoryEntity>>> call() async {
    return await repository.getPopularServices();
  }
}
