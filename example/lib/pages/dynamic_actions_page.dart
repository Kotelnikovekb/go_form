import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_dynamic_input.dart';
import '../inputs/go_text_input.dart';

class DynamicActionsPage extends StatefulWidget {
  const DynamicActionsPage({super.key});

  @override
  State<DynamicActionsPage> createState() => _DynamicActionsPageState();
}

class _DynamicActionsPageState extends State<DynamicActionsPage> {
  final _formController = FormController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

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
              ),
            ],
            controller: _formController,
          ),
          TextButton(
              onPressed: (){
                _formController.setValue('text', 'ep;dfksmb');
              },
              child: Text('set Emmail')
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
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}