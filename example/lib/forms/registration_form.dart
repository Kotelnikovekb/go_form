import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_check_box.dart';
import '../inputs/go_password_input.dart';
import '../inputs/go_text_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formController = FormController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DynamicForm(
          fields: [
            GoTextInput(
              name: 'text',
              label: 'Email',
              validator: (val) {
                if (val == null || val.isEmpty) {
                  return 'Согласись';
                }
                return null;
              },
            ),
            GoPasswordInput(
              name: 'text',
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
    );
  }
}
