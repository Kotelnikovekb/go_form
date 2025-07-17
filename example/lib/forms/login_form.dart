import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';
import 'package:go_form_example/inputs/go_password_input.dart';

import '../inputs/inputs.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formController = FormController(debug: true);
  String result='';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DynamicForm(
          fields: [
            GoTextInput(
              name: 'email',
              label: 'Email',
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Согласись';
                }
                return null;
              },
            ),
            GoPasswordInput(
              name: 'password',
              label: 'Password',
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Согласись';
                }
                return null;
              },
            ),
            GoCheckBox(
              name: 'checkbox',
              label: 'checkbox',
              validator: (val) {
                if (val == null || val == false) {
                  return 'Согласись';
                }
                return null;
              },
            ),
          ],
          controller: _formController,
        ),
        ElevatedButton(
          onPressed: () {
            _formController.resetAllErrors();
            if (!_formController.validate()) {
              return;
            }
            print('${_formController.getValues()}');
            setState(() {
              result='${_formController.getValues()}';
            });
          },
          child: const Text('Результат'),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(result)
      ],
    );
  }
}
