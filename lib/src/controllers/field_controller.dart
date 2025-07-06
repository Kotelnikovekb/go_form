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

import 'dart:async';

class FieldController<T> extends ChangeNotifier {
  final Key? key;
  TextEditingController? _textEditingController;
  Timer? _debounceTimer;
  Duration? debounceDuration;

  T? get value => _valueNotifier.value.value.value;

  FieldStatus get status => _valueNotifier.value.status;
  final ValueNotifier<FormFieldData<T?>> _valueNotifier;
  final List<VoidCallback> _listeners = [];
  final FocusNode _focusNode = FocusNode();
  final void Function()? onDebounceComplete;

  FieldController({
    T? initialValue,
    String? Function(T?)? validator,
    Future<String?> Function(T?)? asyncValidator,
    this.key,
    this.debounceDuration,
    this.onDebounceComplete,
  }) : _valueNotifier = ValueNotifier(
          FormFieldData<T?>(
            initialValue: initialValue,
            validator: validator,
            asyncValidator: asyncValidator,
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
    if (debounceDuration != null) {
      _debounceTimer?.cancel();
      _valueNotifier.value = _valueNotifier.value.copyWith(
        status: FieldStatus.debounce,
      );
      _debounceTimer = Timer(debounceDuration!, () {
        _applyChange(newValue);
        onDebounceComplete?.call();
      });
    } else {
      _applyChange(newValue);
    }
  }

  void _applyChange(T? newValue) {
    _valueNotifier.value = _valueNotifier.value.copyWith(
      initialValue: newValue,
      error: null,
      status: FieldStatus.filled,
    );

    if (T == String && _textEditingController != null) {
      if (_textEditingController!.text != newValue) {
        _textEditingController!.text = newValue as String? ?? '';
      }
    }

    notifyListeners();
  }

  void setError(String? newError) {
    _valueNotifier.value = _valueNotifier.value.copyWith(
      initialValue: _valueNotifier.value.value.value,
      error: newError,
      status: newError == null ? FieldStatus.filled : FieldStatus.error,
    );
    notifyListeners();
  }

  void setValue(dynamic newValue) {
    if (newValue is T || newValue == null) {
      _valueNotifier.value = _valueNotifier.value.copyWith(
        initialValue: newValue,
        error: _valueNotifier.value.error,
        status: FieldStatus.debounce,
      );
      if (T == String && _textEditingController != null) {
        if (_textEditingController!.text != newValue) {
          _textEditingController!.text = newValue as String? ?? '';
        }
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _valueNotifier.value.dispose();
    _valueNotifier.dispose();
    _textEditingController?.dispose();
    _listeners.clear();
    _focusNode.dispose();
    super.dispose();
  }

  void clearError() {
    _valueNotifier.value = _valueNotifier.value.copyWith(
      initialValue: _valueNotifier.value.value.value,
      error: null,
      status: FieldStatus.filled,
    );
    notifyListeners();
  }

  void setStatus(FieldStatus status) {
    _valueNotifier.value = _valueNotifier.value.copyWith(
      status: status,
    );
    notifyListeners();
  }

  String? get error => _valueNotifier.value.error;

  ValueListenable<FormFieldData<T?>> get valueListenable => _valueNotifier;

  FocusNode get focusNode => _focusNode;

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

  Future<String?> validateAsync() async {
    final asyncValidator = _valueNotifier.value.asyncValidator;
    if (asyncValidator != null) {
      _valueNotifier.value =
          _valueNotifier.value.copyWith(status: FieldStatus.loading);
      final result = await Future.value(asyncValidator.call(value));
      if (result != null) {
        setError(result);
      } else {
        clearError();
      }
      return result;
    }
    notifyListeners();
    return null;
  }

  bool silentValidate() {
    if (_valueNotifier.value.validator != null) {
      final validationError = _valueNotifier.value.validator!.call(value);
      if (validationError != null) {
        return false;
      }
    }
    return true;
  }
}
