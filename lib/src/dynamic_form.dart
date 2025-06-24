import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';


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
///
///
class DynamicForm extends StatefulWidget {
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
  State<DynamicForm> createState() => _DynamicFormState();
}

class _DynamicFormState extends State<DynamicForm> {
  late final List<({FormFieldModelBase field, FieldController controller})> _entries;

  @override
  void initState() {
    super.initState();
    _entries = widget.fields.map((field) {
      final controller = field.addToController(widget.controller);
      field.onInit(controller);
      return (field: field, controller: controller);
    }).toList();
  }

  @override
  void didUpdateWidget(covariant DynamicForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.fields != oldWidget.fields || widget.controller != oldWidget.controller) {
      _entries = widget.fields.map((field) {
        final controller = field.addToController(widget.controller);
        field.onInit(controller);
        return (field: field, controller: controller);
      }).toList();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_entries.isEmpty) {
      return const SizedBox();
    }
    return Column(
      children: List.generate(
        _entries.length * 2 - 1,
        (index) {
          if (index.isEven) {
            final entry = _entries[index ~/ 2];
            return ValueListenableBuilder(
              valueListenable: entry.controller.valueListenable,
              builder: (context, fieldData, child) {
                return Focus(
                  key: entry.field.key,
                  focusNode: entry.controller.focusNode,
                  child: entry.field.build(
                    context,
                    entry.controller,
                  ),
                );
              },
            );
          } else {
            return widget.separatorBuilder?.call(context, index) ??
                SizedBox(height: widget.fieldSpacing);
          }
        },
      ),
    );
  }
}
