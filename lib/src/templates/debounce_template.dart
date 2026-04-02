String debounceTemplate() => '''
import 'dart:async';

class Debounce<T> {
  Debounce(T value, this._duration) : _value = value;

  final Duration _duration;
  T _value;
  Timer? _timer;
  void Function(T value)? _listener;

  T get value => _value;

  set value(T newValue) {
    _value = newValue;
    _timer?.cancel();
    _timer = Timer(_duration, () => _listener?.call(_value));
  }

  void listen(void Function(T value) listener) {
    _listener = listener;
  }

  void dispose() {
    _timer?.cancel();
    _listener = null;
  }
}
''';
