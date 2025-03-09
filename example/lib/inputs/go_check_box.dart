import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

class GoCheckBox extends FormFieldModelBase<bool> {
  final String label;

  GoCheckBox({
    required super.name,
    super.initialValue = false,
    super.validator,
    required this.label,
  });

  @override
  Widget build(BuildContext context, FieldController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Checkbox(
              value: controller.value,
              onChanged: (newValue) {
                controller.onChange(newValue);
              },
            ),
            Text(label),
          ],
        ),
        if (controller.error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              controller.error!,
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );  }

}
