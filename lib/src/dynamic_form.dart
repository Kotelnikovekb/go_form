import 'package:flutter/material.dart';

import 'domain/domain.dart';
import 'form_controller.dart';

class DynamicForm extends StatefulWidget {
  final List<FormFieldModelBase> fields;
  final FormController controller;
  final double fieldSpacing;


  const DynamicForm({super.key,
    required this.fields,
    required this.controller,
    this.fieldSpacing = 8.0,
  });

  @override
  _DynamicFormState createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  @override
  void initState() {
    super.initState();
    for (var field in widget.fields) {
      widget.controller.addTextField(name: field.name,initialValue:  field.initialValue,validator: field.validator);
    }
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: ValueListenableBuilder<Map<String, String?>>(
        valueListenable: widget.controller.errors,
        builder: (context, errors, _) {
          return Column(
            children: List.generate(widget.fields.length * 2 - 1, (index) {
              if (index.isEven) {
                return widget.fields[index ~/ 2].build(context, widget.controller);
              } else {
                return SizedBox(height: widget.fieldSpacing);
              }
            }),
          );
        },
      ),
    );
  }
}