import 'package:flutter/material.dart';

import 'src/blocs/bloc.dart';
import 'src/blocs/game_bloc.dart';
import 'src/screens/game_home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final bloc = GameBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pair game',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: BlocProvider(
        bloc: bloc,
        child: GameHomePage(),
      ),
    );
  }
}
