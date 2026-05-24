import 'package:hive_flutter/hive_flutter.dart';
import '../../features/home/domain/entities/product_entity.dart';
import '../../features/home/domain/entities/review_entity.dart';
import '../../features/home/domain/entities/offer_entity.dart';
import '../../features/sub_category/domain/entities/service_entity.dart';
import '../../features/cart/domain/entities/cart_item_entity.dart';
import '../../features/cart/domain/entities/offer_entity.dart' as cart_offer;
import '../../features/orders/data/models/order_model.dart';
import '../../features/orders/data/models/order_item_model.dart';
import '../../features/service_booking/data/models/booking_model.dart';
import '../../features/orders/domain/entities/order_item_entity.dart';

class ProductEntityAdapter extends TypeAdapter<ProductEntity> {
  @override
  final int typeId = 1;

  @override
  ProductEntity read(BinaryReader reader) {
    return ProductEntity(
      id: reader.read(),
      name: reader.read(),
      image: reader.read(),
      price: reader.read(),
      description: reader.read(),
      offers: (reader.read() as List?)?.cast<OfferEntity>() ?? [],
      reviews: (reader.read() as List?)?.cast<ReviewEntity>() ?? [],
      isFavorite: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductEntity obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.image);
    writer.write(obj.price);
    writer.write(obj.description);
    writer.write(obj.offers);
    writer.write(obj.reviews);
    writer.write(obj.isFavorite);
  }
}

class ReviewEntityAdapter extends TypeAdapter<ReviewEntity> {
  @override
  final int typeId = 2;

  @override
  ReviewEntity read(BinaryReader reader) {
    return ReviewEntity(
      id: reader.read(),
      rating: reader.read(),
      comment: reader.read(),
      createdAt: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ReviewEntity obj) {
    writer.write(obj.id);
    writer.write(obj.rating);
    writer.write(obj.comment);
    writer.write(obj.createdAt);
  }
}

class OfferEntityAdapter extends TypeAdapter<OfferEntity> {
  @override
  final int typeId = 3;

  @override
  OfferEntity read(BinaryReader reader) {
    return OfferEntity(
      id: reader.read(),
      discountPercentage: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, OfferEntity obj) {
    writer.write(obj.id);
    writer.write(obj.discountPercentage);
  }
}

class CartOfferEntityAdapter extends TypeAdapter<cart_offer.OfferEntity> {
  @override
  final int typeId = 11;

  @override
  cart_offer.OfferEntity read(BinaryReader reader) {
    return cart_offer.OfferEntity(
      id: reader.read(),
      discountPercentage: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, cart_offer.OfferEntity obj) {
    writer.write(obj.id);
    writer.write(obj.discountPercentage);
  }
}

class CartItemEntityAdapter extends TypeAdapter<CartItemEntity> {
  @override
  final int typeId = 4;

  @override
  CartItemEntity read(BinaryReader reader) {
    return CartItemEntity(
      id: reader.read(),
      productId: reader.read(),
      productName: reader.read(),
      productImage: reader.read(),
      price: reader.read(),
      productDescription: reader.read(),
      offers: (reader.read() as List?)?.cast<cart_offer.OfferEntity>(),
      quantity: reader.read(),
      unitPrice: reader.read(),
      totalPrice: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, CartItemEntity obj) {
    writer.write(obj.id);
    writer.write(obj.productId);
    writer.write(obj.productName);
    writer.write(obj.productImage);
    writer.write(obj.price);
    writer.write(obj.productDescription);
    writer.write(obj.offers);
    writer.write(obj.quantity);
    writer.write(obj.unitPrice);
    writer.write(obj.totalPrice);
  }
}

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 5;

