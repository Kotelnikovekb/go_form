# GoForm
 
**Available Translations:**
- [English](README.md)
- [Русский](README_RU.md)

---
[![Pub](https://img.shields.io/pub/v/go_form)](https://pub.dev/packages/go_form)

- [How to Install](#how-to-install)
- [Features](#features-of-goform)
- [Quick Start](#quick-start)
  - [Creating a Form with Dynamic Fields](#creating-a-form-with-dynamic-fields)
  - [Validation Check Before Submission](#validation-check-before-submission)
  - [Adding Errors](#adding-errors)
  - [Resetting the Form](#resetting-the-form)
- [How to Create a Custom Field?](#how-to-create-a-custom-field)

GoForm is a powerful library for managing forms in Flutter.  
It allows you to dynamically create, validate, and manage form state  
without the need to manually handle controllers for each field.

## Features of GoForm

- **Smart validation with minimal code**  
  GoForm automatically validates input using standard validators,  
  eliminating the need to manually write validation logic for each field.

- **Flexibility for any field types**  
  Create any form elements — from simple text fields and checkboxes  
  to complex file pickers and dropdown menus.  
  GoForm seamlessly adapts to any UI structure.

- **Centralized error management**  
  Set and reset errors anywhere in your code,  
  without needing to use `setState()`.  
  Error display is fully automated and updates without unnecessary re-renders.

---  

### Comparison of standard Flutter tools and GoForm

| **Feature**                      | **GoForm**                                                    | **Standard Flutter**                            |
|----------------------------------|---------------------------------------------------------------|-------------------------------------------------|
| **Field management**             | Fields are registered automatically                           | Each field requires a `TextEditingController`   |
| **Field flexibility**            | Supports any fields (text, files, checkboxes)                 | Only `TextFormField` and standard widgets       |
| **Error handling**               | Errors are set via `FormController.setError()`                | Errors can only be handled in `validator`       |
| **Centralized state management** | A single `FormController` manages the entire form             | Field states must be tracked manually           |
| **Retrieving values**            | `formController.getValues()` returns a `Map<String, dynamic>` | Requires accessing `TextEditingController.text` |
| **Resetting fields**             | `formController.resetAllFields()`                             | Controllers must be cleared manually            |
| **Handling server-side errors**  | Errors can be set using `setError()`                          | Errors must be stored in `setState()`           |

## How to Install

Add the dependency to `pubspec.yaml`:

```yaml
dependencies:
  go_form: latest_version
```

Replace `latest_version` with the latest version from pub.dev.

# Quick Start

### Creating a Form with Dynamic Fields

In `DynamicForm`, simply pass a list of fields and a controller:

```dart

final _formController = FormController();

@override
Widget build(BuildContext context) {
  return DynamicForm(
    controller: _formController,
    fields: [
      GoTextInput(
        name: 'email',
        label: 'Email',
        validator: (val) => val == null || val.isEmpty ? 'Enter your email' : null,
      ),
      GoTextInput(
        name: 'password',
        label: 'Password',
        validator: (val) => val == null || val.length < 6 ? 'Minimum 6 characters' : null,
      ),
    ],
  );
}
```

### Validation Check Before Submission

```dart
void onSubmit() {
  if (_formController.validate()) {
    print(_formController.getValues()); // Retrieving form data  
  } else {
    print(_formController.errors); // Displaying errors 
  }
}
```

### Adding Errors

```dart
void onLogin() async {
  final response = await AuthAPI.login(
    email: _formController.getFieldValue<String>('email'),
    password: _formController.getFieldValue<String>('password'),
  );

  if (response.hasError) {
    _formController.setError('email', response.errors['email']);
    _formController.setError('password', response.errors['password']);
  }
}
```

### Resetting the Form

```dart
_formController.resetAllFields
(); // Очистка значений  
_formController.resetAllErrors
(); // Очистка ошибок  
```

### How to Create a Custom Field?

Simply extend `FormFieldModelBase<T>` and implement `build()`:

```dart
class GoTextInput extends FormFieldModelBase<String> {
  final String label;

  GoTextInput({required super.name, super.validator, required this.label});

  @override
  Widget build(BuildContext context, FieldController controller) {
    return TextField(
      onChanged: controller.onChange,
      controller: controller.textController,
      decoration: InputDecoration(
        labelText: label,
        errorText: controller.error,
      ),
    );
  }
}
```

### One-Time Initialization (`onInit`)

You can override the `onInit` method inside your custom field to perform one-time setup logic.  
This is useful for asynchronous operations, such as fetching initial data or triggering a service.

```dart
class MyCustomField extends FormFieldModelBase<String> {
  @override
  void onInit(FieldController<String> controller) {
    controller.setValue('initial_value');
  }

  @override
  Widget build(BuildContext context, FieldController<String> controller) {
    // widget build logic here
  }
}
```

# About the author
My telegram channel - [@kotelnikoff_dev](https://t.me/kotelnikoff_dev)
### Contributions

Contributions are welcome! Feel free to open issues or create pull requests on the [GitHub repository](https://github.com/Kotelnikovekb/go_form).
