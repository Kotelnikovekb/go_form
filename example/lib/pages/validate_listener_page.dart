import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_check_box.dart';
import '../inputs/go_password_input.dart';
import '../inputs/go_text_input.dart';

class ValidateListenerPage extends StatefulWidget {
  const ValidateListenerPage({super.key});

  @override
  State<ValidateListenerPage> createState() => _ValidateListenerPageState();
}

class _ValidateListenerPageState extends State<ValidateListenerPage> {
  final _formController = FormController();
  bool isValid=false;

  @override
  void initState() {
    super.initState();

    _formController.addValidationListener((v){
      setState(() {
        isValid=v;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ValidateListenerPage'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
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
              onPressed:(isValid)? (){
                if (!_formController.validate()) {
                  return;
                }
                print('${_formController.getValues()}');
              }
              : null,
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
