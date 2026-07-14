---
name: wassaly-bloc-helper
description: Assists in generating, updating, and testing BLoC events and states following the SafeBloc pattern and standard UI state flows in Wassaly.
---

# Wassaly BLoC Helper Skill

Use this skill to guide BLoC logic generation, state lifecycle management, and event validation in the Wassaly project.

## 1. Bloc Structure Guidelines
Every feature BLoC consists of 3 files:
*   `<feature>_bloc.dart`: Event handling, business logic, usecase execution.
*   `<feature>_event.dart`: Declarative input actions.
*   `<feature>_state.dart`: Declarative state outputs.

---

## 2. Strict UI State Requirements

Every BLoC state definition MUST implement at least the following **six standard states** to ensure a uniform loading/rendering behavior across all screens:

1.  **`Initial`**: The state before any action is triggered.
2.  **`Loading`**: Emitted when the data is first being loaded.
3.  **`Success`**: Emitted when data is successfully loaded or operation succeeds (contains the success data).
4.  **`Failure` / `Error`**: Emitted when an exception or Failure is encountered (contains the error message/object).
5.  **`Empty`**: Emitted when the request succeeds but returns an empty list, empty object, or null results.
6.  **`Refreshing` / `Refresh`**: Emitted when updating existing data (e.g. pull-to-refresh or background updates) without showing a full-screen loading shimmer, keeping the previous data visible.

### Example State Blueprint (`<feature_name>_state.dart`):
```dart
part of '<feature_name>_bloc.dart';

abstract class <FeatureName>State extends Equatable {
  const <FeatureName>State();

  @override
  List<Object?> get props => [];
}

class <FeatureName>Initial extends <FeatureName>State {}

class <FeatureName>Loading extends <FeatureName>State {}

class <FeatureName>Success extends <FeatureName>State {
  final <ResultType> data;
  const <FeatureName>Success(this.data);

  @override
  List<Object?> get props => [data];
}

class <FeatureName>Failure extends <FeatureName>State {
  final String message;
  const <FeatureName>Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class <FeatureName>Empty extends <FeatureName>State {}

class <FeatureName>Refreshing extends <FeatureName>State {
  final <ResultType> oldData;
  const <FeatureName>Refreshing(this.oldData);

  @override
  List<Object?> get props => [oldData];
}
```

---

## 3. SafeBloc Pattern
When executing usecases inside BLoC, always wrap async calls in a unified handler to catch unhandled exceptions, keeping emission safe.

Example Pattern:
```dart
Future<void> _onFetchItems(FetchItemsEvent event, Emitter<ItemState> emit) async {
  if (event.isRefresh) {
    if (state is ItemSuccess) {
      emit(ItemRefreshing((state as ItemSuccess).items));
    } else {
      emit(ItemLoading());
    }
  } else {
    emit(ItemLoading());
  }

  final result = await getItemsUseCase(event.param);

  result.fold(
    (failure) => emit(ItemFailure(message: failure.message)),
    (items) {
      if (items.isEmpty) {
        emit(ItemEmpty());
      } else {
        emit(ItemSuccess(items: items));
      }
    },
  );
}
```

---

## 4. Performance Optimization: `BlocSelector` Preference
To reduce unnecessary widget rebuilds and maintain optimal rendering performance, **prefer using `BlocSelector` over `BlocBuilder`** whenever a widget only depends on a specific property, status, or flag within the BLoC state.

### ❌ Suboptimal (Rebuilds on every state change, e.g., error messages or unrelated list updates):
```dart
BlocBuilder<CartBloc, CartState>(
  builder: (context, state) {
    // Rebuilds even if only items inside success list change, or if a coupon is added.
    final isLoading = state is CartLoading;
    return isLoading ? const LoadingIndicator() : const SizedBox.shrink();
  },
);
```

### ✅ Optimal (Only rebuilds when the evaluated value changes):
```dart
BlocSelector<CartBloc, CartState, bool>(
  selector: (state) => state is CartLoading,
  builder: (context, isLoading) {
    // Rebuilds ONLY when isLoading changes from false to true, or vice versa.
    return isLoading ? const LoadingIndicator() : const SizedBox.shrink();
  },
);
```

---

## 5. Writing Unit Tests for BLoC
Use `bloc_test` to verify event-state emissions. Avoid mocking unless necessary; mock only the UseCases.

Example Test Boilerplate:
```dart
blocTest<ItemBloc, ItemState>(
  'emits [ItemLoading, ItemSuccess] when FetchItemsEvent succeeds',
  build: () {
    when(mockGetItemsUseCase(any)).thenAnswer((_) async => Right(tItemsList));
    return ItemBloc(getItemsUseCase: mockGetItemsUseCase);
  },
  act: (bloc) => bloc.add(const FetchItemsEvent(param: 'test')),
  expect: () => [
    ItemLoading(),
    ItemSuccess(items: tItemsList),
  ],
);
```
