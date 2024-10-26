import 'package:flutter/material.dart';

import 'domain/domain.dart';

enum ErrorResetMode {
  resetOnFocus,
  resetOnValueChange,
  noReset,
}

class FormController {
  final Map<String, FormFieldData> _fields = {};

  bool validateOnFieldChange = false;
  final ErrorResetMode errorResetMode;

  FormController({this.errorResetMode=ErrorResetMode.resetOnFocus});

  void addTextField<T>({
    required String name,
    T? initialValue,
    String? Function(dynamic)? validator,
  }) {
    if(!_fields.containsKey('name')){
      _fields[name]=FormFieldData<T>(
        initialValue: initialValue,
        validator: validator,
      );
    }else{
      throw ArgumentError('Поле $name уже используется');
    }

    final field = _fields[name]!;





    field.focusNode.addListener(() {
      if (validateOnFieldChange && !field.focusNode.hasFocus) {
        _validateField(name);
      }
      if (errorResetMode == ErrorResetMode.resetOnFocus && field.focusNode.hasFocus) {
        resetError(name);
      }
    });

    field.value.addListener(() {
      if (errorResetMode == ErrorResetMode.resetOnValueChange) {
        resetError(name);
      }
    });
  }

  FormFieldData<T> getFieldData<T>(String name) {
    final field = _fields[name];
    if (field == null) {
      throw ArgumentError("Field '$name' not found");
    }
    if (field is! FormFieldData<T>) {
      throw TypeError();
    }
    return field;
  }

  void _validateField<T>(String name) {
    final field = _fields[name];
    if (field != null) {
      final error = field.validator?.call(field.value.value);
      field.error.value = error;
    }
  }

  void setError(String name, String? error) {
    _fields[name]?.error.value = error;
  }

  void resetError(String name) {
    _fields[name]?.error.value = null;
  }

  void resetAllErrors() {
    for (var field in _fields.values) {
      field.error.value = null;
    }
  }


  FocusNode getFocusNode(String name) {
    return _fields[name]?.focusNode ?? (throw ArgumentError("Field '$name' not found"));
  }

  Map<String, String?> get errors {
    return _fields.map((name, field) => MapEntry(name, field.error.value));
  }

  String? getError(String name) {
    return _fields[name]?.error.value;
  }

  ValueNotifier<String?> getErrorNotifier(String name) {
    return _fields[name]?.error ?? ValueNotifier(null);
  }

  bool validate() {
    bool isValid = true;
    resetAllErrors();
    _fields.forEach((name, field) {
      _validateField(name);
      if (field.error.value != null) {
        isValid = false;
      }
    });
    return isValid;
  }


  Map<String, dynamic> getValues() {
    return _fields.map((name, field) => MapEntry(name, field.value.value));
  }


  void dispose() {
    for (var field in _fields.values) {
      field.value.dispose();
      field.error.dispose();
      field.focusNode.dispose();
    }
  }

  /// Сброисть поля в форме
  void resetAllFields() {
    _fields.forEach((name, field) {
      field.value.value = null;
    });
    resetAllErrors();
  }


  // Метод для получения значения конкретного поля
  dynamic getFieldValue(String name) {
    return _fields[name]?.value.value;
  }


  T _defaultValue<T>() {
    if (T == String) return '' as T;
    if (T == int) return 0 as T;
    if (T == double) return 0.0 as T;
    if (T == bool) return false as T;
    throw UnsupportedError("Unsupported default value for type $T");
  }
}