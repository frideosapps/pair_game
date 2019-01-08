import 'dart:async';

import 'package:flutter/material.dart';

import 'streamed_value.dart';

class Stage {
  Widget child;
  int time; // milliseconds
  dynamic data;
  Stage(this.child, this.time, [this.data = 0]);
}

const updateTimeStaged = 100;

class StagedObject {
  ///
  /// Used for timing the stages
  ///
  final _timerObject = TimerObject();

  ///
  /// Stages, every value is a relative or an absolute time
  ///
  final _stages = List<int>();

  /// The list is buffered to let the original one inalterated
  ///
  final _stagesBuffer = List<int>();

  /// The stage to show
  ///
  int stageIndex = 0;

  /// Used in relative timing to calculate the time passed
  /// between two stages
  ///
  int lastStageTime = 0;

  /// Time margin error between the current time and the time
  /// set for the stage
  ///
  static int stageTimeMargin = 100;

  /// Map of widgets
  ///
  Map<int, Stage> _widgetsMap;

  /// Every widget is sent to this stream
  ///
  final _widgetStream = StreamedValue();

  /// WidgetStream getter
  ///
  get widgetStream => _widgetStream.outStream;

  StagedObject(Map<int, Stage> widgetsMap) {
    _widgetsMap = widgetsMap;

    // Extract the times
    widgetsMap.forEach((k, v) => _stages.add(v.time));
    _stagesBuffer.addAll(_stages);

    /// Starting the timer
    // startStages();
  }

  startStages() {
    if (!_timerObject.isTimerActive) {
      print(widgetStream.value);
      var interval = Duration(milliseconds: updateTimeStaged);
      // TODO: how to choose between absolute and relative?
      _timerObject.startPeriodic(interval, checkRelative);
    }
  }

  resetStages() {
    print('Reset stages');
    // Refresh the buffer with the original list
    _stagesBuffer.clear();
    _stagesBuffer.addAll(_stages);

    // Set the stage to the first element
    stageIndex = 0;
    widgetStream.value = _widgetsMap[0].child;
  }

  stopStages() {
    print('Stop stages');
    _timerObject.stopTimer();
    lastStageTime = 0;
  }

/*
  // check for absolute time position
  checkAbsolute(Timer t) {
    //print(_timerObject.getLapTime());
    _timerObject.updateTime(t);
    print(_timerObject.time);
    //print(t.tick);
    if (_stagesBuffer.length > 0) {
      var currentTime = _timerObject.time;
      var stage = _stagesBuffer.first * 1000;
      if (currentTime > stage - 100 && currentTime < stage + 100) {
        widgetStream.value = _widgetsMap[stageIndex];
        print(widgetStream.value);

        print('MATCH ->  T:$currentTime, S:$stage');
        _stagesBuffer.removeAt(0);
        stageIndex++;
      }
    } else {
      print('END STAGES');
      _timerObject.stopTimer();
      _stagesBuffer.addAll(_stages);
      stageIndex = 1;
      lastStageTime = 0;
      startStages();
    }
  }
*/
  checkRelative(Timer t) {
    // Updating the timer
    _timerObject.updateTime(t);

    //    if (stageIndex < _stages.length-1) {
    var currentTime = _timerObject.time;

    // Time in milliseconds of the current stage
    var stage = _stagesBuffer.first;

    // Being relative time the cutoff is the time passed
    // from the time of the last stage and the current one
    //
    int timePassed = currentTime - lastStageTime;

    // If the current time is between +/- 100ms of an item of the stages
    if (timePassed > stage - stageTimeMargin &&
        timePassed < stage + stageTimeMargin) {
      // Check if there are items in the stages list
      // and go on until
      if (_stagesBuffer.length > 1) {
        //print('timePassed: $timePassed');

        stageIndex++;
        // Set the new index so the next time is shown the next widget
        // on the list
        //print('stageIndex: $stageIndex');

        // Send to stream the new widget
        widgetStream.value = _widgetsMap[stageIndex].child;
        //print(widgetStream.value);
        print('MATCH ->  T:$currentTime, S:$stage');

        // Remove the current item
        _stagesBuffer.removeAt(0);

        // The next time the current stage will be used to calculate
        // the time passed.
        lastStageTime = currentTime;
      } else {
        resetStages();
      }
    }
  }

  Stage getCurrentStage() {
    return _widgetsMap[stageIndex];
  }

  dispose() {
    _timerObject.dispose();
    _widgetStream.dispose();
  }
}
