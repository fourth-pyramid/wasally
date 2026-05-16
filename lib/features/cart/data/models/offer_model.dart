import '../../domain/entities/offer_entity.dart';

class OfferModel {
  final int id;
  final double discountPercentage;

  const OfferModel({
    required this.id,
    required this.discountPercentage,
  });

  factory OfferModel.fromEntity(OfferEntity entity) {
    return OfferModel(
      id: entity.id,
      discountPercentage: entity.discountPercentage,
    );
  }

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    return OfferModel(
      id: json['id'] as int,
      discountPercentage:
          (json['discount_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'discount_percentage': discountPercentage,
    };
  }

  OfferEntity toEntity() {
    return OfferEntity(
      id: id,
      discountPercentage: discountPercentage,
    );
  }
}
