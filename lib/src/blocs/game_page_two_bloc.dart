import 'package:frideos/frideos_dart.dart';

import 'bloc.dart';
import '../models/box_model.dart';

class GamePageTwoBloc extends BlocBase {
  final items = StreamedList<Box>();

  // Receiver
  final tunnelReceiver = StreamedValue<Box>();

  GamePageTwoBloc() {
    print('-------GAME PAGE TWO BLOC--------');

    // Listen for the items from the page one.
    // When a box is received, it is added to the 
    // a collection and showed to the view.    
    tunnelReceiver.outStream.listen((box) {
      if (box != null) {
        items.addElement(box);
      } else {
        items.value.clear();
        items.refresh();
      }
    });
  }

  dispose() {
    print('-------GAME PAGE TWO BLOC DISPOSE--------');
    tunnelReceiver.dispose();
    items.dispose();
  }
}
