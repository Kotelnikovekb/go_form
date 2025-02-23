import 'package:flutter/material.dart';

import 'domain/domain.dart';
import 'controllers/form_controller.dart';

/// A dynamic form widget that automatically generates form fields based on the provided list.
///
/// The `DynamicForm` widget takes a list of `FormFieldModelBase` objects and builds a form
/// dynamically. It uses a `FormController` to manage field states and offers customizable spacing
/// or a separator widget between fields.
///
/// ## Features:
/// - Automatically generates form fields.
/// - Uses `FormController` for state management.
/// - Allows spacing customization between fields.
/// - Supports a custom separator via `separatorBuilder`.
///
/// ## Example Usage:
///
/// ### Default Constructor:
/// ```dart
/// DynamicForm(
///   fields: myFields,
///   controller: myController,
///   fieldSpacing: 10.0, // Default spacing
/// )
/// ```
/// This version uses a fixed spacing (`SizedBox(height: fieldSpacing)`) between fields.
///
/// ### Separator Constructor:
/// ```dart
/// DynamicForm.separator(
///   fields: myFields,
///   controller: myController,
///   separatorBuilder: (context, index) => Divider(),
/// )
/// ```
/// This version allows a custom widget to be used as a separator between fields.
///
/// The widget uses a `Column` to arrange fields, inserting either a fixed space (`fieldSpacing`)
/// or a widget provided by `separatorBuilder` between them.
class DynamicForm extends StatelessWidget{
  /// The list of form fields to be rendered.
  final List<FormFieldModelBase<dynamic>> fields;

  /// The form controller that manages the state of the form fields.
  final FormController controller;

  /// The spacing between form fields (used only when `separatorBuilder` is null).
  final double fieldSpacing;

  /// A builder function to provide a custom separator widget between fields.
  /// If provided, this will be used instead of `fieldSpacing`.
  final NullableIndexedWidgetBuilder? separatorBuilder;

  /// Creates a `DynamicForm` with optional spacing between fields.
  const DynamicForm({
    super.key,
    required this.fields,
    required this.controller,
    this.fieldSpacing = 8.0,
    this.separatorBuilder,
  });

  /// Creates a `DynamicForm` that uses a custom separator between fields.
  const DynamicForm.separator({
    super.key,
    required this.fields,
    required this.controller,
    required this.separatorBuilder,
  }) : fieldSpacing = 0.0;

  @override
  Widget build(BuildContext context) {
    if (fields.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: List.generate(
        fields.length * 2 - 1,
            (index) {
          final field = fields[index ~/ 2];
          final controller = field.addToController(this.controller);

          if (index.isEven) {
            return ValueListenableBuilder(
              key: field.key,
              valueListenable: controller.valueListenable,
              builder: (context, fieldData, child) {
                return field.build(context, controller);
              },
            );
          } else {
            return separatorBuilder?.call(context, index) ??
                SizedBox(height: fieldSpacing);
          }
        },
      ),
    );
  }
}