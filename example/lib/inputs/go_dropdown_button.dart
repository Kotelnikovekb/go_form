import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

class GoDropdownButton<T> extends FormFieldModelBase<T> {
  final List<T> items;

  const GoDropdownButton({
    required super.name,
    required this.items,
    super.asyncValidator,
    super.initialValue,
    super.validator,
    super.key,

  });

  @override
  Widget build(BuildContext context, FieldController<T> controller) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        onChanged: (T? value) {
          controller.onChange(value);
        },
        value: controller.value,
        items: items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(item.toString()),
              ),
            )
            .toList(),
      ),

    );
  }
}
