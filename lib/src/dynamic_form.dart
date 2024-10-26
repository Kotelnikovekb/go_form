import 'package:flutter/material.dart';

import 'domain/domain.dart';
import 'form_controller.dart';

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
          if (index.isEven) {
            final field = widget.fields[index ~/ 2];
            field.addToController(widget.controller);


            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                field.build(context, widget.controller),
                ValueListenableBuilder<String?>(
                  valueListenable: widget.controller.getErrorNotifier(field.name),
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
          } else {
            return SizedBox(height: widget.fieldSpacing);
          }
        }),
      ),
    );
  }
}