import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_password_input.dart';
import '../inputs/go_text_input.dart';

class FocusExamplePage extends StatefulWidget {
  const FocusExamplePage({super.key});

  @override
  State<FocusExamplePage> createState() => _FocusExamplePageState();
}

class _FocusExamplePageState extends State<FocusExamplePage> {
  final form = FormController(debug: true);

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Focus Example')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DynamicForm(
                fields: [
                  GoTextInput(
                    label: 'Name',
                    name: 'name',
                  ),
                  GoTextInput(
                    label: 'Email',
                    name: 'email',
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
                ],
                controller: form,
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () => form.focus('name'),
                    child: const Text('Focus Name'),
                  ),
                  ElevatedButton(
                    onPressed: () => form.focus('email'),
                    child: const Text('Focus Email'),
                  ),
                  ElevatedButton(
                    onPressed: () => form.focus('password'),
                    child: const Text('Focus Password'),
                  ),
                  ElevatedButton(
                    onPressed: () => form.unfocus('email'),
                    child: const Text('Unfocus Email'),
                  ),
                  ElevatedButton(
                    onPressed: () => form.focusNext('name'),
                    child: const Text('Focus Next After Name'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
