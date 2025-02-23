import 'package:flutter_test/flutter_test.dart';
import 'package:go_form/go_form.dart';

void main() {
  test('FormController adds and retrieves field values', () {
    final controller = FormController();

    final fieldController = controller.addTextField<String>(
      name: 'email',
      initialValue: 'test@example.com',
      validator: (val) => val == null || val.isEmpty ? 'Ошибка' : null,
    );

    expect(fieldController.value, 'test@example.com');

    fieldController.setValue('new@example.com');
    expect(fieldController.value, 'new@example.com');
  });

  test('FormController validates fields correctly', () {
    final controller = FormController();

    controller.addTextField<String>(
      name: 'email',
      initialValue: '',
      validator: (val) => val == null || val.isEmpty ? 'Ошибка' : null,
    );
    expect(controller.validate(), false);
    expect(controller.errors['email'], 'Ошибка');

    controller.setValue('email', 'valid@example.com');
    expect(controller.validate(), true);
    expect(controller.errors.containsKey('email'), false);
  });

  test('FormController resets all errors correctly', () {
    final controller = FormController();

    controller.addTextField<String>(
      name: 'email',
      initialValue: '',
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
    );

    expect(controller.validate(), false);
    expect(controller.errors.containsKey('email'), true);

    controller.resetAllErrors();

    expect(controller.errors.containsKey('email'), false);
  });

  test('FormController updates field value correctly', () {
    final controller = FormController();

    controller.addTextField<String>(
      name: 'username',
      initialValue: 'JohnDoe',
    );

    expect(controller.getFieldValue('username'), 'JohnDoe');

    controller.setValue('username', 'NewUser');

    expect(controller.getFieldValue('username'), 'NewUser');
  });

  test('FormController sets and clears errors correctly', () {
    final controller = FormController();

    controller.addTextField<String>(name: 'email');
    controller.addTextField<String>(name: 'password');

    controller.setError('email', 'Этот email не зарегистрирован');
    controller.setError('password', 'Неверный пароль');

    expect(controller.errors['email'], 'Этот email не зарегистрирован');
    expect(controller.errors['password'], 'Неверный пароль');

    controller.resetAllErrors();

    expect(controller.errors.isEmpty, true);
  });
}
