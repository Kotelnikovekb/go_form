import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../domain/domain.dart';

/// Controller for managing the state of an individual form field.
///
/// `FieldController` is used inside custom form field widgets
/// to handle values, validation, errors, and focus.
/// **Developers do not interact with this controller directly** –
/// it is automatically created in `DynamicForm` and passed to custom fields.
///
/// ### 📌 Example of a custom field:
/// ```dart
/// class GoTextInput extends FormFieldModelBase<String> {
///   final String label;
///
///   GoTextInput({required super.name, super.validator, required this.label});
///
///   @override
///   Widget build(BuildContext context, FieldController controller) {
///     return RootInput(
///       onChanged: (newValue) => controller.onChange(newValue),
///       initialValue: controller.value,
///       validator: validator,
///       errorText: controller.error,
///       labelText: label,
///     );
///   }
/// }
/// ```
/// 🔹 `controller.value` – current field value.
/// 🔹 `controller.onChange(newValue)` – updates the field value.
/// 🔹 `controller.error` – error message if the field is invalid.
///
/// ---
class FieldController<T> extends ChangeNotifier {
  final Key? key;
  TextEditingController? _textEditingController;

  T? get value => _valueNotifier.value.value.value;
  final ValueNotifier<FormFieldData<T?>> _valueNotifier;
  final List<VoidCallback> _listeners = [];


  FieldController( {
    T? initialValue,
    String? Function(T?)? validator,
    this.key,
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
    if (newValue is T || newValue == null) {
      _valueNotifier.value = FormFieldData<T?>(
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
    } else {
      print('type ${newValue.runtimeType} not ${T.runtimeType} or null');
    }
  }

  @override
  void dispose() {
    super.dispose();
    _valueNotifier.value.dispose();
    _valueNotifier.dispose();
    _textEditingController?.dispose();
    _listeners.clear();

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
