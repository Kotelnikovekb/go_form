import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import 'root_input.dart';

class GoPhoneInput extends FormFieldModelBase<String>{
  final String label;
  GoPhoneInput( {required super.name, super.validator,required this.label,});

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