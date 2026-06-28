---
name: create-feature
description: Create a new Flutter feature following the 3-Layer Clean Architecture structure.
---

When the user asks to create a new feature (e.g., `<feature_name>`), follow these steps:

1. **Directory Structure**:
   Create the following folders under `lib/features/<feature_name>/`:
   - `data/models/`
   - `data/datasources/`
   - `data/repositories/`
   - `domain/entities/`
   - `domain/repositories/`
   - `domain/usecases/`
   - `presentation/bloc/`
   - `presentation/screens/`
   - `presentation/widgets/`

2. **Core Layers Boilerplate**:
   - **Domain Entity**: Create `<feature_name>_entity.dart` extending `Equatable`.
   - **Domain Repository Interface**: Create `<feature_name>_repository.dart` defining the abstract class.
   - **Data Model**: Create `<feature_name>_model.dart` extending the entity and adding `fromJson`/`toJson`.
   - **Data Source**: Create `<feature_name>_remote_data_source.dart` using `DioService`.
   - **Data Repository Implementation**: Create `<feature_name>_repository_impl.dart`.
   - **Presentation Bloc/Cubit**: Create the state and bloc/cubit extending `SafeBloc` or `SafeCubit`.

3. **Dependency Injection**:
   Remind the user (or automatically register if possible) to add registrations in `lib/core/injection/parts/`:
   - Data Source -> `initDataSourceDependencies()`
   - Repository -> `initRepositoryDependencies()`
   - UseCases -> `initUseCaseDependencies()`
   - Bloc/Cubit -> `initBlocDependencies()`
