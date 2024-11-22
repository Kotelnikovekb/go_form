import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/domain.dart';

class FieldController<T> extends ChangeNotifier {
  TextEditingController? _textEditingController;
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


  TextEditingController? get textController {
    if (T == String) {
      _textEditingController ??= TextEditingController(
        text: _valueNotifier.value.value.value as String?,
      );
      _textEditingController!.addListener(() {
        if (_textEditingController!.text != value) {
          onChange(_textEditingController!.text as T?);
        }
      });
    }
    return _textEditingController;
  }

  void onChange(T? newValue) {
    _valueNotifier.value = FormFieldData<T?>(
      initialValue: newValue,
      validator: _valueNotifier.value.validator,
    );
    if (T == String && _textEditingController != null) {
      if (_textEditingController!.text != newValue) {
        _textEditingController!.text = newValue as String? ?? '';
      }
    }
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
  void setValue(dynamic newValue) {
    _valueNotifier.value=FormFieldData<T?>(
      initialValue: newValue,
      validator: _valueNotifier.value.validator,
      error: _valueNotifier.value.error,
    );
    if (T == String && _textEditingController != null) {
      if (_textEditingController!.text != newValue) {
        _textEditingController!.text = newValue as String? ?? '';
      }
    }
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
