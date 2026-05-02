// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes, avoid_renaming_method_parameters, constant_identifier_names

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> _ar = {
  "shared": {
    "get_started": "ابدأ الآن",
    "cancel": "إلغاء",
    "delete": "حذف",
    "edit": "تعديل"
  },
  "home": {
    "home_title": "الرئيسية",
    "welcome_home": "مرحباً بك!",
    "home_subtitle": "مرحباً بك في تطبيق وصّلي"
  },
  "nav": {
    "nav_home": "الرئيسية",
    "nav_category": "الأقسام",
    "nav_cart": "السلة",
    "nav_favorite": "المفضلة",
    "nav_profile": "حسابي"
  },
  "category": {
    "category_title": "الأقسام",
    "category_subtitle": "استكشف أقسام منتجاتنا"
  },
  "cart": {
    "cart_title": "السلة",
    "cart_subtitle": "سلة التسوق فارغة"
  },
  "favorite": {
    "favorite_title": "المفضلة",
    "favorite_subtitle": "ستظهر عناصرك المفضلة هنا"
  },
  "profile": {
    "my_account": "حسابي",
    "my_orders": "طلباتي",
    "payment_methods": "طرق الدفع",
    "notifications": "الإشعارات",
    "privacy_policy": "سياسة الخصوصية",
    "help_center": "مركز المساعدة",
    "personal_info": "المعلومات الشخصية",
    "saved_addresses": "العناوين المحفوظة",
    "add_new_address": "إضافة عنوان جديد",
    "orders_count": {
      "zero": "لا توجد طلبات",
      "one": "طلب واحد",
      "two": "طلبان",
      "few": "{} طلبات",
      "many": "{} طلب",
      "other": "{} طلب"
    },
    "manage": "إدارة",
    "settings": "الإعدادات",
    "security": "الأمان",
    "language": "اللغة",
    "theme": "السمة",
    "dark": "داكن",
    "light": "فاتح",
    "arabic": "العربية",
    "english": "الإنجليزية",
    "logout": "تسجيل الخروج",
    "logout_all_devices": "تسجيل الخروج من جميع الأجهزة",
    "delete_account": "حذف الحساب",
    "edit_profile": "تعديل الملف الشخصي",
    "change_password": "تغيير كلمة المرور",
    "current_password": "كلمة المرور الحالية",
    "save_changes": "حفظ التغييرات",
    "action_success": "تمت العملية بنجاح",
    "logout_title": "تسجيل الخروج",
    "logout_message": "هل أنت متأكد أنك تريد تسجيل الخروج؟",
    "logout_choice_message": "اختر كيف تريد تسجيل الخروج:",
    "logout_this_device": "تسجيل الخروج من هذا الجهاز",
    "logout_all_title": "تسجيل الخروج من جميع الأجهزة",
    "logout_all_message": "سيتم تسجيل خروجك من جميع الأجهزة. هل أنت متأكد؟",
    "delete_account_title": "حذف الحساب",
    "delete_account_message": "لا يمكن التراجع عن هذا الإجراء. سيتم حذف جميع بياناتك نهائيًا. هل أنت متأكد؟",
    "delete_account_confirm": "حذف الحساب",
    "delete_address_title": "حذف العنوان",
    "delete_address_message": "هل أنت متأكد أنك تريد حذف عنوان {address}؟",
    "add_address": "إضافة عنوان",
    "save_address": "حفظ العنوان",
    "address_added": "تمت إضافة العنوان بنجاح",
    "address_updated": "تم تعديل العنوان بنجاح",
    "edit_address": "تعديل العنوان",
    "address_title": "عنوان العنوان",
    "address_title_hint": "المنزل، العمل، إلخ",
    "address_details": "تفاصيل العنوان",
    "address_details_hint": "الشارع، المبنى، الطابق",
    "governorate": "المحافظة",
    "center": "المدينة/المركز",
    "select_governorate": "يرجى اختيار المحافظة",
    "select_center": "يرجى اختيار المدينة",
    "title_required": "العنوان مطلوب",
    "address_required": "تفاصيل العنوان مطلوبة",
    "current_password_required": "كلمة المرور الحالية مطلوبة لتغيير كلمة المرور",
    "no_addresses": "لا توجد عناوين بعد",
    "add_address_hint": "أضف عنوانك الأول للبدء",
    "addresses_error": "فشل في تحميل العناوين",
    "select_language": "اختيار اللغة",
    "general_settings": "الإعدادات العامة",
    "support_and_privacy": "الدعم والخصوصية",
    "active": "مفعل"
  },
  "auth": {
    "log_in": "تسجيل الدخول",
    "log_in_subtitle": "مرحباً بعودتك إلى وصّلي",
    "email_or_phone": "البريد الإلكتروني أو رقم الهاتف",
    "email": "البريد الإلكتروني",
    "email_placeholder": "أدخل بياناتك",
    "email_required": "البريد الإلكتروني مطلوب",
    "email_invalid": "أدخل بريدًا إلكترونيًا صالحًا",
    "password": "كلمة المرور",
    "password_required": "كلمة المرور مطلوبة",
    "password_too_short": "يجب أن تكون كلمة المرور 6 أحرف على الأقل",
    "forgot_password": "هل نسيت كلمة المرور؟",
    "remember_me": "تذكرني",
    "login_button": "تسجيل الدخول",
    "dont_have_account": "ليس لديك حساب؟",
    "sign_up": "إنشاء حساب",
    "sign_up_google": "جوجل",
    "sign_up_facebook": "فيسبوك",
    "or_login_with": "أو سجل عبر",
    "login_with_google": "جوجل",
    "create_account": "إنشاء حساب",
    "create_account_subtitle": "ابدأ رحلتك معنا",
    "name": "الاسم الكامل",
    "name_placeholder": "أدخل اسمك الكامل",
    "name_required": "الاسم الكامل مطلوب",
    "confirm_password": "تأكيد كلمة المرور",
    "confirm_password_required": "تأكيد كلمة المرور مطلوب",
    "passwords_do_not_match": "كلمات المرور غير متطابقة",
    "create_account_button": "إنشاء الحساب",
    "already_have_account": "لديك حساب بالفعل؟",
    "sign_in": "تسجيل الدخول",
    "phone": "رقم الهاتف",
    "phone_required": "رقم الهاتف مطلوب",
    "phone_invalid": "أدخل رقم هاتف صحيح",
    "agree_to": "أوافق على",
    "terms_of_service": "شروط الخدمة",
    "and": "و",
    "privacy_policy": "سياسة الخصوصية",
    "or_continue_with": "أو المتابعة عبر",
    "forgot_password_title": "نسيت كلمة المرور؟",
    "forgot_password_subtitle": "أدخل بريدك الإلكتروني أو رقم هاتفك وسنرسل لك رمز إعادة التعيين",
    "send_code": "إرسال الرمز",
    "back_to_login": "العودة لتسجيل الدخول",
    "reset_link_sent": "تم إرسال رابط إعادة التعيين إلى بريدك الإلكتروني",
    "otp_verification_title": "تأكيد الرمز",
    "otp_verification_subtitle": "أدخل الرمز المرسل إلى بريدك الإلكتروني",
    "add_avatar": "إضافة صورة",
    "change_avatar": "تغيير الصورة",
    "select_image_source": "اختر مصدر الصورة",
    "camera": "الكاميرا",
    "gallery": "المعرض",
    "complete_in_browser": "يرجى إكمال تسجيل الدخول في المتصفح",
    "logging_in": "جاري تسجيل الدخول...",
    "login_success": "تم تسجيل الدخول بنجاح",
    "login_failed": "فشل تسجيل الدخول"
  },
  "privacy_policy": {
    "title": "سياسة الخصوصية",
    "last_updated": "اخر تحديث",
    "last_updated_date": "30 ديسمبر 2024",
    "introduction": {
      "title": "مقدمة",
      "content": "تعتبر Wassaly ('نحن'، 'لنا'، أو 'نا') ملتزمه بحماية خصوصيتك. توضح سياسة الخصوصية هذه كيف نجمع، نستخدم، نكشف، ونحمي معلوماتك عند استخدامك لتطبيقنا المحمول والخدمات ذات الصلة."
    },
    "data_collection": {
      "title": "المعلومات التي نجمعها",
      "content": "نجمع المعلومات التي تقدمها مباشرة لنا، مثل عند إنشاء حساب، تحديث ملفك الشخصي، استخدام خدماتنا، أو الاتصال بنا للحصول على الدعم. تشمل هذه المعلومات: الاسم، عنوان البريد الإلكتروني، رقم الهاتف، معلومات الملف الشخصي، معلومات الدفع، بيانات الموقع، واستخدام البيانات."
    },
    "data_usage": {
      "title": "كيف نستخدم معلوماتك",
      "content": "نستخدم المعلومات التي نجمعها لتقديم خدماتنا، معالجة المعاملات وإرسال المعلومات ذات الصلة، إرسال الإشعارات الفنية ورسائل الدعم، التواصل معك حول المنتجات والخدمات والعروض الترويجية، ورصد وتحليل الاتجاهات والاستخدام."
    },
    "data_sharing": {
      "title": "مشاركة المعلومات",
      "content": "لا نبيع، لا نتبادل، ولا ننقل معلوماتك الشخصية إلى أطراف ثالثة دون موافقتك، باستثناء ما هو موضح في هذه السياسة. قد نشارك المعلومات مع: مقدمي الخدمات الذين يساعدون في تشغيل تطبيقنا، معالجات الدفع، وعندما يطلب القانون أو لحماية حقوقنا."
    },
    "data_security": {
      "title": "أمان البيانات",
      "content": "ننفذ الإجراءات الفنية والتنظيمية المناسبة لحماية معلوماتك الشخصية من الوصول غير المصرح به، التعديل، الإفصاح، أو التدمير. ومع ذلك، لا يوجد طريقة لنقل البيانات عبر الإنترنت تكون آمنة بنسبة 100%."
    },
    "user_rights": {
      "title": "حقوقك",
      "content": "لديك الحق في: الوصول إلى معلوماتك الشخصية وتحديثها، طلب حذف حسابك وبياناتك، إلغاء الاشتراك في الاتصالات التسويقية، وطلب نسخة من بياناتك. للقيام بهذه الحقوق، اتصل بنا باستخدام المعلومات أدناه."
    },
    "third_party": {
      "title": "خدمات الطرف الثالث",
      "content": "قد يحتوي تطبيقنا على روابط لمواقع وخدمات الطرف الثالث. نحن لا نتحمل مسؤولية ممارسات الخصوصية لهذه الأطراف الثالثة. نشجعك على مراجعة سياسات الخصوصية الخاصة بهم."
    },
    "children_privacy": {
      "title": "خصوصية الأطفال",
      "content": "خدماتنا ليست مخصصة للأطفال دون سن 13. نحن لا نجمع معلومات شخصية من الأطفال دون سن 13. إذا كنت تعتقد أننا قد جمعنا مثل هذه المعلومات، يرجى الاتصال بنا على الفور."
    },
    "international_transfers": {
      "title": "نقل البيانات الدولية",
      "content": "قد يتم نقل معلوماتك إلى الدول الأخرى ومعالجتها. نحن نضمن اتخاذ الإجراءات المناسبة لحماية بياناتك وفقًا لقوانين حماية البيانات المعمول بها."
    },
    "changes": {
      "title": "التغييرات على هذه السياسة",
      "content": "قد نحدث هذه سياسة الخصوصية من وقت لآخر. سنخبرك بأي تغييرات من خلال نشر السياسة الجديدة في التطبيق وتحديث تاريخ 'اخر تحديث'. استمرار استخدامك للتطبيق بعد مثل هذه التغييرات يشكل قبولًا."
    },
    "contact": {
      "title": "اتصل بنا",
      "content": "إذا كان لديك أي أسئلة حول سياسة الخصوصية هذه، يرجى الاتصال بنا على: privacy@wassaly.com أو من خلال مركز الدعم داخل التطبيق."
    },
    "footer": {
      "note": "باستخدام Wassaly، أنت تقر بأنك قد قرأت وفهمت سياسة الخصوصية هذه."
    },
    "google_privacy": "سياسة الخصوصية لجوجل",
    "google_terms": "شروط الخدمة لجوجل"
  }
};
static const Map<String,dynamic> _en = {
  "shared": {
    "get_started": "Get Started",
    "cancel": "Cancel",
    "delete": "Delete",
    "edit": "Edit"
  },
  "home": {
    "home_title": "Home",
    "welcome_home": "Welcome!",
    "home_subtitle": "Welcome to Wasally App"
  },
  "nav": {
    "nav_home": "Home",
    "nav_category": "Categories",
    "nav_cart": "Cart",
    "nav_favorite": "Favorites",
    "nav_profile": "Profile"
  },
  "category": {
    "category_title": "Categories",
    "category_subtitle": "Explore our product categories"
  },
  "cart": {
    "cart_title": "Cart",
    "cart_subtitle": "Your cart is empty"
  },
  "favorite": {
    "favorite_title": "Favorites",
    "favorite_subtitle": "Your favorite items will appear here"
  },
  "profile": {
    "my_account": "My Account",
    "my_orders": "My Orders",
    "payment_methods": "Payment Methods",
    "notifications": "Notifications",
    "privacy_policy": "Privacy Policy",
    "help_center": "Help Center",
    "personal_info": "Personal Information",
    "saved_addresses": "Saved Addresses",
    "add_new_address": "Add New Address",
    "orders_count": {
      "zero": "No orders",
      "one": "1 order",
      "two": "2 orders",
      "few": "{} orders",
      "many": "{} orders",
      "other": "{} orders"
    },
    "manage": "Manage",
    "settings": "Settings",
    "security": "Security",
    "language": "Language",
    "theme": "Theme",
    "dark": "Dark",
    "light": "Light",
    "arabic": "Arabic",
    "english": "English",
    "logout": "Logout",
    "logout_all_devices": "Logout from All Devices",
    "delete_account": "Delete Account",
    "edit_profile": "Edit Profile",
    "change_password": "Change Password",
    "current_password": "Current Password",
    "save_changes": "Save Changes",
    "action_success": "Action completed successfully",
    "logout_title": "Logout",
    "logout_message": "Are you sure you want to logout?",
    "logout_choice_message": "Choose how you want to logout:",
    "logout_this_device": "Logout from This Device",
    "logout_all_title": "Logout from All Devices",
    "logout_all_message": "You will be logged out from all devices. Are you sure?",
    "delete_account_title": "Delete Account",
    "delete_account_message": "This action cannot be undone. All your data will be permanently deleted. Are you sure?",
    "delete_account_confirm": "Delete Account",
    "delete_address_title": "Delete Address",
    "delete_address_message": "Are you sure you want to delete address {address}?",
    "add_address": "Add Address",
    "save_address": "Save Address",
    "address_added": "Address added successfully",
    "address_updated": "Address updated successfully",
    "edit_address": "Edit Address",
    "address_title": "Address Title",
    "address_title_hint": "Home, Work, etc",
    "address_details": "Address Details",
    "address_details_hint": "Street, Building, Floor",
    "governorate": "Governorate",
    "center": "City/Center",
    "select_governorate": "Please select a governorate",
    "select_center": "Please select a city",
    "title_required": "Title is required",
    "address_required": "Address is required",
    "current_password_required": "Current password is required to change password",
    "no_addresses": "No addresses yet",
    "add_address_hint": "Add your first address to get started",
    "addresses_error": "Failed to load addresses",
    "select_language": "Select Language",
    "general_settings": "General Settings",
    "support_and_privacy": "Support & Privacy",
    "active": "Active"
  },
  "auth": {
    "log_in": "Login",
    "log_in_subtitle": "Welcome back to Wasally",
    "email_or_phone": "Email or Phone",
    "email": "Email",
    "email_placeholder": "Enter your details",
    "email_required": "Email is required",
    "email_invalid": "Enter a valid email",
    "password": "Password",
    "password_required": "Password is required",
    "password_too_short": "Password must be at least 6 characters",
    "forgot_password": "Forgot password?",
    "remember_me": "Remember me",
    "login_button": "Login",
    "dont_have_account": "Don't have an account?",
    "sign_up": "Sign up",
    "sign_up_google": "Google",
    "sign_up_facebook": "Facebook",
    "or_login_with": "Or login with",
    "login_with_google": "Google",
    "create_account": "Create Account",
    "create_account_subtitle": "Start your journey with us",
    "name": "Full Name",
    "name_placeholder": "Enter your full name",
    "name_required": "Full name is required",
    "confirm_password": "Confirm Password",
    "confirm_password_required": "Confirm password is required",
    "passwords_do_not_match": "Passwords do not match",
    "create_account_button": "Create Account",
    "already_have_account": "Already have an account?",
    "sign_in": "Sign in",
    "phone": "Phone Number",
    "phone_required": "Phone number is required",
    "phone_invalid": "Enter a valid phone number",
    "agree_to": "I agree to",
    "terms_of_service": "Terms of Service",
    "and": "and",
    "privacy_policy": "Privacy Policy",
    "or_continue_with": "Or continue with",
    "forgot_password_title": "Forgot Password?",
    "forgot_password_subtitle": "Enter your email or phone and we’ll send a reset code",
    "send_code": "Send Code",
    "back_to_login": "Back to Login",
    "reset_link_sent": "Reset link sent to your email",
    "otp_verification_title": "OTP Verification",
    "otp_verification_subtitle": "Enter the code sent to your email",
    "add_avatar": "Add Avatar",
    "change_avatar": "Change Avatar",
    "select_image_source": "Select image source",
    "camera": "Camera",
    "gallery": "Gallery",
    "complete_in_browser": "Complete login in browser",
    "logging_in": "Logging in...",
    "login_success": "Login successful",
    "login_failed": "Login failed"
  },
  "privacy_policy": {
    "title": "Privacy Policy",
    "last_updated": "Last Updated",
    "last_updated_date": "December 30, 2024",
    "introduction": {
      "title": "Introduction",
      "content": "Wassaly ('we', 'our', or 'us') is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and related services."
    },
    "data_collection": {
      "title": "Information We Collect",
      "content": "We collect information you provide directly to us, such as when you create an account, update your profile, use our services, or contact us for support. This includes: name, email address, phone number, profile information, payment information, location data, and usage data."
    },
    "data_usage": {
      "title": "How We Use Your Information",
      "content": "We use the information we collect to: provide, maintain, and improve our services; process transactions and send related information; send technical notices and support messages; communicate with you about products, services, and promotional offers; and monitor and analyze trends and usage."
    },
    "data_sharing": {
      "title": "Information Sharing",
      "content": "We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy. We may share information with: service providers who assist in operating our app, payment processors, and when required by law or to protect our rights."
    },
    "data_security": {
      "title": "Data Security",
      "content": "We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure."
    },
    "user_rights": {
      "title": "Your Rights",
      "content": "You have the right to: access and update your personal information, request deletion of your account and data, opt-out of marketing communications, and request a copy of your data. To exercise these rights, contact us using the information below."
    },
    "third_party": {
      "title": "Third-Party Services",
      "content": "Our app may contain links to third-party websites and services. We are not responsible for the privacy practices of these third parties. We encourage you to review their privacy policies."
    },
    "children_privacy": {
      "title": "Children's Privacy",
      "content": "Our services are not intended for children under 13. We do not knowingly collect personal information from children under 13. If you believe we have collected such information, please contact us immediately."
    },
    "international_transfers": {
      "title": "International Data Transfers",
      "content": "Your information may be transferred to and processed in countries other than your own. We ensure appropriate safeguards are in place to protect your data in accordance with applicable data protection laws."
    },
    "changes": {
      "title": "Changes to This Policy",
      "content": "We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy in the app and updating the 'Last Updated' date. Your continued use of the app after such changes constitutes acceptance."
    },
    "contact": {
      "title": "Contact Us",
      "content": "If you have any questions about this Privacy Policy, please contact us at: privacy@wassaly.com or through our in-app support center."
    },
    "footer": {
      "note": "By using Wassaly, you acknowledge that you have read and understood this Privacy Policy."
    },
    "google_privacy": "Google Privacy Policy",
    "google_terms": "Google Terms of Service"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"ar": _ar, "en": _en};
}
