---
name: clean-flutter-generator
description: Scaffolds Clean Architecture directories, use cases, BLoCs, and repositories for Flutter features according to the Wassaly pattern.
---

# Clean Flutter Generator Skill

Use this skill to automatically generate directories, models, use cases, and state management setups for any new feature in a Flutter project following the Wassaly pattern.

## 1. Directory Scaffolding

When asked to generate a new feature named `<feature_name>`, execute the following PowerShell command in the terminal from the project root to build the correct directory structure:

```powershell
$f = "lib/features/<feature_name>"; New-Item -ItemType Directory -Force -Path "$f/data/datasources", "$f/data/models", "$f/data/repositories", "$f/domain/entities", "$f/domain/repositories", "$f/domain/usecases", "$f/presentation/bloc", "$f/presentation/pages", "$f/presentation/widgets" | Out-Null; Write-Host "Clean Architecture directories created for: <feature_name>"
```

*Note: Replace `<feature_name>` with the name of the feature in lowercase snake_case (e.g. `product_details`).*

---

## 2. File Generation Templates

Follow these standard boilerplate layouts when creating core files:

### A. UseCase File (`lib/features/<feature_name>/domain/usecases/<action>_usecase.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/failure.dart'; // Adjust core paths as necessary
import '../repositories/<feature_name>_repository.dart';

class <Action>UseCase {
  final <FeatureName>Repository repository;

  const <Action>UseCase(this.repository);

  Future<Either<Failure, <ResultType>>> call(<ParamsType> params) async {
    return await repository.<action>(params);
  }
}
```

### B. Repository Interface (`lib/features/<feature_name>/domain/repositories/<feature_name>_repository.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/failure.dart';

abstract class <FeatureName>Repository {
  Future<Either<Failure, <ResultType>>> <action>(<ParamsType> params);
}
```

### C. Repository Implementation (`lib/features/<feature_name>/data/repositories/<feature_name>_repository_impl.dart`)
```dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/failure.dart';
import '../../domain/repositories/<feature_name>_repository.dart';
import '../datasources/<feature_name>_remote_data_source.dart';

class <FeatureName>RepositoryImpl implements <FeatureName>Repository {
  final <FeatureName>RemoteDataSource remoteDataSource;

  const <FeatureName>RepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, <ResultType>>> <action>(<ParamsType> params) async {
    try {
      final result = await remoteDataSource.<action>(params);
      return Right(result);
    } on Exception catch (e) {
      return Left(ServerFailure(e.toString())); // Adjust failure types mapping
    }
  }
}
```

### D. BLoC Boilerplate (`lib/features/<feature_name>/presentation/bloc/`)

#### Event (`lib/features/<feature_name>/presentation/bloc/<feature_name>_event.dart`)
```dart
part of '<feature_name>_bloc.dart';

abstract class <FeatureName>Event extends Equatable {
  const <FeatureName>Event();

  @override
  List<Object?> get props => [];
}

class Get<FeatureName>DataEvent extends <FeatureName>Event {
  final String id;
  const Get<FeatureName>DataEvent(this.id);

  @override
  List<Object?> get props => [id];
}
```

#### State (`lib/features/<feature_name>/presentation/bloc/<feature_name>_state.dart`)
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
```

#### BLoC (`lib/features/<feature_name>/presentation/bloc/<feature_name>_bloc.dart`)
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_<feature_name>_usecase.dart';

part '<feature_name>_event.dart';
part '<feature_name>_state.dart';

class <FeatureName>Bloc extends Bloc<<FeatureName>Event, <FeatureName>State> {
  final Get<FeatureName>UseCase get<FeatureName>UseCase;

  <FeatureName>Bloc({required this.get<FeatureName>UseCase}) : super(<FeatureName>Initial()) {
    on<Get<FeatureName>DataEvent>(_onGetData);
  }

  Future<void> _onGetData(Get<FeatureName>DataEvent event, Emitter<<FeatureName>State> emit) async {
    emit(<FeatureName>Loading());
    final result = await get<FeatureName>UseCase(event.id);
    result.fold(
      (failure) => emit(<FeatureName>Failure(failure.message)),
      (data) => emit(<FeatureName>Success(data)),
    );
  }
}
```

---

## 3. ScreenUtil Responsive Check
When creating or editing a presentation Widget:
1. Ensure all `Padding`, `Margin`, `SizedBox` heights/widths, and fonts are wrapped in dynamic scaling functions:
   * Widths / horizontal margins: `.w` (e.g. `SizedBox(width: 8.w)`)
   * Heights / vertical margins: `.h` (e.g. `SizedBox(height: 16.h)`)
   * Borders / Radii: `.r` (e.g. `BorderRadius.circular(12.r)`)
   * Fonts: `.sp` (e.g. `fontSize: 16.sp`)
