import 'package:flutter/material.dart';

import '../../go_form.dart';

abstract class FormFieldModelBase<T> {
  final String name;
  final T? initialValue;
  final String? Function(T?)? validator;

  FormFieldModelBase({
    required this.name,
    this.initialValue,
    this.validator,
  });

  Widget build(BuildContext context, FieldController<T> controller);

  Type get fieldType => T;

  FieldController<T> addToController(FormController controller) {
    return controller.addTextField<T>(
      name: name,
      initialValue: initialValue,
      validator: validator,
    );
  }

}
