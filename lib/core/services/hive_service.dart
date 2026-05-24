import 'package:hive_flutter/hive_flutter.dart';
import 'package:wassaly/core/imports/imports.dart';

import '../../features/cart/domain/entities/cart_item_entity.dart';
import '../../features/home/domain/entities/product_entity.dart';
import '../../features/orders/data/models/order_model.dart';
import '../../features/service_booking/data/models/booking_model.dart';
import '../../features/sub_category/domain/entities/service_entity.dart';
import 'hive_adapters.dart';

class HiveService {
  static const String cartBox = 'cart_box';
  static const String favoriteProductsBox = 'favorite_products_box';
  static const String favoriteServicesBox = 'favorite_services_box';
  static const String ordersBox = 'orders_box';
  static const String bookingsBox = 'bookings_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(ProductEntityAdapter());
    Hive.registerAdapter(ReviewEntityAdapter());
    Hive.registerAdapter(OfferEntityAdapter());
    Hive.registerAdapter(CartOfferEntityAdapter());
    Hive.registerAdapter(ServiceEntityAdapter());
    Hive.registerAdapter(CartItemEntityAdapter());
    Hive.registerAdapter(OrderModelAdapter());
    Hive.registerAdapter(OrderItemModelAdapter());
    Hive.registerAdapter(BookingModelAdapter());
    Hive.registerAdapter(BookingServiceModelAdapter());
    Hive.registerAdapter(BookingProviderModelAdapter());

    // Open Boxes
    await Future.wait([
      Hive.openBox<CartItemEntity>(cartBox),
      Hive.openBox<ProductEntity>(favoriteProductsBox),
      Hive.openBox<ServiceEntity>(favoriteServicesBox),
      Hive.openBox<OrderModel>(ordersBox),
      Hive.openBox<BookingModel>(bookingsBox),
    ]);

    AppLogger.info('HiveService initialized and boxes opened');
  }
}
