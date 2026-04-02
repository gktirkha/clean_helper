String debounceTemplate() => '''
import 'dart:async';
import 'dart:developer';

/// A generic debounce utility that delays invoking a listener until after
/// [_duration] has elapsed since the last time [value] was set.
///
/// Example:
/// ```dart
/// final debounce = Debounce<String>('', Duration(milliseconds: 300));
/// debounce.listen((value) => print(value));
/// debounce.value = 'hello'; // listener fires after 300ms
/// ```
class Debounce<T> {
  /// Creates a [Debounce] with an initial [value] and a debounce [_duration].
  ///
  /// Set [allowMultipleListeners] to `true` to allow multiple listeners to be
  /// registered. When `false` (default), each [listen] call overwrites the
  /// previous listener.
  Debounce(
    T value,
    this._duration, {
    this.allowMultipleListeners = false,
    this.maxListeners = 30,
    this.logLabel = 'Debounce',
  }) : _value = value;

  /// The debounce duration. The listener is called only after this duration
  /// has passed without another [value] update.
  final Duration _duration;

  /// Whether multiple listeners can be registered.
  ///
  /// - `false` (default): calling [listen] overwrites the previous listener.
  /// - `true`: each [listen] call adds a new listener; all are notified.
  final bool allowMultipleListeners;

  /// The label used as the `name` in log messages. Defaults to `'Debounce'`.
  final String logLabel;

  /// Maximum number of listeners allowed when [allowMultipleListeners] is `true`.
  ///
  /// When the limit is exceeded, the oldest listener (index 0) is removed to
  /// make room for the new one. Defaults to `30`.
  final int maxListeners;

  T _value;
  Timer? _timer;
  void Function(T value)? _listener;
  final List<void Function(T value)> _listeners = [];

  /// The current value. Setting this restarts the debounce timer.
  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    final hasListeners = allowMultipleListeners
        ? _listeners.isNotEmpty
        : _listener != null;
    if (!hasListeners) return;
    _timer?.cancel();
    _timer = Timer(_duration, () {
      if (allowMultipleListeners) {
        for (final listener in _listeners) {
          listener(_value);
        }
      } else {
        _listener?.call(_value);
      }
    });
  }

  /// Registers a [listener] to be called when the debounce timer fires.
  ///
  /// If [allowMultipleListeners] is `false`, this overwrites any previously
  /// registered listener and logs a warning if one was already set.
  /// If `true`, the listener is appended to the list.
  void listen(void Function(T value) listener) {
    if (allowMultipleListeners) {
      if (_listeners.length >= maxListeners) {
        _listeners.removeAt(0);
        log(
          'maxListeners (\$maxListeners) reached. Oldest listener removed.',
          name: logLabel,
        );
      }
      _listeners.add(listener);
    } else {
      if (_listener != null) {
        log(
          'A listener is already registered and will be overwritten. Set allowMultipleListeners: true to support multiple listeners.',
          name: logLabel,
        );
      }
      _listener = listener;
    }
  }

  /// Cancels any pending timer and removes all listeners.
  ///
  /// Call this to avoid memory leaks when the debounce is no longer needed.
  void dispose() {
    _timer?.cancel();
    _listener = null;
    _listeners.clear();
  }
}
''';
