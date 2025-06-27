import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'field_controller.dart';

enum ErrorResetMode {
  resetOnFocus,
  resetOnValueChange,
  noReset,
}

enum ValidationMode {
  valueChange,
  focusChange,
  noValidate,
}

/// Manages the state, validation, and interaction of form fields.
///
/// `FormController` provides a centralized way to handle form fields,
/// manage their values, validate input, and handle errors.
/// It replaces the need for using `FormState` in traditional Flutter forms,
/// offering more control over field states.
///
/// ### Example Usage:
/// ```dart
/// final formController = FormController();
///
/// bool isValid = formController.validate();
/// print(formController.errors); // Output: {'email': 'Enter a valid email'}
/// ```
///
/// ## Key Features:
/// - **Field management** via `DynamicForm`, which registers all fields automatically.
/// - **Get and update field values** using `getFieldValue()` and `setValue()`.
/// - **Form validation** with `validate()` and `setError()`.
/// - **Focus management** via `getFocusNode()`.
/// - **Reset errors and values** with `resetAllErrors()` and `resetAllFields()`.
///
/// ---
class FormController {
  /// Stores form fields by their names.
  final Map<String, FieldController<dynamic>> _fields = {};

  bool _lastValidationState = false;
  bool _isValidationRunning = false;

  /// Determines whether validation should trigger on field value changes.
  ///
  /// If `true`, validation runs automatically when a field's value changes.
  final bool validateOnFieldChange = false;

  /// Defines when errors should be reset (`resetOnFocus`, `resetOnValueChange`, `noReset`).
  final ErrorResetMode errorResetMode;

  /// Enables debug mode (throws exceptions if fields are missing).
  final bool _debug;

  /// Creates a new `FormController`.
  ///
  /// - `errorResetMode` defines when field errors should be reset.
  /// - `debug` enables debug mode for strict field validation.
  FormController({
    this.errorResetMode = ErrorResetMode.resetOnFocus,
    bool debug = false,
  }) : _debug = debug;

  final List<VoidCallback> _listeners = [];
  final List<void Function(bool)> _validationListeners = [];
  final List<void Function(String name, dynamic value)> _fieldValueListeners =
      [];
  final List<void Function(String name, FocusNode focusNode)>
      _fieldFocusListeners = [];

