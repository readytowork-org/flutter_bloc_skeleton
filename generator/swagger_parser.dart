// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

/// A robust Swagger-to-Feature generator for Clean Architecture.
/// Supports inline schemas, allOf merging, entities, mappers, and camelCase.
/// UPDATED: Sanitizes illegal characters ({, }) in filenames and identifiers.
void main(List<String> args) async {
  if (args.length < 2) {
    print(
      '❌ Usage: dart generator/swagger_parser.dart <FeatureTag> <PathToSwaggerJson>',
    );
    return;
  }

  final String targetTag = args[0];
  final String jsonPath = args[1];
  final String featureName = _toSnakeCase(targetTag);

  print('🚀 Starting Robust Swagger Parser for Feature: $targetTag...');

  final file = File(jsonPath);
  if (!file.existsSync()) {
    print('❌ Error: $jsonPath not found.');
    return;
  }

  final jsonStr = await file.readAsString();
  final Map<String, dynamic> data = json.decode(jsonStr);

  final baseDir = 'lib/features/$featureName';
  _createDirectories(baseDir);

  final schemas =
      (data['components']?['schemas'] as Map<String, dynamic>?) ?? {};
  final paths = (data['paths'] as Map<String, dynamic>?) ?? {};

  final Map<String, Map<String, dynamic>> syntheticSchemas = {};

  String getItemType(String originalName) {
    final schema = schemas[originalName] ?? syntheticSchemas[originalName];
    if (schema == null) return 'dynamic';
    if (schema['type'] == 'array') {
      final items = schema['items'] as Map<String, dynamic>?;
      if (items != null && items.containsKey('\$ref')) {
        return _cleanName((items['\$ref'] as String).split('/').last);
      }
      return 'dynamic';
    }
    if (schema.containsKey('properties')) {
      final props = schema['properties'] as Map<String, dynamic>;
      for (final prop in props.values) {
        if (prop['type'] == 'array') {
          final items = prop['items'] as Map<String, dynamic>?;
          if (items != null && items.containsKey('\$ref')) {
            return _cleanName((items['\$ref'] as String).split('/').last);
          }
        }
      }
    }
    return 'dynamic';
  }

  // 1. Discover Paths and Inline Schemas
  final List<GeneratedEndpoint> endpoints = [];

  paths.forEach((path, methods) {
    (methods as Map<String, dynamic>).forEach((method, details) {
      // TAG FALLBACK + SANITIZATION
      final rawPathSegments = path
          .split('/')
          .where((s) => s.isNotEmpty)
          .toList();
      final cleanPathSegments = rawPathSegments.map(_cleanPathSegment).toList();

      final fallbackTag = cleanPathSegments.isNotEmpty
          ? cleanPathSegments[0]
          : 'default';
      final tags =
          (details['tags'] as List<dynamic>?)
              ?.map((e) => e.toString().toLowerCase())
              .toList() ??
          [fallbackTag.toLowerCase()];

      if (tags.contains(targetTag.toLowerCase())) {
        // OPERATION ID FALLBACK + SANITIZATION
        var operationId = details['operationId'] as String?;
        if (operationId == null) {
          final camelPath = cleanPathSegments.map(_capitalize).join('');
          operationId = '${method.toLowerCase()}$camelPath';
        }

        final cleanOperationId = _sanitizeKey(operationId);
        final parts = cleanOperationId.split('_');
        final cleanName = parts.length > 1 ? parts[1] : cleanOperationId;

        final responseRawName = _handleResponseSchemaRaw(
          details,
          cleanName,
          syntheticSchemas,
        );

        endpoints.add(
          GeneratedEndpoint(
            path: path,
            method: method,
            methodName: cleanName,
            returnTypeRaw: responseRawName,
            details: details,
          ),
        );
      }
    });
  });

  if (endpoints.isEmpty) {
    print('⚠️ Warning: No endpoints found for tag "$targetTag".');
    return;
  }

  // 2. Discover Schema Dependencies (using original names)
  final Set<String> modelsToGenerateOriginal = {};
  for (final endpoint in endpoints) {
    if (endpoint.returnTypeRaw != 'dynamic') {
      modelsToGenerateOriginal.add(endpoint.returnTypeRaw);
    }
    final reqRef = _getSchemaRef(endpoint.details['requestBody'] ?? {});
    if (reqRef != null) modelsToGenerateOriginal.add(reqRef);
  }

  final Set<String> finalModelsOriginalNames = {};
  void discover(String originalName) {
    if (finalModelsOriginalNames.contains(originalName)) return;
    finalModelsOriginalNames.add(originalName);

    final schema = schemas[originalName] ?? syntheticSchemas[originalName];
    if (schema != null) {
      final props = _resolveProperties(schema, schemas);
      props.forEach((key, value) {
        final ref = _getSchemaRefFromProp(value);
        if (ref != null) discover(ref);
      });
    }
  }

  modelsToGenerateOriginal.forEach(discover);

  // 3. Generate Models & Entities
  for (final originalName in finalModelsOriginalNames) {
    final schema = schemas[originalName] ?? syntheticSchemas[originalName];
    if (schema != null) {
      _generateModel(originalName, schema, '$baseDir/data/models', schemas);
      _generateEntity(
        originalName,
        schema,
        '$baseDir/domain/entities',
        schemas,
      );
    }
  }

  // 4. Generate Domain Layer
  _generateRepositoryInterface(
    targetTag,
    endpoints,
    '$baseDir/domain/repositories',
  );
  for (final endpoint in endpoints) {
    _generateUseCase(endpoint, '$baseDir/domain/usecases', targetTag);
  }

  // 5. Generate Data Layer
  _generateRemoteDataSource(targetTag, endpoints, '$baseDir/data/datasources');
  _generateRemoteDataSourceImpl(
    targetTag,
    endpoints,
    '$baseDir/data/datasources',
  );
  _generateRepositoryImpl(targetTag, endpoints, '$baseDir/data/repositories');
  // 6. Generate Presentation Layer
  final List<GeneratedEndpoint> listEndpoints = [];
  final List<GeneratedEndpoint> detailsEndpoints = [];
  final List<GeneratedEndpoint> addEndpoints = [];
  final List<GeneratedEndpoint> editEndpoints = [];
  final List<GeneratedEndpoint> deleteEndpoints = [];

  for (final ep in endpoints) {
    final pathHasId = ep.path.contains('{id}');
    final method = ep.method.toLowerCase();

    if (method == 'get') {
      if (pathHasId) {
        detailsEndpoints.add(ep);
      } else {
        listEndpoints.add(ep);
      }
    } else if (method == 'post') {
      addEndpoints.add(ep);
    } else if (method == 'put' || method == 'patch') {
      editEndpoints.add(ep);
    } else if (method == 'delete') {
      deleteEndpoints.add(ep);
    }
  }

  for (final ep in endpoints) {
    final isList = listEndpoints.contains(ep);
    final itemType = isList ? getItemType(ep.returnTypeRaw) : null;
    final method = ep.method.toLowerCase();
    _generateBloc(
      ep,
      '$baseDir/presentation/bloc/$method',
      targetTag,
      isList: isList,
      itemType: itemType,
      method: method,
    );
  }

  final List<String> pageTypes = [];
  if (listEndpoints.isNotEmpty) {
    final ep = listEndpoints[0];
    final itemType = getItemType(ep.returnTypeRaw);
    _generateListPage(
      targetTag,
      ep,
      deleteEndpoints,
      '$baseDir/presentation/pages',
      itemType,
    );
    pageTypes.add('list');
  }
  if (detailsEndpoints.isNotEmpty) {
    _generateDetailsPage(
      targetTag,
      detailsEndpoints[0],
      '$baseDir/presentation/pages',
    );
    pageTypes.add('details');
  }
  if (addEndpoints.isNotEmpty) {
    _generateAddPage(targetTag, addEndpoints[0], '$baseDir/presentation/pages');
    pageTypes.add('add');
  }
  if (editEndpoints.isNotEmpty) {
    _generateEditPage(
      targetTag,
      editEndpoints[0],
      '$baseDir/presentation/pages',
    );
    pageTypes.add('edit');
  }

  // 7. Generate DI and Routing
  _generateDI(targetTag, endpoints, listEndpoints, baseDir);
  _generateRoutePaths(targetTag, pageTypes, '$baseDir/presentation/routes');
  _generateRoutes(targetTag, pageTypes, '$baseDir/presentation/routes');
  _generateFeatureEntry(targetTag, baseDir);

  // 8. Update Global ApiEndpoints
  _updateApiEndpoints(endpoints);

  print('✅ Feature $targetTag generated successfully in $baseDir');
}

