import 'streamed_value.dart';

import 'streamed_collection.dart';


///
/// Used to make a one-way tunnel beetween two blocs (from blocA to blocB).
///
///
/// 1) Define a [StreamedValueBase] derived object in the blocB
///
///
///   StreamedValue receiver;
///
///
/// 2) Define a [StreamedSender] in the blocA
///
///
///   StreamedSender tunnelSender;
///
///
/// 3) Set the receiver in the sender on the class the holds
///    the instances of the blocs
///
///
///   tunnelSender.setReceiver(blocB.receiver);
///
///
/// 4) To send data from blocA to bloc B then:
///
///
///    tunnelSender.send(dataToSend);
///
///
///
class StreamedSender<T> {
  StreamedValueBase<T> _receiver;

  StreamedSender();

  StreamedSender.setReceiver(StreamedValue<T> receiver) {
    _receiver = receiver;
  }

  setReceiver(StreamedValue<T> receiver) {
    _receiver = receiver;
  }

  send(T data) {
    _receiver.value = data;
    if (T is List) _receiver.refresh();
    //print(data);
  }
}

class CollectionSender<T> {
  StreamedCollectionBase<T> _receiver;

  CollectionSender();

  CollectionSender.setReceiver(StreamedCollectionBase<T> receiver) {
    _receiver = receiver;
  }

  setReceiver(StreamedCollectionBase<T> receiver) {
    _receiver = receiver;
  }

  send(List<T> data) {
    print('data: $data');
    _receiver.value.clear();
    _receiver.value.addAll(data);
    _receiver.refresh();
  }
}

///
///
/// Used to make a bidirectional tunnel beetween two blocs (from blocA to blocB).
///
///
/// 1) Define a [StreamedValueBase] derived object in both blocs
///
///
///   StreamedValue receiver;
///
///
/// 2) Define a [TunnelObject] in both blocA and blocB
///
///
///   blocA:
///   final tunnelObjectA = TunnelObject();
///
///
///   blocB:
///   final tunnelObjectB = TunnelObject();
///
///
/// 3) Link the TunnelObject to the respectives StreamedValues in the class
///   the hold the blocs
///
///
///   blocA.tunnelObjectA.link(blocA.receiverFromB, blocB.receiverFromA);
///   blocB.tunnelObjectB.link(blocA.receiverFromB, blocB.receiverFromA);
///
///
/// 4a) To send data from blocA to blocB then in bloc A:
///
///
///    tunnelObjectA.sendB(dataToSend);
///
///
/// 4b) To send data from blocB to blocA then in bloc B:
///
///
///    tunnelObjectB.sendA(dataToSend);
///
///
///
class TunnelObject<T> {
  StreamedValueBase<T> _streamedA;
  StreamedValueBase<T> _streamedB;

  TunnelObject(StreamedValueBase<T> streamedA, StreamedValueBase<T> streamedB) {
    _streamedA = streamedA;
    _streamedB = streamedB;
  }

  /*
  link(StreamedValueBase<T> streamedA, StreamedValueBase<T> streamedB) {
    _streamedA = streamedA;
    _streamedB = streamedB;    
  }
*/

  sendToA(T data) {
    //streamA.inStream(data);
    _streamedA.value = data;
    print(data);
  }

  sendToB(T data) {
    //streamB.inStream(data);
    _streamedB.value = data;
    print(data);
  }
}

///
///
///
///

abstract class TunnelClass {
  link();
}
