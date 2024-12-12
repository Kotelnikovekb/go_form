import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_dynamic_input.dart';

class InitValuesPage extends StatefulWidget {
  const InitValuesPage({super.key});

  @override
  State<InitValuesPage> createState() => _InitValuesPageState();
}

class _InitValuesPageState extends State<InitValuesPage> {
  final _formController = FormController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('init values'),
      ),
      body: Column(
        children: [
          DynamicForm(
            fields: [
              GoDynamicInput(
                name: 'text',
                label: 'Email',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Согласись';
                  }
                  return null;
                },
                initialValue: 'hello'
              )
            ],
            controller: _formController,
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formController.validate()) {
                return;
              }
              print('${_formController.getValues()}');
            },
            child: Text('Результат'),
          ),

        ],
      ),
    );
  }
}
