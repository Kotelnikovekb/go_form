import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:go_form_example/inputs/root_input.dart';

class GoTextInput extends FormFieldModelBase<String> {
  final String label;

  GoTextInput({
    required super.name,
    super.validator,
    required this.label,
  });

  @override
  Widget build(BuildContext context, FieldController controller) {
    return RootInput(
      onChanged: (newValue) => controller.onChange(newValue),
      initialValue: controller.value,
      validator: validator,
      errorText: controller.error,
      labelText: label,
    );
  }
}
