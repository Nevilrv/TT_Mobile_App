import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/workout_response_model/user_workouts_date_response_model.dart';
import 'package:tcm/repo/workout_repo/user_workouts_date_repo.dart';

class UserWorkoutsDateViewModel extends GetxController {
  // TextEditingController textEditingController = TextEditingController();
  List exerciseId = [];
  List tmpExerciseId = [];
  List supersetExerciseId = [];
  List warmUpId = [];
  int supersetRound = 0;
  String supersetRestTime = "";
  int supersetCounter = 0;
  String userProgramDateID = '';
  int exeIdCounter = 0;
  bool isHold = false;
  bool isFirst = false;
  bool isGreaterOne = false;
  TextEditingController? supersetWeight;
  Timer? newTimer;
  int currentValue = 0;
  int responseTime = 0;
  Timer? timer;
  List repsList = [];
  // List repsList = [12, 15, 18, 20];
  // List weightList = ["80", "85", "70", "65"];
  List weightList = [];

  void startTimer() {
    currentValue = 0;
    timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        print('responseTime--- $responseTime');
        if (currentValue >= 0 && currentValue < responseTime) {
          currentValue++;
          print('count>>>>>$currentValue');
          update();
        } else {
          currentValue = 0;
          timer.cancel();
          update();
        }
      },
    );
  }

  int currentRestValue = 0;
  int responseRestTime = 30;
  Timer? resTimer;
  void startRestTimer() {
    resTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (currentRestValue >= 0 && currentRestValue < responseRestTime) {
          currentRestValue++;

          print('count>>>>>$currentRestValue');
          update();
        } else {
          currentRestValue = 0;
          resTimer!.cancel();
          update();
        }
      },
    );
  }

  getSupersetRound() {
    if (supersetCounter < supersetRound) {
      supersetCounter++;
    }
    update();
  }

  getSupersetBackRound() {
    if (0 < supersetCounter) {
      supersetCounter--;
    }
    update();
  }

  getExeId({int? counter}) {
    if (counter! < exerciseId.length) {
      exeIdCounter++;
    }
    update();
  }

  getBackId({int? counter}) {
    if (counter! > 0) {
      exeIdCounter--;
    }
    update();
  }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getUserWorkoutsDateDetails({
    String? date,
    String? userId,
  }) async {
    log('uid ==== $userId ------ date ========== $date ');
    if (_apiResponse.status == Status.INITIAL) {
      _apiResponse = ApiResponse.loading(message: 'Loading');
      update();
    }

    try {
      UserWorkoutsDateResponseModel response = await UserWorkoutsDateRepo()
          .userWorkoutsDateRepo(date: date, userId: userId);
      print('UserWorkoutsDateResponseModel=>$response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("----- UserWorkoutsDateResponseModel === >$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
