import 'package:flutter/material.dart';
import 'package:go_form/go_form.dart';

import '../inputs/go_dynamic_input.dart';

class BigListPage extends StatefulWidget {
  const BigListPage({super.key});

  @override
  State<BigListPage> createState() => _BigListPageState();
}

class _BigListPageState extends State<BigListPage> {
  final _formController = FormController();
  final ScrollController _scrollController = ScrollController();


  void _validateForm() {
    if(!_formController.validate()){
      _formController.scrollToFirstErrorField();
      /*final errorKey=_formController.errorsKeys.firstWhere((key) => key != null, orElse: () => null);
      if(errorKey!=null&& errorKey is GlobalKey){
        final context = errorKey.currentContext;
        if(context!=null){
          Scrollable.ensureVisible(
            context,
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
          );
        }
      }else{
        print('erer errorKey');
      }*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: DynamicForm(
            fields: [
              ...List.generate(100, (index){
                return GoDynamicInput(
                  key:  GlobalKey(),
                  name: 'text$index',
                  label: 'Email',
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Согласись';
                    }
                    return null;
                  },
                  initialValue: 'hello',
                );
              }),
              GoDynamicInput(
                key:  GlobalKey(),
                name: 'email_error',
                label: 'Email',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Согласись';
                  }
                  return null;
                },
              )
            ],
            controller: _formController,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        child: ElevatedButton(
          key: const Key('validate_button'),
          onPressed: _validateForm,
          child: const Text('Validate'),
        ),
      ),
    );
  }
}
