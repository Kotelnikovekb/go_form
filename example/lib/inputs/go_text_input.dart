
import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

class GoTextInput extends FormFieldModelBase<String>{
  final String label;
  GoTextInput( {required super.name, super.validator,required this.label,});

  @override
  Widget build(BuildContext context, FormController controller) {
    final fieldData = controller.getFieldData<String>(name);
    return TextFormField(
      focusNode: fieldData.focusNode,
      onChanged: (newValue) => fieldData.value.value = newValue,
      initialValue: fieldData.value.value,
      validator: validator,
    );
  }

  @override
  getValue(FormController controller) {
    throw UnimplementedError();
  }

}