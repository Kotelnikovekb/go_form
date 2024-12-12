import 'package:flutter/material.dart';

class FormFieldData<T> {
  final ValueNotifier<T?> value;
  String? error;
  final FocusNode focusNode;
  final String? Function(T? value)? validator;

  FormFieldData({
    T? initialValue,
    this.validator,
    this.error,
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


}
