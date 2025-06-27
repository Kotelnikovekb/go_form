#  GoForm 

**Доступные языки:**
-  [English](README.md)
-  [Русский](README_RU.md)

[![Pub](https://img.shields.io/pub/v/go_form)](https://pub.dev/packages/go_form)


- [Как установить](#как-установить)  
- [Возможности](#возможности-GoForm)  
- [Быстрый старт](#быстрый-старт) 
  - [Создание формы с динамическими полями](#создание-формы-с-динамическими-полями)
  - [Проверка валидации перед отправкой](#проверка-валидации-перед-отправкой)
  - [Добавление ошибок](#добавление-ошибок)
  - [Сброс формы](#сброс-формы)
  - [Пример с debounce](#пример-с-debounce)
  - [Пример с асинхронной валидацией](#пример-с-асинхронной-валидацией)
  - [Пример с управлением фокусом](#пример-с-управлением-фокусом)
  - [Пример с прокруткой к первому полю с ошибкой](#пример-с-прокруткой-к-первому-полю-с-ошибкой)
- [Как создать своё поле?](#как-создать-своё-поле)


GoForm — это мощная библиотека для управления формами в Flutter.  
Она позволяет динамически создавать, валидировать и управлять состоянием формы  
без необходимости вручную управлять контроллерами для каждого поля.

# Возможности GoForm

- Умная валидация без лишнего кода  
GoForm автоматически проверяет введенные данные с помощью стандартных валидаторов, убирая необходимость вручную писать логику проверки для каждого поля.

- Гибкость для любых типов полей  
Создавайте любые элементы формы — от простых текстовых полей и чекбоксов до сложных файловых загрузчиков и выпадающих списков. GoForm легко адаптируется под любую структуру UI.

- Централизованное управление ошибками  
Устанавливайте и сбрасывайте ошибки в любой точке кода, без необходимости управлять setState(). Отображение ошибок полностью автоматизировано и обновляется без лишних ререндеров.

- Отложенные изменения (debounce)  
Поддержка `debounceDuration` в `FieldController` позволяет ограничить частоту обработки изменений значений полей. Это полезно для полей поиска или динамических фильтров.

- Асинхронная валидация  
Используйте `asyncValidator` для полей, где требуется асинхронная проверка (например, проверка уникальности email на сервере).  
Вызывайте `formController.validateAsync()`, чтобы выполнить асинхронную валидацию всех полей.

- Управление фокусом  
`FormController` предоставляет методы для управления фокусом:  
  - `focus(String name)` — фокусирует поле с заданным именем.  
  - `unfocus(String name)` — снимает фокус с указанного поля.  
  - `unfocusAll()` — снимает фокус со всех полей.  
  - `focusNext(String name)` — переводит фокус на следующее поле.  
  - `focusPrevious(String name)` — переводит фокус на предыдущее поле.  
  - `focusFirstError()` — фокусирует первое поле с ошибкой.  
  - `hasFocus(String name)` — возвращает `true`, если поле в фокусе.  
  - `hasError(String name)` — возвращает `true`, если у поля есть ошибка.

---
### Сравнение стандартных инструментов Flutter и GoForm

| **Функция**                     | **GoForm**                                                     | **Стандартный Flutter**                        |
|---------------------------------|----------------------------------------------------------------|------------------------------------------------|
| **Управление полями**           | Поля регистрируются автоматически                              | Каждое поле требует `TextEditingController`    |
| **Гибкость полей**              | Поддержка любых полей (текст, файлы, чекбоксы)                 | Только `TextFormField` и стандартные виджеты   |
| **Обработка ошибок**            | Ошибки устанавливаются через `FormController.setError()`       | Ошибки можно обрабатывать только в `validator` |
| **Централизованное управление** | Один `FormController` управляет всей формой                    | Нужно вручную отслеживать состояния полей      |
| **Получение значений**          | `formController.getValues()` возвращает `Map<String, dynamic>` | Нужно работать с `TextEditingController.text`  |
| **Сброс данных**                | `formController.resetAllFields()`                              | Нужно очищать контроллеры вручную              |
| **Обработка серверных ошибок**  | Можно установить ошибку через `setError()`                     | Требуется хранить ошибки в `setState()`        |


## Как установить

Добавьте зависимость в `pubspec.yaml`:

```yaml
dependencies:
  go_form: latest_version
```
Замените latest_version на актуальную версию из pub.dev.

# Быстрый старт

### Создание формы с динамическими полями

В `DynamicForm` достаточно передать список полей и контроллер:

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
        validator: (val) => val == null || val.isEmpty ? 'Введите email' : null,
      ),
      GoTextInput(
        name: 'password',
        label: 'Пароль',
        validator: (val) => val == null || val.length < 6 ? 'Минимум 6 символов' : null,
      ),
    ],
  );
}
```

### Проверка валидации перед отправкой

```dart
void onSubmit() {
  if (_formController.validate()) {
    print(_formController.getValues()); // Получаем данные формы
  } else {
    print(_formController.errors); // Вывод ошибок
  }
}
```

###  Добавление ошибок

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

###  Сброс формы

```dart
_formController.resetAllFields(); // Очистка значений  
_formController.resetAllErrors(); // Очистка ошибок  
```

### Пример с debounce

Вы можете задать задержку перед применением изменений через параметр `debounceDuration`:

```dart
GoTextInput(
  name: 'search',
  label: 'Поиск',
  debounceDuration: Duration(milliseconds: 500),
  onChanged: (val) {
    // Сработает только после паузы в 500мс
    print('Отправляем запрос: $val');
  },
);
```

### Пример с асинхронной валидацией

Асинхронная валидация выполняется через параметр `asyncValidator`, который может, например, имитировать обращение к серверу:

```dart
GoTextInput(
  name: 'username',
  label: 'Имя пользователя',
  asyncValidator: (val) async {
    await Future.delayed(Duration(seconds: 1));
    if (val != null && val == 'admin') {
      return 'Это имя уже занято';
    }
    return null;
  },
);
```

Для запуска асинхронной валидации всех полей используйте:

```dart
final isValid = await _formController.validateAsync();
if (!isValid) {
  print(_formController.errors);
}
```

### Пример с управлением фокусом

Вы можете программно управлять фокусом полей с помощью методов `FormController`:

```dart
GoTextInput(
  name: 'email',
  label: 'Email',
),
GoTextInput(
  name: 'password',
  label: 'Пароль',
),
```

Например, чтобы перейти к следующему полю при нажатии кнопки:

```dart
ElevatedButton(
  onPressed: () {
    _formController.focusNext('email');
  },
  child: Text('Перейти к паролю'),
);
```

Или сфокусироваться на первом поле с ошибкой:

```dart
ElevatedButton(
  onPressed: () async {
    final isValid = await _formController.validateAsync();
    if (!isValid) {
      _formController.focusFirstError();
    }
  },
  child: Text('Проверить и показать ошибку'),
);
```

### Пример с прокруткой к первому полю с ошибкой

Если у формы есть поля, скрытые за пределами экрана, можно автоматически прокрутить к первому полю с ошибкой:

```dart
ElevatedButton(
  onPressed: () async {
    final isValid = await _formController.validateAsync();
    if (!isValid) {
      _formController.scrollToFirstErrorField();
    }
  },
  child: Text('Проверить и прокрутить'),
);
```

Метод `scrollToFirstErrorField()` работает только в пределах `DynamicForm`, который должен быть обернут в `SingleChildScrollView` (по умолчанию так и есть).

### Как создать своё поле?

Просто наследуйтесь от FormFieldModelBase<T> и реализуйте build():

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


# От автора
Я в telegram - [@kotelnikoff_dev](https://t.me/kotelnikoff_dev)
[Подкинте автору на кофе](https://www.tinkoff.ru/rm/kotelnikov.yuriy2/PzxiM41989/), а то ему еще песика кормить
