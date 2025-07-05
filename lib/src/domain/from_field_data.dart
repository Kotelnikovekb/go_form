import 'package:flutter/material.dart';

import '../../go_form.dart';

class FormFieldData<T> {
  final ValueNotifier<T?> value;
  final String? error;
  final String? Function(T? value)? validator;
  final Key? key;
  final Future<String?> Function(T? value)? asyncValidator;
  final void Function()? onDebounceComplete;
  final FieldStatus status;

  FormFieldData({
    T? initialValue,
    this.validator,
    this.error,
    this.key,
    this.asyncValidator,
    this.status = FieldStatus.idle,
    this.onDebounceComplete,
  }) : value = ValueNotifier<T?>(initialValue);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FormFieldData<T> &&
        other.value.value == value.value &&
        other.error == error &&
        other.validator == validator &&
        other.asyncValidator == asyncValidator &&
        other.status == status;
  }

  @override
  int get hashCode =>
      value.value.hashCode ^
      error.hashCode ^
      validator.hashCode ^
      asyncValidator.hashCode ^
      status.hashCode;

  /// Creates a copy of this [FormFieldData] with the ability to override some properties.
  FormFieldData<T> copyWith({
    T? initialValue,
    String? error,
    String? Function(dynamic value)? validator,
    T? value,
    Future<String?> Function(T? value)? asyncValidator,
    FieldStatus? status,
    void Function()? onDebounceComplete,
  }) {
    return FormFieldData<T>(
      initialValue: initialValue ?? this.value.value,
      error: error ?? this.error,
      validator: validator ?? this.validator,
      asyncValidator: asyncValidator ?? this.asyncValidator,
      status: status ?? this.status,
      onDebounceComplete: onDebounceComplete ?? this.onDebounceComplete,
    );
  }

  void dispose() {
    value.dispose();
  }
}
