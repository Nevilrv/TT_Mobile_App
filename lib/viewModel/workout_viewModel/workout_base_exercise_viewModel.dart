import 'dart:async';

import 'package:get/get.dart';

class WorkoutBaseExerciseViewModel extends GetxController {
  List widgetOfIndex = [];
  List appBarTitle = [];
  List allIdList = [];
  List exeNewList = [];
  bool showReps = false;
  Map<String, dynamic> superSetRepsSaveMap = {};

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

  bool isButtonShow = false;
  setIsButtonShow({required bool isShow}) {
    isButtonShow = isShow;
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
          timerStop = false;
          resTimer!.cancel();
          update();
        }
      },
    );
  }

  /// superset timer
  bool superSetApiCall = true;
  bool timerStop = false;
  int roundCounter = 0;
  int roundCount = 0;

  bool isClickForSuperSet = false;

  List<Map<String, dynamic>> superSetDataCountList = [];

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

/*
  Timer? staticSuperSetTimer;
  int staticCounterCurrentValue = 0;
  void startStaticSuperSetTimer({required String endTime}) {
    staticSuperSetTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (staticCounterCurrentValue >= 0 &&
            staticCounterCurrentValue < int.parse(endTime)) {
          staticCounterCurrentValue++;
          print('count>>>>>$staticCounterCurrentValue');
          update();
        } else {
          print('Timer Cancel');
          */
/*  staticCounterCurrentValue = 0;
          showTimer = null;
          isClickForSuperSet = true;
          staticTimer = false;
          timerStop = false;*/ /*

          staticCounterCurrentValue = 0;
          staticSuperSetTimer!.cancel();
          update();
        }
      },
    );
  }
*/

  /// for weighted screen
  List lbsList = [];
  List weightedRepsList = [];
  Map<String, dynamic> weightedIndexRepsMap = {};
  Map<String, dynamic> weightedIndexLbsMap = {};
  bool weightedEnter = false;
  updateWeightRepsList(
      {required int index, required bool isPlus, required String keys}) {
    if (isPlus) {
      int mil = int.parse("${weightedIndexRepsMap[keys][index]}");
      mil++;
      print('milll $mil');
      weightedIndexRepsMap[keys].removeAt(index);
      weightedIndexRepsMap[keys].insert(index, mil);
    } else {
      if (weightedIndexRepsMap[keys][index] != 0) {
        int mil = int.parse("${weightedIndexRepsMap[keys][index]}");
        mil--;
        print('milll $mil');
        weightedIndexRepsMap[keys].removeAt(index);
        weightedIndexRepsMap[keys].insert(index, mil);
      }
    }
    print('weightedIndexRepsList >>  ${weightedIndexRepsMap}');
    update();
  }

  updateLbsList(
      {required int index, required String value, required String keys}) {
    weightedIndexLbsMap[keys].removeAt(index);
    weightedIndexLbsMap[keys].insert(index, value);
    update();
    print('weightedIndexLbsMap >>> ${weightedIndexLbsMap}');
  }

  /// for reps screen

  List repsList = [];
  Map<String, dynamic> repsIndexMap = {};
  List repsSuperSetList = [];
  updateRepsList(
      {required int index, required bool isPlus, required String key}) {
    if (isPlus) {
      // int mil = repsList[index];
      int mil = repsIndexMap[key][index];
      mil++;
      // repsList.removeAt(index);
      // repsList.insert(index, mil);
      repsIndexMap[key].removeAt(index);
      repsIndexMap[key].insert(index, mil);
    } else {
      if (repsIndexMap[key][index] != 0) {
        // int mil = repsList[index];
        int mil = repsIndexMap[key][index];
        mil--;
        // repsList.removeAt(index);
        // repsList.insert(index, mil);
        repsIndexMap[key].removeAt(index);
        repsIndexMap[key].insert(index, mil);
      }
    }
    update();
    print('List ertrt ==== ${repsIndexMap}');
  }

  // int updateRepsSuperSetList({required int index, required bool isPlus}) {
  //    print('repsSuperSetList ??  ${repsSuperSetList}');
  //    if (isPlus) {
  //      int mil = ;
  //      mil++;
  //
  //      print('++ $mil');
  //      return mil;
  //    } else {
  //      if (repsSuperSetList[index] != 0) {
  //        int mil = ;
  //        mil--;
  //        print('--$mil');
  //        return mil;
  //
  //      }
  //    }
  //    update();
  //  }
}
