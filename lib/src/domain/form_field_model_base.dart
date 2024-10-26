import 'package:flutter/material.dart';

import '../form_controller.dart';

abstract class FormFieldModelBase<T> {
  final String name;
  final String label;
  final T? initialValue;
  final String? Function(dynamic)? validator;

  FormFieldModelBase({
    required this.name,
    required this.label,
    this.initialValue,
    this.validator,
  });

  Widget build(BuildContext context, FormController controller);

  T? getValue(TextEditingController controller);
}
