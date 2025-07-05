/// Describes the current state of a field in the form lifecycle.
///
/// This enum helps track how the field is behaving at any moment:
/// whether it's waiting for input, validating asynchronously,
/// contains errors, or has been recently modified.
enum FieldStatus {
  /// Initial state. No value entered, and no validation has occurred.
  idle,

  /// The field is currently running an async validator (e.g., API call).
  loading,

  /// The field passed validation successfully.
  validated,

  /// The field has a validation error (sync or async).
  error,

  /// Debounce delay is in progress before value is committed.
  debounce,

  /// Value has been entered and committed, but validation hasn't been run yet.
  filled,
}