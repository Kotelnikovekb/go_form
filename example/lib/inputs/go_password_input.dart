import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:go_form_example/inputs/root_input.dart';

class GoPasswordInput extends FormFieldModelBase<String>{
  final String label;
  GoPasswordInput( {required super.name, super.validator,required this.label,});

  @override
  Widget build(BuildContext context, FieldController controller) {
    return _PasswordField(
      controller: controller,
      label: label,
      validator: validator,
    );
  }
}

class _PasswordField extends StatefulWidget {
  final FieldController controller;
  final String label;
  final String? Function(String?)? validator;

  const _PasswordField({
    required this.controller,
    required this.label,
    this.validator,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return RootInput(
      onChanged: (newValue) => widget.controller.onChange(newValue),
      initialValue: widget.controller.value,
      validator: widget.validator,
      errorText: widget.controller.error,
      labelText: widget.label,
      suffixIcon: IconButton(
        icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            showPassword = !showPassword;
          });
        },
      ),
      obscureText: !showPassword,
    );
  }
}
