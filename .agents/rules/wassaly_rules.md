# Global Rules for Flutter Clean Architecture (Wassaly Pattern)

Whenever you are working on my Flutter/Dart projects, you MUST strictly follow these guidelines:

## 1. Clean Architecture & Structure
All features must reside inside `lib/features/feature_name/` and follow the 3-Layer Clean Architecture structure:
*   **domain/**: Pure business logic (framework-independent).
    *   `entities/`: Plain data objects.
    *   `repositories/`: Abstract repository contracts (interfaces).
    *   `usecases/`: Single-responsibility classes implementing the business flows.
*   **data/**: Concrete data fetching and parsing.
    *   `datasources/`: REST API clients (remote) and DB storage wrappers (local).
    *   `models/`: DTO models extending domain entities with JSON serialization.
    *   `repositories/`: Concrete implementations of domain repository contracts.
*   **presentation/**: The UI and state coordination.
    *   `bloc/`: BLoC logic (`bloc.dart`, `event.dart`, `state.dart`).
    *   `pages/`: High-level full screen page widgets.
    *   `widgets/`: Smaller, reusable components.

## 2. Technology Stack & Packages
*   **State Management:** Always use `flutter_bloc` for tracking event/state flows.
*   **Navigation:** Use `go_router` for route definition and transition handling.
*   **Networking:** Use `dio` with custom interceptors and error logging.
*   **Local Storage:** Use `Hive` for data caching, `shared_preferences` for simple key-value settings, and `flutter_secure_storage` for credentials.
*   **Functional Programming:** Use `fpdart`'s `Either` type (`Either<Failure, Success>`) for repository/usecase outputs to ensure functional error handling.

## 3. UI/UX & Responsive Layouts
*   **Responsive Dimensions:** Never hardcode absolute pixel sizes for width, height, padding, margins, borders, or text. Always use `flutter_screenutil` extensions (e.g. `16.w`, `24.h`, `14.sp`, `8.r`).
*   **Localization:** Avoid raw hardcoded user-facing strings. Access localized content dynamically via `context.l10n`.
*   **Themes:** Avoid raw color hex values in visual files. Utilize theme extensions or properties (e.g. `context.colors`, `context.textTheme`).
*   **Load States:** Use `skeletonizer` for shimmer placeholders instead of simple loaders. Use `flutter_animate` for animations.

## 4. File Naming & Conventions
*   **File Names:** Use lowercase `snake_case` for all files (e.g. `get_user_usecase.dart`, `custom_text_field.dart`).
*   **Cleanups:** Remove unused imports, run `flutter format`, and declare constructors with `const` wherever possible.
