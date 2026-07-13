import 'package:flutter/material.dart';

// ponytail: Static key registry to avoid tight coupling between shell layout and screens.
class AppShowcaseKeys {
  AppShowcaseKeys._();

  // Home Page Tour Keys
  static final GlobalKey homeSearch = GlobalKey();
  static final GlobalKey homeFilter = GlobalKey();
  static final GlobalKey homeCategories = GlobalKey();
  static final GlobalKey homeNavBar = GlobalKey();

  // Product Details Tour Keys
  static final GlobalKey productAddToCart = GlobalKey();

  // Cart Page Tour Keys
  static final GlobalKey cartItemSwipe = GlobalKey();
  static final GlobalKey cartOrderSummary = GlobalKey();

  // Favorite Page Tour Keys
  static final GlobalKey favoriteTabs = GlobalKey();

  // Profile Page Tour Keys
  static final GlobalKey profileStats = GlobalKey();
  static final GlobalKey profileSettings = GlobalKey();
  static final GlobalKey profileSupport = GlobalKey();

  // Search Page Tour Keys
  static final GlobalKey searchField = GlobalKey();

  // Products Filter Tour Keys
  static final GlobalKey filterFab = GlobalKey();

  // Checkout Tour Keys
  static final GlobalKey checkoutForm = GlobalKey();
  static final GlobalKey checkoutSummary = GlobalKey();

  // Orders Tour Keys
  static final GlobalKey ordersTabs = GlobalKey();

  // All Categories Tour Keys
  static final GlobalKey allCategoriesGrid = GlobalKey();

  // Category Tour Keys
  static final GlobalKey categorySubCategories = GlobalKey();

  // Sub-Category Tour Keys
  static final GlobalKey subCategoryProducts = GlobalKey();

  // Brands Tour Keys
  static final GlobalKey brandsGrid = GlobalKey();

  // Brand Details Tour Keys
  static final GlobalKey brandProducts = GlobalKey();

  // Service Details Tour Keys
  static final GlobalKey serviceProviderCard = GlobalKey();
  static final GlobalKey serviceReviewsBtn = GlobalKey();

  // Service Booking Tour Keys
  static final GlobalKey serviceBookingAddress = GlobalKey();
  static final GlobalKey serviceBookingConfirm = GlobalKey();

  // Provider Details Tour Keys
  static final GlobalKey providerServicesList = GlobalKey();
  static final GlobalKey providerContactInfo = GlobalKey();

  // Addresses Tour Keys
  static final GlobalKey addressesList = GlobalKey();
  static final GlobalKey addAddressButton = GlobalKey();

  // Add Address Tour Keys
  static final GlobalKey addAddressForm = GlobalKey();

  // Edit Profile Tour Keys
  static final GlobalKey editProfileForm = GlobalKey();

  // Help Center Tour Keys
  static final GlobalKey helpCenterFaq = GlobalKey();
  static final GlobalKey helpCenterContact = GlobalKey();

  // Order Details Tour Keys
  static final GlobalKey orderDetailsStatus = GlobalKey();
  static final GlobalKey orderDetailsItems = GlobalKey();

  // Booking Details Tour Keys
  static final GlobalKey bookingDetailsStatus = GlobalKey();
  static final GlobalKey bookingDetailsProvider = GlobalKey();

  // Offers Tour Keys
  static final GlobalKey offersPromotions = GlobalKey();

  // Notifications Tour Keys
  static final GlobalKey notificationsList = GlobalKey();
}
