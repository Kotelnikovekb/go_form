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
  Widget build(BuildContext context, FormController controller) {
    // Получаем данные поля через FormController
    final fieldData = controller.getFieldData<bool>(name);

    return ValueListenableBuilder<bool?>(
      valueListenable: fieldData.value,
      builder: (context, value, _) {
        return Column(
          children: [
            Row(
              children: [
                Checkbox(
                  focusNode: fieldData.focusNode,
                  value: value ?? false,
                  onChanged: (newValue) {
                    fieldData.value.value = newValue;
                    if (newValue != null) {
                      controller.setError(name, null);
                    }
                  },
                ),
                Text(label),
              ],
            ),
            ValueListenableBuilder<String?>(
              valueListenable: fieldData.error,
              builder: (context, error, _) {
                return error != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  bool? getValue(FormController controller) {
    return controller.getFieldData<bool>(name).value.value;
  }
}
