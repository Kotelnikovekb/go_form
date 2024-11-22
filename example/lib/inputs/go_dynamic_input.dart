
import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

class GoDynamicInput extends FormFieldModelBase<String>{
  final String label;
  GoDynamicInput( {required super.name, super.validator,required this.label,});

  @override
  Widget build(BuildContext context, FieldController<String> controller) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        errorText: controller.error,
      ),
      controller: controller.textController,
    );
  }
}