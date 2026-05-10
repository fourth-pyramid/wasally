#  FLUTTER GLOBAL RULES (Windsurf)

**ALWAYS start with imports:**
```dart
import 'package:[PROJECT]/core/imports/core_imports.dart';
import 'package:[PROJECT]/core/imports/packages_imports.dart';
import 'package:[PROJECT]/core/injection/injection.dart';
```

---

## 🏗️ ARCHITECTURE (3-Layer Strict)

```
Presentation → Domain (interfaces only)
Domain → Core ONLY
Data → Domain, Core
❌ Presentation → Data (FORBIDDEN)
❌ Domain → Flutter/packages
```

---

## 🎨 UI Rules

### Theme & Colors
```dart
final cs = context.theme.colorScheme;
final tt = context.theme.textTheme;
color: cs.primary  // Never hard-coded colors
```

### Responsive Sizing
```dart
100.w  // Width %
20.h   // Height %
14.sp  // Font size
12.r   // Border radius
```

### Navigation
```dart
context.go(AppRoutes.home)      // Replace
context.push(AppRoutes.profile) // Stack
context.pop()                   // Back
```

### Overlays
```dart
context.showSnackBar('msg')
context.showErrorSnackBar('msg')
context.showAppDialog(builder: ...)
context.showAppBottomSheet(builder: ...)
```

---

## 📦 BLoC State Management

### State Must Be:
- ✅ Immutable (use `final`)
- ✅ Extends `Equatable`
- ✅ Has `copyWith()`
- ✅ Include `status` field
- ✅ `@override List<Object?> get props`

### In UI
```dart
// BlocBuilder with buildWhen optimization
BlocBuilder<AuthBloc, AuthState>(
  buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
  builder: (context, state) => ...,
)

// BlocListener for navigation/snackbars
BlocListener<AuthBloc, AuthState>(
  listenWhen: (prev, curr) => curr.user != null,
  listener: (context, state) => context.go(AppRoutes.home),
  child: child,
)

// BlocSelector to prevent rebuilds
BlocSelector<AuthBloc, AuthState, bool>(
  selector: (state) => state.isLoading,
  builder: (context, isLoading) => ...,
)
```

---

## 🔧 Dependency Injection (get_it)

```dart
// Registrations
sl.registerLazySingleton<Repo>(...);  // Once per app
sl.registerFactory<Bloc>(...);        // New per call

// In UI
BlocProvider(
  create: (_) => sl<LoginBloc>(),
  child: ...,
)
```

---

## ⚠️ Error Handling (Either)

```dart
Future<Either<Failure, User>> login(...);

// In BLoC
result.fold(
  (failure) => emit(state.copyWith(
    errorMessage: failure.message,
    isLoading: false,
  )),
  (data) => emit(state.copyWith(
    data: data,
    isLoading: false,
  )),
);
```

---

## 🎯 Shared Widgets (ALWAYS use these)

```dart
AppTextField()
AppButton()
AppLoading()
AppError(message: '...')
AppEmptyState()
AppCard()
AppImage()
AppSvg()
```

---

## 🚫 DON'Ts (STRICT)

| ❌ Never | ✅ Use Instead |
|---------|---------------|
| Direct API calls in UI | Repository → BLoC |
| setState for complex state | BLoC |
| Hard-coded colors | `context.theme.colorScheme` |
| Direct Dio calls | DataSource layer |
| Import data in presentation | Import domain only |
| Magic numbers | Design tokens |
| Hard-coded strings | `'key'.tr()` localization |

---

## 📝 File Header (EVERY file)

```dart
import 'package:[PROJECT]/core/imports/core_imports.dart';
import 'package:[PROJECT]/core/imports/packages_imports.dart';
import 'package:[PROJECT]/core/injection/injection.dart';
```

---

## 📁 Directory Structure

```
lib/core/
├── imports/              ⭐ BARREL IMPORTS
├── extensions/          ⭐ context.theme, context.go(), etc.
├── injection/           ⭐ get_it setup
├── services/            ⭐ API, Cache, Location
├── theme/
├── routing/
└── shared/widgets/      ⭐ AppButton, AppTextField, etc.

lib/features/feature_name/
├── data/               📊 Models, DataSources, Repo Impl
├── domain/             🧠 Entities, Interfaces, UseCases
└── presentation/       🎨 BLoC, Pages, Widgets
```

---

## ✨ Naming Conventions

| What | Convention | Example |
|------|-----------|---------|
| Files | snake_case | `user_repository.dart` |
| Classes | PascalCase | `LoginBloc` |
| Functions/Vars | camelCase | `getUserData()` |
| Private | _leading | `_privateMethod()` |
| Routes | camelCase | `AppRoutes.userProfile` |

---

## 🔄 Data Flow

```
User Action
    ↓
BLoC.add(Event)
    ↓
BLoC.on<Event>()
    ↓
UseCase(params)
    ↓
Repository.method()
    ↓
DataSource.call()
    ↓
emit(State) → UI Updates
```

---

## ✅ Pre-Submission Checklist

- [ ] Uses barrel imports (`core_imports.dart`)
- [ ] Uses `context.theme.colorScheme` (no hard-coded colors)
- [ ] Uses `'key'.tr()` for all strings
- [ ] Uses responsive units (`.w`, `.h`, `.sp`, `.r`)
- [ ] Uses `const` constructors
- [ ] 3 layers: domain/data/presentation
- [ ] Repository interface in domain, impl in data
- [ ] BLoC with Event/State (immutable, Equatable)
- [ ] Page uses BlocProvider
- [ ] BlocBuilder with `buildWhen` optimization
- [ ] BlocListener for navigation/dialogs
- [ ] Handles loading, error, empty states
- [ ] Uses shared widgets (not raw Flutter widgets)

---

**Follow strictly for every file!** 🚀