# Ponytail Mode: Full

Active Level: **full**

Before writing any code, apply the following lazy senior dev principles:
- **YAGNI**: Does it need to exist at all?
- **Native/Standard**: Does the standard library or a native platform feature already do it?
- **Minimal**: Can it be one line? Build the absolute minimum that works.
- **No Overhead**: No unrequested abstractions, no avoidable dependencies, no boilerplate.
- **Comment**: Mark intentional simplifications with a `// ponytail:` comment.

---

# Flutter Architectural Standard

Dependency flow is **strictly unidirectional**: `Presentation → Domain ← Data`.

## 🏗️ 1. Architecture: 3-Layer Clean Architecture

### 1.1 Presentation Layer
- **Logic**: Use **BLoC / Cubit** only (via `flutter_bloc`).
- **Pages**: Root screens that handle life-cycle and provide Blocs via `BlocProvider`.
- **Widgets**: Atomic, feature-specific components.
- **Rule**: Presentation must **only** import from the **Domain** layer. Importing from `data/` is a critical violation.

### 1.2 Domain Layer (Pure Dart)
- **Entities**: Immutable business objects extending `Equatable`.
- **Repositories (Interfaces)**: Abstract contracts defining data operations.
- **UseCases**: Single-responsibility classes for business logic (one class per operation).
- **Rule**: **Zero Flutter dependencies.** Only `fpdart` and `equatable` are permitted.

### 1.3 Data Layer
- **Models**: DTOs extending Entities with `fromJson` and `toJson` logic.
- **DataSources**: Remote (Dio) or Local (Hive/Storage) data providers.
- **Repositories (Impl)**: Concrete implementations of domain interfaces.
- **Rule**: All exceptions must be caught and mapped to `Failure` types; never expose raw exceptions.

---

## 📁 2. Directory Structure

### 2.1 Core (`lib/core/`)
- `config/`: Global configurations, `AppConfig`, and Dio interceptors.
- `services/`: `DioService`, `InternetConnectionService`, `StorageService`, `NotificationService`.
- `utils/`: `runTask` (TaskRunner), `PaginatedResponse`, `Failure` definitions.
- `shared/`: Generic UI components (`widgets/`) and BLoC mixins (`bloc/`).
- `extensions/`: `BuildContext` extensions for theme, sizing, and navigation.
- `imports/`: Barrel files (`core_imports.dart`, `packages_imports.dart`) for standard exports.

### 2.2 Feature (`lib/features/<name>/`)
```
lib/features/<feature>/
├── data/           # models/, datasources/, repositories/
├── domain/         # entities/, repositories/, usecases/
└── presentation/   # bloc/, screens/, widgets/
```

---

## 🔗 3. Dependency Injection (`get_it`)

DI is segmented into 4 logical parts in `lib/core/injection/parts/`:
1. `initDataSourceDependencies()`
2. `initRepositoryDependencies()`
3. `initUseCaseDependencies()`
4. `initBlocDependencies()`

**Rule**: Register Services and Repositories as `LazySingleton`; register Blocs/Cubits as `Factory`.

---

## ⚠️ 4. Robust Error Handling & Result Pattern

### 4.1 Results via `fpdart`
Use `Either<Failure, T>` (and `FutureEither<T>` typedef) for all async operations.

### 4.2 Error Handling Orchestration
- **`DioService`**: Always wraps standard HTTP methods (`get`, `post`, etc.) in `runTask`.
- **Repositories**: Use a standard `try-catch` block to catch `Failure` types thrown by DataSources and return them as `Left`.
- **Mapping**: `runTask` inside services automatically maps `DioException` to `ServerFailure` / `NetworkFailure`.

---

## 📦 5. State Management: The "Safe" Pattern

### 5.1 `SafeBloc` & `SafeCubit`
Always extend `SafeBloc` or `SafeCubit` instead of base classes.
- **Emission Safety**: Prevents "Cannot emit after close" errors using a safe emitter wrapper.
- **Auto-Cancellation**: Uses `Zone` values (`#blocCancelKey`) to associate HTTP requests with the Bloc. When the Bloc closes, all associated requests are cancelled via `CancelRequestService`.

