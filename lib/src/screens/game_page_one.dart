import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../blocs/game_page_one_bloc.dart';
import '../models/box_model.dart';

class GamePageOne extends StatelessWidget {
  GamePageOne({this.bloc});

  final GamePageOneBloc bloc;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    var height = size.height;
    
    var outerBox = (height / 8) - 4.0;
    var innerBox = outerBox - 6.0;

    buildCel(int index, List<Box> items) {
      var item = items.firstWhere((item) => item.position == index,
          orElse: () => null);

      if (item == null) {
        return StreamedWidget<double>(
            stream: bloc.emptyBoxAnimation.animation.outStream,
            builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
              return Opacity(
                opacity: bloc.emptyBoxes[index - 1].opacity,
                child: Container(
                  margin: EdgeInsets.all(3.0),
                  height: innerBox,
                  width: innerBox,
                  decoration: BoxDecoration(
                    color: bloc.emptyBoxes[index - 1].color,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.black, width: 2.0),
                    gradient: LinearGradient(
                        colors: [
                          bloc.emptyBoxes[index - 1].color,
                          Colors.blueGrey[100],
                          bloc.emptyBoxes[index - 1].color,
                        ],
                        begin: const FractionalOffset(0.5, 0.0),
                        end: const FractionalOffset(0.0, 0.5),
                        stops: [0.0, 0.5, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                ),
              );
            });
      }

      return StreamedWidget<double>(
          stream: bloc.boxAnimation.animation.outStream,
          builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
            return Opacity(
              opacity: item.opacity,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  StreamedWidget<double>(
                    stream: bloc.selectionAnimation.animation.outStream,
                    builder:
                        (BuildContext context, AsyncSnapshot<double> snapshot) {
                      return Opacity(
                        opacity: bloc.getItemOpacity(item),
                        child: Container(
                          height: outerBox,
                          width: outerBox,
                          decoration: BoxDecoration(
                            color: Colors.blue[500],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: InkWell(
                      child: Container(
                        height: innerBox,
                        width: innerBox,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                              color: Colors.blueGrey[900], width: 2.0),
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 0.6,
                            colors: <Color>[
                              Colors.orange[100],
                              item.color,
                            ],
                          ),
                        ),
                        child: Center(
                            child: Text(item.text,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600))),
                      ),
                      onTap: () {
                        bloc.selectItem(item);
                      },
                    ),
                  ),
                ],
              ),
            );
          });
    }

    buildRows(List<Box> boxes) {
      return Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildCel(bloc.boxesPosition[0], boxes),
                buildCel(bloc.boxesPosition[1], boxes),
                buildCel(bloc.boxesPosition[2], boxes),
                buildCel(bloc.boxesPosition[3], boxes),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildCel(bloc.boxesPosition[4], boxes),
                buildCel(bloc.boxesPosition[5], boxes),
                buildCel(bloc.boxesPosition[6], boxes),
                buildCel(bloc.boxesPosition[7], boxes),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildCel(bloc.boxesPosition[8], boxes),
                buildCel(bloc.boxesPosition[9], boxes),
                buildCel(bloc.boxesPosition[10], boxes),
                buildCel(bloc.boxesPosition[11], boxes),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildCel(bloc.boxesPosition[12], boxes),
                buildCel(bloc.boxesPosition[13], boxes),
                buildCel(bloc.boxesPosition[14], boxes),
                buildCel(bloc.boxesPosition[15], boxes),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(12.0),
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
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 12.0,
          ),
          Container(
            alignment: Alignment.center,
            child: StreamedWidget<int>(
              stream: bloc.score.outStream,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
                  Text('Score: ${snapshot.data}',
                      style: TextStyle(
                          color: Colors.blue[900],
                          fontSize: 24.0,
                          fontWeight: FontWeight.w500)),
              noDataChild: Text('NO DATA'),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: StreamedWidget(
              stream: bloc.gameTimer.outStream,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) =>
                  Text('Time: ${(snapshot.data * 0.001).toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500)),
              noDataChild: Text('Click on the first tile to begin.'),
            ),
          ),
          Container(
            height: 20.0,
          ),
          StreamedWidget<double>(
                initialData: 0.0,
                stream: bloc.flutterAnimation.animation.outStream,
                builder: (c, AsyncSnapshot<double> s) {
                  return Transform.rotate(
          angle: s.data * (math.pi / 180),
          child: Column(
            children: <Widget>[
              StreamedWidget<List<Box>>(
                initialData: bloc.mockItems.value,
                stream: bloc.mockItems.outStream,
                builder: (c, AsyncSnapshot<List<Box>> s) {
                  return buildRows(s.data);
                },
              ),
              Container(
                height: 20.0,
              ),
              StreamedWidget(
                stream: bloc.moves.outStream,
                builder: (BuildContext context,
                        AsyncSnapshot<int> snapshot) =>
                    Text('Moves: ${snapshot.data}',
                        style: TextStyle(
                            color: Colors.blueGrey[900],
                            fontSize: 18.0,
                            fontWeight: FontWeight.w500)),
                noDataChild: Text(
                    'At the end go on the moves page to see them.'),
              ),
            ],
          ));
                }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamedWidget<String>(
              stream: bloc.ending.outStream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  Text(snapshot.data,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500)),
              noDataChild: Container(
                height: 20,
              ),
            ),
          ),
          RaisedButton(
              color: Colors.blue[200],
              child: Text('Reset game'),
              onPressed: () {
                bloc.resetGame();
              }),
          Container(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
