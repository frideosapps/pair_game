import 'package:flutter/material.dart';

import 'extended_asyncwidgets.dart';
import 'package:pair_game/src/frideos_dart/frideos_dart.dart';

class StatestreamWidget extends StatelessWidget {
  StatestreamWidget({this.stream});
  final StreamedValue<Widget> stream;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamedWidget(
          stream: stream.outStream,
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) =>
              snapshot.data),
    );
  }
}

class TunneledWidget extends StatelessWidget {
  TunneledWidget({this.stream});

  final StreamedValue<Widget> stream;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamedWidget(
          stream: stream.outStream,
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) =>
              snapshot.data),
    );
  }
}