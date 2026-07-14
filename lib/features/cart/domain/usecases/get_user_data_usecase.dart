import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/auth/domain/entities/user_entity.dart';
import 'package:wassaly/features/auth/domain/usecases/get_cached_user_usecase.dart';

class GetUserDataUseCase {
  final GetCachedUserUseCase _getCachedUserUseCase;

  GetUserDataUseCase(this._getCachedUserUseCase);

  Future<Either<Failure, UserEntity?>> call() async => _getCachedUserUseCase();
}
