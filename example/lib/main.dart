import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:go_form/go_form.dart';

import 'inputs/go_check_box.dart';
import 'inputs/go_text_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _formController = FormController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
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
                _formController.validate();
                print('${_formController.getValues()}');
              },
              child: Text('Результат'),
            )
          ],
        ),
      ),
    );
  }
}
