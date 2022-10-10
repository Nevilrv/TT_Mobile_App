import 'dart:async';

import 'package:get/get.dart';

class WorkoutBaseExerciseViewModel extends GetxController {
  List widgetOfIndex = [];
  List appBarTitle = [];
  List allIdList = [];

  updateAppBarTitle(String value) {
    appBarTitle.add(value);
    update();
  }

  setWidgetOfIndex({dynamic value}) {
    widgetOfIndex.add(value);
    update();
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    update();
  }

  /// Timer progress bar

  Timer? resTimer;
  int? showTimer;
  int currentValue = 0;

  void startRestTimer({required String endTime}) {
    resTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (currentValue >= 0 && currentValue < int.parse(endTime)) {
          currentValue++;
          print('count>>>>>$currentValue');
          update();
        } else {
          print('Timer Cancel');
          currentValue = 0;
          showTimer = null;
          isClickForSuperSet = true;
          staticTimer = false;
          resTimer!.cancel();
          update();
        }
      },
    );
  }

  /// superset timer
  bool isClickForSuperSet = false;
  setIsClickForSuperSet({required bool isValue}) {
    isClickForSuperSet = isValue;
  }

  int? superSetCurrentValue;
  setSuperSetCurrentValue({required int? valueForSuperSet}) {
    superSetCurrentValue = valueForSuperSet;
    update();
  }

  bool staticTimer = false;
  setStaticTimer({required bool staticTimerValue}) {
    staticTimer = staticTimerValue;
    update();
  }

  /// for weighted screen
  List lbsList = [];
  List weightedRepsList = [];
  updateWeightRepsList({required int index, required bool isPlus}) {
    print('List   >>> ${weightedRepsList[index]}');
    print('List   >>> ${weightedRepsList[index].runtimeType}');
    if (isPlus) {
      int mil = int.parse("${weightedRepsList[index]}");
      mil++;
      print('milll $mil');
      weightedRepsList.removeAt(index);
      weightedRepsList.insert(index, mil);
    } else {
      if (weightedRepsList[index] != 0) {
        int mil = int.parse("${weightedRepsList[index]}");
        mil--;
        print('milll $mil');
        weightedRepsList.removeAt(index);
        weightedRepsList.insert(index, mil);
      }
    }
    print('weightedRepsList >>  ${weightedRepsList}');
    update();
  }

  updateLbsList({required int index, required String value}) {
    lbsList.removeAt(index);
    lbsList.insert(index, value);
    update();
    print('lbsList >>> ${lbsList}');
  }

  /// for reps screen

  List repsList = [];
  List repsSuperSetList = [];
  updateRepsList({required int index, required bool isPlus}) {
    if (isPlus) {
      int mil = repsList[index];
      mil++;
      repsList.removeAt(index);
      repsList.insert(index, mil);
    } else {
      if (repsList[index] != 0) {
        int mil = repsList[index];
        mil--;
        repsList.removeAt(index);
        repsList.insert(index, mil);
      }
    }
    update();
  }

  updateRepsSuperSetList({required int index, required bool isPlus}) {
    if (isPlus) {
      int mil = repsSuperSetList[index];
      mil++;
      repsSuperSetList.removeAt(index);
      repsSuperSetList.insert(index, mil);
    } else {
      if (repsSuperSetList[index] != 0) {
        int mil = repsSuperSetList[index];
        mil--;
        repsSuperSetList.removeAt(index);
        repsSuperSetList.insert(index, mil);
      }
    }
    update();
  }
}
