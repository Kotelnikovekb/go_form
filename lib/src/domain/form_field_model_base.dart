import 'package:flutter/material.dart';

import '../../go_form.dart';

/// Base class for defining custom form fields within a `DynamicForm`.
///
/// This abstract class allows developers to create reusable form field components
/// with validation, initial values, and integration with `FormController`.
///
/// ### Example Usage:
/// ```dart
/// class GoDynamicInput extends FormFieldModelBase<String> {
///   final String label;
///
///   GoDynamicInput({
///     required super.name,
///     super.validator,
///     required this.label,
///     super.initialValue,
///     super.key,
///   });
///
///   @override
///   Widget build(BuildContext context, FieldController<String> controller) {
///     return TextFormField(
///       key: key,
///       controller: controller.textController,
///       decoration: InputDecoration(labelText: label, errorText: controller.error),
///     );
///   }
/// }
/// ```
///
/// ### Type Parameter `<T>`
/// - Defines the expected type of the field's value.
///
/// ### Properties:
/// - **`name`**: Unique identifier for the field in the form.
/// - **`initialValue`**: The default value of the field when the form is initialized.
/// - **`validator`**: A function that validates the field's value and returns an error message if invalid.
/// - **`key`**: Optional key for widget identification in tests or optimizations.
///
/// ### Methods:
/// - **`build()`**: Must be implemented to define the UI of the field.
/// - **`addToController()`**: Registers the field in the provided `FormController` and returns its `FieldController`.
///
/// This class serves as a foundation for creating custom form fields, such as text inputs, checkboxes, and dropdowns.
abstract class FormFieldModelBase<T> {
  /// Unique identifier for the field in the form.
  ///
  /// Used to reference the field when retrieving values or setting errors in `FormController`.
  final String name;

  /// The initial value of the field when the form is first loaded.
  ///
  /// If not provided, the value will be `null` until updated.
  final T? initialValue;

  /// A validation function that checks if the field's value is valid.
  ///
  /// Returns an error message if the validation fails, or `null` if the value is valid.
  final String? Function(T?)? validator;

  /// An optional `Key` used for widget identification in tests and rendering optimizations.
  final Key? key;

  /// Optional debounce duration for input changes.
  final Duration? debounceDuration;

  /// Optional async validator for the field.
  final Future<String?> Function(T?)? asyncValidator;

  /// Optional callback that will be triggered after debounce completes.
  final void Function()? onDebounceComplete;

  /// Constructor for creating a form field.
  ///
  /// - `name` – Required unique name for the field.
  /// - `initialValue` – Optional default value.
  /// - `validator` – Function to validate the field's input.
  /// - `asyncValidator` – Async function to validate the field's input.
  /// - `key` – Optional key for testing and performance optimization.
  /// - `debounceDuration` – Optional debounce duration for input changes.
  const FormFieldModelBase({
    required this.name,
    this.initialValue,
    this.validator,
    this.asyncValidator,
    this.key,
    this.debounceDuration,
    this.onDebounceComplete,
  });

  /// Abstract method that must be implemented to define the UI of the field.
  ///
  /// Receives `context` and a `FieldController<T>` that manages the state of this field.
  Widget build(BuildContext context, FieldController<T> controller);

  /// Returns the data type (`T`) stored in this field.
  ///
  /// Useful for dynamic analysis of form structure.
  Type get fieldType => T;





  /// Registers this field in the `FormController` and returns its `FieldController`.
  ///
  /// This method automatically adds the field to the `FormController` and links it
  /// to the form's state management.
  ///
  /// ```dart
  /// final controller = FormController();
  /// final fieldController = myField.addToController(controller);
  /// ```
  FieldController<T> addToController(FormController controller) {
    return controller.addTextField<T>(
      name: name,
      initialValue: initialValue,
      validator: validator,
      asyncValidator: asyncValidator,
      key: key,
      debounceDuration: debounceDuration,
      onDebounceComplete: onDebounceComplete,
    );
  }

  /// Called once when the field is initialized in the form.
  /// Can be overridden for custom logic (e.g., async loading, side effects).
  @mustCallSuper
  void onInit(FieldController<T> controller) {}
}
