import 'package:flutter/material.dart';
import 'package:go_form_example/pages/phone_and_country.dart';
import 'package:go_form_example/pages/select_file_page.dart';
import 'package:go_form_example/pages/test_form_page.dart';
import 'package:go_form_example/pages/validate_listener_page.dart';
import 'package:go_form_example/pages/value_listener.dart';

import '../forms/forms.dart';
import 'async_validator_page.dart';
import 'big_list_page.dart';
import 'debounce_example_page.dart';
import 'dynamic_actions_page.dart';
import 'focus_example_page.dart';
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
        title: const Text('Go form'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Authentication'),
          _buildNavButton(context, 'Login',
              const FormPage(title: 'Login Form', body: LoginForm())),
          _buildNavButton(
              context,
              'Registration',
              const FormPage(
                  title: 'Registration Form', body: RegistrationPage())),
          _buildSectionTitle('Examples'),
          _buildNavButton(context, 'Init values', const InitValuesPage()),
          _buildNavButton(
              context, 'Dynamic Actions', const DynamicActionsPage()),
          _buildNavButton(context, 'Test', const TestFormPage()),
          _buildNavButton(context, 'Big List', const BigListPage()),
          _buildNavButton(context, 'Focus', const FocusExamplePage()),
          _buildNavButton(context, 'Debounce', const DebounceExamplePage()),
          _buildNavButton(
              context, 'Async Validator', const AsyncValidatorPage()),
          _buildNavButton(context, 'Select Files', const SelectFilePage()),
          _buildSectionTitle('Listeners'),
          _buildNavButton(context, 'Focus Listener', const FocusListenerPage()),
          _buildNavButton(
              context, 'Validate Listener', const ValidateListenerPage()),
          _buildNavButton(context, 'Value Listener', const ValueListenerPage()),
          _buildSectionTitle('Misc'),
          _buildNavButton(context, 'OnInit Page', const OninitPage()),
          _buildNavButton(
              context, 'Phone and Country', const PhoneAndCountry()),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton.icon(
        label: Text(label),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
