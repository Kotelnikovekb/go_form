import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:go_form_example/inputs/root_input.dart';

class GoPasswordInput extends FormFieldModelBase<String>{
  final String label;
  GoPasswordInput( {required super.name, super.validator,required this.label,});

  @override
  Widget build(BuildContext context, FieldController controller) {
    return StatefulBuilder(
      builder: (context,setState) {
        bool showPassword=false;
        return RootInput(
          onChanged: (newValue) => controller.onChange(newValue),
          initialValue: controller.value,
          validator: validator,
          errorText: controller.error,
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon((showPassword)?Icons.visibility:Icons.visibility_off),
            onPressed: () {
              showPassword=!showPassword;
              setState((){});
            },
          ),
          obscureText: showPassword,
        );
      }
    );
  }
}
