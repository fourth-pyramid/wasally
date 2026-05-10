import '../../domain/entities/offer_entity.dart';

class OfferModel extends OfferEntity {
  const OfferModel({
    required super.id,
    required super.discountPercentage,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as int? ?? 0,
      discountPercentage:
          int.tryParse(json['discount_percentage']?.toString() ?? '') ?? 0,
    );
  }
}
