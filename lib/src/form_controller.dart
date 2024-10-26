import 'package:flutter/material.dart';

enum ErrorResetMode {
  resetOnFocus,
  resetOnValueChange,
  noReset,
}

class FormController {
  final Map<String, TextEditingController> _controllers = {};
  final ValueNotifier<Map<String, String?>> _errors = ValueNotifier({});
  final Map<String, FocusNode> _focusNodes = {};

  final Map<String, String? Function(String?)?> _textValidators = {};
  final Map<String, String? Function(bool?)?> _checkboxValidators = {};

  final Map<String, bool> _checkboxValues = {};

  bool validateOnFieldChange = false;
  final ErrorResetMode errorResetMode;

  FormController({this.errorResetMode=ErrorResetMode.resetOnFocus});

  void addTextField({
    required String name,
    String? initialValue,
    String? Function(String?)? validator,
  }) {
    _controllers[name] = TextEditingController(text: initialValue);
    _focusNodes[name] = FocusNode();

    _textValidators[name] = validator;

    _focusNodes[name]!.addListener(() {
      if (validateOnFieldChange && _focusNodes[name]!.hasFocus == false) {
        _validateField(name);
      }
      if (errorResetMode == ErrorResetMode.resetOnFocus && _focusNodes[name]!.hasFocus) {
        resetError(name);
      }
    });

    _controllers[name]!.addListener(() {
      if (errorResetMode == ErrorResetMode.resetOnValueChange) {
        resetError(name);
      }
    });
  }

  void addCheckboxField({
    required String name,
    bool initialValue = false,
    String? Function(bool?)? validator,
  }) {
    _checkboxValues[name] = initialValue;
    _checkboxValidators[name] = validator;
  }

  void _validateField(String name) {
    if (_controllers.containsKey(name)) {
      final validator = _textValidators[name];
      final value = _controllers[name]?.text;
      final error = validator?.call(value);
      _errors.value = {..._errors.value, name: error};
    } else if (_checkboxValues.containsKey(name)) {
      final validator = _checkboxValidators[name];
      final value = _checkboxValues[name];
      final error = validator?.call(value);
      _errors.value = {..._errors.value, name: error};
    }
  }

  void setError(String name, String error) {
    _errors.value = {..._errors.value, name: error};
  }

  void resetError(String name) {
    _errors.value = {..._errors.value, name: null};
  }

  void resetAllErrors() {
    _errors.value = {};
  }

  TextEditingController getController(String name) {
    return _controllers[name]!;
  }

  FocusNode getFocusNode(String name) {
    return _focusNodes[name]!;
  }

  bool? getCheckboxValue(String name) {
    return _checkboxValues[name];
  }

  void setCheckboxValue(String name, bool value) {
    _checkboxValues[name] = value;
  }

  ValueNotifier<Map<String, String?>> get errors => _errors;

  String? getError(String name) {
    return _errors.value[name];
  }

  bool validate() {
    bool isValid = true;
    _errors.value = {};

    _controllers.forEach((name, controller) {
      _validateField(name);
      if (_errors.value[name] != null) {
        isValid = false;
      }
    });

    _checkboxValues.forEach((name, value) {
      _validateField(name);
      if (_errors.value[name] != null) {
        isValid = false;
      }
    });

    return isValid;
  }

  Map<String, dynamic> getValues() {
    final values = _controllers.map((name, controller) => MapEntry(name, controller.text as dynamic));
    values.addAll(_checkboxValues);
    return values;
  }

  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _focusNodes.values.forEach((focusNode) => focusNode.dispose());
  }
  /// Сброисть поля в форме
  void resetAllFields() {
    for (var controller in _controllers.values) {
      controller.clear();
    }
    _checkboxValues.updateAll((key, value) => false);
    resetAllErrors();
  }

  // Метод для получения значения конкретного поля
  dynamic getFieldValue(String name) {
    if (_controllers.containsKey(name)) {
      return _controllers[name]!.text;
    } else if (_checkboxValues.containsKey(name)) {
      return _checkboxValues[name];
    }
    return null;
  }
}