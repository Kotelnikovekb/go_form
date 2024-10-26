import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/inputs.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formController = FormController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DynamicForm(
          fields: [
            GoCheckBox(
                name: 'checkbox',
                label: 'checkbox',
                validator: (val) {
                  if (val == null || val == false) {
                    return 'Согласись';
                  }
                  return null;
                }),
            GoTextInput(
                name: 'text',
                label: 'text',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Согласись';
                  }
                  return null;
                }),
          ],
          controller: _formController,
        ),
        ElevatedButton(
          onPressed: () {
            if(_formController.validate()){
              return;
            }
            print('${_formController.getValues()}');
          },
          child: Text('Результат'),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}
