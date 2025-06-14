import 'package:flutter/material.dart';
import 'package:go_form_example/pages/test_form_page.dart';
import 'package:go_form_example/pages/validate_listener_page.dart';
import 'package:go_form_example/pages/value_listener.dart';

import '../forms/forms.dart';
import 'big_list_page.dart';
import 'dynamic_actions_page.dart';
import 'focus_listener_page.dart';
import 'form_page.dart';
import 'init_values_page.dart';
import 'onInit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormPage(
                    title: 'Login Form',
                    body: LoginForm(),
                  ),
                ),
              );
            },
            child: Text('Login'),
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FormPage(
                    title: 'Registration Form',
                    body: RegistrationPage(),
                  ),
                ),
              );
            },
            child: Text('Registration'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DynamicActionsPage(),
                ),
              );
            },
            child: Text('Dynamic Actions'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InitValuesPage(),
                ),
              );
            },
            child: Text('Init values'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestFormPage(),
                ),
              );
            },
            child: Text('Test'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BigListPage(),
                ),
              );
            },
            child: Text('big list'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ValidateListenerPage(),
                ),
              );
            },
            child: Text('Validate Page'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FocusListenerPage(),
                ),
              );
            },
            child: Text('Focus listener'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OninitPage(),
                ),
              );
            },
            child: Text('OninitPage'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ValueListenerPage(),
                ),
              );
            },
            child: Text('ValueListenerPage'),
          ),
        ],
      ),
    );
  }
}
