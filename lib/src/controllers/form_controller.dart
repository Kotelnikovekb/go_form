import 'package:flutter/material.dart';

import '../domain/domain.dart';
import 'field_controller.dart';

enum ErrorResetMode {
  resetOnFocus,
  resetOnValueChange,
  noReset,
}

class FormController {
  final Map<String, FieldController<dynamic>> _fields = {};

  bool validateOnFieldChange = false;
  final ErrorResetMode errorResetMode;

  FormController({this.errorResetMode=ErrorResetMode.resetOnFocus});

  FieldController<T> addTextField<T>({
    required String name,
    T? initialValue,
    String? Function(dynamic)? validator,
  }) {
    if(!_fields.containsKey('name')){
      if (!_fields.containsKey(name)) {
        _fields[name] = FieldController<T>(
          initialValue: initialValue,
          validator: validator,
        );
      }
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

/*    field.value.addListener(() {
      if (errorResetMode == ErrorResetMode.resetOnValueChange) {
        resetError(name);
      }
    });*/

  return field as FieldController<T>;
  }

  FieldController<T> getFieldController<T>(String name) {
    final field = _fields[name];
    if (field == null) {
      throw ArgumentError("Field '$name' not found");
    }
    if (field is! FieldController<T>) {
      throw TypeError();
    }
    return field as FieldController<T>;
  }

  /// Выполнение валидации поля
  void validateField<T>(String name) {
    final fieldController = getFieldController<T>(name);
  }

  /*FormFieldData<T> getFieldData<T>(String name) {
    final field = _fields[name];
    if (field == null) {
      throw ArgumentError("Field '$name' not found");
    }
    if (field is! FormFieldData<T>) {
      throw TypeError();
    }
    return field;
  }*/

  void _validateField<T>(String name) {
    /*final field = _fields[name];
    if (field != null) {
      final error = field.validator?.call(field.value.value);
      field.error.value = error;
    }*/
  }

  void setError(String name, String? error) {
    _fields[name]?.setError(error);
  }

  void resetError(String name) {
    _fields[name]?.setError(null);
  }

  void resetAllErrors() {
    for (var field in _fields.values) {
      field.setError(null);
    }
  }


  FocusNode getFocusNode(String name) {
    return _fields[name]?.focusNode ?? (throw ArgumentError("Field '$name' not found"));
  }

  Map<String, String?> get errors {
    return _fields.map((name, field) => MapEntry(name, field.error));
  }

  String? getError(String name) {
    return _fields[name]?.error;
  }

/*  ValueNotifier<String?> getErrorNotifier(String name) {
    return _fields[name]?.error ?? ValueNotifier(null);
  }*/

  bool validate() {
    bool isValid = true;
    resetAllErrors();
    _fields.forEach((name, field) {
      final error = field.value.validator?.call(field.value.value.value);
      field.value.error.value = error;

      if (error!= null) {
        field.setError(error);
        isValid = false;
      }
    });
    return isValid;
  }


  Map<String, dynamic> getValues() {
    return _fields.map((name, field) => MapEntry(name, field.value.value.value));
  }


  void dispose() {
    /*for (var field in _fields.values) {
      field.value.dispose();
      field.error.dispose();
      field.focusNode.dispose();
    }*/
  }

  /// Сброисть поля в форме
  void resetAllFields() {
   /* _fields.forEach((name, field) {
      field.value.value = null;
    });*/
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