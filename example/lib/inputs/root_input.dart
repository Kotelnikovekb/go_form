import 'package:flutter/material.dart';

class RootInput extends TextFormField {
  RootInput({
    super.key,
    super.focusNode,
    required void Function(String) super.onChanged,
    super.validator,
    required super.initialValue,
    required String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? labelText,
    super.obscureText,
    super.inputFormatters,
    super.controller,
    Widget? prefix,
  }) : super(
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText: errorText,
              labelText: labelText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              prefix: prefix),
        );
}