  /// Registers a new text field in the form and returns its `FieldController<T>`.
  ///
  /// If a field with the given name already exists, it returns the existing `FieldController<T>`.
  /// Otherwise, it creates a new field, initializes it with an optional value and validator,
  /// and sets up listeners for state changes and focus events.
  ///
  /// ### Automatic Updates:
  /// - **Adds a listener** that notifies registered observers when the field changes.
  /// - **Listens to focus changes** to trigger validation or reset errors if necessary.
  ///
  /// ### Example Usage:
  /// ```dart
  /// final FieldController<String> emailController =
  ///     formController.addTextField<String>(
  ///       name: 'email',
  ///       initialValue: '',
  ///       validator: (val) => val!.isEmpty ? 'Enter your email' : null,
  ///     );
  ///
  /// emailController.setValue('test@example.com');
  /// print(emailController.value); // Output: test@example.com
  /// ```
  ///
  /// - **Parameter `name`** – The unique identifier of the field.
  /// - **Parameter `initialValue`** – The initial value of the field (optional).
  /// - **Parameter `validator`** – A function to validate the field (optional).
  /// - **Parameter `key`** – An optional key for widget identification.
  /// - **Returns** – `FieldController<T>` that manages the registered field.
  FieldController<T> addTextField<T>({
    required String name,
    T? initialValue,
    String? Function(T?)? validator,
    Future<String?> Function(T?)? asyncValidator,
    Key? key,
    Duration? debounceDuration,
  }) {
    if (!_fields.containsKey(name)) {
      _fields[name] = FieldController<T>(
        initialValue: initialValue,
        validator: validator,
        asyncValidator: asyncValidator,
        key: key,
        debounceDuration: debounceDuration,
      );
      final field = _fields[name]!;
      T? lastValue = field.value;
      field.addListener(() {
        _notifyListeners();
        _silentValidate();

        if (field.value != lastValue) {
          lastValue = field.value;
          for (final listener in _fieldValueListeners) {
            listener(name, field.value);
          }
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
    field.focusNode.addListener(() {
      final hasFocus = field.focusNode.hasFocus;
      for (final listener in _fieldFocusListeners) {
        listener(name, field.focusNode);
      }

      if (validateOnFieldChange && !hasFocus) {
        _validateField(name);
      }
      if (errorResetMode == ErrorResetMode.resetOnFocus && hasFocus) {
        resetError(name);
      }
    });

    return field as FieldController<T>;
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void _silentValidate() {
    if (_isValidationRunning) return;
    _isValidationRunning = true;

    Future.microtask(() {
      bool isValid = _isValid();

      if (isValid != _lastValidationState) {
        _lastValidationState = isValid;
        for (final listener in _validationListeners) {
          listener(isValid);
        }
      }

      _isValidationRunning = false;
    });
  }

  bool _isValid() {
    for (var field in _fields.values) {
      if (!field.silentValidate()) {
        return false;
      }
    }
    return true;
  }

  void addFocusListener(
      void Function(String name, FocusNode focusNode) listener) {
    _fieldFocusListeners.add(listener);
  }

  void removeFocusListener(
      void Function(String name, FocusNode focusNode) listener) {
    _fieldFocusListeners.remove(listener);
  }

  /// Checks if there are any registered listeners.
  ///
  /// Returns `true` if at least one listener is added, otherwise `false`.
  ///
  /// ### Example Usage:
  /// ```dart
  /// bool hasListeners = formController.hasListeners;
  /// print(hasListeners); // Output: true or false
  /// ```
  bool get hasListeners => _listeners.isNotEmpty;

  /// Adds a listener that will be called when the form state changes.
  ///
  /// This method allows external components to be notified whenever
  /// there are updates in the form fields.
  ///
  /// ### Example Usage:
  /// ```dart
  /// formController.addListener(() {
  ///   print('Form updated!');
  /// });
  /// ```
  ///
  /// - **Parameter `listener`** – A function that will be executed on form updates.
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  /// Removes a previously added listener.
  ///
  /// If the listener is not found in the list, nothing happens.
  ///
  /// ### Example Usage:
  /// ```dart
  /// VoidCallback listener = () => print('Form updated!');
  /// formController.addListener(listener);
  ///
  /// formController.removeListener(listener); // Listener is now removed
  /// ```
  ///
  /// - **Parameter `listener`** – The listener function to be removed.
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }

  /// Adds a listener that gets notified when the form's validation state changes.
  ///
  /// The listener receives a `bool` indicating whether the form is valid.
  ///
  /// Example:
  /// ```dart
  /// formController.addValidationListener((isValid) {
  ///   print('Form is valid: $isValid');
  /// });
  /// ```
  void addValidationListener(void Function(bool) listener) {
    _validationListeners.add(listener);
  }

  /// Removes a previously added validation listener.
  ///
  /// If the listener is not found, nothing happens.
  ///
  /// Example:
  /// ```dart
  /// void Function(bool) listener = (isValid) => print('Form is valid: $isValid');
  /// formController.addValidationListener(listener);
  ///
  /// formController.removeValidationListener(listener); // Listener is now removed
  /// ```
  void removeValidationListener(void Function(bool) listener) {
    _validationListeners.remove(listener);
  }

  /// Adds a listener that gets notified whenever a field value changes.
  ///
  /// The listener receives the field name and its new value.
  ///
  /// Example:
  /// ```dart
  /// formController.addFieldValueListener((name, value) {
  ///   print('Field $name changed to: $value');
  /// });
  /// ```
  void addFieldValueListener(
      void Function(String name, dynamic value) listener) {
    _fieldValueListeners.add(listener);
  }

  /// Removes a previously added field value change listener.
  ///
  /// If the listener is not found, nothing happens.
  ///
  /// Example:
  /// ```dart
  /// void Function(String, dynamic) listener = (name, value) => print('Field $name changed to: $value');
  /// formController.addFieldValueListener(listener);
  ///
  /// formController.removeFieldValueListener(listener); // Listener is now removed
  /// ```
  void removeFieldValueListener(
      void Function(String name, dynamic value) listener) {
    _fieldValueListeners.remove(listener);
  }

  /// Returns the `FieldController<T>` for the specified field.
  ///
  /// This method retrieves the controller for a specific form field,
  /// allowing direct management of its state and value.
  ///
  /// If the field with the given name is not found, an `ArgumentError` is thrown.
  /// If the field is found but does not match the expected type `<T>`, a `TypeError` is thrown.
  ///
  /// ### Example Usage:
  /// ```dart
  /// final FieldController<String> emailController =
  ///     formController.getFieldController<String>('email');
  ///
  /// emailController.setValue('new@example.com');
  /// print(emailController.value); // Output: new@example.com
  /// ```
  ///
  /// - **Parameter `name`** – The name of the field to retrieve the controller for.
  /// - **Returns** – `FieldController<T>` associated with the specified field.
  /// - **Throws**:
  ///   - `ArgumentError` if the field does not exist.
  ///   - `TypeError` if the expected type `<T>` does not match the actual field type.
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

  void _validateField<T>(String name) {
    /*final field = _fields[name];
    if (field != null) {
      final error = field.validator?.call(field.value.value);
      field.error.value = error;
    }*/
  }

  /// Sets a validation error for a specific field.
  ///
  /// Used to display server-side validation errors.
  ///
  /// ### Example:
  /// ```dart
  /// formController.setError('email', 'This email is already in use');
  /// ```
  void setError(String name, String? error) {
    _fields[name]?.setError(error);
  }

  /// Updates the value of a specific field.
  ///
  /// If `debug` mode is enabled, it throws an error if the field does not exist.
  ///
  /// ### Example:
  /// ```dart
  /// formController.setValue('email', 'test@example.com');
  /// ```
  void setValue(String name, dynamic value) {
    if (_debug) {
      if (_fields[name] == null) {
        throw ArgumentError("Field '$name' not found");
      }
      _fields[name]?.setValue(value);
    } else {
      _fields[name]?.setValue(value);
    }
  }

  List<String> getAllKeys() {
    return _fields.keys.toList();
  }

  /// Checks whether a field exists in the form.
  ///
  /// ### Example:
  /// ```dart
  /// bool exists = formController.isKeyExist('email');
  /// ```
  bool isKeyExist(String key) {
    return _fields.containsKey(key);
  }

  /// Clears the validation error for the specified field.
  ///
  /// This method removes the current error message, if any,
  /// but does not trigger field revalidation.
  ///
  /// ### Example Usage:
  /// ```dart
  /// formController.setError('email', 'Invalid email');
  /// print(formController.getError('email')); // Output: Invalid email
  ///
  /// formController.resetError('email');
  /// print(formController.getError('email')); // Output: null
  /// ```
  ///
  /// - **Parameter `name`** – The name of the field whose error should be cleared.
  void resetError(String name) {
    _fields[name]?.setError(null);
  }

  /// Resets all validation errors in the form.
  ///
  /// This method clears all existing validation errors for every field in the form.
  /// It only updates fields that currently have errors, preventing unnecessary UI rebuilds.
  ///
  /// If the form uses `ChangeNotifier`, this method can trigger `notifyListeners()` to
  /// ensure the UI reflects the changes.
  ///
  /// ### Example Usage:
  /// ```dart
  /// final controller = FormController();
  ///
  /// controller.addTextField<String>(
  ///   name: 'email',
  ///   initialValue: '',
  ///   validator: (val) => val == null || val.isEmpty ? 'Required' : null,
  /// );
  ///
  /// controller.validate(); // Triggers validation
  /// print(controller.errors); // Output: {'email': 'Required'}
  ///
  /// controller.resetAllErrors(); // Clears all errors
  /// print(controller.errors); // Output: {}
  /// ```
  ///
  /// This method improves performance by only resetting fields with existing errors.
  void resetAllErrors() {
    for (var field in _fields.values) {
      if (field.error != null) {
        field.setError(null);
      }
    }
  }

  /// Returns the `FocusNode` for the specified field.
  ///
  /// This method is used to manage focus for form fields,
  /// such as programmatically shifting focus or tracking input state.
  ///
  /// If the field with the given name is not found, an `ArgumentError` is thrown.
  ///
  /// ### Example Usage:
  /// ```dart
  /// FocusNode emailFocus = formController.getFocusNode('email');
  /// emailFocus.requestFocus(); // Moves focus to the email field
  /// ```
  ///
  /// - **Parameter `name`** – The name of the field to retrieve the `FocusNode` for.
  /// - **Returns** – The `FocusNode` associated with the field.
  /// - **Throws** – `ArgumentError` if the field is not found.
  FocusNode getFocusNode(String name) {
    return _fields[name]?.focusNode ??
        (throw ArgumentError("Field '$name' not found"));
  }

  /// Returns a `Map` containing only the form fields that have validation errors.
  ///
  /// The keys are the field names, and the values are the corresponding error messages.
  ///
  /// ### Example Usage:
  /// ```dart
  /// final controller = FormController();
  ///
  /// controller.addTextField<String>(
  ///   name: 'email',
  ///   initialValue: '',
  ///   validator: (val) => val == null || val.isEmpty ? 'Enter your email' : null,
  /// );
  ///
  /// controller.validate(); // Trigger validation
  ///
  /// print(controller.errors); // Output: {'email': 'Enter your email'}
  /// ```
  ///
  /// If there are no errors, it returns an empty `Map<String, String>`.
  Map<String, String> get errors {
    return Map.fromEntries(
      _fields.entries
          .where((entry) => entry.value.error != null)
          .map((entry) => MapEntry(entry.key, entry.value.error!)),
    );
  }

  List<Key?> get errorsKeys {
    return _fields.entries
        .where((entry) => entry.value.error != null)
        .map((entry) => entry.value.key)
        .toList();
  }

  Key? get firstFieldKey {
    return _fields.isNotEmpty ? _fields.entries.first.value.key : null;
  }

  FocusNode? get getErrorFocusNode {
    return _fields.entries
        .where((entry) => entry.value.error != null)
        .map((entry) => entry.value.focusNode)
        .firstOrNull;
  }

  /// Scrolls to the first input field.
  ///
  /// This method retrieves the first `FocusNode` from `_fields`
  /// and scrolls to it using `Scrollable.ensureVisible()`.
  void scrollToFirstField() {
    if (_fields.isEmpty) return;

    FocusNode firstNode = _fields.entries.first.value.focusNode;

    Scrollable.ensureVisible(
      firstNode.context!,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    firstNode.requestFocus();
  }

  /// Scrolls to the first field with an error.
  ///
  /// This method searches for the first `FocusNode` in `_fields` that has an error
  /// and scrolls to it using `Scrollable.ensureVisible()`.
  void scrollToFirstErrorField() {
    FocusNode? errorNode = getErrorFocusNode;
    if (errorNode == null) return;

    if (errorNode.context != null) {
      Scrollable.ensureVisible(
        errorNode.context!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      if (_debug && kDebugMode) {
        print('getErrorFocusNode not found');
      }
    }
  }

  /// Retrieves the validation error message for a specific field.
  ///
  /// If the field has an error, this method returns the error message.
  /// If there is no error or the field does not exist, it returns `null`.
  ///
  /// ### Example Usage:
  /// ```dart
  /// formController.setError('email', 'Invalid email');
  ///
  /// String? error = formController.getError('email');
  /// print(error); // Output: Invalid email
  ///
  /// print(formController.getError('password')); // Output: null
  /// ```
  ///
  /// - **Parameter `name`** – The name of the field to retrieve the error for.
  /// - **Returns** – The error message or `null` if there is no error.
  String? getError(String name) {
    return _fields[name]?.error;
  }

  /// Validates all form fields.
  ///
  /// Returns `true` if all fields are valid; otherwise, returns `false`.
  ///
  /// Errors are updated and stored for later use.
  ///
  /// ### Example:
  /// ```dart
  /// bool isValid = formController.validate();
  /// if (!isValid) {
  ///   print(formController.errors); // Outputs validation errors
  /// }
  /// ```
  bool validate() {
    bool isValid = true;
    resetAllErrors();
    _fields.forEach((name, field) {
      final error = field.validate();
      if (error != null) {
        field.setError(error);
        isValid = false;
        if (_debug && kDebugMode) {
          print('fild $name - has error $error');
        }
      } else {
        if (_debug && kDebugMode) {
          print('fild $name - ok');
        }
      }
    });
    return isValid;
  }

  /// Validates all form fields asynchronously.
  ///
  /// This method awaits the result of each field's async validator.
  /// If any validator returns a non-null error, it will be stored and the form is considered invalid.
  ///
  /// ### Example:
  /// ```dart
  /// final isValid = await formController.validateAsync();
  /// if (!isValid) {
  ///   print(formController.errors); // Display errors
  /// }
  /// ```
  Future<bool> validateAsync() async {
    bool isValid = true;
    resetAllErrors();
    for (final entry in _fields.entries) {
      final field = entry.value;
      final result = await field.validateAsync();
      if (result != null) {
        isValid = false;
        if (_debug && kDebugMode) {
          print('Field ${entry.key} - has async error $result');
        }
      } else {
        if (_debug && kDebugMode) {
          print('Field ${entry.key} - async ok');
        }
      }
    }
    return isValid;
  }

  /// Retrieves all field values in the form as a `Map`.
  ///
  /// ### Example:
  /// ```dart
  /// final values = formController.getValues();
  /// print(values); // {'email': 'test@example.com', 'password': '123456'}
  /// ```
  Map<String, dynamic> getValues() {
    return _fields.map((name, field) => MapEntry(name, field.value));
  }

  /// Releases form resources.
  ///
  /// Call this before destroying the `FormController` to prevent memory leaks.
  ///
  /// ### Example:
  /// ```dart
  /// @override
  /// void dispose() {
  ///   formController.dispose();
  ///   super.dispose();
  /// }
  /// ```
  void dispose() {
    for (var field in _fields.values) {
      field.dispose();
    }
    _fields.clear();
    _listeners.clear();
    _fieldFocusListeners.clear();
  }

  /// Clears validation errors for all form fields.
  ///
  /// This method iterates through all fields and resets their validation errors.
  /// Since each field is updated via `ValueNotifier`, the UI will automatically
  /// reflect the changes without requiring `notifyListeners()`.
  ///
  /// ### Example Usage:
  /// ```dart
  /// final controller = FormController();
  ///
  /// controller.addTextField<String>(
  ///   name: 'email',
  ///   initialValue: '',
  ///   validator: (val) => val == null || val.isEmpty ? 'Required field' : null,
  /// );
  ///
  /// controller.validate(); // Trigger validation
  /// print(controller.errors); // {'email': 'Required field'}
  ///
  /// controller.resetAllErrors(); // Clear errors
  /// print(controller.errors); // {}
  /// ```
  ///
  /// This method ensures optimal performance by resetting only fields with existing errors.
  void resetAllFields() {
    _fields.forEach((name, field) {
      field.setValue(null);
    });
  }

  /// Retrieves the current value of a specific form field.
  ///
  /// This method returns the value stored in the field identified by the given `name`.
  /// If the field does not exist, it returns `null`.
  ///
  /// ### Example Usage:
  /// ```dart
  /// final controller = FormController();
  ///
  /// controller.addTextField<String>(
  ///   name: 'username',
  ///   initialValue: 'JohnDoe',
  /// );
  ///
  /// String? username = controller.getFieldValue('username');
  /// print(username); // Output: JohnDoe
  /// ```
  ///
  /// If the field does not exist or has no value, it returns `null`:
  /// ```dart
  /// String? missingField = controller.getFieldValue('unknown');
  /// print(missingField); // Output: null
  /// ```
  ///
  /// - **Type parameter `<T>`**: The expected type of the field value.
  /// - **Parameter `name`**: The name of the field whose value needs to be retrieved.
  /// - **Returns**: The current value of the field, or `null` if the field is not found.
  T? getFieldValue<T>(String name) {
    return _fields[name]?.value as T?;
  }


  /// Moves focus to the field with the specified name.
  ///
  /// This method uses the field's [FocusNode] to request focus. It is useful for
  /// programmatically setting focus based on field name.
  ///
  /// If the field is not found or its [FocusNode] has no context (i.e., not attached to the widget tree),
  /// the method does nothing.
  ///
  /// ### Example:
  /// ```dart
  /// formController.focus('email');
  /// ```
  ///
  /// - [name] — the name of the field to focus.
  void focus(String name) {
    final node = _fields[name]?.focusNode;
    if (node != null && node.context != null) {
      FocusScope.of(node.context!).requestFocus(node);
    }
    else{
      if(_debug){
        if (kDebugMode) {
          print('node: ${node != null } context: ${node?.context != null}');
        }
      }
    }
  }

  /// Removes focus from the field with the given name.
  ///
  /// If the field exists, its [FocusNode] will be unfocused.
  ///
  /// - [name] — the name of the field.
  void unfocus(String name) {
    _fields[name]?.focusNode.unfocus();
  }

  /// Checks whether the specified field currently has focus.
  ///
  /// - [name] — the name of the field.
  /// - Returns `true` if the field is focused, otherwise `false`.
  bool hasFocus(String name) {
    return _fields[name]?.focusNode.hasFocus ?? false;
  }

  /// Moves focus to the next field after the current one.
  ///
  /// Fields are ordered by their insertion order. If the current field is found,
  /// focus will be moved to the next field if available.
  ///
  /// - [currentName] — the name of the current field.
  void focusNext(String currentName) {
    final keys = _fields.keys.toList();
    final currentIndex = keys.indexOf(currentName);
    if (currentIndex != -1 && currentIndex + 1 < keys.length) {
      final nextName = keys[currentIndex + 1];
      focus(nextName);
    }
  }

  /// Moves focus to the previous field before the current one.
  ///
  /// Fields are ordered by their insertion order. If the current field is found,
  /// focus will be moved to the previous field if available.
  ///
  /// - [currentName] — the name of the current field.
  void focusPrevious(String currentName) {
    final keys = _fields.keys.toList();
    final currentIndex = keys.indexOf(currentName);
    if (currentIndex > 0) {
      final previousName = keys[currentIndex - 1];
      focus(previousName);
    }else{
      if(_debug){
        if (kDebugMode) {
          print('currentIndex null');
        }
      }
    }
  }

  /// Checks whether the specified field currently has a validation error.
  ///
  /// Returns `true` if an error is set for the field, otherwise `false`.
  ///
  /// ### Example Usage:
  /// ```dart
  /// bool hasError = formController.hasError('email');
  /// if (hasError) {
  ///   print('Email field has an error.');
  /// }
  /// ```
  ///
  /// - [name] — the name of the field to check.
  bool hasError(String name) {
    return _fields[name]?.error != null;
  }

  /// Moves focus to the first field that contains a validation error.
  ///
  /// This method scans all registered fields in their insertion order
  /// and focuses the first one that has a non-null error message.
  ///
  /// If no field has an error, nothing happens.
  ///
  /// ### Example Usage:
  /// ```dart
  /// formController.validate(); // Populate errors
  /// formController.focusFirstError(); // Focus first errored field
  /// ```
  void focusFirstError() {
    for (final entry in _fields.entries) {
      if (entry.value.error != null) {
        final node = entry.value.focusNode;
        if (node.context != null) {
          FocusScope.of(node.context!).requestFocus(node);
        }
        break;
      }
    }
  }
}
