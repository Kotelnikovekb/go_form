
import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

class GoTextInput extends FormFieldModelBase<String>{
  final String label;
  GoTextInput( {required super.name, super.validator,required this.label,});

  @override
  Widget build(BuildContext context, FieldController controller) {
    return TextFormField(
      focusNode: controller.focusNode,
      onChanged: (newValue) => controller.onChange(newValue),
      initialValue: controller.fieldValue,
      validator: validator,
      decoration: InputDecoration(
        errorText: controller.error
      ),
    );
  }

  @override
  getValue(FieldController controller) {
    throw UnimplementedError();
  }

}