void _updateApiEndpoints(List<GeneratedEndpoint> endpoints) {
  final file = File('lib/core/network/api_endpoints.dart');
  if (!file.existsSync()) return;

  List<String> lines = file.readAsLinesSync();
  final lastLineIndex = lines.lastIndexWhere((line) => line.contains('}'));
  if (lastLineIndex == -1) return;

  bool updated = false;
  for (final ep in endpoints) {
    final constantName = ep.methodName;
    final exists = lines.any(
      (line) => line.contains('static const String $constantName ='),
    );
    if (!exists) {
      lines.insert(
        lastLineIndex,
        "  static const String $constantName = '${ep.path}';",
      );
      updated = true;
    }
  }

  if (updated) {
    file.writeAsStringSync(lines.join('\n'));
    print('📝 Updated lib/core/network/api_endpoints.dart with new constants.');
  }
}

class GeneratedEndpoint {
  final String path;
  final String method;
  final String methodName;
  final String returnTypeRaw; // Original Swagger Name
  final Map<String, dynamic> details;

  GeneratedEndpoint({
    required this.path,
    required this.method,
    required this.methodName,
    required this.returnTypeRaw,
    required this.details,
  });

  String get returnTypeModel => returnTypeRaw == 'dynamic'
      ? 'dynamic'
      : '${_cleanName(returnTypeRaw)}Model';
  String get returnTypeEntity => returnTypeRaw == 'dynamic'
      ? 'dynamic'
      : '${_cleanName(returnTypeRaw)}Entity';
}

void _createDirectories(String baseDir) {
  final dirs = [
    '$baseDir/data/datasources',
    '$baseDir/data/models',
    '$baseDir/data/repositories',
    '$baseDir/domain/entities',
    '$baseDir/domain/repositories',
    '$baseDir/domain/usecases',
    '$baseDir/presentation/bloc/get',
    '$baseDir/presentation/bloc/post',
    '$baseDir/presentation/bloc/put',
    '$baseDir/presentation/bloc/patch',
    '$baseDir/presentation/bloc/delete',
    '$baseDir/presentation/pages',
    '$baseDir/presentation/routes',
  ];
  for (final dir in dirs) {
    Directory(dir).createSync(recursive: true);
  }
}

String _handleResponseSchemaRaw(
  Map<String, dynamic> details,
  String methodName,
  Map<String, Map<String, dynamic>> synthetic,
) {
  final responses = details['responses'] as Map<String, dynamic>?;
  final successRes = responses?['200'] ?? responses?['201'];
  if (successRes == null) return 'dynamic';

  final ref = _getSchemaRef(successRes);
  if (ref != null) return ref;

  final content = successRes['content'] as Map<String, dynamic>?;
  final schema =
      content?['application/json']?['schema'] as Map<String, dynamic>?;
  if (schema != null &&
      (schema['type'] == 'object' || schema.containsKey('properties'))) {
    final syntheticName = '${_capitalize(methodName)}Response';
    synthetic[syntheticName] = schema;
    return syntheticName;
  }

  return 'dynamic';
}

String? _getSchemaRef(Map<String, dynamic> container) {
  final content = container['content'] as Map<String, dynamic>?;
  final schema = content?['application/json']?['schema'] ?? container['schema'];
  if (schema == null) return null;

  if (schema['\$ref'] != null) {
    return (schema['\$ref'] as String).split('/').last;
  }
  if (schema['items'] != null && schema['items']['\$ref'] != null) {
    return (schema['items']['\$ref'] as String).split('/').last;
  }
  return null;
}

String? _getSchemaRefFromProp(Map<String, dynamic> prop) {
  if (prop['\$ref'] != null) return (prop['\$ref'] as String).split('/').last;
  if (prop['items'] != null && prop['items']['\$ref'] != null) {
    return (prop['items']['\$ref'] as String).split('/').last;
  }
  return null;
}

Map<String, dynamic> _resolveProperties(
  Map<String, dynamic> schema,
  Map<String, dynamic> allSchemas,
) {
  Map<String, dynamic> combined = {};

  if (schema.containsKey('allOf')) {
    final List<dynamic> allOf = schema['allOf'];
    for (final item in allOf) {
      if (item.containsKey('\$ref')) {
        final refName = (item['\$ref'] as String).split('/').last;
        final refSchema = allSchemas[refName];
        if (refSchema != null) {
          combined.addAll(_resolveProperties(refSchema, allSchemas));
        }
      } else if (item.containsKey('properties')) {
        combined.addAll(item['properties']);
      }
    }
  }

  if (schema.containsKey('properties')) {
    combined.addAll(schema['properties']);
  }

  return combined;
}

