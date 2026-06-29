import 'package:nocterm/nocterm.dart';

typedef KeyAction = bool Function();

class KeyBinding {
  final LogicalKey key;
  final bool Function(KeyboardEvent event)? predicate;
  final KeyAction action;

  const KeyBinding({required this.key, this.predicate, required this.action});
}

class InputService {
  final List<KeyBinding> _bindings = [];

  void registerAll(List<KeyBinding> bindings) {
    _bindings.addAll(bindings);
  }

  void clear() {
    _bindings.clear();
  }

  bool handle(KeyboardEvent event) {
    for (final binding in _bindings) {
      if (binding.key == event.logicalKey) {
        if (binding.predicate == null || binding.predicate!(event)) {
          return binding.action();
        }
      }
    }
    return false;
  }
}
