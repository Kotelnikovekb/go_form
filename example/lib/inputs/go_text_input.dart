import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_form/go_form.dart';
import 'package:go_form_example/inputs/root_input.dart';

class GoTextInput extends FormFieldModelBase<String> {
  final String label;
  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool obscureText;

  const GoTextInput({
    required super.name,
    super.validator,
    required this.label,
    this.prefix,
    this.inputFormatters,
    this.keyboardType,
    super.key,
    super.initialValue,
    super.debounceDuration,
    super.asyncValidator,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context, FieldController<String> controller) {
    return RootInput(
      onChanged: (newValue) => controller.onChange(newValue),
      initialValue: controller.value,
      validator: validator,
      errorText: controller.error,
      labelText: label,
      prefix: prefix,
      inputFormatters: inputFormatters,
      focusNode: controller.focusNode,
    );
  }
}
