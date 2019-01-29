import 'dart:async';

import 'package:flutter/material.dart';

import 'package:frideos/frideos_dart.dart';

import 'bloc.dart';
import '../models/box_model.dart';

// Speed for the opacity animation of the selection box
const double opacitySpeed = 0.08;

class GamePageOneBloc extends BlocBase with Tunnel {
  GamePageOneBloc() {
    print('-------GAME PAGE ONE BLOC--------');

    initGame();
  }

  final boxesPosition = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];

  final mockItems = StreamedList<Box>();

  final selectedCollection = StreamedList<Box>();

  final selectionAnimation = AnimatedObject(initialValue: 0.0, interval: 20);
  final opacityList = List<Item>();

  int lastSelectedItem = -1;

  /// CHECK FOR TWO EQUAL BOXES
  final boxesToRemove = List<Box>();

  // Animation disappearing animation (Fade out)
  final boxAnimation = AnimatedObject<double>(initialValue: 0.0, interval: 17);

  // Replacing boxes fade in (50 milliseconds)
  final emptyBoxes = List<Box>();
  final emptyBoxAnimation =
      AnimatedObject<double>(initialValue: 0.0, interval: 50);

  // Flutter's animation
  final flutterAnimation = AnimatedObject(initialValue: 0.0, interval: 17);

  // Score
  final score = StreamedValue<int>();

  // Score
  final moves = StreamedValue<int>();

  // Game timer
  final gameTimer = TimerObject();

  // Ending message
  final ending = StreamedValue<String>();

  initGame() {
    selectionAnimation.animation.value = 0;

    final initialMockBoxes = [
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
      Box(15, 'Shark', Colors.indigo[500], 1.0),
      Box(16, 'Shark', Colors.indigo[500], 1.0),
    ];

    mockItems.value.addAll(initialMockBoxes);
    mockItems.value.shuffle();
    boxesPosition.shuffle();
    boxAnimation.animation.value = 0.0;

    // EMPTY BOXES
    emptyBoxAnimation.animation.value = 0.0;
    for (int i = 0; i <= mockItems.value.length - 1; i++) {
      emptyBoxes.add(Box(i + 1, 'Empty', Colors.indigo[300], 0.0));
    }

    // set the position after the shuffling
    for (int i = 0; i <= mockItems.value.length - 1; i++) {
      mockItems.value[i].position = boxesPosition[i];
    }

    score.value = 0;
    moves.value = 0;
  }

  checkPair(Box box) {
    selectedCollection.value.forEach((item) {
      if (box != item) {
        if (item.text == box.text) {
          print('match found: ${item.text} ${box.text}');
          // Remove both the item checked and the same one already
          // in the collection
          boxesToRemove.add(box);
          boxesToRemove.add(item);

          // Rotate the board if the matched pair is "Flutter"
          if (box.text == 'Flutter') {
            flutterAnimation.start((Timer t) {
              flutterAnimation.animation.value += 6.0;
              if (flutterAnimation.animation.value > 360.0) {
                flutterAnimation.animation.value = 0;
                flutterAnimation.stop();
              }
            });
          }
        }
      }
    });

    // Add the item to the selected items
    selectedCollection.value.add(box);

    // If there boxes to remove it means that there is a match
    // so start the fade out animation of the boxes
    if (boxesToRemove.length >= 1) {
      startBoxAnimation();
    }
  }

  removeBoxes() {
    boxesToRemove.forEach((box) {
      mockItems.value.remove(box);
      // When eliminate from the selected collection
      selectedCollection.value.remove(box);
      mockItems.refresh();
    });

    // Update score (based on the time passed)
    // The more is the time passed the little are the points given
    score.value += (530000 ~/ gameTimer.time).toInt();
    // check if it is the last pair of tiles
    if (mockItems.value.length == 0) {
      gameTimer.pauseTimer();
      print('Game completed');

      //ending.value = "Go to the moves page to see all the moves you made.";
      Utils.sendText(
          "Go to the moves page to see all the moves you made.", ending, 60);
    }
  }

  startBoxAnimation() {
    boxAnimation.start((Timer t) => updateBoxAnimation(t));
  }

  updateBoxAnimation(Timer t) {
    // Update value for every element
    boxesToRemove.forEach((box) {
      var item = selectedCollection.value
          .firstWhere((item) => item.index == box.index, orElse: () => null);

      if (item != null) {
        item.opacity -= 0.05;

        if (item.opacity < 0) {
          item.opacity = 0;
          // If the opacity reached zero means that it ended
          // and the empty boxes can appear replacing the ones
          // eliminated
          startEmptyBoxesAnimation();
        }

        // Set the new opacity to the stream. Here it is used only
        // one opacity value for both the boxes because their animations
        // are concurrent.
        boxAnimation.animation.value = item.opacity;
      }
    });
  }

  //
  //
  // EMPTY BOXES ANIMATION
  //
  //
  startEmptyBoxesAnimation() {
    removeBoxes();
    Timer(const Duration(milliseconds: 100), () {
      boxAnimation.stop();
      emptyBoxAnimation.start((t) {
        if (emptyBoxAnimation.animation.value + 0.1 > 1) {
          emptyBoxAnimation.stop();
          // Remove the boxes to delete only after the animation
          // for the empty boxes ends (it needs the reference)
          // to know where are the box to fade in
          boxesToRemove.clear();
        } else {
          emptyBoxAnimation.animation.value += 0.1;
        }

        boxesToRemove.forEach((box) {
          emptyBoxes[box.position - 1].opacity =
              emptyBoxAnimation.animation.value;
        });
      });
    });
  }

  //
  //
  // SELECTION ANIMATION
  //
  //
  selectItem(Box box) {
    var isSelected = checkIfSelected(box);

    //
    // If the item is selected then unselect it
    //
    if (isSelected) {
      print('unselect item ${box.index}');

      // Add the item to the opacity animation list fo the fade in
      // opacityForward = true, starting opacity = 1
      var toAdd = Item(box.index, false, 1);
      opacityList.add(toAdd);

      //
      // Remove from the collection of the selected items
      //
      selectedCollection.value.remove(box);

      // Update the moves
      if (moves.value == null) {
        moves.value = 1;
      } else {
        moves.value += 1;
      }
    } else {
      if (selectedCollection.value.length < 2) {
        print('select item ${box.index}');

        // If the element is selected then the animation will be a fade out
        // opacityForward = false, starting opacity = 0.01
        var toAdd = Item(box.index, true, 0.01);
        opacityList.add(toAdd);

        //
        // On every item selected check if there is a match
        //
        checkPair(box);

        // Send the box to the second page
        box.time = gameTimer.time;
        tunnelSenderBox.send(box);

        //Start the timer if it is not playing
        if (!gameTimer.isTimerActive) gameTimer.startTimer();

        // Update the moves
        if (moves.value == null) {
          moves.value = 1;
        } else {
          moves.value += 1;
        }
      }
    }

    // Starting selection animation
    startBorderAnimation();
  }

  // To check if the item is selected
  bool checkIfSelected(Box box) {
    var selected = selectedCollection.value.contains(box);
    assert(selected != null);
    return selected;
  }

  //
  // Animation of the border of the box
  //
  startBorderAnimation() {
    selectionAnimation.start((Timer t) => updateBorderOpacity(t));
  }

  updateBorderOpacity(Timer t) {
    // List to the border to delete
    List<int> toDelete = [];

    // Update opacity for every element
    for (int i = 0; i <= opacityList.length - 1; i++) {
      if (opacityList[i].opacityForward) {
        opacityList[i].opacity += opacitySpeed;
      } else {
        opacityList[i].opacity -= opacitySpeed;
      }

      // If the opacity goes over the min or max then delete this animation
      // (it means that it ended and can be eliminated)
      if (opacityList[i].opacity < 0 || opacityList[i].opacity > 1) {
        toDelete.add(i);
      }
    }

    // Removes all the animation from the collection that ended
    for (int i = 0; i <= toDelete.length - 1; i++) {
      opacityList.removeAt(i);
    }

    // When all the animation were deleted then stop the timer
    //
    // Start the animation of the boxes
    if (opacityList.length == 0) {
      selectionAnimation.stop();
    }
//    selectedCollection.refresh();

    //Update the animation
    selectionAnimation.animation.value += 0.1;
  }

  getItemOpacity(Box box) {
    var item = opacityList.firstWhere((item) => item.index == box.index,
        orElse: () => null);

    if (item != null) {
      return item.opacity;
    } else {
      // if it was selected the default opacity is 1.0, else is 0
      var isSelected = checkIfSelected(box);
      return isSelected ? 1.0 : 0.0;
    }
  }

  resetGame() {
    final initialMockBoxes = [
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
      Box(15, 'Shark', Colors.indigo[500], 1.0),
      Box(16, 'Shark', Colors.indigo[500], 1.0),
    ];

    selectionAnimation.animation.value = 0;
    mockItems.value.clear();
    mockItems.value.addAll(initialMockBoxes);
    // Shuffle the list
    mockItems.value.shuffle();
    boxesPosition.shuffle();
    // Set the animation to 0.0
    boxAnimation.animation.value = 0.0;

    // EMPTY BOXES
    emptyBoxAnimation.animation.value = 0.0;
    for (int i = 0; i <= mockItems.value.length - 1; i++) {
      emptyBoxes.add(Box(i + 1, 'Empty', Colors.indigo[300], 0.0));
    }

    // set the position after the shuffling
    for (int i = 0; i <= mockItems.value.length - 1; i++) {
      mockItems.value[i].position = boxesPosition[i];
    }

    score.value = 0;
    moves.value = null;

    gameTimer.stopTimer();
    mockItems.refresh();

    // Send an event to the other page to refresh it
    tunnelSenderBox.send(null);

    //Delete the message
    ending.value = null;
  }

  dispose() {
    print('-------GAME PAGE ONE BLOC DISPOSE--------');
    selectionAnimation.dispose();
    selectedCollection.dispose();
    mockItems.dispose();
    boxAnimation.dispose();
    emptyBoxAnimation.dispose();
    score.dispose();
    moves.dispose();
    gameTimer.dispose();
    ending.dispose();
  }
}

class Tunnel {
  // Senders

  final tunnelSenderBox = StreamedSender<Box>();

  send() {}
}
