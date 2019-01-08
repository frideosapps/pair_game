import 'dart:async';

import 'streamed_value.dart';

///
///
///
/// [AnimatedObject]
///
///
///

class AnimatedObject<T> {
  final timer = TimerObject();
  final animation = StreamedValue<T>();
  final int _interval;
  final T initialValue;

  AnimatedObject(this.initialValue, this._interval);

  start(Function(Timer t) callback) {
    animation.value = initialValue;
    timer.startPeriodic(
        Duration(milliseconds: _interval), (Timer t) => callback(t));
  }

  stop() {
    timer.stopTimer();
  }
  
  reset() {
    animation.value = initialValue;
  }

  dispose() {
    timer.dispose();
  }
}
