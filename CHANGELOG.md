## [1.1.0] - 2025-02-28
### Added
- **Getter `errorsKey`**: Returns a `List<Key?>` containing all elements with validation errors.
- **Method `firstFieldKey`**: Returns the `Key` of the first element in `_fields`, or `null` if `_fields` is empty.
- **Method `scrollToFirstField()`**: Automatically scrolls to the first field in `_fields` and requests focus.
- **Method `scrollToFirstErrorField()`**: Scrolls to the first field with an error and requests focus.
- Improved validation handling: now it's easier to locate and scroll to invalid fields.

### Fixed
- Resolved potential issues with `Key` handling in forms.

### Usage
#### **Scroll to the first field**
You can now automatically scroll to the first field in `_fields`:
```dart
scrollToFirstField();
```

## [1.0.0] - 2025-02-24

### New Features
- **Added documentation** – full README with examples, API descriptions, and usage instructions.  
- **Added support for `key`** – now widgets can be identified more easily in tests.

### Improvements
- **Optimized `dispose()` in `FormController`** – resources are now properly cleaned up.
- **Enhanced handling of `key` properties** – fields can now use keys for better identification.
- **Optimized UI re-rendering** – reduced unnecessary rebuilds.

### 🐞 Bug Fixes
- Fixed memory leak issues related to `dispose()`.
- Fixed test failures caused by missing `key` properties.
- Improved error handling in form validation.

### Developer Experience
- **Added full documentation** – with examples, project structure, and best practices.  
- **Added new tests** – improved unit and widget test coverage.  
- **Cleaner and more efficient code** – improved architecture and optimized UI updates.

## [0.3.1] - 2025-01-29
### Added
- Introduced a named constructor `DynamicForm.separator`, allowing the use of `separatorBuilder` for custom separators between form fields.
- If `separatorBuilder` is provided, it will be used instead of the default `SizedBox(height: fieldSpacing)`, offering greater flexibility in UI customization.

### Example:
```dart
DynamicForm.separator(
  fields: myFields,
  controller: myController,
  separatorBuilder: (context, index) => Divider(),
);
```

## [0.2.3] - 2024-12-04
### Fixes
- Fixed issue with `initialValue` in the widget.

## [0.2.2] - 2024-12-04
### Fixes
- Fixed the "name field is already in use" issue.
- Disabled protection against duplicate field creation.

## [0.2.1] - 2024-12-04
### Fixes
- Fixed form reset issue.
- Fixed field data retrieval issue.

## [0.2.0] - 2024-12-02

### Added
- **Listener support**: Introduced the ability to add, remove, and check listeners for `FieldController` and `FormController`.
  - New methods in `FormController`:
    - `addListener(String name, VoidCallback listener)`: Attach a listener to a specific field.
    - `removeListener(String name, VoidCallback listener)`: Detach a listener from a specific field.
    - `hasListener(String name)`: Check if a field has listeners attached.
  - Enhancements to `FieldController`:
    - Stores and triggers custom listeners on value changes.
    - Exposes `hasListeners` to check if listeners are registered.


## [0.1.1] - 2024-11-22
### Fixed
- Fixed an issue with generic type mismatch causing override errors in `FormFieldModelBase.build`.


## 0.1.0
- Added `FieldController` for form field state management.
- Support for `TextFormField` synchronization via `TextEditingController`.
- Added `setValue` method to `FieldController` for programmatically updating field values.
- Built-in validation and error handling.

## 0.0.2
- Initial release of the `go_form` plugin.


## 0.0.1
- Initial release of the `go_form` plugin.
- Key features:
    - Form controller
