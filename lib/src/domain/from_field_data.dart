import 'package:flutter/material.dart';

class FormFieldData<T> {
  final ValueNotifier<T?> value;
  final String? error;
  final String? Function(T? value)? validator;
  final Key? key;
  final Future<String?> Function(T? value)? asyncValidator;

  FormFieldData({
    T? initialValue,
    this.validator,
    this.error,
    this.key,
    this.asyncValidator,
  }) : value = ValueNotifier<T?>(initialValue);

  @override
  bool operator ==(Object other) {
    return other is FormFieldData<T> &&
        other.value == value &&
        other.error == error;
  }

  @override
  int get hashCode => value.hashCode ^ error.hashCode;

  /// Creates a copy of this [FormFieldData] with the ability to override some properties.
  FormFieldData<T> copyWith({
    T? initialValue,
    String? error,
    String? Function(dynamic value)? validator,
    T? value,
    Future<String?> Function(T? value)? asyncValidator,
  }) {
    return FormFieldData<T>(
      initialValue: initialValue ?? this.value.value,
      error: error ?? this.error,
      validator: validator ?? this.validator,
      asyncValidator: asyncValidator ?? this.asyncValidator,
    );
  }

  void dispose() {
    value.dispose();
  }
}
