import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/domain.dart';

class FieldController<T> extends ChangeNotifier {
  T? get value => _valueNotifier.value.value.value;
  final ValueNotifier<FormFieldData<T?>> _valueNotifier;

  FieldController({
    T? initialValue,
    String? Function(dynamic)? validator,
  }) : _valueNotifier = ValueNotifier(
          FormFieldData<T?>(
            initialValue: initialValue,
            validator: validator,
          ),
        );

  void onChange(T? newValue) {
    _valueNotifier.value = FormFieldData<T?>(
      initialValue: newValue,
      validator: _valueNotifier.value.validator,
    );
    notifyListeners();
  }

  void setError(String? newError) {
    _valueNotifier.value = FormFieldData<T?>(
      initialValue: _valueNotifier.value.value.value,
      validator: _valueNotifier.value.validator,
      error: newError,
    );
    notifyListeners();
  }

  void clearError() {
    _valueNotifier.value = FormFieldData<T?>(
      initialValue: _valueNotifier.value.value.value,
      validator: _valueNotifier.value.validator,
      error: null,
    );
    notifyListeners();
  }

  String? get error => _valueNotifier.value.error;

  ValueListenable<FormFieldData<T?>> get valueListenable => _valueNotifier;

  /// Получение `FocusNode`
  FocusNode get focusNode => _valueNotifier.value.focusNode;

  String? validate() {
    if (_valueNotifier.value.validator != null) {
      final validationError = _valueNotifier.value.validator!.call(value);
      if (validationError != null) {
        setError(validationError);
      } else {
        clearError();
      }

      return validationError;
    }
    notifyListeners();

    return null;
  }
}