void _generateModel(
  String originalName,
  Map<String, dynamic> schema,
  String outputDir,
  Map<String, dynamic> allSchemas,
) {
  final cleanName = _cleanName(originalName);
  final fileName = _toSnakeCase(cleanName);
  final props = _resolveProperties(schema, allSchemas);
  final requiredFields =
      (schema['required'] as List<dynamic>?)?.cast<String>() ?? [];

  final Set<String> imports = {};
  props.forEach((key, value) {
    final ref = _getSchemaRefFromProp(value);
    if (ref != null && ref != originalName) {
      final refClean = _cleanName(ref);
      imports.add("import '${_toSnakeCase(refClean)}_model.dart';");
    }
  });

  StringBuffer body = StringBuffer();
  body.writeln("import 'package:freezed_annotation/freezed_annotation.dart';");
  body.writeln("import '../../domain/entities/${fileName}_entity.dart';");
  for (final imp in imports) {
    body.writeln(imp);
  }
  body.writeln();
  body.writeln("part '${fileName}_model.freezed.dart';");
  body.writeln("part '${fileName}_model.g.dart';");
  body.writeln();
  body.writeln("@freezed");
  body.writeln("abstract class ${cleanName}Model with _\$${cleanName}Model {");
  body.writeln("  const factory ${cleanName}Model({");

  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    final isRequired = requiredFields.contains(key);
    final type = _getDartType(value, suffix: 'Model', isRequired: isRequired);

    if (isRequired) {
      final defaultValue = _getDefaultValue(type);
      body.writeln("    @Default($defaultValue) $type $camelKey,");
    } else {
      body.writeln("     $type $camelKey,");
    }
  });

  body.writeln("  }) = _${cleanName}Model;");
  body.writeln();
  body.writeln(
    "  factory ${cleanName}Model.fromJson(Map<String, dynamic> json) => _\$${cleanName}ModelFromJson(json);",
  );
  body.writeln();
  body.writeln(
    "  factory ${cleanName}Model.fromEntity(${cleanName}Entity entity) {",
  );
  body.writeln("    return ${cleanName}Model(");
  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    final isRequired = requiredFields.contains(key);
    final type = _getDartType(value, suffix: 'Model', isRequired: isRequired);

    if (type.contains('Model')) {
      if (type.startsWith('List')) {
        final modelType = type
            .replaceAll('List<', '')
            .replaceAll('>?', '')
            .replaceAll('>', '');
        body.writeln(
          "      $camelKey: entity.$camelKey?.map((e) => $modelType.fromEntity(e)).toList() ?? const [],",
        );
      } else {
        final modelType = type.replaceAll('?', '');
        if (isRequired) {
          body.writeln(
            "      $camelKey: $modelType.fromEntity(entity.$camelKey),",
          );
        } else {
          body.writeln(
            "      $camelKey: entity.$camelKey != null ? $modelType.fromEntity(entity.$camelKey!) : null,",
          );
        }
      }
    } else {
      body.writeln("      $camelKey: entity.$camelKey,");
    }
  });
  body.writeln("    );");
  body.writeln("  }");
  body.writeln();
  body.writeln("  const ${cleanName}Model._();");
  body.writeln();
  body.writeln("  ${cleanName}Entity toEntity() {");
  body.writeln("    return ${cleanName}Entity(");
  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    final isRequired = requiredFields.contains(key);
    final type = _getDartType(value, suffix: 'Model', isRequired: isRequired);

    if (type.contains('Model')) {
      if (type.startsWith('List')) {
        body.writeln(
          "      $camelKey: $camelKey?.map((e) => e.toEntity()).toList() ?? const [],",
        );
      } else {
        if (isRequired) {
          body.writeln("      $camelKey: $camelKey.toEntity(),");
        } else {
          body.writeln("      $camelKey: $camelKey?.toEntity(),");
        }
      }
    } else {
      body.writeln("      $camelKey: $camelKey,");
    }
  });
  body.writeln("    );");
  body.writeln("  }");
  body.writeln("}");

  File('$outputDir/${fileName}_model.dart').writeAsStringSync(body.toString());
}

String _getDefaultValue(String type) {
  if (type.startsWith('List')) return 'const []';
  if (type.startsWith('String')) return "''";
  if (type.startsWith('num') || type.startsWith('int')) return '0';
  if (type.startsWith('bool')) return 'false';
  if (type.contains('Model')) {
    final clean = type.replaceAll('?', '');
    return 'const $clean()';
  }
  return 'null';
}

void _generateEntity(
  String originalName,
  Map<String, dynamic> schema,
  String outputDir,
  Map<String, dynamic> allSchemas,
) {
  final cleanName = _cleanName(originalName);
  final fileName = _toSnakeCase(cleanName);
  final props = _resolveProperties(schema, allSchemas);
  final requiredFields =
      (schema['required'] as List<dynamic>?)?.cast<String>() ?? [];

  final Set<String> imports = {};
  props.forEach((key, value) {
    final ref = _getSchemaRefFromProp(value);
    if (ref != null && ref != originalName) {
      final refClean = _cleanName(ref);
      imports.add("import '${_toSnakeCase(refClean)}_entity.dart';");
    }
  });

  StringBuffer body = StringBuffer();
  for (final imp in imports) {
    body.writeln(imp);
  }
  body.writeln();
  body.writeln("class ${cleanName}Entity {");

  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    final isRequired = requiredFields.contains(key);
    final type = _getDartType(value, suffix: 'Entity', isRequired: isRequired);
    body.writeln("  final $type $camelKey;");
  });

  body.writeln();
  body.writeln("  const ${cleanName}Entity({");
  props.forEach((key, value) {
    final camelKey = _toCamelCase(_sanitizeKey(key));
    final isRequired = requiredFields.contains(key);
    if (isRequired) {
      body.writeln("    required this.$camelKey,");
    } else {
      body.writeln("    this.$camelKey,");
    }
  });
  body.writeln("  });");
  body.writeln("}");

  File('$outputDir/${fileName}_entity.dart').writeAsStringSync(body.toString());
}

