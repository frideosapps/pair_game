import 'package:flutter/material.dart';

import 'package:frideos/frideos.dart';

import 'game_page_one.dart';
import 'game_page_two.dart';
import '../blocs/bloc.dart';
import '../blocs/game_bloc.dart';

class GameHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    GameBloc bloc = BlocProvider.of(context);
    Utils.sendText('Welcome to this pair game example made with Flutter.',
        bloc.welcomeMsg, 60);

    Widget _home() {
      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(28.0),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            StreamedWidget<String>(
                stream: bloc.welcomeMsg.outStream,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  return Text(snapshot.data,
                      style: TextStyle(
                          color: Colors.blueGrey[900],
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500));
                },
                noDataChild: Text('Pair game')),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                      color: Colors.blue[200],
                      child: Text('Start game'),
                      onPressed: () {
                        bloc.page.value = GamePageOne(
                          bloc: bloc.blocA,
                        );
                      }),
                ),
              ],
            ),
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
