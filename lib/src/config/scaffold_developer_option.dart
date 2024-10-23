import 'package:flutter/widgets.dart';

class ScaffoldDeveloperOption {
  final String? password;
  final Iterable<ScaffoldDOPreferenceField>? preferenceFields;

  const ScaffoldDeveloperOption({
    this.password,
    this.preferenceFields,
  });

  @override
  String toString() {
    return 'ScaffoldDeveloperOption{password: $password, preferenceFields: $preferenceFields}';
  }
}

enum ScaffoldDOPreferenceFieldType {
  boolField,
  intField,
  doubleField,
  stringField,
}

class ScaffoldDOPreferenceField {
  final String key;
  final ScaffoldDOPreferenceFieldType type;
  final String name;
  final String? hintText;
  final String? description;
  final TextInputType? keyboardType;

  const ScaffoldDOPreferenceField({
    required this.key,
    required this.type,
    required this.name,
    this.hintText,
    this.description,
    this.keyboardType,
  });

  @override
  String toString() {
    return 'ScaffoldDOPreferenceField{key: $key, type: $type, name: $name, hintText: $hintText, description: $description, keyboardType: $keyboardType}';
  }
}
