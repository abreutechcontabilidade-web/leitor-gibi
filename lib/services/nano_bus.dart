import 'dart:async';

class NanoBus {
  static final NanoBus _instance = NanoBus._internal();
  factory NanoBus() => _instance;
  NanoBus._internal();

  final Map<String, StreamController<dynamic>> _controllers = {};

  void emit(String eventName, dynamic payload) {
    _controllers.putIfAbsent(eventName, () => StreamController<dynamic>.broadcast());
    _controllers[eventName]!.add(payload);
  }

  StreamSubscription on(String eventName, void Function(dynamic) callback) {
    _controllers.putIfAbsent(eventName, () => StreamController<dynamic>.broadcast());
    return _controllers[eventName]!.stream.listen(callback);
  }
}