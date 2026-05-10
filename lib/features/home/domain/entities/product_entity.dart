import '../../../../core/imports/imports.dart';
import 'offer_entity.dart';
import 'review_entity.dart';

class ProductEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final String price;
  final String description;
  final List<OfferEntity> offers;
  final List<ReviewEntity> reviews;
  final bool isFavorite;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.offers,
    required this.reviews,
    required this.isFavorite,
  });

  /// Returns the first offer's discount percentage, or 0 if no offers.
  int get discountPercentage =>
      offers.isNotEmpty ? offers.first.discountPercentage : 0;

  /// Whether this product has an active offer.
  bool get hasOffer => offers.isNotEmpty;

  /// Calculates the discounted price based on the first offer.
  double get discountedPrice {
    final originalPrice = double.tryParse(price) ?? 0;
    if (!hasOffer) return originalPrice;
    return originalPrice - (originalPrice * discountPercentage / 100);
  }

  /// Average rating from all reviews.
  double get averageRating {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold<int>(0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  /// Total number of reviews.
  int get reviewCount => reviews.length;

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        price,
        description,
        offers,
        reviews,
        isFavorite,
      ];
}
