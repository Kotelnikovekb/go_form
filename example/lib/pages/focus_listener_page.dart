import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_check_box.dart';
import '../inputs/go_password_input.dart';
import '../inputs/go_text_input.dart';

class FocusListenerPage extends StatefulWidget {
  const FocusListenerPage({super.key});

  @override
  State<FocusListenerPage> createState() => _FocusListenerPageState();
}

class _FocusListenerPageState extends State<FocusListenerPage> {
  final _formController = FormController();

  @override
  void initState() {
    super.initState();
    _formController.addFocusListener((name, focus) {
      print('Поле $name ${focus.hasFocus ? "получило" : "потеряло"} фокус');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Listener page'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
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
      ),
    );
  }
}