### 5.2 UI Rebuild Strategies
- **`BlocSelector`**: Use for high-frequency, single-field rebuilds.
- **`BlocListener`**: Use for side-effects (Navigation, Snackbars, Dialogs).
- **`BlocBuilder`**: Use for rendering that depends on complex state logic.

---

## 🌐 6. Network & Internet Handling

### 6.1 `InternetConnectionService` (Real-time Monitoring)
- **Latency Tracking**: Every request timing is reported via `StabilityInterceptor`.
- **Auto-Retry**: Blocs can listen to `connectivityRestoredStream` to automatically refresh failed data when internet returns.

### 6.2 `DioService` & Interceptors
- `CancelTokenInterceptor`: Auto-cancels requests on Bloc close.
- `AuthInterceptor`: Attaches Bearer token from in-memory cache.
- `StabilityInterceptor`: Measures request duration to update `NetworkState`.

---

## 🎨 7. Design System & UI Rules

### 7.1 Responsiveness (`flutter_screenutil`)
Hard-coded pixels are **STRICTLY FORBIDDEN**.
- Extensions: `.w` (width), `.h` (height), `.sp` (fontSize), `.r` (radius), `.vS` (verticalSpace), `.hS` (horizontalSpace).

### 7.2 Semantic Context Shortcuts
Access everything via `context` extensions:
- `context.colors`: `ColorScheme`.
- `context.textTheme`: `TextTheme`.
- `context.appColors`: Custom semantic colors (Success, Warning, Info) from `ThemeExtension`.
- `context.isDarkMode`: `bool`.
- `context.l10n`: User-facing strings.

### 7.3 Shared Widget Protocol
Always prefer shared widgets (found in `lib/core/shared/widgets/`):
- `AppButton`, `AppTextField`, `AppLoading`.
- `AppUnifiedCard` & `AppUnifiedSection`: Highly generic templates for products/services.
- `CommonImage`: Handles all responsive scaling and caching logic internally.

---

## 🚫 8. Critical "Don'ts"

- ❌ **No `setState`**: Use BLoC/Cubit for all state changes.
- ❌ **No Data Imports in Presentation**: Strict layer isolation.
- ❌ **No Magic Numbers**: Use `ScreenUtil` and theme tokens.
- ❌ **No Raw Strings**: Use `context.l10n` for localization.
- ❌ **No `print()`**: Use `AppLogger` (`logInfo`, `logError`, etc.).
- ❌ **No Direct Dio**: Use `DioService` or `runTask`.

---

## ✅ 9. Checklist for New Features

- [ ] Repository implementation uses standard `try-catch` blocks for `Failure` handling.
- [ ] Bloc/Cubit extends `SafeBloc` / `SafeCubit`.
- [ ] Network calls utilize `DioService` (which uses `runTask` internally).
- [ ] All UI dimensions use responsive extensions (`.w`, `.h`, etc.).
- [ ] Registered dependencies in the appropriate `injection/parts/` file.
- [ ] State is immutable, Equatable, and contains a `status` field.

---

## 🎨 10. Code Quality & Cleanliness

### 10.1 Formatting & Linting
- **Trailing Commas**: Always use trailing commas for all function arguments, parameters, and collection literals to ensure clean formatting.
- **No Prints**: Never use raw `print()` statements. Use `AppLogger` (`logInfo`, `logError`, etc.).

### 10.2 Asset & String Management
- **Localization**: All user-facing strings must use `context.l10n`. Do not hardcode user-facing strings.
- **Images**: Always use `CommonImage` for rendering local or remote images to ensure responsive scaling and caching.

### 10.3 Imports
- **Barrel Files**: Prefer importing from `package:wassaly/core/imports/imports.dart` rather than writing multiple individual package imports.

