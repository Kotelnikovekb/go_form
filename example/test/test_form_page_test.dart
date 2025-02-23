import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_form/go_form.dart';
import 'package:go_form_example/pages/test_form_page.dart';

void main() {
  group('TestFormPage Tests', () {
    testWidgets('TestFormPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestFormPage()));

      expect(find.text('Test form'), findsOneWidget);
      expect(find.byType(DynamicForm), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('TestFormPage renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestFormPage()));

      expect(find.byType(DynamicForm), findsOneWidget);
      expect(find.text('Test form'), findsOneWidget);
    });

    testWidgets('Entering text updates the field value', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestFormPage()));

      final textField = find.byType(TextFormField);
      await tester.enterText(textField, 'new@example.com');
      await tester.pump();

      expect(find.text('new@example.com'), findsOneWidget);
    });

    testWidgets('Validation error appears when field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TestFormPage()));

      final textField = find.byType(TextFormField);
      await tester.enterText(textField, ''); // Очищаем поле
      await tester.pump();

      final validateButton = find.byKey(const Key('validate_button'));
      await tester.tap(validateButton);
      await tester.pump();

      expect(find.text('Согласись'), findsOneWidget);
    });

    testWidgets('Validation error disappears with valid input', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestFormPage()));

      final textField = find.byType(TextFormField);
      await tester.enterText(textField, '');

      final validateButton = find.byKey(const Key('validate_button'));
      await tester.tap(validateButton);
      await tester.pump();
      expect(find.text('Согласись'), findsOneWidget);

      await tester.enterText(textField, 'valid@example.com');
      await tester.pump();

      expect(find.text('Согласись'), findsNothing); // Ошибка исчезает
    });

    testWidgets('Reset button clears validation errors', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestFormPage()));

      final textField = find.byType(TextFormField);
      await tester.enterText(textField, ''); // Очищаем поле
      await tester.pump();

      final validateButton = find.byKey(Key('validate_button'));
      await tester.tap(validateButton);
      await tester.pump();

      expect(find.text('Согласись'), findsOneWidget); // Ошибка должна появиться

      final resetButton = find.byKey(Key('reset_button'));
      await tester.tap(resetButton); // Сбрасываем ошибки
      await tester.pump();

      expect(find.text('Согласись'), findsNothing); // Ошибка должна исчезнуть
    });

    testWidgets('Valid input does not trigger validation error', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestFormPage()));

      final textField = find.byType(TextFormField);
      await tester.enterText(textField, 'valid@example.com'); // Вводим корректное значение
      await tester.pump();

      final validateButton = find.byKey(Key('validate_button'));
      await tester.tap(validateButton);
      await tester.pump();

      expect(find.text('Согласись'), findsNothing); // Ошибка не должна появиться
    });

    testWidgets('Fixing input removes validation error', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestFormPage()));

      final textField = find.byType(TextFormField);
      await tester.enterText(textField, ''); // Очищаем поле
      await tester.pump();

      final validateButton = find.byKey(Key('validate_button'));
      await tester.tap(validateButton);
      await tester.pump();

      expect(find.text('Согласись'), findsOneWidget); // Ошибка должна появиться

      await tester.enterText(textField, 'valid@example.com'); // Вводим корректное значение
      await tester.pump();

      await tester.tap(validateButton);
      await tester.pump();

      expect(find.text('Согласись'), findsNothing); // Ошибка должна исчезнуть
    });

    testWidgets('Manual error set using setError() is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: TestFormPage()));

      final formWidget = tester.widget<DynamicForm>(find.byType(DynamicForm));
      final formController = formWidget.controller;

      formController.setError('text', 'Ошибка сервера'); // Устанавливаем ошибку вручную
      await tester.pump();

      expect(find.text('Ошибка сервера'), findsOneWidget); // Ошибка должна появиться
    });

    testWidgets('Form does not rebuild unnecessarily', (WidgetTester tester) async {
      int buildCount = 0;

      await tester.pumpWidget(
        StatefulBuilder(
          builder: (context, setState) {
            buildCount++;
            return MaterialApp(home: TestFormPage());
          },
        ),
      );

      final textField = find.byType(TextFormField);
      await tester.enterText(textField, 'test@example.com');
      await tester.pump();

      expect(buildCount, lessThan(3));
    });
  });
}