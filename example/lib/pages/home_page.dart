import 'package:flutter/material.dart';

import '../forms/forms.dart';
import 'dynamic_actions_page.dart';
import 'form_page.dart';

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
        ],
      ),
    );
  }
}
