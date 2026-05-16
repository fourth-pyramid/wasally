import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Wassaly'**
  String get app_title;

  /// No description provided for @shared_get_started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get shared_get_started;

  /// No description provided for @shared_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get shared_cancel;

  /// No description provided for @shared_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get shared_delete;

  /// No description provided for @shared_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get shared_edit;

  /// No description provided for @shared_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get shared_done;

  /// No description provided for @shared_optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get shared_optional;

  /// No description provided for @shared_currency_egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get shared_currency_egp;

  /// No description provided for @shared_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get shared_retry;

  /// No description provided for @shared_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get shared_save;

  /// No description provided for @shared_show_more.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get shared_show_more;

  /// No description provided for @shared_show_less.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get shared_show_less;

  /// No description provided for @common_currency.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get common_currency;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @errors_something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errors_something_went_wrong;

  /// No description provided for @errors_no_internet_title.
  ///
  /// In en, this message translates to:
  /// **'no_internet'**
  String get errors_no_internet_title;

  /// No description provided for @errors_no_internet_message.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your connection and try again.'**
  String get errors_no_internet_message;

  /// No description provided for @errors_not_found_title.
  ///
  /// In en, this message translates to:
  /// **'not_found'**
  String get errors_not_found_title;

  /// No description provided for @errors_not_found_message.
  ///
  /// In en, this message translates to:
  /// **'The service is currently unavailable, please try again later.'**
  String get errors_not_found_message;

  /// No description provided for @errors_server_error_title.
  ///
  /// In en, this message translates to:
  /// **'server_error'**
  String get errors_server_error_title;

  /// No description provided for @errors_server_error_message.
  ///
  /// In en, this message translates to:
  /// **'A server error occurred. Please try again later.'**
  String get errors_server_error_message;

  /// No description provided for @errors_cache_error_title.
  ///
  /// In en, this message translates to:
  /// **'cache_error'**
  String get errors_cache_error_title;

  /// No description provided for @errors_cache_error_message.
  ///
  /// In en, this message translates to:
  /// **'A cache error occurred. Please try again.'**
  String get errors_cache_error_message;

  /// No description provided for @errors_error_occurred_title.
  ///
  /// In en, this message translates to:
  /// **'error_occurred'**
  String get errors_error_occurred_title;

  /// No description provided for @errors_error_occurred_message.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errors_error_occurred_message;

  /// No description provided for @errors_error_title.
  ///
  /// In en, this message translates to:
  /// **'error_occurred'**
  String get errors_error_title;

  /// No description provided for @errors_unknown_error.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get errors_unknown_error;

  /// No description provided for @errors_try_again.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get errors_try_again;

  /// No description provided for @errors_no_internet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get errors_no_internet;

  /// No description provided for @errors_invalid_category.
  ///
  /// In en, this message translates to:
  /// **'Invalid category'**
  String get errors_invalid_category;

  /// No description provided for @errors_invalid_sub_category.
  ///
  /// In en, this message translates to:
  /// **'Invalid sub-category'**
  String get errors_invalid_sub_category;

  /// No description provided for @home_home_title.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home_home_title;

  /// No description provided for @home_welcome_home.
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get home_welcome_home;

  /// No description provided for @home_home_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Wasally App'**
  String get home_home_subtitle;

  /// No description provided for @home_popular_services.
  ///
  /// In en, this message translates to:
  /// **'Popular Services'**
  String get home_popular_services;

  /// No description provided for @home_selected_products.
  ///
  /// In en, this message translates to:
  /// **'Selected Products'**
  String get home_selected_products;

  /// No description provided for @home_main_categories.
  ///
  /// In en, this message translates to:
  /// **'Main Categories'**
  String get home_main_categories;

  /// No description provided for @home_services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get home_services;

  /// No description provided for @home_browse_now.
  ///
  /// In en, this message translates to:
  /// **'Browse Now'**
  String get home_browse_now;

  /// No description provided for @home_no_services_products.
  ///
  /// In en, this message translates to:
  /// **'No services or products'**
  String get home_no_services_products;

  /// No description provided for @home_no_sub_categories.
  ///
  /// In en, this message translates to:
  /// **'No sub-categories'**
  String get home_no_sub_categories;

  /// No description provided for @nav_nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_nav_home;

  /// No description provided for @nav_nav_category.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get nav_nav_category;

  /// No description provided for @nav_nav_cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get nav_nav_cart;

  /// No description provided for @nav_nav_favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get nav_nav_favorite;

  /// No description provided for @nav_nav_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get nav_nav_profile;

  /// No description provided for @search_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search for products and services'**
  String get search_search_hint;

  /// No description provided for @search_no_results_found.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get search_no_results_found;

  /// No description provided for @search_try_different_search.
  ///
  /// In en, this message translates to:
  /// **'Try searching with different keywords'**
  String get search_try_different_search;

  /// No description provided for @category_category_title.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get category_category_title;

  /// No description provided for @category_category_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Explore our product categories'**
  String get category_category_subtitle;

  /// No description provided for @cart_cart_title.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart_cart_title;

  /// No description provided for @cart_cart_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cart_cart_subtitle;

  /// No description provided for @cart_empty_title.
  ///
  /// In en, this message translates to:
  /// **'Cart is Empty'**
  String get cart_empty_title;

  /// No description provided for @cart_empty_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add some products to your cart'**
  String get cart_empty_subtitle;

  /// No description provided for @cart_continue_shopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get cart_continue_shopping;

  /// No description provided for @cart_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get cart_delete;

  /// No description provided for @cart_remove_item_title.
  ///
  /// In en, this message translates to:
  /// **'Remove Product'**
  String get cart_remove_item_title;

  /// No description provided for @cart_remove_item_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this product from cart?'**
  String get cart_remove_item_message;

  /// No description provided for @cart_error_loading_cart.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cart'**
  String get cart_error_loading_cart;

  /// No description provided for @cart_total_price.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cart_total_price;

  /// No description provided for @cart_subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cart_subtotal;

  /// No description provided for @cart_product_offers.
  ///
  /// In en, this message translates to:
  /// **'Product Offers'**
  String get cart_product_offers;

  /// No description provided for @cart_coupon_discount.
  ///
  /// In en, this message translates to:
  /// **'Coupon Discount'**
  String get cart_coupon_discount;

  /// No description provided for @cart_total_discounts.
  ///
  /// In en, this message translates to:
  /// **'Total Discounts'**
  String get cart_total_discounts;

  /// No description provided for @cart_delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get cart_delivery;

  /// No description provided for @cart_total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get cart_total;

  /// No description provided for @cart_checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get cart_checkout;

  /// No description provided for @cart_items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get cart_items;

  /// No description provided for @cart_user_info.
  ///
  /// In en, this message translates to:
  /// **'Order Information'**
  String get cart_user_info;

  /// No description provided for @cart_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get cart_name;

  /// No description provided for @cart_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get cart_name_hint;

  /// No description provided for @cart_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get cart_phone;

  /// No description provided for @cart_phone_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get cart_phone_hint;

  /// No description provided for @cart_name_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get cart_name_required;

  /// No description provided for @cart_phone_required.
  ///
  /// In en, this message translates to:
  /// **'Phone is required'**
  String get cart_phone_required;

  /// No description provided for @cart_delivery_address.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get cart_delivery_address;

  /// No description provided for @cart_loading_addresses.
  ///
  /// In en, this message translates to:
  /// **'Loading addresses...'**
  String get cart_loading_addresses;

  /// No description provided for @cart_no_addresses.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get cart_no_addresses;

  /// No description provided for @cart_add_new_address.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get cart_add_new_address;

  /// No description provided for @cart_shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get cart_shipping;

  /// No description provided for @cart_save_info.
  ///
  /// In en, this message translates to:
  /// **'Save Information'**
  String get cart_save_info;

  /// No description provided for @cart_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get cart_save;

  /// No description provided for @favorite_favorite_title.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorite_favorite_title;

  /// No description provided for @favorite_favorite_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Your favorite items will appear here'**
  String get favorite_favorite_subtitle;

  /// No description provided for @favorite_no_favorites.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favorite_no_favorites;

  /// No description provided for @favorite_no_favorites_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your favorite products here'**
  String get favorite_no_favorites_subtitle;

  /// No description provided for @favorite_removed_from_favorites.
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get favorite_removed_from_favorites;

  /// No description provided for @favorite_products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get favorite_products;

  /// No description provided for @favorite_services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get favorite_services;

  /// No description provided for @product_details_title.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get product_details_title;

  /// No description provided for @product_details_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get product_details_description;

  /// No description provided for @product_details_reviews.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get product_details_reviews;

  /// No description provided for @product_details_brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get product_details_brand;

  /// No description provided for @product_details_sub_category.
  ///
  /// In en, this message translates to:
  /// **'Sub-category'**
  String get product_details_sub_category;

  /// No description provided for @product_details_offer.
  ///
  /// In en, this message translates to:
  /// **'Offer'**
  String get product_details_offer;

  /// No description provided for @product_details_discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get product_details_discount;

  /// No description provided for @product_details_related_products.
  ///
  /// In en, this message translates to:
  /// **'Similar Products'**
  String get product_details_related_products;

  /// No description provided for @product_details_no_related_products.
  ///
  /// In en, this message translates to:
  /// **'No similar products found'**
  String get product_details_no_related_products;

  /// No description provided for @product_details_show_more.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get product_details_show_more;

  /// No description provided for @product_details_all_reviews.
  ///
  /// In en, this message translates to:
  /// **'All reviews'**
  String get product_details_all_reviews;

  /// No description provided for @product_details_add_review.
  ///
  /// In en, this message translates to:
  /// **'Add review'**
  String get product_details_add_review;

  /// No description provided for @product_details_edit_review.
  ///
  /// In en, this message translates to:
  /// **'Edit review'**
  String get product_details_edit_review;

  /// No description provided for @product_details_review_comment_hint.
  ///
  /// In en, this message translates to:
  /// **'Write your review'**
  String get product_details_review_comment_hint;

  /// No description provided for @product_details_review_comment_required.
  ///
  /// In en, this message translates to:
  /// **'Please write your review'**
  String get product_details_review_comment_required;

  /// No description provided for @product_details_review_created.
  ///
  /// In en, this message translates to:
  /// **'Review added successfully'**
  String get product_details_review_created;

  /// No description provided for @product_details_review_updated.
  ///
  /// In en, this message translates to:
  /// **'Review updated successfully'**
  String get product_details_review_updated;

  /// No description provided for @product_details_review_options.
  ///
  /// In en, this message translates to:
  /// **'Review options'**
  String get product_details_review_options;

  /// No description provided for @product_details_edit_time_expired.
  ///
  /// In en, this message translates to:
  /// **'Edit time expired'**
  String get product_details_edit_time_expired;

  /// No description provided for @profile_my_account.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get profile_my_account;

  /// No description provided for @profile_my_orders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get profile_my_orders;

  /// No description provided for @profile_payment_methods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get profile_payment_methods;

  /// No description provided for @profile_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profile_notifications;

  /// No description provided for @profile_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profile_privacy_policy;

  /// No description provided for @profile_help_center.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get profile_help_center;

  /// No description provided for @profile_personal_info.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get profile_personal_info;

  /// No description provided for @profile_saved_addresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get profile_saved_addresses;

  /// No description provided for @profile_add_new_address.
  ///
  /// In en, this message translates to:
  /// **'Add New Address'**
  String get profile_add_new_address;

  /// No description provided for @profile_orders_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No orders} =1{1 order} =2{2 orders} few{{count} orders} many{{count} orders} other{{count} orders} }'**
  String profile_orders_count(num count);

  /// No description provided for @profile_manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get profile_manage;

  /// No description provided for @profile_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get profile_settings;

  /// No description provided for @profile_security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get profile_security;

  /// No description provided for @profile_language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profile_language;

  /// No description provided for @profile_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profile_theme;

  /// No description provided for @profile_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get profile_dark;

  /// No description provided for @profile_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get profile_light;

  /// No description provided for @profile_arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get profile_arabic;

  /// No description provided for @profile_english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get profile_english;

  /// No description provided for @profile_language_change_title.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get profile_language_change_title;

  /// No description provided for @profile_language_change_message.
  ///
  /// In en, this message translates to:
  /// **'The app will restart completely to apply the language change. Do you want to continue?'**
  String get profile_language_change_message;

  /// No description provided for @profile_language_change_confirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, Change Language'**
  String get profile_language_change_confirm;

  /// No description provided for @profile_language_change_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get profile_language_change_cancel;

  /// No description provided for @profile_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_logout;

  /// No description provided for @profile_logout_all_devices.
  ///
  /// In en, this message translates to:
  /// **'Logout from All Devices'**
  String get profile_logout_all_devices;

  /// No description provided for @profile_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profile_delete_account;

  /// No description provided for @profile_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get profile_edit_profile;

  /// No description provided for @profile_change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get profile_change_password;

  /// No description provided for @profile_current_password.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get profile_current_password;

  /// No description provided for @profile_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get profile_save_changes;

  /// No description provided for @profile_action_success.
  ///
  /// In en, this message translates to:
  /// **'Action completed successfully'**
  String get profile_action_success;

  /// No description provided for @profile_logout_title.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_logout_title;

  /// No description provided for @profile_logout_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get profile_logout_message;

  /// No description provided for @profile_logout_choice_message.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want to logout:'**
  String get profile_logout_choice_message;

  /// No description provided for @profile_logout_this_device.
  ///
  /// In en, this message translates to:
  /// **'Logout from This Device'**
  String get profile_logout_this_device;

  /// No description provided for @profile_logout_all_title.
  ///
  /// In en, this message translates to:
  /// **'Logout from All Devices'**
  String get profile_logout_all_title;

  /// No description provided for @profile_logout_all_message.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out from all devices. Are you sure?'**
  String get profile_logout_all_message;

  /// No description provided for @profile_delete_account_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profile_delete_account_title;

  /// No description provided for @profile_delete_account_message.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone. All your data will be permanently deleted. Are you sure?'**
  String get profile_delete_account_message;

  /// No description provided for @profile_delete_account_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get profile_delete_account_confirm;

  /// No description provided for @profile_delete_address_title.
  ///
  /// In en, this message translates to:
  /// **'Delete Address'**
  String get profile_delete_address_title;

  /// No description provided for @profile_delete_address_message.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete address {address}?'**
  String profile_delete_address_message(Object address);

  /// No description provided for @profile_add_address.
  ///
  /// In en, this message translates to:
  /// **'Add Address'**
  String get profile_add_address;

  /// No description provided for @profile_save_address.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get profile_save_address;

  /// No description provided for @profile_address_added.
  ///
  /// In en, this message translates to:
  /// **'Address added successfully'**
  String get profile_address_added;

  /// No description provided for @profile_address_updated.
  ///
  /// In en, this message translates to:
  /// **'Address updated successfully'**
  String get profile_address_updated;

  /// No description provided for @profile_edit_address.
  ///
  /// In en, this message translates to:
  /// **'Edit Address'**
  String get profile_edit_address;

  /// No description provided for @profile_address_title.
  ///
  /// In en, this message translates to:
  /// **'Address Title'**
  String get profile_address_title;

  /// No description provided for @profile_address_title_hint.
  ///
  /// In en, this message translates to:
  /// **'Home, Work, etc'**
  String get profile_address_title_hint;

  /// No description provided for @profile_address_details.
  ///
  /// In en, this message translates to:
  /// **'Address Details'**
  String get profile_address_details;

  /// No description provided for @profile_address_details_hint.
  ///
  /// In en, this message translates to:
  /// **'Street, Building, Floor'**
  String get profile_address_details_hint;

  /// No description provided for @profile_governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get profile_governorate;

  /// No description provided for @profile_center.
  ///
  /// In en, this message translates to:
  /// **'City/Center'**
  String get profile_center;

  /// No description provided for @profile_select_governorate.
  ///
  /// In en, this message translates to:
  /// **'Please select a governorate'**
  String get profile_select_governorate;

  /// No description provided for @profile_select_center.
  ///
  /// In en, this message translates to:
  /// **'Please select a city'**
  String get profile_select_center;

  /// No description provided for @profile_title_required.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get profile_title_required;

  /// No description provided for @profile_address_required.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get profile_address_required;

  /// No description provided for @profile_current_password_required.
  ///
  /// In en, this message translates to:
  /// **'Current password is required to change password'**
  String get profile_current_password_required;

  /// No description provided for @profile_no_addresses.
  ///
  /// In en, this message translates to:
  /// **'No addresses yet'**
  String get profile_no_addresses;

  /// No description provided for @profile_add_address_hint.
  ///
  /// In en, this message translates to:
  /// **'Add your first address to get started'**
  String get profile_add_address_hint;

  /// No description provided for @profile_addresses_error.
  ///
  /// In en, this message translates to:
  /// **'Failed to load addresses'**
  String get profile_addresses_error;

  /// No description provided for @profile_select_language.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get profile_select_language;

  /// No description provided for @profile_general_settings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get profile_general_settings;

  /// No description provided for @profile_support_and_privacy.
  ///
  /// In en, this message translates to:
  /// **'Support & Privacy'**
  String get profile_support_and_privacy;

  /// No description provided for @profile_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get profile_active;

  /// No description provided for @profile_choose_image_source.
  ///
  /// In en, this message translates to:
  /// **'Choose Image Source'**
  String get profile_choose_image_source;

  /// No description provided for @profile_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get profile_camera;

  /// No description provided for @profile_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get profile_gallery;

  /// No description provided for @profile_update_success.
  ///
  /// In en, this message translates to:
  /// **'Data updated successfully'**
  String get profile_update_success;

  /// No description provided for @auth_log_in.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_log_in;

  /// No description provided for @auth_log_in_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back to Wasally'**
  String get auth_log_in_subtitle;

  /// No description provided for @auth_email_or_phone.
  ///
  /// In en, this message translates to:
  /// **'Email or Phone'**
  String get auth_email_or_phone;

  /// No description provided for @auth_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email;

  /// No description provided for @auth_email_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your details'**
  String get auth_email_placeholder;

  /// No description provided for @auth_email_required.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get auth_email_required;

  /// No description provided for @auth_email_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get auth_email_invalid;

  /// No description provided for @auth_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// No description provided for @auth_password_required.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get auth_password_required;

  /// No description provided for @auth_password_too_short.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get auth_password_too_short;

  /// No description provided for @auth_forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get auth_forgot_password;

  /// No description provided for @auth_remember_me.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get auth_remember_me;

  /// No description provided for @auth_login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login_button;

  /// No description provided for @auth_dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get auth_dont_have_account;

  /// No description provided for @auth_sign_up.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get auth_sign_up;

  /// No description provided for @auth_sign_up_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with google'**
  String get auth_sign_up_google;

  /// No description provided for @auth_sign_up_facebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with facebook'**
  String get auth_sign_up_facebook;

  /// No description provided for @auth_or_login_with.
  ///
  /// In en, this message translates to:
  /// **'Or login with'**
  String get auth_or_login_with;

  /// No description provided for @auth_login_with_google.
  ///
  /// In en, this message translates to:
  /// **'Continue with google'**
  String get auth_login_with_google;

  /// No description provided for @auth_create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_create_account;

  /// No description provided for @auth_create_account_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey with us'**
  String get auth_create_account_subtitle;

  /// No description provided for @auth_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get auth_name;

  /// No description provided for @auth_name_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get auth_name_placeholder;

  /// No description provided for @auth_name_required.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get auth_name_required;

  /// No description provided for @auth_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get auth_confirm_password;

  /// No description provided for @auth_confirm_password_required.
  ///
  /// In en, this message translates to:
  /// **'Confirm password is required'**
  String get auth_confirm_password_required;

  /// No description provided for @auth_passwords_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get auth_passwords_do_not_match;

  /// No description provided for @auth_create_account_button.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get auth_create_account_button;

  /// No description provided for @auth_already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get auth_already_have_account;

  /// No description provided for @auth_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get auth_sign_in;

  /// No description provided for @auth_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get auth_phone;

  /// No description provided for @auth_phone_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get auth_phone_required;

  /// No description provided for @auth_phone_invalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get auth_phone_invalid;

  /// No description provided for @auth_agree_to.
  ///
  /// In en, this message translates to:
  /// **'I agree to'**
  String get auth_agree_to;

  /// No description provided for @auth_terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get auth_terms_of_service;

  /// No description provided for @auth_and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get auth_and;

  /// No description provided for @auth_privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get auth_privacy_policy;

  /// No description provided for @auth_or_continue_with.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get auth_or_continue_with;

  /// No description provided for @auth_forgot_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get auth_forgot_password_title;

  /// No description provided for @auth_forgot_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or phone and we’ll send a reset code'**
  String get auth_forgot_password_subtitle;

  /// No description provided for @auth_send_code.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get auth_send_code;

  /// No description provided for @auth_back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get auth_back_to_login;

  /// No description provided for @auth_reset_link_sent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent to your email'**
  String get auth_reset_link_sent;

  /// No description provided for @auth_otp_verification_title.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get auth_otp_verification_title;

  /// No description provided for @auth_otp_verification_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to your email'**
  String get auth_otp_verification_subtitle;

  /// No description provided for @auth_add_avatar.
  ///
  /// In en, this message translates to:
  /// **'Add Avatar'**
  String get auth_add_avatar;

  /// No description provided for @auth_change_avatar.
  ///
  /// In en, this message translates to:
  /// **'Change Avatar'**
  String get auth_change_avatar;

  /// No description provided for @auth_select_image_source.
  ///
  /// In en, this message translates to:
  /// **'Select image source'**
  String get auth_select_image_source;

  /// No description provided for @auth_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get auth_camera;

  /// No description provided for @auth_gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get auth_gallery;

  /// No description provided for @auth_complete_in_browser.
  ///
  /// In en, this message translates to:
  /// **'Complete login in browser'**
  String get auth_complete_in_browser;

  /// No description provided for @auth_logging_in.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get auth_logging_in;

  /// No description provided for @auth_login_success.
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get auth_login_success;

  /// No description provided for @auth_login_failed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get auth_login_failed;

  /// No description provided for @auth_terms_required.
  ///
  /// In en, this message translates to:
  /// **'You must accept the terms and conditions to continue'**
  String get auth_terms_required;

  /// No description provided for @auth_splash_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast and reliable delivery'**
  String get auth_splash_subtitle;

  /// No description provided for @auth_otp_sent_success.
  ///
  /// In en, this message translates to:
  /// **'Verification code sent successfully'**
  String get auth_otp_sent_success;

  /// No description provided for @auth_account_not_active.
  ///
  /// In en, this message translates to:
  /// **'not active'**
  String get auth_account_not_active;

  /// No description provided for @auth_reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_reset_password_title;

  /// No description provided for @auth_reset_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get auth_reset_password_subtitle;

  /// No description provided for @auth_reset_password_new_password.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get auth_reset_password_new_password;

  /// No description provided for @auth_reset_password_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get auth_reset_password_confirm_password;

  /// No description provided for @auth_reset_password_button.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get auth_reset_password_button;

  /// No description provided for @checkout_title.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout_title;

  /// No description provided for @checkout_shipping_address.
  ///
  /// In en, this message translates to:
  /// **'Shipping Address'**
  String get checkout_shipping_address;

  /// No description provided for @checkout_contact_info.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get checkout_contact_info;

  /// No description provided for @checkout_saved_addresses.
  ///
  /// In en, this message translates to:
  /// **'Saved Addresses'**
  String get checkout_saved_addresses;

  /// No description provided for @checkout_customer_name.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get checkout_customer_name;

  /// No description provided for @checkout_customer_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get checkout_customer_name_hint;

  /// No description provided for @checkout_customer_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get checkout_customer_phone;

  /// No description provided for @checkout_customer_phone_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get checkout_customer_phone_hint;

  /// No description provided for @checkout_customer_address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get checkout_customer_address;

  /// No description provided for @checkout_governorate.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get checkout_governorate;

  /// No description provided for @checkout_region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get checkout_region;

  /// No description provided for @checkout_center.
  ///
  /// In en, this message translates to:
  /// **'City/Center'**
  String get checkout_center;

  /// No description provided for @checkout_coupon_code.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get checkout_coupon_code;

  /// No description provided for @checkout_order_summary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get checkout_order_summary;

  /// No description provided for @checkout_complete_order.
  ///
  /// In en, this message translates to:
  /// **'Complete Order'**
  String get checkout_complete_order;

  /// No description provided for @checkout_subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get checkout_subtotal;

  /// No description provided for @checkout_shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get checkout_shipping;

  /// No description provided for @checkout_discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get checkout_discount;

  /// No description provided for @checkout_total.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get checkout_total;

  /// No description provided for @checkout_order_success.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully!'**
  String get checkout_order_success;

  /// No description provided for @checkout_validation_name_required.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get checkout_validation_name_required;

  /// No description provided for @checkout_validation_phone_required.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get checkout_validation_phone_required;

  /// No description provided for @checkout_validation_address_required.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get checkout_validation_address_required;

  /// No description provided for @checkout_validation_governorate_required.
  ///
  /// In en, this message translates to:
  /// **'Governorate is required'**
  String get checkout_validation_governorate_required;

  /// No description provided for @checkout_validation_center_required.
  ///
  /// In en, this message translates to:
  /// **'City is required'**
  String get checkout_validation_center_required;

  /// No description provided for @checkout_apply_coupon.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get checkout_apply_coupon;

  /// No description provided for @checkout_remove_coupon.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get checkout_remove_coupon;

  /// No description provided for @privacy_policy_title.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy_title;

  /// No description provided for @privacy_policy_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get privacy_policy_last_updated;

  /// No description provided for @privacy_policy_last_updated_date.
  ///
  /// In en, this message translates to:
  /// **'December 30, 2024'**
  String get privacy_policy_last_updated_date;

  /// No description provided for @privacy_policy_introduction_title.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get privacy_policy_introduction_title;

  /// No description provided for @privacy_policy_introduction_content.
  ///
  /// In en, this message translates to:
  /// **'Wassaly (\'we\', \'our\', or \'us\') is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and related services.'**
  String get privacy_policy_introduction_content;

  /// No description provided for @privacy_policy_data_collection_title.
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get privacy_policy_data_collection_title;

  /// No description provided for @privacy_policy_data_collection_content.
  ///
  /// In en, this message translates to:
  /// **'We collect information you provide directly to us, such as when you create an account, update your profile, use our services, or contact us for support. This includes: name, email address, phone number, profile information, payment information, location data, and usage data.'**
  String get privacy_policy_data_collection_content;

  /// No description provided for @privacy_policy_data_usage_title.
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get privacy_policy_data_usage_title;

  /// No description provided for @privacy_policy_data_usage_content.
  ///
  /// In en, this message translates to:
  /// **'We use the information we collect to: provide, maintain, and improve our services; process transactions and send related information; send technical notices and support messages; communicate with you about products, services, and promotional offers; and monitor and analyze trends and usage.'**
  String get privacy_policy_data_usage_content;

  /// No description provided for @privacy_policy_data_sharing_title.
  ///
  /// In en, this message translates to:
  /// **'Information Sharing'**
  String get privacy_policy_data_sharing_title;

  /// No description provided for @privacy_policy_data_sharing_content.
  ///
  /// In en, this message translates to:
  /// **'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy. We may share information with: service providers who assist in operating our app, payment processors, and when required by law or to protect our rights.'**
  String get privacy_policy_data_sharing_content;

  /// No description provided for @privacy_policy_data_security_title.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get privacy_policy_data_security_title;

  /// No description provided for @privacy_policy_data_security_content.
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.'**
  String get privacy_policy_data_security_content;

  /// No description provided for @privacy_policy_user_rights_title.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get privacy_policy_user_rights_title;

  /// No description provided for @privacy_policy_user_rights_content.
  ///
  /// In en, this message translates to:
  /// **'You have the right to: access and update your personal information, request deletion of your account and data, opt-out of marketing communications, and request a copy of your data. To exercise these rights, contact us using the information below.'**
  String get privacy_policy_user_rights_content;

  /// No description provided for @privacy_policy_third_party_title.
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get privacy_policy_third_party_title;

  /// No description provided for @privacy_policy_third_party_content.
  ///
  /// In en, this message translates to:
  /// **'Our app may contain links to third-party websites and services. We are not responsible for the privacy practices of these third parties. We encourage you to review their privacy policies.'**
  String get privacy_policy_third_party_content;

  /// No description provided for @privacy_policy_children_privacy_title.
  ///
  /// In en, this message translates to:
  /// **'Children\'s Privacy'**
  String get privacy_policy_children_privacy_title;

  /// No description provided for @privacy_policy_children_privacy_content.
  ///
  /// In en, this message translates to:
  /// **'Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13. If you believe we have collected such information, please contact us immediately.'**
  String get privacy_policy_children_privacy_content;

  /// No description provided for @privacy_policy_international_transfers_title.
  ///
  /// In en, this message translates to:
  /// **'International Data Transfers'**
  String get privacy_policy_international_transfers_title;

  /// No description provided for @privacy_policy_international_transfers_content.
  ///
  /// In en, this message translates to:
  /// **'Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your data in accordance with applicable data protection laws.'**
  String get privacy_policy_international_transfers_content;

  /// No description provided for @privacy_policy_changes_title.
  ///
  /// In en, this message translates to:
  /// **'Changes to This Policy'**
  String get privacy_policy_changes_title;

  /// No description provided for @privacy_policy_changes_content.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy in the app and updating the \'Last Updated\' date. Your continued use of the app after such changes constitutes acceptance.'**
  String get privacy_policy_changes_content;

  /// No description provided for @privacy_policy_contact_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get privacy_policy_contact_title;

  /// No description provided for @privacy_policy_contact_content.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy, please contact us at: privacy@wassaly.com or through our in-app support center.'**
  String get privacy_policy_contact_content;

  /// No description provided for @privacy_policy_footer_note.
  ///
  /// In en, this message translates to:
  /// **'By using Wassaly, you acknowledge that you have read and understood this Privacy Policy.'**
  String get privacy_policy_footer_note;

  /// No description provided for @privacy_policy_google_privacy.
  ///
  /// In en, this message translates to:
  /// **'Google Privacy Policy'**
  String get privacy_policy_google_privacy;

  /// No description provided for @privacy_policy_google_terms.
  ///
  /// In en, this message translates to:
  /// **'Google Terms of Service'**
  String get privacy_policy_google_terms;

  /// No description provided for @terms_of_service_title.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms_of_service_title;

  /// No description provided for @terms_of_service_last_updated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get terms_of_service_last_updated;

  /// No description provided for @terms_of_service_last_updated_date.
  ///
  /// In en, this message translates to:
  /// **'December 30, 2024'**
  String get terms_of_service_last_updated_date;

  /// No description provided for @terms_of_service_acceptance_title.
  ///
  /// In en, this message translates to:
  /// **'Acceptance of Terms'**
  String get terms_of_service_acceptance_title;

  /// No description provided for @terms_of_service_acceptance_content.
  ///
  /// In en, this message translates to:
  /// **'By accessing or using the Wassaly mobile application, you agree to be bound by these Terms of Service. If you do not agree to all of these terms, do not use the application.'**
  String get terms_of_service_acceptance_content;

  /// No description provided for @terms_of_service_services_title.
  ///
  /// In en, this message translates to:
  /// **'Description of Services'**
  String get terms_of_service_services_title;

  /// No description provided for @terms_of_service_services_content.
  ///
  /// In en, this message translates to:
  /// **'Wassaly provides a platform connecting customers with delivery services for various products. We reserve the right to modify or discontinue any service at any time.'**
  String get terms_of_service_services_content;

  /// No description provided for @terms_of_service_user_responsibilities_title.
  ///
  /// In en, this message translates to:
  /// **'User Responsibilities'**
  String get terms_of_service_user_responsibilities_title;

  /// No description provided for @terms_of_service_user_responsibilities_content.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for maintaining the confidentiality of your account information and for all activities that occur under your account. You agree to provide accurate and complete information.'**
  String get terms_of_service_user_responsibilities_content;

  /// No description provided for @terms_of_service_prohibited_uses_title.
  ///
  /// In en, this message translates to:
  /// **'Prohibited Uses'**
  String get terms_of_service_prohibited_uses_title;

  /// No description provided for @terms_of_service_prohibited_uses_content.
  ///
  /// In en, this message translates to:
  /// **'You may not use the application for any illegal purpose, to transmit any malicious code, or to interfere with the proper working of the application.'**
  String get terms_of_service_prohibited_uses_content;

  /// No description provided for @terms_of_service_intellectual_property_title.
  ///
  /// In en, this message translates to:
  /// **'Intellectual Property'**
  String get terms_of_service_intellectual_property_title;

  /// No description provided for @terms_of_service_intellectual_property_content.
  ///
  /// In en, this message translates to:
  /// **'All content and software included in the application are the property of Wassaly or its suppliers and are protected by intellectual property laws.'**
  String get terms_of_service_intellectual_property_content;

  /// No description provided for @terms_of_service_termination_title.
  ///
  /// In en, this message translates to:
  /// **'Termination'**
  String get terms_of_service_termination_title;

  /// No description provided for @terms_of_service_termination_content.
  ///
  /// In en, this message translates to:
  /// **'We may terminate or suspend your access to the application immediately, without prior notice or liability, for any reason, including breach of these Terms.'**
  String get terms_of_service_termination_content;

  /// No description provided for @terms_of_service_limitation_title.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get terms_of_service_limitation_title;

  /// No description provided for @terms_of_service_limitation_content.
  ///
  /// In en, this message translates to:
  /// **'Wassaly shall not be liable for any indirect, incidental, special, or consequential damages resulting from the use or inability to use the application.'**
  String get terms_of_service_limitation_content;

  /// No description provided for @terms_of_service_changes_title.
  ///
  /// In en, this message translates to:
  /// **'Changes to Terms'**
  String get terms_of_service_changes_title;

  /// No description provided for @terms_of_service_changes_content.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to update or change our Terms of Service at any time. Your continued use of the service after we post any modifications will constitute your acknowledgment of the modifications.'**
  String get terms_of_service_changes_content;

  /// No description provided for @terms_of_service_contact_title.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get terms_of_service_contact_title;

  /// No description provided for @terms_of_service_contact_content.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about these Terms, please contact us at: terms@wassaly.com'**
  String get terms_of_service_contact_content;

  /// No description provided for @terms_of_service_footer_note.
  ///
  /// In en, this message translates to:
  /// **'Thank you for using Wassaly!'**
  String get terms_of_service_footer_note;

  /// No description provided for @order_items_count.
  ///
  /// In en, this message translates to:
  /// **'Items Count'**
  String get order_items_count;

  /// No description provided for @order_date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get order_date;

  /// No description provided for @order_payment_method.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get order_payment_method;

  /// No description provided for @order_payment_cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get order_payment_cash;

  /// No description provided for @order_payment_online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get order_payment_online;

  /// No description provided for @order_no_orders_msg.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any orders yet'**
  String get order_no_orders_msg;

  /// No description provided for @order_no_orders_title.
  ///
  /// In en, this message translates to:
  /// **'No Orders'**
  String get order_no_orders_title;

  /// No description provided for @order_total_price.
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get order_total_price;

  /// No description provided for @order_products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get order_products;

  /// No description provided for @order_services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get order_services;

  /// No description provided for @order_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get order_status_pending;

  /// No description provided for @order_status_accepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get order_status_accepted;

  /// No description provided for @order_status_confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get order_status_confirmed;

  /// No description provided for @order_status_processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get order_status_processing;

  /// No description provided for @order_status_shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get order_status_shipped;

  /// No description provided for @order_status_delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get order_status_delivered;

  /// No description provided for @order_status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get order_status_completed;

  /// No description provided for @order_status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get order_status_cancelled;

  /// No description provided for @no_cached_user.
  ///
  /// In en, this message translates to:
  /// **'No user data found'**
  String get no_cached_user;

  /// No description provided for @reset_password_strength_weak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get reset_password_strength_weak;

  /// No description provided for @reset_password_strength_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get reset_password_strength_medium;

  /// No description provided for @reset_password_strength_strong.
  ///
  /// In en, this message translates to:
  /// **'Strong'**
  String get reset_password_strength_strong;

  /// No description provided for @reset_password_new_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get reset_password_new_password_hint;

  /// No description provided for @reset_password_confirm_password_hint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get reset_password_confirm_password_hint;

  /// No description provided for @reset_password_reset_button.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password_reset_button;

  /// No description provided for @reset_password_back_to_login.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get reset_password_back_to_login;

  /// No description provided for @otp_verification_success.
  ///
  /// In en, this message translates to:
  /// **'Phone verified successfully!'**
  String get otp_verification_success;

  /// No description provided for @otp_resend_success.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully!'**
  String get otp_resend_success;

  /// No description provided for @otp_verify_now.
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get otp_verify_now;

  /// No description provided for @reset_password_success_message.
  ///
  /// In en, this message translates to:
  /// **'Password reset successfully!'**
  String get reset_password_success_message;

  /// No description provided for @reset_password_title.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password_title;

  /// No description provided for @reset_password_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a strong new password'**
  String get reset_password_subtitle;

  /// No description provided for @reset_password_requirements_title.
  ///
  /// In en, this message translates to:
  /// **'Password must meet the following requirements:'**
  String get reset_password_requirements_title;

  /// No description provided for @reset_password_req_min_length.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters long'**
  String get reset_password_req_min_length;

  /// No description provided for @reset_password_req_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords must match'**
  String get reset_password_req_match;

  /// No description provided for @otp_otp_sent_to.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to '**
  String get otp_otp_sent_to;

  /// No description provided for @otp_didnt_receive_code.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get otp_didnt_receive_code;

  /// No description provided for @otp_resend_code.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get otp_resend_code;

  /// No description provided for @reset_password_strength_very_weak.
  ///
  /// In en, this message translates to:
  /// **'Very Weak'**
  String get reset_password_strength_very_weak;

  /// No description provided for @reset_password_strength_fair.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get reset_password_strength_fair;

  /// No description provided for @reset_password_strength_good.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get reset_password_strength_good;

  /// No description provided for @otp_retry_after.
  ///
  /// In en, this message translates to:
  /// **'Retry after {seconds}s'**
  String otp_retry_after(int seconds);

  /// No description provided for @service_details_title.
  ///
  /// In en, this message translates to:
  /// **'Service Details'**
  String get service_details_title;

  /// No description provided for @service_details_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get service_details_description;

  /// No description provided for @service_details_provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get service_details_provider;

  /// No description provided for @service_details_book_now.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get service_details_book_now;

  /// No description provided for @service_details_no_available_days.
  ///
  /// In en, this message translates to:
  /// **'No available slots at the moment'**
  String get service_details_no_available_days;

  /// No description provided for @service_details_available_days.
  ///
  /// In en, this message translates to:
  /// **'Available Days'**
  String get service_details_available_days;

  /// No description provided for @service_details_available_times.
  ///
  /// In en, this message translates to:
  /// **'Available Times'**
  String get service_details_available_times;

  /// No description provided for @service_booking_title.
  ///
  /// In en, this message translates to:
  /// **'Service Booking'**
  String get service_booking_title;

  /// No description provided for @service_booking_customer_info.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get service_booking_customer_info;

  /// No description provided for @service_booking_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get service_booking_name;

  /// No description provided for @service_booking_phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get service_booking_phone;

  /// No description provided for @service_booking_email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get service_booking_email;

  /// No description provided for @service_booking_problem.
  ///
  /// In en, this message translates to:
  /// **'Problem Description (Optional)'**
  String get service_booking_problem;

  /// No description provided for @service_booking_problem_hint.
  ///
  /// In en, this message translates to:
  /// **'Explain your problem here...'**
  String get service_booking_problem_hint;

  /// No description provided for @service_booking_address_info.
  ///
  /// In en, this message translates to:
  /// **'Address Information'**
  String get service_booking_address_info;

  /// No description provided for @service_booking_selected_day.
  ///
  /// In en, this message translates to:
  /// **'Selected Day'**
  String get service_booking_selected_day;

  /// No description provided for @service_booking_selected_time.
  ///
  /// In en, this message translates to:
  /// **'Selected Time'**
  String get service_booking_selected_time;

  /// No description provided for @service_booking_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get service_booking_confirm;

  /// No description provided for @service_booking_success_title.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful!'**
  String get service_booking_success_title;

  /// No description provided for @service_booking_success_msg.
  ///
  /// In en, this message translates to:
  /// **'Your booking request has been received, the provider will contact you soon.'**
  String get service_booking_success_msg;

  /// No description provided for @service_booking_id.
  ///
  /// In en, this message translates to:
  /// **'Booking ID'**
  String get service_booking_id;

  /// No description provided for @service_booking_service.
  ///
  /// In en, this message translates to:
  /// **'Service'**
  String get service_booking_service;

  /// No description provided for @service_booking_provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get service_booking_provider;

  /// No description provided for @service_booking_day.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get service_booking_day;

  /// No description provided for @service_booking_time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get service_booking_time;

  /// No description provided for @service_booking_go_home.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get service_booking_go_home;

  /// No description provided for @service_booking_view_orders.
  ///
  /// In en, this message translates to:
  /// **'View My Bookings'**
  String get service_booking_view_orders;

  /// No description provided for @provider_details_title.
  ///
  /// In en, this message translates to:
  /// **'Provider Details'**
  String get provider_details_title;

  /// No description provided for @provider_details_working_hours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get provider_details_working_hours;

  /// No description provided for @provider_details_days.
  ///
  /// In en, this message translates to:
  /// **'Working Days'**
  String get provider_details_days;

  /// No description provided for @provider_details_time.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get provider_details_time;

  /// No description provided for @provider_details_price_from.
  ///
  /// In en, this message translates to:
  /// **'Price Starts From'**
  String get provider_details_price_from;

  /// No description provided for @provider_details_services.
  ///
  /// In en, this message translates to:
  /// **'Offered Services'**
  String get provider_details_services;

  /// No description provided for @brands.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brands;

  /// No description provided for @no_brands.
  ///
  /// In en, this message translates to:
  /// **'No brands added yet'**
  String get no_brands;

  /// No description provided for @brand_products.
  ///
  /// In en, this message translates to:
  /// **'Brand Products'**
  String get brand_products;

  /// No description provided for @no_brand_products.
  ///
  /// In en, this message translates to:
  /// **'No products in this brand yet'**
  String get no_brand_products;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return SAr();
    case 'en':
      return SEn();
  }

  throw FlutterError(
      'S.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
