import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_recaptcha.dart';

class OninitPage extends StatefulWidget {
  const OninitPage({super.key});

  @override
  State<OninitPage> createState() => _OninitPageState();
}

class _OninitPageState extends State<OninitPage> {
  final controller = FormController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('recapcha'),
      ),
      body: Column(
        children: [
          DynamicForm(
            fields: [GoRecaptcha(name: 'recapcha')],
            controller: controller,
          )
        ],
      ),
    );
  }
}
