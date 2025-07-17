import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_text_input.dart';

/// This example demonstrates how to use asynchronous validation in a GoForm field.
///
/// The form contains a single `GoTextInput` field with an `asyncValidator` that simulates
/// a delay and returns an error if the input is empty. When the "Validate" button is pressed,
/// the form performs async validation and can react to the result.
///
/// This is useful when validation logic requires API calls or other asynchronous operations.
class AsyncValidatorPage extends StatefulWidget {
  const AsyncValidatorPage({super.key});

  @override
  State<AsyncValidatorPage> createState() => _AsyncValidatorPageState();
}

class _AsyncValidatorPageState extends State<AsyncValidatorPage> {
  final formController = FormController();

  bool? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Validator'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            DynamicForm(
              fields: [
                GoTextInput(
                  name: 'search',
                  label: 'Search',
                  asyncValidator: (value) async {
                    await Future.delayed(const Duration(seconds: 2));
                    if (value == null || value.isEmpty) {
                      return 'error';
                    }
                    return null;
                  },
                ),
              ],
              controller: formController,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final isValid = await formController.validateAsync();
                setState(() {
                  result = isValid;
                });
                print(isValid);
              },
              child: const Text('Validate'),
            ),
            const SizedBox(
              height: 20,
            ),
            if (result != null) Text(result.toString()),
          ],
        ),
      ),
    );
  }
}
