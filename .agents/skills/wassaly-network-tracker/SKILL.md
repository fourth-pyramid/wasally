---
name: wassaly-network-tracker
description: Guides the usage, integration, and debugging of Wassaly's custom network connectivity and latency tracking system.
---

# Wassaly Network Tracker Skill

Use this skill when implementing new network actions, wrapping UI layouts, or listening to network connection changes in the Wassaly project.

## 1. Network Architecture Components

Wassaly uses a custom network tracking system consisting of three core parts:
1. **`InternetConnectionService`**: A background service that checks raw internet access and pings (`1.1.1.1` on port 53) to detect connection quality (`connected`, `unstable`, `disconnected`).
2. **`InternetConnectionWrapper`**: A top-level widget that listens to the connection service and pops up a responsive status banner overlay.
3. **`runTask<T>`**: A utility method that wraps Dio requests, catches network timeouts or exceptions, and verifies connectivity.

---

## 2. Using `runTask` in Repositories

When implementing repository methods, always use `runTask` and set `requiresNetwork: true` for any remote data fetching operation. This automatically routes connection issues to return a `NetworkFailure` or `ServerFailure`.

Example usage:
```dart
@override
FutureEither<ProductDetails> getProductDetails(String productId) {
  return runTask(
    () => remoteDataSource.getProductDetails(productId),
    requiresNetwork: true,
  );
}
```

---

## 3. Listening to Connectivity Changes in Blocs

If a feature needs to automatically refresh or react when internet connection is restored:
1. Inject `InternetConnectionService` into the BLoC.
2. Listen to `connectivityRestoredStream` or `stateStream`.
3. Dispatch a refresh event when connection is restored.

Example:
```dart
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;
  final InternetConnectionService connectionService;
  StreamSubscription? _networkSub;

  ProductBloc({
    required this.getProductDetailsUseCase,
    required this.connectionService,
  }) : super(ProductInitial()) {
    on<FetchProductEvent>(_onFetchProduct);

    // Automatically trigger reload when internet is restored
    _networkSub = connectionService.connectivityRestoredStream.listen((_) {
      add(const FetchProductEvent(refresh: true));
    });
  }

  @override
  Future<void> close() {
    _networkSub?.cancel();
    return super.close();
  }
}
```

---

## 4. Manual Ping / Refresh Action
To force a latency check or status update immediately (e.g., when a user clicks a "Retry" button on a failure screen):
```dart
ElevatedButton(
  onPressed: () async {
    await sl<InternetConnectionService>().checkNow();
  },
  child: const Text('Try Again'),
);
```
