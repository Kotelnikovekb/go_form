import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_text_input.dart';

class ValidateModePage extends StatefulWidget {
  const ValidateModePage({super.key});

  @override
  State<ValidateModePage> createState() => _ValidateModePageState();
}

class _ValidateModePageState extends State<ValidateModePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Different form controllers for each validation mode
  late FormController _conservativeController;
  late FormController _friendlyController;
  late FormController _strictController;
  late FormController _mixedController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _initializeControllers();
  }

  void _initializeControllers() {
    // 1. Conservative: validate only on submit
    _conservativeController = FormController(
      defaultValidationTriggers: {ValidationTrigger.onSubmit},
      validateOnlyAfterFirstSubmit: false,
    );

    // 2. User-Friendly: validate after first submit, then in real-time
    _friendlyController = FormController(
      defaultValidationTriggers: {
        ValidationTrigger.onFocusLost,
        ValidationTrigger.onValueChange,
      },
      validateOnlyAfterFirstSubmit: true,
    );

    // 3. Strict: immediate validation
    _strictController = FormController(
      defaultValidationTriggers: {ValidationTrigger.onValueChange},
      validateOnlyAfterFirstSubmit: false,
    );

    // 4. Mixed: different triggers for different fields
    _mixedController = FormController(
      defaultValidationTriggers: {ValidationTrigger.onFocusLost},
      validateOnlyAfterFirstSubmit: true,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _conservativeController.dispose();
    _friendlyController.dispose();
    _strictController.dispose();
    _mixedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validation Modes Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Conservative'),
            Tab(text: 'User-Friendly'),
            Tab(text: 'Strict'),
            Tab(text: 'Mixed Strategy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConservativeForm(),
          _buildFriendlyForm(),
          _buildStrictForm(),
          _buildMixedForm(),
        ],
      ),
    );
  }

  Widget _buildConservativeForm() {
    return _FormWrapper(
      title: 'Conservative Mode',
      subtitle: 'Validates only when you submit the form',
      description: 'Good for: Simple forms, less distracting',
      controller: _conservativeController,
      formBuilder: (controller) => _buildBasicForm(controller),
    );
  }

  Widget _buildFriendlyForm() {
    return _FormWrapper(
      title: 'User-Friendly Mode',
      subtitle: 'No errors until first submit, then real-time validation',
      description: 'Good for: Most forms, balanced UX',
      controller: _friendlyController,
      formBuilder: (controller) => _buildBasicForm(controller),
    );
  }

  Widget _buildStrictForm() {
    return _FormWrapper(
      title: 'Strict Mode',
      subtitle: 'Validates immediately as you type',
      description: 'Good for: Password fields, critical inputs',
      controller: _strictController,
      formBuilder: (controller) => _buildBasicForm(controller),
    );
  }

  Widget _buildMixedForm() {
    return _FormWrapper(
      title: 'Mixed Strategy',
      subtitle: 'Different validation rules for each field',
      description: 'Good for: Complex forms with varied requirements',
      controller: _mixedController,
      formBuilder: (controller) => _buildAdvancedForm(controller),
    );
  }

  List<FormFieldModelBase> _buildBasicForm(FormController controller) {
    return [
      GoTextInput(
        name: 'email',
        label: 'Email',
        validator: (val) {
          if (val == null || val.isEmpty) return 'Email is required';
          if (!val.contains('@')) return 'Please enter a valid email';
          return null;
        },
      ),
      GoTextInput(
        name: 'password',
        label: 'Password',
        obscureText: true,
        validator: (val) {
          if (val == null || val.isEmpty) return 'Password is required';
          if (val.length < 6) return 'Password must be at least 6 characters';
          return null;
        },
      ),
      GoTextInput(
        name: 'confirmPassword',
        label: 'Confirm Password',
        obscureText: true,
        validator: (val) {
          final password = controller.getFieldValue<String>('password');
          if (val == null || val.isEmpty) return 'Please confirm your password';
          if (val != password) return 'Passwords do not match';
          return null;
        },
      ),
    ];
  }

  List<FormFieldModelBase> _buildAdvancedForm(FormController controller) {
    // Set up different validation triggers for different fields
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Email: validate on focus lost (standard)
      controller.setFieldValidationTriggers('email', {
        ValidationTrigger.onFocusLost,
      });

      // Password: real-time validation for immediate feedback
      controller.setFieldValidationTriggers('password', {
        ValidationTrigger.onValueChange,
        ValidationTrigger.onFocusLost,
      });

      // Confirm password: only validate on submit to avoid premature errors
      controller.setFieldValidationTriggers('confirmPassword', {
        ValidationTrigger.onSubmit,
      });

      // Phone: validate after debounce (for potential API calls)
      controller.setFieldValidationTriggers('phone', {
        ValidationTrigger.onDebounceComplete,
        ValidationTrigger.onFocusLost,
      });
    });

    return [
      GoTextInput(
        name: 'email',
        label: 'Email (validates on focus lost)',
        validator: (val) {
          if (val == null || val.isEmpty) return 'Email is required';
          if (!val.contains('@')) return 'Please enter a valid email';
          return null;
        },
      ),
      GoTextInput(
        name: 'password',
        label: 'Password (real-time validation)',
        obscureText: true,
        validator: (val) {
          if (val == null || val.isEmpty) return 'Password is required';
          if (val.length < 6) return 'Password must be at least 6 characters';
          if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d)').hasMatch(val)) {
            return 'Password must contain letters and numbers';
          }
          return null;
        },
      ),
      GoTextInput(
        name: 'confirmPassword',
        label: 'Confirm Password (validates only on submit)',
        obscureText: true,
        validator: (val) {
          final password = controller.getFieldValue<String>('password');
          if (val == null || val.isEmpty) return 'Please confirm your password';
          if (val != password) return 'Passwords do not match';
          return null;
        },
      ),
      GoTextInput(
        name: 'phone',
        label: 'Phone (validates after 500ms delay)',
        debounceDuration: const Duration(milliseconds: 500),
        validator: (val) {
          if (val == null || val.isEmpty) return 'Phone is required';
          if (!RegExp(r'^\+?[\d\s-()]+$').hasMatch(val)) {
            return 'Please enter a valid phone number';
          }
          return null;
        },
      ),
    ];
  }

  Widget _buildSubmitButton(FormController controller, String mode) {
    return ElevatedButton(
      onPressed: () async {
        final isValid = await controller.validateAsync();
        
        if (isValid) {
          _showSuccessSnackBar('$mode form is valid!');
        } else {
          _showErrorSnackBar('Please fix the errors above');
          controller.focusFirstError();
        }
      },
      child: const Text('Submit Form'),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class _FormWrapper extends StatefulWidget {
  final String title;
  final String subtitle;
  final String description;
  final FormController controller;
  final List<FormFieldModelBase> Function(FormController) formBuilder;

  const _FormWrapper({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.controller,
    required this.formBuilder,
  });

  @override
  State<_FormWrapper> createState() => _FormWrapperState();
}

class _FormWrapperState extends State<_FormWrapper> {
  @override
  void initState() {
    super.initState();
    // Listen to form changes and rebuild widget
    widget.controller.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onFormChanged);
    super.dispose();
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header information
          Card(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Form
          DynamicForm(
            controller: widget.controller,
            fields: widget.formBuilder(widget.controller),
          ),
          
          const SizedBox(height: 24),
          
          // Submit and Reset buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final isValid = await widget.controller.validateAsync();
                    
                    if (isValid) {
                      _showSuccessSnackBar(context, '${widget.title} is valid!');
                    } else {
                      _showErrorSnackBar(context, 'Please fix the errors above');
                      widget.controller.focusFirstError();
                    }
                  },
                  child: const Text('Submit Form'),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {
                  widget.controller.resetAllFields();
                  widget.controller.resetAllErrors();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          
          // Debug information
          const SizedBox(height: 24),
          _buildDebugInfo(),
        ],
      ),
    );
  }

  Widget _buildDebugInfo() {
    return ExpansionTile(
      title: const Text('Debug Information'),
      children: [
        ListTile(
          title: const Text('Form Values:'),
          subtitle: Text(widget.controller.getValues().toString()),
        ),
        if (widget.controller.errors.isNotEmpty)
          ListTile(
            title: const Text('Validation Errors:'),
            subtitle: Text(widget.controller.errors.toString()),
          ),
        ListTile(
          title: const Text('Has Changes:'),
          subtitle: Text(widget.controller.hasChanges().toString()),
        ),
        if (widget.controller.hasChanges())
          ListTile(
            title: const Text('Changed Fields:'),
            subtitle: Text(widget.controller.getChangedFields().toString()),
          ),
      ],
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}