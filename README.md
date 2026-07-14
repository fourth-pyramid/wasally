# 🚀 Wassaly - Smart E-Commerce & Service Booking Platform

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean-brightgreen?style=for-the-badge)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![BLoC](https://img.shields.io/badge/State--Management-BLoC-blue?style=for-the-badge)](https://bloclibrary.dev)

Wassaly is a production-grade, highly scalable mobile application developed using Flutter. It is designed to act as a hybrid platform that seamlessly blends a fully-featured **E-Commerce storefront** with a robust **Professional Service Booking engine**. The app is engineered following strict Clean Architecture guidelines and state-of-the-art UI/UX standards, delivering a responsive, premium, and highly interactive user experience.

---

## 💡 System Overview & Core Concept

Wassaly solves the fragmentation of on-demand consumer needs by unifying product shopping and service appointment booking into a single mobile client:
* **The E-Commerce Engine:** Enables users to browse diverse catalogs, manage items in a persistent shopping cart, apply promotional offers, complete checkout procedures, and track the shipping lifecycle of their orders.
* **The Service Booking Engine:** Connects users with professional service providers. It includes provider detail pages, interactive service catalogs, and scheduling systems to book and manage appointments.
* **Unified Core Platform:** Shares a cohesive security framework, local storage cache, localization context (Arabic/English), and state management pattern across all modules.

---

## ✨ Features & Functional Modules

### 🔑 1. Authentication & Profile Management
* **Secure OTP Flow:** Mobile number registration coupled with multi-factor OTP verification for secure login.
* **Profile Customization:** Comprehensive profile updating, avatar management, and multi-address book control.
* **Localization Settings:** Toggle between English and Arabic with automated layout switching (LTR / RTL) supported by the premium **Cairo** font.

### 🛍️ 2. Advanced E-Commerce Storefront
* **Product Catalog & Brands:** Deep hierarchical categorization (categories, sub-categories) and brand filtering.
* **Dynamic Search & Filtering:** Live search engine covering products, brands, and service terms with robust query filtering options.
* **Persistent Cart & Checkout:** Add/remove items, manage quantities, calculate taxes, apply coupon discounts, compute shipping rates, and select delivered addresses.
* **Order Tracking:** Track ongoing orders through status stages (Pending, Processing, In-Transit, Delivered) with detailed history logs.

### 📅 3. On-Demand Service Booking
* **Service Directories:** Explore categories of services (e.g., maintenance, beauty, consultations) and view top-rated local providers.
* **Provider Profiling:** Read detailed provider descriptions, check their ratings, view offered service lists, and look through direct client reviews.
* **Booking Scheduler:** Intuitive appointment selector allowing users to reserve precise dates and times for service execution.

### ⭐ 4. Interactive Review & Rating System
* **Bilateral Reviews:** Users can leave ratings and text feedback on both purchased physical products and completed services.
* **Time-Restricted Editing:** Reviews feature a localized edit-window timer, ensuring comments remain up-to-date while protecting the integrity of provider ratings.

### 🔔 5. Notifications & Real-Time Syncing
* **Push Notifications:** Firebase Cloud Messaging (FCM) integration for background and terminated-state system alerts.
* **Local Notifications:** Awesome Notifications integration to handle instant scheduled reminders and rich interactive in-app banners.

### 🎨 6. Premium UI/UX & Micro-Interactions
* **Responsive Layouts:** Implemented with `flutter_screenutil` for seamless visual scaling on phones, foldables, and tablets.
* **Micro-Animations:** Interactive components powered by `flutter_animate` for smooth transitions, list-loading fades, and buttons.
* **Skeleton Shimmers:** Powered by `skeletonizer` to transition skeleton placeholding placeholders to real data cleanly without jarring jumps.
* **Showcase Tutorials:** Direct walkthrough guide (`showcase_tutorial`) helping first-time users understand how to navigate the application.

---

## 🛠️ Technology Stack & Libraries

* **State Management:** `flutter_bloc` with custom abstract classes (`SafeBloc`) ensuring safe error catching and uniform state emissions.
* **Navigation:** `go_router` supporting deep linking, sub-routing, and programmatic navigation.
* **Networking:** `dio` configured with custom interceptors for session authentication, token refresh, and `pretty_dio_logger` for debug tracing.
* **Dependency Injection:** `get_it` for global service locator configuration, ensuring decoupled dependencies.
* **Data Persistence:**
  * `Hive` for high-performance offline caching of products and service lists.
  * `shared_preferences` for basic settings and flags.
  * `flutter_secure_storage` for storing OAuth tokens and private keys.
* **Functional Programming:** `fpdart` utilized to apply `Either<Failure, Success>` patterns to repository interfaces, preventing uncaught runtime exceptions.

---

## 🏗️ Architecture Design (The 3-Layer Rule)

Wassaly adheres strictly to **Clean Architecture** to separate domain business rules from external frameworks or UI widgets.

```
lib/features/feature_name/
├── data/
│   ├── datasources/   # Remote REST APIs (Dio) & Local DB caches (Hive)
│   ├── models/        # Data Transfer Objects (DTOs) and JSON serialization
│   └── repositories/  # Implementation of domain repository interfaces
├── domain/
│   ├── entities/      # Pure business objects (no frameworks or annotations)
│   ├── repositories/  # Repository contracts (interfaces)
│   └── usecases/      # Discrete, single-purpose business logic functions
└── presentation/
    ├── bloc/          # Bloc event-to-state transformers
    ├── pages/         # High-level screen configurations
    └── widgets/       # Low-level reusable UI components
```

---

## 📂 Project Directory Structure

```bash
lib/
├── core/
│   ├── theme/         # App colors, styles, Cairo font settings, and themes
│   ├── utils/         # Extension helpers, formatters, and utilities
│   ├── network/       # Dio clients, error handlers, and network monitors
│   └── di/            # Dependency injection setup (get_it)
├── features/          # Modular feature directories (Auth, Cart, Booking, etc.)
├── l10n/              # AR/EN localization arb templates
├── main.dart          # App initializers and runner
└── app.dart           # App MaterialApp widget and routing setup
```

---

## 🚀 Getting Started

Follow these steps to run the project locally on your emulator or physical device.

### 📋 Prerequisites
* Flutter SDK (version `>=3.5.0 <4.0.0`)
* Android Studio / Xcode configured with emulator/simulator

### ⚙️ Step-by-Step Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/MahmoudMagdy001/wassaly.git
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Environment Variables:**
   Create a `.env` file in the root directory of the project:
   ```env
   API_BASE_URL=https://api.wassaly.example.com
   # Add any other required integration credentials here
   ```

4. **Code Generation (if applicable):**
   If build_runner is needed for local database models:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the Application:**
   ```bash
   flutter run
   ```

---

## 💡 Development Guidelines

* **Responsiveness:** Always wrap dimensional sizes (width, height, font size, border radius) using `flutter_screenutil` syntax (e.g., `16.w`, `24.h`, `14.sp`, `8.r`).
* **Localization:** Always read string resources from the localization context (e.g., `context.l10n.some_string_key`) to support English/Arabic dynamic switching.
* **Theme Styling:** Avoid hardcoded hex colors inside widgets. Refer to `context.colors` and `context.textTheme` to adapt styling to dark and light modes.

---

<p align="center">
  Crafted with ❤️ to deliver a premium user experience.
</p>
