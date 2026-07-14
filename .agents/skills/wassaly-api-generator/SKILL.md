---
name: wassaly-api-generator
description: Generates remote data sources, model DTOs, and serialization logic for remote REST APIs using Dio and fpdart in Wassaly.
---

# Wassaly API Generator Skill

Use this skill to scaffold Dio-based REST API data source interfaces, implementation classes, and model files.

## 1. Remote Data Source Boilerplate
Data sources must catch external network exceptions and throw local exceptions (e.g. `ServerException`), which are then caught and converted to `Failure` instances inside repositories.

Example DataSource:
```dart
import 'package:dio/dio.dart';
import '../../../../core/network/exceptions.dart';
import '../models/<model_name>_model.dart';

abstract class <FeatureName>RemoteDataSource {
  Future<<ModelName>Model> getDetails(String id);
}

class <FeatureName>RemoteDataSourceImpl implements <FeatureName>RemoteDataSource {
  final Dio dio;

  const <FeatureName>RemoteDataSourceImpl({required this.dio});

  @override
  Future<<ModelName>Model> getDetails(String id) async {
    try {
      final response = await dio.get('/endpoints/$id');
      if (response.statusCode == 200) {
        return <ModelName>Model.fromJson(response.data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
```

## 2. Model DTO Boilerplate
Models should extend domain entities. They contain the `fromJson` factory constructor, the `toJson` map serializer, and a helper to convert back to entities if there is a distinct difference.

Example Model:
```dart
import '../../domain/entities/<entity_name>.dart';

class <ModelName>Model extends <EntityName> {
  const <ModelName>Model({
    required super.id,
    required super.title,
  });

  factory <ModelName>Model.fromJson(Map<String, dynamic> json) {
    return <ModelName>Model(
      id: json['id'] as String,
      title: json['title'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}
```
