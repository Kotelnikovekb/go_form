import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_form_files.dart';

class SelectFilePage extends StatefulWidget {
  const SelectFilePage({super.key});

  @override
  State<SelectFilePage> createState() => _SelectFilePageState();
}

class _SelectFilePageState extends State<SelectFilePage> {

  final formController = FormController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Выбор файлов'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DynamicForm(
                fields: [
                  GoFormFiles(
                    name: 'files',
                  )
                ],
                controller: formController
            )
          ],
        ),
      ),
    );
  }
}
