import 'package:flutter/material.dart';

import '../form_controller.dart';

abstract class FormFieldModelBase<T> {
  final String name;
  final T? initialValue;
  final String? Function(dynamic)? validator;

  FormFieldModelBase({
    required this.name,
    this.initialValue,
    this.validator,
  });

  Widget build(BuildContext context, FormController controller);

  T? getValue(FormController controller);

  Type get fieldType => T;

  void addToController(FormController controller) {
    controller.addTextField<T>(
      name: name,
      initialValue: initialValue,
      validator: validator,
    );
  }

}
