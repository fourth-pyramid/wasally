import 'package:wassaly/core/imports/packages_imports.dart';
import 'package:wassaly/features/cart/domain/entities/cart_item_entity.dart';
import 'package:wassaly/features/cart/domain/entities/offer_entity.dart'
    as cart_offer;
import 'package:wassaly/features/home/domain/entities/offer_entity.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/home/domain/entities/review_entity.dart';
import 'package:wassaly/features/notifications/data/models/notification_model.dart';
import 'package:wassaly/features/orders/data/models/order_item_model.dart';
import 'package:wassaly/features/orders/data/models/order_model.dart';
import 'package:wassaly/features/orders/domain/entities/order_item_entity.dart';
import 'package:wassaly/features/service_booking/data/models/booking_model.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

class ProductEntityAdapter extends TypeAdapter<ProductEntity> {
  @override
  final int typeId = 1;

  @override
  ProductEntity read(BinaryReader reader) => ProductEntity(
        id: reader.read() as int,
        name: reader.read() as String,
        image: reader.read() as String,
        price: reader.read() as String,
        description: reader.read() as String,
        offers: (reader.read() as List?)?.cast<OfferEntity>() ?? [],
        reviews: (reader.read() as List?)?.cast<ReviewEntity>() ?? [],
        isFavorite: reader.read() as bool,
      );

  @override
  void write(BinaryWriter writer, ProductEntity obj) {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.image)
      ..write(obj.price)
      ..write(obj.description)
      ..write(obj.offers)
      ..write(obj.reviews)
      ..write(obj.isFavorite);
  }
}

class ReviewEntityAdapter extends TypeAdapter<ReviewEntity> {
  @override
  final int typeId = 2;

  @override
  ReviewEntity read(BinaryReader reader) => ReviewEntity(
        id: reader.read() as int,
        rating: reader.read() as int,
        comment: reader.read() as String,
        createdAt: reader.read() as String,
      );

  @override
  void write(BinaryWriter writer, ReviewEntity obj) {
    writer
      ..write(obj.id)
      ..write(obj.rating)
      ..write(obj.comment)
      ..write(obj.createdAt);
  }
}

class OfferEntityAdapter extends TypeAdapter<OfferEntity> {
  @override
  final int typeId = 3;

  @override
  OfferEntity read(BinaryReader reader) => OfferEntity(
        id: reader.read() as int,
        discountPercentage: reader.read() as int,
      );

  @override
  void write(BinaryWriter writer, OfferEntity obj) {
    writer
      ..write(obj.id)
      ..write(obj.discountPercentage);
  }
}

class CartOfferEntityAdapter extends TypeAdapter<cart_offer.OfferEntity> {
  @override
  final int typeId = 11;

  @override
  cart_offer.OfferEntity read(BinaryReader reader) => cart_offer.OfferEntity(
        id: reader.read() as int,
        discountPercentage: reader.read() as double,
      );

  @override
  void write(BinaryWriter writer, cart_offer.OfferEntity obj) {
    writer
      ..write(obj.id)
      ..write(obj.discountPercentage);
  }
}

class CartItemEntityAdapter extends TypeAdapter<CartItemEntity> {
  @override
  final int typeId = 4;

  @override
  CartItemEntity read(BinaryReader reader) => CartItemEntity(
        id: reader.read() as int,
        productId: reader.read() as int,
        productName: reader.read() as String,
        productImage: reader.read() as String,
        price: reader.read() as String,
        productDescription: reader.read() as String?,
        offers: (reader.read() as List?)?.cast<cart_offer.OfferEntity>(),
        quantity: reader.read() as int,
        unitPrice: reader.read() as double,
        totalPrice: reader.read() as double,
      );

  @override
  void write(BinaryWriter writer, CartItemEntity obj) {
    writer
      ..write(obj.id)
      ..write(obj.productId)
      ..write(obj.productName)
      ..write(obj.productImage)
      ..write(obj.price)
      ..write(obj.productDescription)
      ..write(obj.offers)
      ..write(obj.quantity)
      ..write(obj.unitPrice)
      ..write(obj.totalPrice);
  }
}

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 5;

  @override
  OrderModel read(BinaryReader reader) => OrderModel(
        id: reader.read() as int,
        orderNumber: reader.read() as String,
        status: reader.read() as String,
        totalPrice: reader.read() as double,
        paymentMethod: reader.read() as String,
        deliveryFees: reader.read() as double,
        items: (reader.read() as List?)?.cast<OrderItemEntity>() ?? [],
        createdAt: reader.read() as String,
        subTotal: reader.read() as double?,
        discountAmount: reader.read() as double?,
        customerName: reader.read() as String?,
        customerPhone: reader.read() as String?,
        deliveryAddress: reader.read() as String?,
        governorateName: reader.read() as String?,
        governorateId: reader.read() as String?,
        centerId: reader.read() as String?,
        centerName: reader.read() as String?,
      );

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..write(obj.id)
      ..write(obj.orderNumber)
      ..write(obj.status)
      ..write(obj.totalPrice)
      ..write(obj.paymentMethod)
      ..write(obj.deliveryFees)
      ..write(obj.items)
      ..write(obj.createdAt)
      ..write(obj.subTotal)
      ..write(obj.discountAmount)
      ..write(obj.customerName)
      ..write(obj.customerPhone)
      ..write(obj.deliveryAddress)
      ..write(obj.governorateName)
      ..write(obj.governorateId)
      ..write(obj.centerId)
      ..write(obj.centerName);
  }
}

