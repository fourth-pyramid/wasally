---
name: create-bloc
description: Create a new Bloc or Cubit for state management following the project's SafeBloc pattern.
---

When the user asks to create a new Bloc or Cubit, follow these steps:

1. **File Structure**:
   Generate three files under `lib/features/<feature_name>/presentation/bloc/`:
   - `<feature_name>_bloc.dart` (or `<feature_name>_cubit.dart`)
   - `<feature_name>_event.dart` (if using Bloc)
   - `<feature_name>_state.dart`

2. **State Design (`<feature_name>_state.dart`)**:
   - The state must extend `Equatable`.
   - Include a `status` field using `AppStatus` (e.g. `initial`, `loading`, `success`, `failure`).
   - Include an optional `errorMessage` string.
   - Use `const` constructors and provide a `copyWith` method.

3. **Event Design (`<feature_name>_event.dart`)**:
   - Create a base abstract class extending `Equatable`.
   - Add concrete events with `const` constructors.

4. **Bloc Design (`<feature_name>_bloc.dart`)**:
   - Import `package:wassaly/core/imports/imports.dart`.
   - Extend `Bloc` or `Cubit` (which are the safe versions with automatic zone/cancel-token propagation).
   - In event handlers, call the appropriate UseCases, and use `result.fold` to update state:
     ```dart
     result.fold(
       (failure) => emit(state.copyWith(status: AppStatus.failure, errorMessage: failure.message)),
       (data) => emit(state.copyWith(status: AppStatus.success, ...)),
     );
     ```

5. **Dependency Injection**:
   Register the new Bloc/Cubit as a `Factory` in `lib/core/injection/parts/bloc_injection.dart`:
   ```dart
   sl.registerFactory(() => FeatureBloc(sl(), sl()));
   ```
