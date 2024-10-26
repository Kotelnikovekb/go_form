import 'package:flutter/material.dart';

class FormFieldData<T> {
  final ValueNotifier<T?> value;
  final ValueNotifier<String?> error;
  final FocusNode focusNode;
  final String? Function(T? value)? validator;

  FormFieldData({
    T? initialValue,
    this.validator,
  })  : value = ValueNotifier<T?>(initialValue),
        error = ValueNotifier<String?>(null),
        focusNode = FocusNode();
}
