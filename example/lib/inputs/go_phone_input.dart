import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'root_input.dart';

class GoPhoneInput extends FormFieldModelBase<String>{
  final String label;
  final maskFormatter =  MaskTextInputFormatter(
      mask: '+# (###) ###-##-##',
      filter: { "#": RegExp(r'[0-9]') },
      type: MaskAutoCompletionType.lazy
  );
  GoPhoneInput( {required super.name, super.validator,required this.label,});

  @override
  Widget build(BuildContext context, FieldController controller) {
    return RootInput(
      onChanged: (newValue) => controller.onChange(newValue),
      initialValue: controller.value,
      validator: validator,
      errorText: controller.error,
      labelText: label,
      inputFormatters: [maskFormatter],
    );
  }
}