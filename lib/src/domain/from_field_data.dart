import 'package:flutter/material.dart';

class FormFieldData<T> {
  final ValueNotifier<T?> value;
  final String? error;
  final FocusNode focusNode;
  final String? Function(T? value)? validator;
  final Key? key;

  FormFieldData( {
    T? initialValue,
    this.validator,
    this.error,
    this.key,
  })  : value = ValueNotifier<T?>(initialValue),
        focusNode = FocusNode();

  @override
  bool operator ==(Object other) {
    return other is FormFieldData<T> && other.value==value&&other.error==error;
  }

  @override
  int get hashCode => value.hashCode^error.hashCode;

  /// Creates a copy of this [FormFieldData] with the ability to override some properties.
  FormFieldData<T> copyWith({
    T? initialValue,
    String? error,
    String? Function(dynamic value)? validator,
    T? value,
  }) {
    return FormFieldData<T>(
      initialValue: initialValue ?? this.value.value,
      error: error ?? this.error,
      validator: validator ?? this.validator,
    );
  }

  void dispose() {
    focusNode.dispose();
    value.dispose();
  }

}
