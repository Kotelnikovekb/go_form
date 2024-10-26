import 'package:flutter/material.dart';

import '../domain/domain.dart';

class FieldController<T> extends ValueNotifier<FormFieldData<T?>>{
  FieldController({
    T? initialValue,
    String? Function(dynamic)? validator,
  }) : super(FormFieldData<T?>(
    initialValue: initialValue,
    validator: validator,
  ));
  T? get fieldValue => value.value.value;

  void onChange(T? newValue) {
    value.value.value = newValue;
    notifyListeners();
  }

  void setError(String? newError) {
    value.error.value = newError;
    notifyListeners();
  }

  String? get error => value.error.value;


  /// Получение `FocusNode`
  FocusNode get focusNode => value.focusNode;
}