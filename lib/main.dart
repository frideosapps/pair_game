import 'package:flutter/material.dart';

import 'package:pair_game/src/screens/game_home.dart';
import 'package:pair_game/src/blocs/bloc.dart';
import 'package:pair_game/src/blocs/game_bloc.dart';

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
