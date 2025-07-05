import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_form/go_form.dart';
import 'package:go_form_example/inputs/root_input.dart';

class GoSearchInput extends FormFieldModelBase<String> {
  final String label;
  final Widget? prefix;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  const GoSearchInput({
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
    super.onDebounceComplete,
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
      suffixIcon: Builder(builder: (context) {
        switch (controller.status) {
          case FieldStatus.idle:
            return const SizedBox();
          case FieldStatus.error:
            return const Icon(Icons.error);
          case FieldStatus.debounce:
          case FieldStatus.loading:
            return const SizedBox(
              width: 6,
              height: 6,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case FieldStatus.filled:
          case FieldStatus.validated:
            return const Icon(Icons.check);
        }
      }),
    );
  }
}
