import 'package:flutter/material.dart';

import 'domain/domain.dart';
import 'controllers/form_controller.dart';

class DynamicForm extends StatefulWidget {
  final List<FormFieldModelBase<dynamic>> fields;
  final FormController controller;
  final double fieldSpacing;

  const DynamicForm({
    super.key,
    required this.fields,
    required this.controller,
    this.fieldSpacing = 8.0,
  });

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  @override
  Widget build(BuildContext context) {

    return Form(
      child: Column(
        children: List.generate(widget.fields.length * 2 - 1, (index) {
          final field=widget.fields[index~/2];
          final controller =field.addToController(widget.controller);
          if (index.isEven) {
            return ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, fieldData, child) {
                return widget.fields[index ~/ 2].build(context, widget.controller.getFieldController(field.name));
              },
            );

          } else {
            return SizedBox(height: widget.fieldSpacing);
          }
        }),
      ),
    );
  }
}