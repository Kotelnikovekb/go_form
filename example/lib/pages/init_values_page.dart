import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_dropdown_button.dart';
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
        title: Text('Редактирование профиля'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DynamicForm(
              fields: [
                GoDynamicInput(
                  name: 'name',
                  label: 'Имя',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Пожалуйста, введите имя';
                    }
                    return null;
                  },
                  initialValue: 'Алексей',
                ),
                GoDynamicInput(
                  name: 'email',
                  label: 'Email',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Введите email';
                    }
                    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
                    if (!emailRegex.hasMatch(val)) {
                      return 'Некорректный email';
                    }
                    return null;
                  },
                  initialValue: 'alexey@example.com',
                ),
                GoDropdownButton(
                  name: 'gender',
                  items: ['Мужской', 'Женский', 'Другое'],
                  initialValue: 'Мужской',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Выберите пол';
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

          ],
        ),
      ),
    );
  }
}
