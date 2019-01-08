import 'package:flutter/material.dart';

class Box {
  String text;
  Color color;
  int index;
  double opacity;
  int position = 0;
  int time = 0;
  Box(this.index, this.text, this.color, this.opacity);
}
/*
final globalMockBoxes = [
  Box(1, 'Car', Colors.red[200], 1.0),
  Box(2, 'Bike', Colors.blue[200], 1.0),
  Box(3, 'Airplane', Colors.green[200], 1.0),
  Box(4, 'Car', Colors.red[200], 1.0),
  Box(5, 'Bike', Colors.blue[200], 1.0),
  Box(6, 'Airplane', Colors.green[200], 1.0),
  Box(7, 'Snake', Colors.green[200], 1.0),
  Box(8, 'Pizza', Colors.pink[200], 1.0),
  Box(9, 'Pizza', Colors.pink[200], 1.0),
  Box(10, 'Camel', Colors.brown[200], 1.0),
  Box(11, 'Camel', Colors.brown[200], 1.0),
  Box(12, 'Flutter', Colors.blue[200], 1.0),
  Box(13, 'Flutter', Colors.blue[200], 1.0),
  Box(14, 'Snake', Colors.green[200], 1.0),
  Box(15, 'Shark', Colors.indigo[200], 1.0),
  Box(16, 'Shark', Colors.indigo[200], 1.0),
];
*/

get globalMockBoxes => [
      Box(1, 'Car', Colors.red[400], 1.0),
      Box(2, 'Bike', Colors.lime[400], 1.0),
      Box(3, 'Airplane', Colors.green[400], 1.0),
      Box(4, 'Car', Colors.red[400], 1.0),
      Box(5, 'Bike', Colors.lime[400], 1.0),
      Box(6, 'Airplane', Colors.green[400], 1.0),
      Box(7, 'Snake', Colors.purple[400], 1.0),
      Box(8, 'Pizza', Colors.orange[400], 1.0),
      Box(9, 'Pizza', Colors.orange[400], 1.0),
      Box(10, 'Camel', Colors.brown[400], 1.0),
      Box(11, 'Camel', Colors.brown[400], 1.0),
      Box(12, 'Flutter', Colors.blue[400], 1.0),
      Box(13, 'Flutter', Colors.blue[400], 1.0),
      Box(14, 'Snake', Colors.purple[400], 1.0),
      Box(15, 'Shark', Colors.indigo[400], 1.0),
      Box(16, 'Shark', Colors.indigo[400], 1.0),
    ];


// Used for the selection animation
class Item {
  int index;
  double opacity;
  bool opacityForward;

  Item(
    this.index,
    this.opacityForward,
    this.opacity,
  );

  @override
  String toString() {
    return "$index, $opacity";
  }
}