import 'package:flutter/material.dart';

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
  bool debug;

  FormController({
    this.errorResetMode = ErrorResetMode.resetOnFocus,
    this.debug=false,
  });

  final List<VoidCallback> _listeners = [];

  FieldController<T> addTextField<T>({
    required String name,
    T? initialValue,
    String? Function(dynamic)? validator,
  }) {
    if (!_fields.containsKey(name)) {
      _fields[name] = FieldController<T>(
        initialValue: initialValue,
        validator: validator,
      );
      _fields[name]!.addListener(() {
        for (final listener in _listeners) {
          listener();
        }
      });
    }

    final field = _fields[name]!;
    field.focusNode.addListener(() {
      if (validateOnFieldChange && !field.focusNode.hasFocus) {
        _validateField(name);
      }
      if (errorResetMode == ErrorResetMode.resetOnFocus &&
          field.focusNode.hasFocus) {
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

  bool get hasListeners => _listeners.isNotEmpty;

  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  FieldController<T> getFieldController<T>(String name) {
    final field = _fields[name];
    if (field == null) {
      throw ArgumentError("Field '$name' not found");
    }
    if (field is! FieldController<T>) {
      throw TypeError();
    }
    return field;
  }

  /// Выполнение валидации поля
/*  void validateField<T>(String name) {
    final fieldController = getFieldController<T>(name);
  }*/

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

  void setValue(String name, dynamic value) {
    if(debug){
      if(_fields[name]==null){
        throw ArgumentError("Field '$name' not found");
      }
      _fields[name]?.setValue(value);
    }else{
      _fields[name]?.setValue(value);
    }
  }

  List<String> getAllKeys(){
    return _fields.keys.toList();
  }
  bool isKeyExist(String key){
    return _fields.containsKey(key);
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
    return _fields[name]?.focusNode ??
        (throw ArgumentError("Field '$name' not found"));
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
      final error = field.validate();
      if (error != null) {
        field.setError(error);
        isValid = false;
      }
    });
    return isValid;
  }

  Map<String, dynamic> getValues() {
    return _fields.map((name, field) => MapEntry(name, field.value));
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
    _fields.forEach((name, field) {
      field.setValue(null);
    });
  }

  // Метод для получения значения конкретного поля
  T? getFieldValue<T>(String name) {
    return _fields[name]?.value as T?;
  }

/*  T _defaultValue<T>() {
    if (T == String) return '' as T;
    if (T == int) return 0 as T;
    if (T == double) return 0.0 as T;
    if (T == bool) return false as T;
    throw UnsupportedError("Unsupported default value for type $T");
  }*/
}
