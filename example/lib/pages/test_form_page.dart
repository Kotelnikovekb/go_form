import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_dynamic_input.dart';

class TestFormPage extends StatefulWidget {
  const TestFormPage({super.key});

  @override
  State<TestFormPage> createState() => _TestFormPageState();
}

class _TestFormPageState extends State<TestFormPage> {
  final _formController = FormController();


  void _validateForm() {
    _formController.validate();
  }

  void _resetErrors() {
    _formController.resetAllErrors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test form'),
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            DynamicForm(
              fields: [
                GoDynamicInput(
                    key: const Key('email'),
                    name: 'text',
                    label: 'Email',
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Согласись';
                      }
                      return null;
                    },
                    initialValue: 'hello')
              ],
              controller: _formController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('validate_button'),
              onPressed: _validateForm,
              child: const Text('Validate'),
            ),
            ElevatedButton(
              key: const Key('reset_button'),
              onPressed: _resetErrors,
              child: const Text('Reset Errors'),
            ),
          ],
        ),
      ),
    );
  }
}
