import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/profile/domain/entities/governorate_entity.dart';
import 'package:wassaly/features/profile/domain/usecases/get_governorates_usecase.dart'
    as profile;

class GetCartGovernoratesUseCase {
  final profile.GetGovernoratesUseCase _getGovernoratesUseCase;

  GetCartGovernoratesUseCase(this._getGovernoratesUseCase);

  Future<Either<Failure, List<GovernorateEntity>>> call() async =>
      _getGovernoratesUseCase();
}
