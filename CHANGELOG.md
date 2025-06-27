## [1.6.0] - 2025-06-27
### Added
- Added new focus control methods in `FormController`:
  - `focus(String name)` – focuses the field with the given name.
  - `unfocus(String name)` – removes focus from the specified field.
  - `unfocusAll()` – removes focus from all fields.
  - `focusNext(String name)` – moves focus to the next field.
  - `focusPrevious(String name)` – moves focus to the previous field.
  - `focusFirstError()` – focuses the first field that has a validation error.
  - `hasFocus(String name)` – returns `true` if the field is currently focused.
  - `hasError(String name)` – returns `true` if the field currently has a validation error.
- Added support for debounced value changes via `debounceDuration` in `FieldController`.
- Added `validateAsync()` method in `FieldController` and `FormController` for asynchronous validation.
- Added `asyncValidator` property in `FormFieldModelBase` and `FormController` to support field-level async validation logic.

### Fixed
- Fixed an issue where `FocusNode` state could be lost during `DynamicForm` rebuilds.
- Improved compatibility with `scrollToFirstErrorField()` — it now reliably focuses the first field with a validation error.
- Fixed a bug with recursive `Focus` wrapping that triggered `child != this` assertion errors.
- Added `isFocusHandledExternally` flag to `FieldController` to allow external management of focus nodes.
- Updated the example: added a form demonstrating automatic focus on the first error field.
- Fixed field rebuild behavior when using debounce; fields no longer lose state on delayed input.

## [1.5.3] - 2025-06-14
- bug fix

## [1.5.2] - 2025-06-14
### Fixed
- Migrated DynamicForm from StatelessWidget to StatefulWidget to support local state handling.
- lemented didUpdateWidget to properly refresh field entries when fields or controller change.

## [1.5.1] - 2025-06-14
### Changed
- Refactored `DynamicForm` to be a `StatefulWidget`, allowing controller initialization and `onInit` to be called once during `initState()`.
- Improved performance by avoiding repeated `addToController` and `onInit` calls during every `build`.

## [1.5.0] - 2025-06-14
### Added
- Added `onInit(FieldController<T>)` method to `FormFieldModelBase`, which is called once when the field is initialized in the form.
- Useful for custom one-time field logic (e.g., preloading data, triggering async calls).

### Fixed
- `addFieldValueListener` now triggers only on real value changes, not during validation.

## [1.4.0] - 2025-03-17
### Added
- Added new methods in `FormController`:
  - `addFieldFocusListener(void Function(String name, bool hasFocus) listener)` — adds a focus change listener.
  - `removeFieldFocusListener(void Function(String name, bool hasFocus) listener)` — removes a focus change listener.
### Changed
- Moved `FocusNode` storage from `FormFieldData` to `FieldController` to prevent it from being recreated when data updates.
- `FocusNode` is now created once in `FieldController` and managed at the field level, improving focus stability.


## [1.3.0] - 2025-03-12
### New Features
- Added `addFieldValueListener(void Function(String, dynamic) listener)` to `FormController`.
- Added `removeFieldValueListener(void Function(String, dynamic) listener)` to `FormController`.
- Now `addTextField` automatically notifies listeners when field values change.

## [1.2.0] - 2025-03-09
### New Features
- Added methods for subscribing to form validation state changes:
  - `addValidationListener(void Function(bool) listener)` – allows subscribing to form validation state changes (valid/invalid).
  - `removeValidationListener(void Function(bool) listener)` – removes a previously added validation listener.

- Added a new method in `FieldController`:
  - `silentValidate()` – performs field validation **without setting an error** and returns `true` if the field is valid or `false` if there is an error.


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

### Bug Fixes
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
