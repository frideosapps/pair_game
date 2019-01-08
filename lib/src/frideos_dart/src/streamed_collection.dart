import 'dart:async';

import 'package:rxdart/rxdart.dart';

///
///
/// Base class for the streamed collections
///
///
class StreamedCollectionBase<T> {
  final stream = BehaviorSubject<List<T>>();
  final _value = List<T>();

  /// timesUpdate shows how many times the got updated
  int timesUpdated = 0;

  /// Sink for the stream
  Function(List<T>) get inStream => stream.sink.add;

  /// Stream getter
  Stream<List<T>> get outStream => stream.stream;

  List<T> get value => _value;

  set value(List<T> value) => _value;

  refresh() {
    inStream(_value);
  }

  dispose() {
    print('---------- Closing Stream ------ type: $T');
    stream.close();
  }
}

///
///
/// Used when T is a collection, it works like [StreamedValue].
///
///
class StreamedCollection<T> extends StreamedCollectionBase<T> {
  /// Used when T is a collection, to add items and update the stream
  addElement(element) {
    _value.add(element);
    inStream(_value);
    timesUpdated++;
  }

  refresh() {
    inStream(_value);
  }
}
