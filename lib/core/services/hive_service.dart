import 'package:wassaly/core/imports/imports.dart';
import 'package:wassaly/core/services/hive_adapters.dart';
import 'package:wassaly/features/cart/domain/entities/cart_item_entity.dart';
import 'package:wassaly/features/home/domain/entities/product_entity.dart';
import 'package:wassaly/features/notifications/data/models/notification_model.dart';
import 'package:wassaly/features/orders/data/models/order_model.dart';
import 'package:wassaly/features/service_booking/data/models/booking_model.dart';
import 'package:wassaly/features/sub_category/domain/entities/service_entity.dart';

class HiveService {
  static const String cartBox = 'cart_box';
  static const String favoriteProductsBox = 'favorite_products_box';
  static const String favoriteServicesBox = 'favorite_services_box';
  static const String ordersBox = 'orders_box';
  static const String bookingsBox = 'bookings_box';
  static const String notificationsBox = 'notifications_box';
  static const String favoritePendingBox = 'favorite_pending_box';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive
      ..registerAdapter(ProductEntityAdapter())
      ..registerAdapter(ReviewEntityAdapter())
      ..registerAdapter(OfferEntityAdapter())
      ..registerAdapter(CartOfferEntityAdapter())
      ..registerAdapter(ServiceEntityAdapter())
      ..registerAdapter(CartItemEntityAdapter())
      ..registerAdapter(OrderModelAdapter())
      ..registerAdapter(OrderItemModelAdapter())
      ..registerAdapter(BookingModelAdapter())
      ..registerAdapter(BookingServiceModelAdapter())
      ..registerAdapter(BookingProviderModelAdapter())
      ..registerAdapter(NotificationModelAdapter());

    // Open Boxes
    await Future.wait([
      Hive.openBox<CartItemEntity>(cartBox),
      Hive.openBox<ProductEntity>(favoriteProductsBox),
      Hive.openBox<ServiceEntity>(favoriteServicesBox),
      Hive.openBox<OrderModel>(ordersBox),
      Hive.openBox<BookingModel>(bookingsBox),
      Hive.openBox<NotificationModel>(notificationsBox),
      Hive.openBox<Map<String, dynamic>>(favoritePendingBox),
    ]);

    AppLogger.info('HiveService initialized and boxes opened');
  }
}
