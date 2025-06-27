import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_dynamic_input.dart';
import '../inputs/go_text_input.dart';

/// Example: Dynamic Form Actions
///
/// This example demonstrates how to use `FormController` and `DynamicForm`
/// from the `go_form` package to programmatically interact with a form.
///
/// Features shown in this example:
/// - Setting a field value programmatically (`setValue`)
/// - Listening to all form changes (`addListener`)
/// - Listening to specific field changes (`addFieldValueListener`)
/// - Getting current form values (`getValues`)
/// - Validating the form (`validate`)
/// - Resetting all fields (`resetAllFields`)
/// - Getting the value of a specific field (`getFieldValue`)
///
/// This example is useful for learning how to interact with a form
/// without manually managing input controllers.

class DynamicActionsPage extends StatefulWidget {
  const DynamicActionsPage({super.key});

  @override
  State<DynamicActionsPage> createState() => _DynamicActionsPageState();
}

class _DynamicActionsPageState extends State<DynamicActionsPage> {
  final _formController = FormController();
  String _output = '';

  @override
  void initState() {
    super.initState();
    _formController.addListener(() {
      setState(() {
        _output = 'All Values: ${_formController.getValues()}';
      });
    });
    _formController.addFieldValueListener((name, v) {
      setState(() {
        _output = 'Field "$name" changed: $v';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Actions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DynamicForm(
              fields: [
                GoDynamicInput(
                  name: 'text',
                  label: 'Email Address',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Please provide an email';
                    }
                    return null;
                  },
                ),
              ],
              controller: _formController,
            ),
            TextButton(
              onPressed: () {
                _formController.setValue('text', 'custom@email.example');
              },
              child: const Text('Set Email'),
            ),
            ElevatedButton(
              onPressed: () {
                if (!_formController.validate()) {
                  return;
                }
                setState(() {
                  _output = 'Validated values: ${_formController.getValues()}';
                });
              },
              child: const Text('Submit'),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                _formController.resetAllFields();
              },
              child: const Text('Reset Fields'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _output =
                      'Single value: ${_formController.getFieldValue<String>('text')}';
                });
              },
              child: const Text('Get Field Value'),
            ),
            const SizedBox(height: 20),
            Text(_output),
          ],
        ),
      ),
    );
  }
}