class OrderItemModelAdapter extends TypeAdapter<OrderItemModel> {
  @override
  final int typeId = 6;

  @override
  OrderItemModel read(BinaryReader reader) => OrderItemModel(
        id: reader.read() as int,
        price: reader.read() as double,
        quantity: reader.read() as int,
        totalPrice: reader.read() as double,
        product: reader.read() as ProductEntity?,
      );

  @override
  void write(BinaryWriter writer, OrderItemModel obj) {
    writer
      ..write(obj.id)
      ..write(obj.price)
      ..write(obj.quantity)
      ..write(obj.totalPrice)
      ..write(obj.product);
  }
}

class BookingModelAdapter extends TypeAdapter<BookingModel> {
  @override
  final int typeId = 7;

  @override
  BookingModel read(BinaryReader reader) => BookingModel(
        id: reader.read() as int,
        status: reader.read() as String,
        problemDescription: reader.read() as String,
        service: reader.read() as BookingServiceModel,
        provider: reader.read() as BookingProviderModel,
        dayAr: reader.read() as String,
        dayEn: reader.read() as String,
        time: reader.read() as String,
        createdAt: reader.read() as String,
        customerName: reader.read() as String,
        customerPhone: reader.read() as String,
        customerEmail: reader.read() as String?,
        governorate: reader.read() as String?,
        center: reader.read() as String?,
      );

  @override
  void write(BinaryWriter writer, BookingModel obj) {
    writer
      ..write(obj.id)
      ..write(obj.status)
      ..write(obj.problemDescription)
      ..write(obj.service)
      ..write(obj.provider)
      ..write(obj.dayAr)
      ..write(obj.dayEn)
      ..write(obj.time)
      ..write(obj.createdAt)
      ..write(obj.customerName)
      ..write(obj.customerPhone)
      ..write(obj.customerEmail)
      ..write(obj.governorate)
      ..write(obj.center);
  }
}

class BookingServiceModelAdapter extends TypeAdapter<BookingServiceModel> {
  @override
  final int typeId = 8;

  @override
  BookingServiceModel read(BinaryReader reader) => BookingServiceModel(
        id: reader.read() as int,
        name: reader.read() as String,
        image: reader.read() as String?,
        description: reader.read() as String?,
        price: reader.read() as num,
      );

  @override
  void write(BinaryWriter writer, BookingServiceModel obj) {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.image)
      ..write(obj.description)
      ..write(obj.price);
  }
}

class BookingProviderModelAdapter extends TypeAdapter<BookingProviderModel> {
  @override
  final int typeId = 9;

  @override
  BookingProviderModel read(BinaryReader reader) => BookingProviderModel(
        id: reader.read() as int,
        name: reader.read() as String,
        avatar: reader.read() as String?,
        description: reader.read() as String?,
        rating: reader.read() as double?,
        reviewsCount: reader.read() as int?,
      );

  @override
  void write(BinaryWriter writer, BookingProviderModel obj) {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.avatar)
      ..write(obj.description)
      ..write(obj.rating)
      ..write(obj.reviewsCount);
  }
}

class ServiceEntityAdapter extends TypeAdapter<ServiceEntity> {
  @override
  final int typeId = 10;

  @override
  ServiceEntity read(BinaryReader reader) => ServiceEntity(
        id: reader.read() as int,
        title: reader.read() as String,
        description: reader.read() as String,
        image: reader.read() as String?,
        price: reader.read() as num,
        isFavorite: reader.read() as bool,
      );

  @override
  void write(BinaryWriter writer, ServiceEntity obj) {
    writer
      ..write(obj.id)
      ..write(obj.title)
      ..write(obj.description)
      ..write(obj.image)
      ..write(obj.price)
      ..write(obj.isFavorite);
  }
}

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 12;

  @override
  NotificationModel read(BinaryReader reader) => NotificationModel(
        id: reader.read() as int,
        title: reader.read() as String,
        body: reader.read() as String,
        type: reader.read() as String,
        data: (reader.read() as Map?)?.cast<String, dynamic>() ?? {},
        isRead: reader.read() as bool,
        createdAt: reader.read() as DateTime,
      );

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..write(obj.id)
      ..write(obj.title)
      ..write(obj.body)
      ..write(obj.type)
      ..write(obj.data)
      ..write(obj.isRead)
      ..write(obj.createdAt);
  }
}
