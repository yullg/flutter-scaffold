import 'package:flutter/widgets.dart';

class ScaffoldDeveloperOption {
  final String? password;
  final Iterable<ScaffoldDOPreferenceFiled>? preferenceFileds;

  const ScaffoldDeveloperOption({
    this.password,
    this.preferenceFileds,
  });

  @override
  String toString() {
    return 'ScaffoldDeveloperOption{password: $password, preferenceFileds: $preferenceFileds}';
  }
}

enum ScaffoldDOPreferenceFiledType {
  boolField,
  intField,
  doubleField,
  stringField,
}

class ScaffoldDOPreferenceFiled {
  final String key;
  final ScaffoldDOPreferenceFiledType type;
  final String name;
  final String? description;
  final TextInputType? keyboardType;

  const ScaffoldDOPreferenceFiled({
    required this.key,
    required this.type,
    required this.name,
    this.description,
    this.keyboardType,
  });

  @override
  String toString() {
    return 'ScaffoldDOPreferenceFiled{key: $key, type: $type, name: $name, description: $description, keyboardType: $keyboardType}';
  }
}
