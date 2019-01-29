import 'package:flutter/material.dart';

import 'package:frideos/frideos_flutter.dart';

import '../blocs/game_page_two_bloc.dart';
import '../models/box_model.dart';

class GamePageTwo extends StatelessWidget {
  GamePageTwo({this.bloc});

  final GamePageTwoBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(8.0),
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
      child: StreamedWidget<List<Box>>(
        stream: bloc.items.outStream,
        builder: (BuildContext context, AsyncSnapshot<List<Box>> snapshot) {

          if (snapshot.data.length == 0) {
            return Text('Here you will see all the moves made.');
          }

          return GridView.builder(
              itemCount: snapshot.data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, mainAxisSpacing: 12.0),
              itemBuilder: (BuildContext context, int index) {
                var item = snapshot.data[index];
                return InkWell(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text('Move: ${index + 1}',
                            style: TextStyle(
                                color: Colors.blueGrey[900],
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        child: Container(   
                          alignment: Alignment.center,                        
                          margin: EdgeInsets.symmetric(horizontal: 4.0),
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                                color: Colors.blueGrey[900], width: 2.0),
                          ),
                          child: Text(item.text,
                              style: TextStyle(
                                  color: Colors.blueGrey[900],
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                            'Time: ${(item.time * 0.001).toStringAsFixed(2)}',
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400)),
                      ),
                    ],
                  ),
                  onTap: () {},
                );
              });
        },       
      ),
    );
  }
}
