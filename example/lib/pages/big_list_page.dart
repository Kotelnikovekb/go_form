
import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import '../inputs/go_text_input.dart';

/// Example: Big List Form Page
///
/// This example demonstrates how to build a scrollable form
/// with a large number of fields using `DynamicForm` from the `go_form` package.
///
/// Key features:
/// - Validates multiple fields
/// - Automatically scrolls to the first field with a validation error
/// - Uses `FormController` and `ScrollController` for managing form and scroll behavior
///
/// This page is useful for testing large forms, input performance,
/// and error handling in vertical layouts.
class BigListPage extends StatefulWidget {
  const BigListPage({super.key});

  @override
  State<BigListPage> createState() => _BigListPageState();
}

class _BigListPageState extends State<BigListPage> {
  final _formController = FormController();
  final ScrollController _scrollController = ScrollController();


  void _validateForm() {
    if(!_formController.validate()){
      _formController.scrollToFirstErrorField();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: DynamicForm(
            fields: [
              ...List.generate(10, (index){
                return GoTextInput(
                  name: 'text$index',
                  label: 'Email',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Fill in the field';
                    }
                    return null;
                  },
                  initialValue: 'text ${index}',
                );
              }),
              GoTextInput(
                name: 'email_error',
                label: 'Email',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Fill in the field';
                  }
                  return null;
                },
              )
            ],
            controller: _formController,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
            onPressed: _validateForm,
            child: const Text('Validate'),
          ),
        ),
      ),
    );
  }
}