void _generateUseCase(
  GeneratedEndpoint endpoint,
  String outputDir,
  String featureTag,
) {
  final ucName = '${_capitalize(endpoint.methodName)}UseCase';
  final fileName = '${_toSnakeCase(endpoint.methodName)}_usecase.dart';
  final repoName = '${featureTag}Repository';
  final repoFileName = '${_toSnakeCase(featureTag)}_repository.dart';
  final entityName = endpoint.returnTypeEntity;

  final reqRef = _getSchemaRef(endpoint.details['requestBody'] ?? {});
  final reqClean = reqRef != null ? _cleanName(reqRef) : null;

  StringBuffer body = StringBuffer();
  body.writeln("import '../../../../core/network/api_result.dart';");
  body.writeln("import '../repositories/$repoFileName';");

  final List<String> imports = [];
  if (endpoint.returnTypeRaw != 'dynamic') {
    imports.add(
      "import '../entities/${_toSnakeCase(_cleanName(endpoint.returnTypeRaw))}_entity.dart';",
    );
  }
  if (reqClean != null) {
    imports.add("import '../entities/${_toSnakeCase(reqClean)}_entity.dart';");
  }
  imports.sort();
  for (final imp in imports) {
    body.writeln(imp);
  }

  body.writeln();
  body.writeln("class $ucName {");
  body.writeln("  final $repoName _repository;");
  body.writeln();
  body.writeln("  $ucName(this._repository);");

  body.writeln();
  if (reqClean != null) {
    body.writeln(
      "  Future<ApiResult<$entityName>> call(${reqClean}Entity input) async {",
    );
    body.writeln("    return await _repository.${endpoint.methodName}(input);");
  } else {
    body.writeln("  Future<ApiResult<$entityName>> call() async {");
    body.writeln("    return await _repository.${endpoint.methodName}();");
  }
  body.writeln("  }");
  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

void _generateRepositoryInterface(
  String feature,
  List<GeneratedEndpoint> endpoints,
  String outputDir,
) {
  final name = '${feature}Repository';
  final fileName = '${_toSnakeCase(feature)}_repository.dart';

  StringBuffer body = StringBuffer();
  body.writeln("import '../../../../core/network/api_result.dart';");

  final List<String> imports = [];
  final Set<String> neededRawNames = {};
  for (final ep in endpoints) {
    if (ep.returnTypeRaw != 'dynamic') neededRawNames.add(ep.returnTypeRaw);
    final reqRef = _getSchemaRef(ep.details['requestBody'] ?? {});
    if (reqRef != null) neededRawNames.add(reqRef);
  }
  for (final raw in neededRawNames) {
    imports.add(
      "import '../entities/${_toSnakeCase(_cleanName(raw))}_entity.dart';",
    );
  }
  imports.sort();
  for (final imp in imports) {
    body.writeln(imp);
  }

  body.writeln();
  body.writeln("abstract class $name {");
  for (final ep in endpoints) {
    final reqRef = _getSchemaRef(ep.details['requestBody'] ?? {});
    final reqClean = reqRef != null ? _cleanName(reqRef) : null;

    if (reqClean != null) {
      body.writeln(
        "  Future<ApiResult<${ep.returnTypeEntity}>> ${ep.methodName}(${reqClean}Entity input);",
      );
    } else {
      body.writeln(
        "  Future<ApiResult<${ep.returnTypeEntity}>> ${ep.methodName}();",
      );
    }
  }
  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

void _generateRemoteDataSource(
  String feature,
  List<GeneratedEndpoint> endpoints,
  String outputDir,
) {
  final name = '${feature}RemoteDataSource';
  final fileName = '${_toSnakeCase(feature)}_remote_datasource.dart';

  StringBuffer body = StringBuffer();

  final List<String> modelImports = [];
  final Set<String> neededModels = {};
  for (final ep in endpoints) {
    if (ep.returnTypeRaw != 'dynamic') neededModels.add(ep.returnTypeRaw);
    final reqRef = _getSchemaRef(ep.details['requestBody'] ?? {});
    if (reqRef != null) neededModels.add(reqRef);
  }
  for (final raw in neededModels) {
    modelImports.add(
      "import '../models/${_toSnakeCase(_cleanName(raw))}_model.dart';",
    );
  }
  modelImports.sort();
  for (final imp in modelImports) {
    body.writeln(imp);
  }

  body.writeln();
  body.writeln("abstract class $name {");

  for (final ep in endpoints) {
    final reqRef = _getSchemaRef(ep.details['requestBody'] ?? {});
    final reqClean = reqRef != null ? _cleanName(reqRef) : null;
    if (reqClean != null) {
      body.writeln(
        "  Future<${ep.returnTypeModel}> ${ep.methodName}(${reqClean}Model input);",
      );
    } else {
      body.writeln("  Future<${ep.returnTypeModel}> ${ep.methodName}();");
    }
  }

  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

void _generateRemoteDataSourceImpl(
  String feature,
  List<GeneratedEndpoint> endpoints,
  String outputDir,
) {
  final name = '${feature}RemoteDataSourceImpl';
  final interfaceName = '${feature}RemoteDataSource';
  final fileName = '${_toSnakeCase(feature)}_remote_datasource_impl.dart';
  final interfaceFileName = '${_toSnakeCase(feature)}_remote_datasource.dart';

  StringBuffer body = StringBuffer();
  body.writeln("import '../../../../core/network/api_endpoints.dart';");
  body.writeln("import '../../../../core/network/dio_client.dart';");
  body.writeln("import '$interfaceFileName';");

  final Set<String> neededModels = {};
  for (final ep in endpoints) {
    if (ep.returnTypeRaw != 'dynamic') neededModels.add(ep.returnTypeRaw);
    final reqRef = _getSchemaRef(ep.details['requestBody'] ?? {});
    if (reqRef != null) neededModels.add(reqRef);
  }
  final List<String> sortedModelImports = [];
  for (final raw in neededModels) {
    sortedModelImports.add(
      "import '../models/${_toSnakeCase(_cleanName(raw))}_model.dart';",
    );
  }
  sortedModelImports.sort();
  for (final imp in sortedModelImports) {
    body.writeln(imp);
  }

  body.writeln();
  body.writeln("class $name implements $interfaceName {");
  body.writeln("  final DioClient _dioClient;");
  body.writeln();
  body.writeln("  $name(this._dioClient);");

  for (final ep in endpoints) {
    final reqRef = _getSchemaRef(ep.details['requestBody'] ?? {});
    final reqClean = reqRef != null ? _cleanName(reqRef) : null;

    body.writeln();
    body.writeln("  @override");
    if (reqClean != null) {
      body.writeln(
        "  Future<${ep.returnTypeModel}> ${ep.methodName}(${reqClean}Model input) async {",
      );
      body.writeln(
        "    final response = await _dioClient.${ep.method}(ApiEndpoints.${ep.methodName}, data: input.toJson());",
      );
    } else {
      body.writeln(
        "  Future<${ep.returnTypeModel}> ${ep.methodName}() async {",
      );
      body.writeln(
        "    final response = await _dioClient.${ep.method}(ApiEndpoints.${ep.methodName});",
      );
    }
    if (ep.returnTypeRaw == 'dynamic') {
      body.writeln("    return response.data;");
    } else {
      body.writeln("    if (response.data == null) {");
      if (ep.returnTypeModel.startsWith('List')) {
        body.writeln("      return const [];");
      } else {
        body.writeln("      return const ${ep.returnTypeModel}();");
      }
      body.writeln("    }");
      body.writeln("    return ${ep.returnTypeModel}.fromJson(response.data);");
    }
    body.writeln("  }");
  }

  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

void _generateRepositoryImpl(
  String feature,
  List<GeneratedEndpoint> endpoints,
  String outputDir,
) {
  final name = '${feature}RepositoryImpl';
  final interfaceName = '${feature}Repository';
  final dsName = '${feature}RemoteDataSource';
  final fileName = '${_toSnakeCase(feature)}_repository_impl.dart';
  final interfaceFileName = '${_toSnakeCase(feature)}_repository.dart';
  final dsFileName = '${_toSnakeCase(feature)}_remote_datasource.dart';

  StringBuffer body = StringBuffer();
  body.writeln("import '../../../../core/error/failures.dart';");
  body.writeln("import '../../../../core/network/api_result.dart';");
  body.writeln("import '../../domain/repositories/$interfaceFileName';");
  body.writeln("import '../datasources/$dsFileName';");

  // Only import entity+model for types used directly in method signatures (request bodies).
  // Return-type entities/models are brought in transitively via the datasource import.
  final List<String> sortedImports = [];
  final Set<String> requestBodyNames = {};
  for (final ep in endpoints) {
    final reqRef = _getSchemaRef(ep.details['requestBody'] ?? {});
    if (reqRef != null) requestBodyNames.add(reqRef);
  }
  // Also add the return-type entity for each endpoint (used in ApiResult<X>)
  final Set<String> returnTypeNames = {};
  for (final ep in endpoints) {
    if (ep.returnTypeRaw != 'dynamic') returnTypeNames.add(ep.returnTypeRaw);
  }
  for (final raw in returnTypeNames) {
    final snake = _toSnakeCase(_cleanName(raw));
    sortedImports.add("import '../../domain/entities/${snake}_entity.dart';");
  }
  for (final raw in requestBodyNames) {
    final snake = _toSnakeCase(_cleanName(raw));
    if (!returnTypeNames.contains(raw)) {
      sortedImports.add("import '../../domain/entities/${snake}_entity.dart';");
    }
    sortedImports.add("import '../models/${snake}_model.dart';");
  }
  sortedImports.sort();
  for (final imp in sortedImports) {
    body.writeln(imp);
  }

  body.writeln();
  body.writeln("class $name implements $interfaceName {");
  body.writeln("  final $dsName _remoteDataSource;");
  body.writeln();
  body.writeln("  $name(this._remoteDataSource);");

  for (final ep in endpoints) {
    final reqRef = _getSchemaRef(ep.details['requestBody'] ?? {});
    final reqClean = reqRef != null ? _cleanName(reqRef) : null;

    body.writeln();
    body.writeln("  @override");
    if (reqClean != null) {
      body.writeln(
        "  Future<ApiResult<${ep.returnTypeEntity}>> ${ep.methodName}(${reqClean}Entity input) async {",
      );
      body.writeln("    try {");
      body.writeln(
        "      final result = await _remoteDataSource.${ep.methodName}(${reqClean}Model.fromEntity(input));",
      );
    } else {
      body.writeln(
        "  Future<ApiResult<${ep.returnTypeEntity}>> ${ep.methodName}() async {",
      );
      body.writeln("    try {");
      body.writeln(
        "      final result = await _remoteDataSource.${ep.methodName}();",
      );
    }
    if (ep.returnTypeRaw == 'dynamic') {
      body.writeln("      return ApiResult.success(result);");
    } else {
      body.writeln("      return ApiResult.success(result.toEntity());");
    }
    body.writeln("    } catch (e) {");
    body.writeln(
      "      return ApiResult.failure(ServerFailure(e.toString()));",
    );
    body.writeln("    }");
    body.writeln("  }");
  }

  body.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(body.toString());
}

String _cleanPathSegment(String segment) {
  return segment.replaceAll('{', '').replaceAll('}', '');
}

String _cleanName(String name) {
  return name.replaceAll('DTO', '').replaceAll('Dto', '');
}

String _sanitizeKey(String key) {
  return key
      .replaceAll(RegExp(r'[^\w]'), '_')
      .replaceAll('{', '')
      .replaceAll('}', '');
}

String _toCamelCase(String text) {
  if (text.isEmpty) return text;
  final parts = text.split(RegExp(r'[_-\s]'));
  if (parts.length == 1 && parts[0] == parts[0].toLowerCase()) return parts[0];

  final first = parts[0].toLowerCase();
  final rest = parts.sublist(1).map(_capitalize).join('');
  return '$first$rest';
}

String _getDartType(
  Map<String, dynamic> prop, {
  String suffix = '',
  bool isRequired = false,
}) {
  final nullableSuffix = isRequired ? '' : '?';

  if (prop.containsKey('\$ref')) {
    final ref = (prop['\$ref'] as String).split('/').last;
    final cleanRef = _cleanName(ref);
    return '$cleanRef$suffix$nullableSuffix';
  }

  final type = prop['type'];
  switch (type) {
    case 'string':
      return 'String$nullableSuffix';
    case 'number':
      return 'num$nullableSuffix';
    case 'integer':
      return 'int$nullableSuffix';
    case 'boolean':
      return 'bool$nullableSuffix';
    case 'array':
      final items = prop['items'] as Map<String, dynamic>?;
      if (items != null && items.containsKey('\$ref')) {
        final ref = (items['\$ref'] as String).split('/').last;
        final cleanRef = _cleanName(ref);
        return 'List<$cleanRef$suffix>$nullableSuffix';
      }
      return 'List<dynamic>$nullableSuffix';
    default:
      return 'dynamic';
  }
}

String _toSnakeCase(String text) {
  return text
      .replaceAllMapped(
        RegExp(r'([A-Z])'),
        (match) => '_${match.group(1)!.toLowerCase()}',
      )
      .toLowerCase()
      .replaceAll(RegExp(r'^_'), '');
}

String _capitalize(String text) =>
    text.isEmpty ? '' : text[0].toUpperCase() + text.substring(1);

void _generateBloc(
  GeneratedEndpoint endpoint,
  String outputDir,
  String featureTag, {
  bool isList = false,
  String? itemType,
  required String method,
}) {
  final cleanName = endpoint.methodName;
  final snakeName = _toSnakeCase(cleanName);
  final isGet = method.toLowerCase() == 'get';
  final blocName = isList
      ? '${_capitalize(featureTag)}PaginationBloc'
      : '${_capitalize(cleanName)}Bloc';
  final eventName = isList
      ? 'PaginationEvent'
      : '${_capitalize(cleanName)}Event';
  final stateName = isList
      ? 'PaginationState'
      : '${_capitalize(cleanName)}State';
  final useCaseName = '${_capitalize(cleanName)}UseCase';
  final returnType = isList ? '${itemType}Entity' : endpoint.returnTypeEntity;

  final buffer = StringBuffer();
  if (isList) {
    buffer.writeln("import '../../../../../core/network/api_result.dart';");
    buffer.writeln(
      "import '../../../../../shared/bloc/base_pagination_bloc.dart';",
    );
    buffer.writeln(
      "import '../../../../../shared/models/pagination_params.dart';",
    );
    buffer.writeln(
      "import '../../../domain/usecases/${_toSnakeCase(cleanName)}_usecase.dart';",
    );
    buffer.writeln(
      "import '../../../domain/entities/${_toSnakeCase(itemType!)}_entity.dart';",
    );
    buffer.writeln();
    buffer.writeln("class $blocName extends BasePaginationBloc<$returnType> {");
    buffer.writeln("  final $useCaseName _useCase;");
    buffer.writeln();
    buffer.writeln("  $blocName(this._useCase);");
    buffer.writeln();
    buffer.writeln("  @override");
    buffer.writeln(
      "  Future<ApiResult<PaginatedData<$returnType>>> fetchItems(PaginationParams params) async {",
    );
    buffer.writeln("    final result = await _useCase();");
    buffer.writeln("    return result.when(");
    buffer.writeln("      success: (data) => ApiResult.success(");
    buffer.writeln("        PaginatedData<$returnType>(");
    buffer.writeln(
      "          items: data.${_toCamelCase(_toSnakeCase(itemType))}s ?? [],",
    );
    buffer.writeln(
      "          isEnd: (data.skip ?? 0) + (data.limit ?? 0) >= (data.total ?? 0),",
    );
    buffer.writeln("        ),");
    buffer.writeln("      ),");
    buffer.writeln("      failure: (failure) => ApiResult.failure(failure),");
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("}");
  } else {
    buffer.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
    buffer.writeln("import '../../../../../core/network/api_result.dart';");
    buffer.writeln(
      "import '../../../domain/usecases/${_toSnakeCase(cleanName)}_usecase.dart';",
    );
    if (endpoint.returnTypeRaw != 'dynamic') {
      // Return type entity usually not needed directly in Bloc file unless used in state
      // but we import it in the state file usually.
    }
    buffer.writeln("import '${snakeName}_event.dart';");
    buffer.writeln("import '${snakeName}_state.dart';");
    final reqRef = _getSchemaRef(endpoint.details['requestBody'] ?? {});
    final reqClean = reqRef != null ? _cleanName(reqRef) : null;
    // Input entity import lives in the event file; skip it in the bloc file.
    buffer.writeln();
    final statePrefix = _capitalize(cleanName);
    buffer.writeln("class $blocName extends Bloc<$eventName, $stateName> {");
    buffer.writeln("  final $useCaseName _useCase;");
    buffer.writeln();
    buffer.writeln(
      "  $blocName(this._useCase) : super(const ${statePrefix}Initial()) {",
    );
    buffer.writeln(
      "    on<${_capitalize(cleanName)}Started>((event, emit) => emit(const ${statePrefix}Initial()));",
    );
    buffer.writeln("    on<${_capitalize(cleanName)}Executed>(_onExecuted);");
    buffer.writeln("  }");
    buffer.writeln();
    buffer.writeln("  Future<void> _onExecuted(");
    buffer.writeln("    ${_capitalize(cleanName)}Executed event,");
    buffer.writeln("    Emitter<$stateName> emit,");
    buffer.writeln("  ) async {");
    buffer.writeln("    emit(const ${statePrefix}Loading());");
    if (reqClean != null) {
      buffer.writeln("    final result = await _useCase(event.input);");
    } else {
      buffer.writeln("    final result = await _useCase();");
    }
    buffer.writeln("    result.when(");
    buffer.writeln(
      "      success: (data) => emit(${statePrefix}Loaded(res: data)),",
    );
    buffer.writeln(
      "      failure: (failure) => emit(${statePrefix}Failure(message: failure.message)),",
    );
    buffer.writeln("    );");
    buffer.writeln("  }");
    buffer.writeln("}");

    // Generate Event
    final eventBuffer = StringBuffer();
    eventBuffer.writeln(
      "import 'package:freezed_annotation/freezed_annotation.dart';",
    );
    if (reqClean != null) {
      eventBuffer.writeln(
        "import '../../../domain/entities/${_toSnakeCase(reqClean)}_entity.dart';",
      );
    }
    eventBuffer.writeln();
    eventBuffer.writeln("part '${snakeName}_event.freezed.dart';");
    eventBuffer.writeln();
    eventBuffer.writeln("@freezed");
    eventBuffer.writeln("abstract class $eventName with _\$$eventName {");
    eventBuffer.writeln(
      "  const factory $eventName.started() = ${_capitalize(cleanName)}Started;",
    );
    if (reqClean != null) {
      eventBuffer.writeln(
        "  const factory $eventName.executed({required ${reqClean}Entity input}) = ${_capitalize(cleanName)}Executed;",
      );
    } else {
      eventBuffer.writeln(
        "  const factory $eventName.executed() = ${_capitalize(cleanName)}Executed;",
      );
    }
    eventBuffer.writeln("}");
    File(
      '$outputDir/${snakeName}_event.dart',
    ).writeAsStringSync(eventBuffer.toString());

    // Generate State
    final stateBuffer = StringBuffer();
    stateBuffer.writeln(
      "import 'package:freezed_annotation/freezed_annotation.dart';",
    );
    if (isGet) {
      stateBuffer.writeln(
        "import '../../../../../shared/state/base_state.dart';",
      );
    }
    if (endpoint.returnTypeRaw != 'dynamic') {
      stateBuffer.writeln(
        "import '../../../domain/entities/${_toSnakeCase(_cleanName(endpoint.returnTypeRaw))}_entity.dart';",
      );
    }
    stateBuffer.writeln();
    stateBuffer.writeln("part '${snakeName}_state.freezed.dart';");
    stateBuffer.writeln();
    stateBuffer.writeln("@freezed");
    if (isGet) {
      stateBuffer.writeln(
        "sealed class $stateName with _\$$stateName implements BaseState {",
      );
      stateBuffer.writeln("  @Implements<BaseInitial>()");
      stateBuffer.writeln(
        "  const factory $stateName.initial() = ${statePrefix}Initial;",
      );
      stateBuffer.writeln("  @Implements<BaseLoading>()");
      stateBuffer.writeln(
        "  const factory $stateName.loading() = ${statePrefix}Loading;",
      );
      stateBuffer.writeln("  @Implements<BaseLoaded<$returnType>>()");
      stateBuffer.writeln(
        "  const factory $stateName.loaded({required $returnType res}) = ${statePrefix}Loaded;",
      );
      stateBuffer.writeln("  @Implements<BaseFailure>()");
      stateBuffer.writeln(
        "  const factory $stateName.failure({required String message}) = ${statePrefix}Failure;",
      );
    } else {
      stateBuffer.writeln("class $stateName with _\$$stateName {");
      stateBuffer.writeln(
        "  const factory $stateName.initial() = ${statePrefix}Initial;",
      );
      stateBuffer.writeln(
        "  const factory $stateName.loading() = ${statePrefix}Loading;",
      );
      stateBuffer.writeln(
        "  const factory $stateName.loaded({required $returnType res}) = ${statePrefix}Loaded;",
      );
      stateBuffer.writeln(
        "  const factory $stateName.failure({required String message}) = ${statePrefix}Failure;",
      );
    }
    stateBuffer.writeln("}");
    File(
      '$outputDir/${snakeName}_state.dart',
    ).writeAsStringSync(stateBuffer.toString());
  }

  File(
    '$outputDir/${snakeName}_bloc.dart',
  ).writeAsStringSync(buffer.toString());
}

void _generateListPage(
  String featureTag,
  GeneratedEndpoint listEp,
  List<GeneratedEndpoint> deleteEps,
  String outputDir,
  String itemType,
) {
  final featureName = _toSnakeCase(featureTag);
  final blocName = '${_capitalize(featureTag)}PaginationBloc';
  final entityName = '${itemType}Entity';
  final fileName = '${featureName}_list_page.dart';

  final buffer = StringBuffer();
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
  buffer.writeln("import '../../../../../core/di/service_locator.dart';");
  buffer.writeln(
    "import '../../../../../shared/bloc/base_pagination_bloc.dart';",
  );
  buffer.writeln(
    "import '../../../../../shared/widgets/organisms/bloc_pagination_view.dart';",
  );
  buffer.writeln(
    "import '../../../../../shared/widgets/molecules/app_bloc_button.dart';",
  );
  buffer.writeln(
    "import '../bloc/get/${_toSnakeCase(listEp.methodName)}_bloc.dart';",
  );
  buffer.writeln(
    "import '../../domain/entities/${_toSnakeCase(itemType)}_entity.dart';",
  );
  for (final dep in deleteEps) {
    buffer.writeln(
      "import '../bloc/delete/${_toSnakeCase(dep.methodName)}_bloc.dart';",
    );
    buffer.writeln(
      "import '../bloc/delete/${_toSnakeCase(dep.methodName)}_state.dart';",
    );
    buffer.writeln(
      "import '../bloc/delete/${_toSnakeCase(dep.methodName)}_event.dart';",
    );
  }

  buffer.writeln();
  buffer.writeln(
    "class ${_capitalize(featureTag)}ListPage extends StatelessWidget {",
  );
  buffer.writeln("  const ${_capitalize(featureTag)}ListPage({super.key});");
  buffer.writeln();
  buffer.writeln("  @override");
  buffer.writeln("  Widget build(BuildContext context) {");
  buffer.writeln("    return Scaffold(");
  buffer.writeln(
    "      appBar: AppBar(title: const Text('$featureTag List')),",
  );
  buffer.writeln("      body: BlocProvider(");
  buffer.writeln(
    "        create: (context) => sl<$blocName>()..add(const PaginationFetch()),",
  );
  buffer.writeln("        child: BlocPaginationView<$entityName, $blocName>(");
  buffer.writeln("          itemBuilder: (context, item) {");
  buffer.writeln("            return ListTile(");
  buffer.writeln("              title: Text(item.toString()),");
  buffer.writeln("              trailing: Row(");
  buffer.writeln("                mainAxisSize: MainAxisSize.min,");
  buffer.writeln("                children: [");
  for (final dep in deleteEps) {
    final dBloc = '${_capitalize(dep.methodName)}Bloc';
    final dState = '${_capitalize(dep.methodName)}State';
    final dEvent = '${_capitalize(dep.methodName)}Event';
    final dPrefix = _capitalize(dep.methodName);
    buffer.writeln("                  AppBlocButton<$dBloc, $dState>(");
    buffer.writeln("                    bloc: sl<$dBloc>(),");
    buffer.writeln("                    label: 'Delete',");
    buffer.writeln(
      "                    onTap: (bloc) => bloc.add(const $dEvent.executed()),",
    );
    buffer.writeln(
      "                    isLoading: (state) => state is ${dPrefix}Loading,",
    );
    buffer.writeln("                    listener: (context, state) {");
    buffer.writeln("                      if (state is ${dPrefix}Loaded) {");
    buffer.writeln(
      "                         context.read<$blocName>().add(const PaginationRefresh());",
    );
    buffer.writeln("                      }");
    buffer.writeln("                    },");
    buffer.writeln("                  ),");
  }
  buffer.writeln("                ],");
  buffer.writeln("              ),");
  buffer.writeln("            );");
  buffer.writeln("          },");
  buffer.writeln("        ),");
  buffer.writeln("      ),");
  buffer.writeln("    );");
  buffer.writeln("  }");
  buffer.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(buffer.toString());
}

void _generateDetailsPage(
  String featureTag,
  GeneratedEndpoint ep,
  String outputDir,
) {
  final featureName = _toSnakeCase(featureTag);
  final blocName = '${_capitalize(ep.methodName)}Bloc';
  final fileName = '${featureName}_details_page.dart';

  final buffer = StringBuffer();
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
  buffer.writeln("import '../../../../../core/di/service_locator.dart';");
  buffer.writeln(
    "import '../../../../../shared/widgets/molecules/bloc_state_builder.dart';",
  );
  buffer.writeln(
    "import '../bloc/get/${_toSnakeCase(ep.methodName)}_bloc.dart';",
  );
  buffer.writeln(
    "import '../bloc/get/${_toSnakeCase(ep.methodName)}_state.dart';",
  );
  buffer.writeln(
    "import '../bloc/get/${_toSnakeCase(ep.methodName)}_event.dart';",
  );

  buffer.writeln();
  final statePrefix = _capitalize(ep.methodName);
  buffer.writeln(
    "class ${_capitalize(featureTag)}DetailsPage extends StatelessWidget {",
  );
  buffer.writeln("  const ${_capitalize(featureTag)}DetailsPage({super.key});");
  buffer.writeln();
  buffer.writeln("  @override");
  buffer.writeln("  Widget build(BuildContext context) {");
  buffer.writeln("    return Scaffold(");
  buffer.writeln(
    "      appBar: AppBar(title: const Text('$featureTag Details')),",
  );
  final stateName = '${_capitalize(ep.methodName)}State';
  buffer.writeln("      body: BlocProvider(");
  buffer.writeln(
    "        create: (context) => sl<$blocName>()..add(const ${_capitalize(ep.methodName)}Executed()),",
  );
  buffer.writeln("        child: BlocStateBuilder<$blocName, $stateName>(");
  buffer.writeln(
    "          onRetry: (bloc) => bloc.add(const ${_capitalize(ep.methodName)}Executed()),",
  );
  buffer.writeln("          onLoaded: (context, state) {");
  buffer.writeln(
    "            final item = (state as ${statePrefix}Loaded).res;",
  );
  buffer.writeln("            return Padding(");
  buffer.writeln("              padding: const EdgeInsets.all(16.0),");
  buffer.writeln("              child: Text(item.toString()),");
  buffer.writeln("            );");
  buffer.writeln("          },");
  buffer.writeln("        ),");
  buffer.writeln("      ),");
  buffer.writeln("    );");
  buffer.writeln("  }");
  buffer.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(buffer.toString());
}

void _generateAddPage(
  String featureTag,
  GeneratedEndpoint ep,
  String outputDir,
) {
  _generateActionPage(featureTag, ep, outputDir, 'Add');
}

void _generateEditPage(
  String featureTag,
  GeneratedEndpoint ep,
  String outputDir,
) {
  _generateActionPage(featureTag, ep, outputDir, 'Edit');
}

void _generateActionPage(
  String featureTag,
  GeneratedEndpoint ep,
  String outputDir,
  String actionLabel,
) {
  final featureName = _toSnakeCase(featureTag);
  final blocName = '${_capitalize(ep.methodName)}Bloc';
  final fileName = '${featureName}_${actionLabel.toLowerCase()}_page.dart';

  final buffer = StringBuffer();
  buffer.writeln("import 'package:flutter/material.dart';");
  buffer.writeln("import 'package:flutter_bloc/flutter_bloc.dart';");
  buffer.writeln("import '../../../../../core/di/service_locator.dart';");
  buffer.writeln(
    "import '../../../../../shared/widgets/molecules/app_bloc_button.dart';",
  );
  final method = ep.method.toLowerCase();
  buffer.writeln(
    "import '../bloc/$method/${_toSnakeCase(ep.methodName)}_bloc.dart';",
  );
  buffer.writeln(
    "import '../bloc/$method/${_toSnakeCase(ep.methodName)}_state.dart';",
  );
  buffer.writeln(
    "import '../bloc/$method/${_toSnakeCase(ep.methodName)}_event.dart';",
  );

  final reqRef = _getSchemaRef(ep.details['requestBody'] ?? {});
  final reqClean = reqRef != null ? _cleanName(reqRef) : null;
  if (reqClean != null) {
    buffer.writeln(
      "import '../../domain/entities/${_toSnakeCase(reqClean)}_entity.dart';",
    );
  }

  // Return-type entity is not directly referenced in the page scaffold.

  buffer.writeln();
  final statePrefix = _capitalize(ep.methodName);
  buffer.writeln(
    "class ${_capitalize(featureTag)}${actionLabel}Page extends StatelessWidget {",
  );
  buffer.writeln(
    "  const ${_capitalize(featureTag)}${actionLabel}Page({super.key});",
  );
  buffer.writeln();
  buffer.writeln("  @override");
  buffer.writeln("  Widget build(BuildContext context) {");
  buffer.writeln("    return Scaffold(");
  buffer.writeln(
    "      appBar: AppBar(title: const Text('$actionLabel $featureTag')),",
  );
  buffer.writeln("      body: Padding(");
  buffer.writeln("        padding: const EdgeInsets.all(16.0),");
  buffer.writeln("        child: Column(");
  buffer.writeln("          children: [");
  buffer.writeln("            const Text('Form fields would go here'),");
  buffer.writeln("            const Spacer(),");
  buffer.writeln("            BlocProvider(");
  buffer.writeln("              create: (context) => sl<$blocName>(),");
  buffer.writeln("              child: Builder(");
  buffer.writeln("                builder: (context) {");
  buffer.writeln(
    "                  return AppBlocButton<$blocName, ${statePrefix}State>(",
  );
  buffer.writeln("                    bloc: context.read<$blocName>(),");
  buffer.writeln("                    label: '$actionLabel',");
  buffer.writeln("                    listener: (context, state) {");
  buffer.writeln("                      if (state is ${statePrefix}Loaded) {");
  buffer.writeln("                        Navigator.pop(context);");
  buffer.writeln("                      }");
  buffer.writeln("                    },");
  if (reqClean != null) {
    buffer.writeln(
      "                    onTap: (bloc) => bloc.add(${statePrefix}Event.executed(input: const ${reqClean}Entity(todo: ''))),",
    );
  } else {
    buffer.writeln(
      "                    onTap: (bloc) => bloc.add(const ${statePrefix}Event.executed()),",
    );
  }
  buffer.writeln(
    "                    isLoading: (state) => state is ${statePrefix}Loading,",
  );
  buffer.writeln("                  );");
  buffer.writeln("                },");
  buffer.writeln("              ),");
  buffer.writeln("            ),");
  buffer.writeln("          ],");
  buffer.writeln("        ),");
  buffer.writeln("      ),");
  buffer.writeln("    );");
  buffer.writeln("  }");
  buffer.writeln("}");

  File('$outputDir/$fileName').writeAsStringSync(buffer.toString());
}

void _generateDI(
  String featureTag,
  List<GeneratedEndpoint> endpoints,
  List<GeneratedEndpoint> listEndpoints,
  String outputDir,
) {
  final featureName = _toSnakeCase(featureTag);
  final buffer = StringBuffer();
  final capFeature = _capitalize(featureTag);

  buffer.writeln("import '../../core/di/service_locator.dart';");
  buffer.writeln("import '../../core/network/dio_client.dart';");
  buffer.writeln(
    "import 'data/datasources/${featureName}_remote_datasource.dart';",
  );
  buffer.writeln(
    "import 'data/datasources/${featureName}_remote_datasource_impl.dart';",
  );
  buffer.writeln(
    "import 'data/repositories/${featureName}_repository_impl.dart';",
  );
  buffer.writeln(
    "import 'domain/repositories/${featureName}_repository.dart';",
  );

  for (final ep in endpoints) {
    buffer.writeln(
      "import 'domain/usecases/${_toSnakeCase(ep.methodName)}_usecase.dart';",
    );
    final method = ep.method.toLowerCase();
    buffer.writeln(
      "import 'presentation/bloc/$method/${_toSnakeCase(ep.methodName)}_bloc.dart';",
    );
  }

  buffer.writeln();
  buffer.writeln("void init$capFeature() {");
  buffer.writeln("  // Data sources");
  buffer.writeln(
    "  sl.registerLazySingleton<${capFeature}RemoteDataSource>(() => ${capFeature}RemoteDataSourceImpl(sl<DioClient>()));",
  );
  buffer.writeln();
  buffer.writeln("  // Repositories");
  buffer.writeln(
    "  sl.registerLazySingleton<${capFeature}Repository>(() => ${capFeature}RepositoryImpl(sl()));",
  );
  buffer.writeln();
  buffer.writeln("  // Use cases");
  for (final ep in endpoints) {
    buffer.writeln(
      "  sl.registerLazySingleton(() => ${_capitalize(ep.methodName)}UseCase(sl()));",
    );
  }
  buffer.writeln();
  buffer.writeln("  // Blocs");
  for (final ep in endpoints) {
    final isList = listEndpoints.contains(ep);
    final blocName = isList
        ? '${capFeature}PaginationBloc'
        : '${_capitalize(ep.methodName)}Bloc';
    buffer.writeln("  sl.registerFactory(() => $blocName(sl()));");
  }
  buffer.writeln("}");

  File(
    '$outputDir/${featureName}_di.dart',
  ).writeAsStringSync(buffer.toString());
}

void _generateRoutePaths(
  String featureTag,
  List<String> pageTypes,
  String outputDir,
) {
  final featureName = _toSnakeCase(featureTag);
  final capFeature = _capitalize(featureTag);
  final buffer = StringBuffer();

  buffer.writeln("enum ${capFeature}Route {");
  for (final type in pageTypes) {
    buffer.writeln("  $type,");
  }
  buffer.writeln(";");
  buffer.writeln();
  buffer.writeln("  String get path => switch (this) {");
  for (final type in pageTypes) {
    final path = type == 'list' ? '/$featureName' : '/$featureName/$type';
    buffer.writeln("    ${capFeature}Route.$type => '$path',");
  }
  buffer.writeln("  };");
  buffer.writeln();
  buffer.writeln("  String get routeName => switch (this) {");
  for (final type in pageTypes) {
    buffer.writeln(
      "    ${capFeature}Route.$type => '$capFeature${_capitalize(type)}',",
    );
  }
  buffer.writeln("  };");
  buffer.writeln("}");

  File(
    '$outputDir/${featureName}_route_paths.dart',
  ).writeAsStringSync(buffer.toString());
}

void _generateRoutes(
  String featureTag,
  List<String> pageTypes,
  String outputDir,
) {
  final featureName = _toSnakeCase(featureTag);
  final capFeature = _capitalize(featureTag);
  final buffer = StringBuffer();

  // flutter/material is not directly needed in routes; go_router provides context.
  buffer.writeln("import 'package:go_router/go_router.dart';");
  for (final type in pageTypes) {
    buffer.writeln("import '../pages/${featureName}_${type}_page.dart';");
  }
  buffer.writeln("import '${featureName}_route_paths.dart';");
  buffer.writeln();
  buffer.writeln("abstract final class ${capFeature}Routes {");
  buffer.writeln("  static List<GoRoute> get routes => [");
  for (final type in pageTypes) {
    buffer.writeln("    GoRoute(");
    buffer.writeln("      path: ${capFeature}Route.$type.path,");
    buffer.writeln("      name: ${capFeature}Route.$type.routeName,");
    buffer.writeln(
      "      builder: (context, state) => const ${_capitalize(featureTag)}${_capitalize(type)}Page(),",
    );
    buffer.writeln("    ),");
  }
  buffer.writeln("  ];");
  buffer.writeln("}");

  File(
    '$outputDir/${featureName}_routes.dart',
  ).writeAsStringSync(buffer.toString());
}

void _generateFeatureEntry(String featureTag, String outputDir) {
  final featureName = _toSnakeCase(featureTag);
  final buffer = StringBuffer();

  buffer.writeln("export '${featureName}_di.dart';");
  buffer.writeln(
    "export 'presentation/routes/${featureName}_route_paths.dart';",
  );
  buffer.writeln("export 'presentation/routes/${featureName}_routes.dart';");

  File('$outputDir/$featureName.dart').writeAsStringSync(buffer.toString());
}
