import 'package:flutter/material.dart';

import 'package:pair_game/src/frideos_dart/frideos_dart.dart';
import 'package:pair_game/src/frideos_flutter/frideos_flutter.dart';

import 'package:pair_game/src/blocs/bloc.dart';
import 'package:pair_game/src/blocs/game_bloc.dart';

import 'game_page_one.dart';
import 'game_page_two.dart';

class GameHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameBloc bloc = BlocProvider.of(context);
    Utils.sendText('Welcome to this pair game example made with Flutter.',
        bloc.welcomeMsg, 60);

    Widget _home() {
      return Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey[200],
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 2.9,
            colors: <Color>[
              Colors.blue[100],
              Colors.pink[50],
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 160.0,
                    child: StreamedWidget<String>(
                        stream: bloc.welcomeMsg.outStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          return Container(
                            padding: const EdgeInsets.all(28.0),
                            child: Text(snapshot.data,
                                style: TextStyle(
                                    color: Colors.blueGrey[900],
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w500)),
                          );
                        },
                        noDataChild: Text('Pair game')),
                  ),
                ),
              ],
            ), /*
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text('Game'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text('Game'),
                              ),
                              body: GamePageOne(
                                bloc: bloc.blocA,
                              ),
                            ),
                      ),
                    );
                  },
                ),
                Container(
                  width: 40.0,
                ),
                RaisedButton(
                  color: Colors.lightBlueAccent,
                  child: Text('Moves'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                              appBar: AppBar(
                                title: Text('Moves'),
                              ),
                              body: GamePageTwo(
                                bloc: bloc.blocB,
                              ),
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),*/
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pair game'),
        ),
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blueGrey[200],
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 2.9,
                colors: <Color>[
                  Colors.blue[100],
                  Colors.pink[50],
                ],
              ),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Center(
                      child: Text('Pair game',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w500))),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                ListTile(
                  title: Text('Home'),
                  onTap: () {
                    Navigator.pop(context);

                    bloc.page.value = _home();
                  },
                ),
                ListTile(
                  title: Text('Game'),
                  onTap: () {
                    Navigator.pop(context);

                    bloc.page.value = GamePageOne(
                      bloc: bloc.blocA,
                    );
                  },
                ),
                ListTile(
                  title: Text('Moves'),
                  onTap: () {
                    Navigator.pop(context);

                    bloc.page.value = GamePageTwo(
                      bloc: bloc.blocB,
                    );
                  },
                ),
                AboutListTile(),
              ],
            ),
          ),
        ),
        body: StreamedWidget<Widget>(
            stream: bloc.page.outStream,
            builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
              return snapshot.data;
            },
            noDataChild: _home()),
      ),
    );
  }
}
