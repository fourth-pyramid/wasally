---
name: create-api-call
description: Implement a new API or network request in DataSources, Repositories, UseCases, and Blocs.
---

When the user asks to add a new network call or API request, follow these steps:

1. **Remote DataSource**:
   - Define the method in the DataSource interface (e.g., `lib/features/<feature_name>/data/datasources/<feature_name>_remote_datasource.dart`).
   - Implement the method in the DataSource implementation using `DioService`:
     ```dart
     final response = await _dioService.get('/api/endpoint'); // or post, put, delete
     ```

2. **Repository Implementation**:
   - Define the method in the Repository interface (e.g., `lib/features/<feature_name>/domain/repositories/<feature_name>_repository.dart`).
   - Implement it in the Repository implementation, returning `Either<Failure, T>`.
   - Wrap the call in a `try-catch` block:
     ```dart
     try {
       final result = await _remoteDataSource.someMethod();
       return Right(result);
     } on Failure catch (e) {
       return Left(e);
     } on Object catch (e) {
       return Left(ServerFailure(e.toString()));
     }
     ```

3. **UseCase**:
   - Create a single-responsibility UseCase class in `lib/features/<feature_name>/domain/usecases/`.
   - Register it as a `LazySingleton` in `lib/core/injection/parts/usecase_injection.dart`.

4. **Bloc/Cubit Integration**:
   - Call the UseCase inside the Bloc/Cubit and handle the result using `.fold(...)` to transition the state.
