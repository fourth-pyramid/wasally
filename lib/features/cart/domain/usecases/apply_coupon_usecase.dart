import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/core/utils/failure.dart';
import 'package:wassaly/features/cart/domain/entities/coupon_entity.dart';
import 'package:wassaly/features/cart/domain/repositories/cart_repository.dart';

class ApplyCouponUseCase {
  final CartRepository repository;

  ApplyCouponUseCase(this.repository);

  Future<Either<Failure, CouponEntity>> call(String code) =>
      repository.applyCoupon(code);
}
