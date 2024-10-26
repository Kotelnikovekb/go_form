import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  final String title;
  final Widget body;
  const FormPage({super.key, required this.title, required this.body});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.body,
      ),
    );
  }
}
