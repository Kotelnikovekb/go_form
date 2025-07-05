import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:go_form_example/inputs/go_text_input.dart';

import '../inputs/search_input.dart';

/// Example: Debounced Input Field
///
/// This example demonstrates how to use a debounce delay on a text field
/// using `GoTextInput` from the `go_form` package. The value change is debounced
/// by 2 seconds and the result is displayed on the screen.
///
/// This is useful for cases like search inputs, where you want to limit
/// how often the form reacts to user typing.
class DebounceExamplePage extends StatefulWidget {
  const DebounceExamplePage({super.key});

  @override
  State<DebounceExamplePage> createState() => _DebounceExamplePageState();
}

class _DebounceExamplePageState extends State<DebounceExamplePage> {
  final formController = FormController();
  String _output = '';

  @override
  void initState() {
    super.initState();
    formController.addFieldValueListener((f, v) {
      setState(() {
        _output = 'Debounced value: $v';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debounce'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            DynamicForm(
              fields: [
                GoSearchInput(
                  name: 'search',
                  label: 'Search',
                  debounceDuration: const Duration(seconds: 2),
                  asyncValidator: (v) async {
                    if (v == null || v.isEmpty) {
                      return 'Input text';
                    }
                    await Future.delayed(const Duration(seconds: 2));
                    if (v == 'admin') {
                      return 'Name exist';
                    }
                    return null;
                  },
                  onDebounceComplete: () async {
                    print('start onDebounceComplete');
                    await formController.validateAsync();
                  },
                ),
              ],
              controller: formController,
            ),
            const SizedBox(height: 16),
            Text(_output),
            ElevatedButton(
              onPressed: () {
                formController.setError('search', 'error');
              },
              child: Text('Add error'),
            )
          ],
        ),
      ),
    );
  }
}
