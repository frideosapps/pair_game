import 'package:flutter/material.dart';

import 'package:frideos/frideos_dart.dart';

import 'bloc.dart';
import 'game_page_one_bloc.dart';
import 'game_page_two_bloc.dart';

class GameBloc extends BlocBase  {
  final blocA = GamePageOneBloc();
  final blocB = GamePageTwoBloc();
  final page = StreamedValue<Widget>();

  final welcomeMsg = StreamedValue<String>();


  GameBloc() {
    print('-------GAME BLOC--------');
    blocA.tunnelSenderBox.setReceiver(blocB.tunnelReceiver);    
  }

 

  dispose() {
    print('-------GAME BLOC DISPOSE--------');

    blocA.dispose();
    blocB.dispose();
  }
}