  @override
  OrderModel read(BinaryReader reader) {
    return OrderModel(
      id: reader.read(),
      orderNumber: reader.read(),
      status: reader.read(),
      totalPrice: reader.read(),
      paymentMethod: reader.read(),
      deliveryFees: reader.read(),
      items: (reader.read() as List?)?.cast<OrderItemEntity>() ?? [],
      createdAt: reader.read(),
      subTotal: reader.read(),
      discountAmount: reader.read(),
      customerName: reader.read(),
      customerPhone: reader.read(),
      deliveryAddress: reader.read(),
      governorateId: reader.read(),
      governorateName: reader.read(),
      centerId: reader.read(),
      centerName: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer.write(obj.id);
    writer.write(obj.orderNumber);
    writer.write(obj.status);
    writer.write(obj.totalPrice);
    writer.write(obj.paymentMethod);
    writer.write(obj.deliveryFees);
    writer.write(obj.items);
    writer.write(obj.createdAt);
    writer.write(obj.subTotal);
    writer.write(obj.discountAmount);
    writer.write(obj.customerName);
    writer.write(obj.customerPhone);
    writer.write(obj.deliveryAddress);
    writer.write(obj.governorateId);
    writer.write(obj.governorateName);
    writer.write(obj.centerId);
    writer.write(obj.centerName);
  }
}

class OrderItemModelAdapter extends TypeAdapter<OrderItemModel> {
  @override
  final int typeId = 6;

  @override
  OrderItemModel read(BinaryReader reader) {
    return OrderItemModel(
      id: reader.read(),
      price: reader.read(),
      quantity: reader.read(),
      totalPrice: reader.read(),
      product: reader.read() as ProductEntity?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItemModel obj) {
    writer.write(obj.id);
    writer.write(obj.price);
    writer.write(obj.quantity);
    writer.write(obj.totalPrice);
    writer.write(obj.product);
  }
}

class BookingModelAdapter extends TypeAdapter<BookingModel> {
  @override
  final int typeId = 7;

  @override
  BookingModel read(BinaryReader reader) {
    return BookingModel(
      id: reader.read(),
      status: reader.read(),
      problemDescription: reader.read(),
      service: reader.read() as BookingServiceModel,
      provider: reader.read() as BookingProviderModel,
      dayAr: reader.read(),
      dayEn: reader.read(),
      time: reader.read(),
      createdAt: reader.read(),
      customerName: reader.read(),
      customerPhone: reader.read(),
      customerEmail: reader.read(),
      governorate: reader.read(),
      center: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, BookingModel obj) {
    writer.write(obj.id);
    writer.write(obj.status);
    writer.write(obj.problemDescription);
    writer.write(obj.service);
    writer.write(obj.provider);
    writer.write(obj.dayAr);
    writer.write(obj.dayEn);
    writer.write(obj.time);
    writer.write(obj.createdAt);
    writer.write(obj.customerName);
    writer.write(obj.customerPhone);
    writer.write(obj.customerEmail);
    writer.write(obj.governorate);
    writer.write(obj.center);
  }
}

class BookingServiceModelAdapter extends TypeAdapter<BookingServiceModel> {
  @override
  final int typeId = 8;

  @override
  BookingServiceModel read(BinaryReader reader) {
    return BookingServiceModel(
      id: reader.read(),
      name: reader.read(),
      image: reader.read(),
      description: reader.read(),
      price: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, BookingServiceModel obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.image);
    writer.write(obj.description);
    writer.write(obj.price);
  }
}

class BookingProviderModelAdapter extends TypeAdapter<BookingProviderModel> {
  @override
  final int typeId = 9;

  @override
  BookingProviderModel read(BinaryReader reader) {
    return BookingProviderModel(
      id: reader.read(),
      name: reader.read(),
      avatar: reader.read(),
      description: reader.read(),
      rating: reader.read(),
      reviewsCount: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, BookingProviderModel obj) {
    writer.write(obj.id);
    writer.write(obj.name);
    writer.write(obj.avatar);
    writer.write(obj.description);
    writer.write(obj.rating);
    writer.write(obj.reviewsCount);
  }
}

class ServiceEntityAdapter extends TypeAdapter<ServiceEntity> {
  @override
  final int typeId = 10;

  @override
  ServiceEntity read(BinaryReader reader) {
    return ServiceEntity(
      id: reader.read(),
      title: reader.read(),
      description: reader.read(),
      image: reader.read(),
      price: reader.read(),
      isFavorite: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ServiceEntity obj) {
    writer.write(obj.id);
    writer.write(obj.title);
    writer.write(obj.description);
    writer.write(obj.image);
    writer.write(obj.price);
    writer.write(obj.isFavorite);
  }
}
