import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:get/get.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/update_status_user_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/model/response_model/update_status_user_program_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/training_plan_screens/exercise_detail_page.dart';
import 'package:tcm/screen/workout_screen/share_progress_screen.dart';
import 'package:tcm/screen/workout_screen/widget/workout_widgets.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/save_user_customized_exercise_viewModel.dart';
import 'package:tcm/viewModel/update_status_user_program_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/user_workouts_date_viewModel.dart';

import '../../repo/training_plan_repo/exercise_by_id_repo.dart';

// ignore: must_be_immutable
class NoWeightExerciseScreen extends StatefulWidget {
  List<WorkoutById> data;
  final String? workoutId;
  NoWeightExerciseScreen({Key? key, required this.data, this.workoutId})
      : super(key: key);
  @override
  State<NoWeightExerciseScreen> createState() => _NoWeightExerciseScreenState();
}

class _NoWeightExerciseScreenState extends State<NoWeightExerciseScreen> {
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());

  // TimerStyle _timerStyle = TimerStyle.ring;
  // TimerProgressIndicatorDirection _progressIndicatorDirection =
  //     TimerProgressIndicatorDirection.clockwise;
  // TimerProgressTextCountDirection _progressTextCountDirection =
  //     TimerProgressTextCountDirection.count_down;
  SaveUserCustomizedExerciseViewModel _customizedExerciseViewModel =
      Get.put(SaveUserCustomizedExerciseViewModel());
  int totalRound = 0;
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  @override
  void initState() {
    _connectivityCheckViewModel.startMonitoring();
    super.initState();
    initData();
  }

  initData() async {
    await _exerciseByIdViewModel.getExerciseByIdDetails(
        id: _userWorkoutsDateViewModel
            .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
    if (_exerciseByIdViewModel.apiResponse.status == Status.LOADING) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (_exerciseByIdViewModel.apiResponse.status == Status.COMPLETE) {
      _exerciseByIdViewModel.responseExe =
          _exerciseByIdViewModel.apiResponse.data;
    }
    _customizedExerciseViewModel.counterReps = int.parse(
        '${_exerciseByIdViewModel.responseExe!.data![0].exerciseReps}');
  }

  int currPlayIndex = 0;

  int counterSets = 0;
  int counterTime = 0;
  String timeCounter({int? counterTime}) {
    int finalCounter = counterTime! * 15;
    var setTime = Duration(seconds: finalCounter).toString().split('.')[0];
    var formatTime = setTime.split(':');
    var finalTime = '${formatTime[1]} : ${formatTime[2]}';
    return finalTime;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(
        builder: (control) => control.isOnline
            ? GetBuilder<UserWorkoutsDateViewModel>(builder: (controllerUSD) {
                return GetBuilder<ExerciseByIdViewModel>(builder: (controller) {
                  if (controller.apiResponse.status == Status.LOADING) {
                    return ColoredBox(
                      color: ColorUtils.kBlack,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorUtils.kTint,
                        ),
                      ),
                    );
                  }
                  if (controller.apiResponse.status == Status.COMPLETE) {
                    controller.responseExe =
                        _exerciseByIdViewModel.apiResponse.data;
                    // log(
                    //     'condition ===================== ${controllerUSD.exeIdCounter == controllerUSD.exerciseId.length}');
                    // log(
                    //     'id counter ===================== ${controllerUSD.exeIdCounter}');
                    // log(
                    //     'id length ===================== ${controllerUSD.exerciseId.length}');
                    // log(
                    //     'superset id  ===================== ${controllerUSD.supersetExerciseId}');
                    // log(
                    //     'exercise  id  ===================== ${controllerUSD.exerciseId}');
                    //
                    // log(
                    //     'controller.responseExe!.data![0].exerciseType ${controller.responseExe!.data![0].exerciseType}');
                    if (controllerUSD.exeIdCounter ==
                        controllerUSD.exerciseId.length) {
                      if (controllerUSD.supersetExerciseId.isNotEmpty ||
                          controllerUSD.supersetExerciseId != []) {
                        return SuperSet(
                          data: widget.data,
                          controller: controller,
                          workoutId: widget.workoutId,
                        );
                      } else {
                        return ColoredBox(
                          color: ColorUtils.kBlack,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ColorUtils.kTint,
                            ),
                          ),
                        );
                      }
                    } else {
                      if (controller.responseExe!.data![0].exerciseType ==
                          "REPS") {
                        // toggleVideo();
                        return RepsScreen(
                          data: widget.data,
                          controller: controller,
                          workoutId: widget.workoutId,
                        );
                      } else if (controller
                              .responseExe!.data![0].exerciseType ==
                          "TIME") {
                        return TimeScreen(
                          data: widget.data,
                          controller: controller,
                          workoutId: widget.workoutId,
                        );
                      } else if (controller
                              .responseExe!.data![0].exerciseType ==
                          "WEIGHTED") {
                        return WeightedCounter(
                          data: widget.data,
                          controller: controller,
                          workoutId: widget.workoutId,
                        );
                      } else {
                        return ColoredBox(
                          color: ColorUtils.kBlack,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: ColorUtils.kTint,
                            ),
                          ),
                        );
                      }
                    }
                  } else {
                    return ColoredBox(
                      color: ColorUtils.kBlack,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: ColorUtils.kTint,
                        ),
                      ),
                    );
                  }
                });
              })
            : ConnectionCheckScreen());
  }
}

// ignore: must_be_immutable
class RepsScreen extends StatefulWidget {
  final ExerciseByIdViewModel? controller;
  // bool isHold;
  // bool isFirst;
  // bool isGreaterOne;
  List<WorkoutById> data;
  final String? workoutId;

  RepsScreen(
      {Key? key,
      this.controller,
      // this.isFirst = false,
      // this.isGreaterOne = false,
      // this.isHold = false,
      this.workoutId,
      required this.data})
      : super(key: key);

  @override
  _RepsScreenState createState() => _RepsScreenState();
}

class _RepsScreenState extends State<RepsScreen> {
  // ExerciseByIdViewModel _exerciseByIdViewModel =
  //     Get.put(ExerciseByIdViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  UpdateStatusUserProgramViewModel _updateStatusUserProgramViewModel =
      Get.put(UpdateStatusUserProgramViewModel());
  bool isShow = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    // initializePlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onHorizontalDragUpdate: (details) async {
      //   log("hello ${details.localPosition}");
      //   log("hello ${details.localPosition.dx}");
      //   log("hello ${details.globalPosition.distance}");
      //
      //   if (details.localPosition.dx < 100.0) {
      //     //SWIPE FROM RIGHT DETECTION
      //     log("hello ");
      //     _userWorkoutsDateViewModel.getBackId(
      //         counter: _userWorkoutsDateViewModel.exeIdCounter);
      //     if (_userWorkoutsDateViewModel.exeIdCounter <
      //         _userWorkoutsDateViewModel.exerciseId.length) {
      //       await widget.controller!.getExerciseByIdDetails(
      //           id: _userWorkoutsDateViewModel
      //               .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
      //       if (widget.controller!.apiResponse.status == Status.LOADING) {
      //         Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       if (widget.controller!.apiResponse.status == Status.COMPLETE) {
      //         widget.controller!.responseExe =
      //             widget.controller!.apiResponse.data;
      //       }
      //     }
      //     if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
      //       widget.isFirst = true;
      //     }
      //     if (widget.isFirst == true) {
      //       if (widget.isGreaterOne == false) {
      //         Get.back();
      //       }
      //       if (widget.isHold == true) {
      //         Get.back();
      //         widget.isHold = false;
      //         widget.isFirst = false;
      //       } else {
      //         widget.isHold = true;
      //       }
      //     }
      //   }
      // },
      child: WillPopScope(
        onWillPop: () async {
          _userWorkoutsDateViewModel.getBackId(
              counter: _userWorkoutsDateViewModel.exeIdCounter);
          if (_userWorkoutsDateViewModel.exeIdCounter <
              _userWorkoutsDateViewModel.exerciseId.length) {
            await widget.controller!.getExerciseByIdDetails(
                id: _userWorkoutsDateViewModel
                    .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
            if (widget.controller!.apiResponse.status == Status.LOADING) {
              Center(
                child: CircularProgressIndicator(),
              );
            }
            if (widget.controller!.apiResponse.status == Status.COMPLETE) {
              widget.controller!.responseExe =
                  widget.controller!.apiResponse.data;
            }
          }
          if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
            _userWorkoutsDateViewModel.isFirst = true;
          }
          if (_userWorkoutsDateViewModel.isFirst == true) {
            if (_userWorkoutsDateViewModel.isGreaterOne == false) {
              Get.back();
            }
            if (_userWorkoutsDateViewModel.isHold == true) {
              _userWorkoutsDateViewModel.isHold = false;
              _userWorkoutsDateViewModel.isFirst = false;
              Get.back();
            } else {
              _userWorkoutsDateViewModel.isHold = true;
            }
          }

          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: ColorUtils.kBlack,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: () async {
                  _userWorkoutsDateViewModel.getBackId(
                      counter: _userWorkoutsDateViewModel.exeIdCounter);
                  if (_userWorkoutsDateViewModel.exeIdCounter <
                      _userWorkoutsDateViewModel.exerciseId.length) {
                    await widget.controller!.getExerciseByIdDetails(
                        id: _userWorkoutsDateViewModel.exerciseId[
                            _userWorkoutsDateViewModel.exeIdCounter]);
                    if (widget.controller!.apiResponse.status ==
                        Status.LOADING) {
                      Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (widget.controller!.apiResponse.status ==
                        Status.COMPLETE) {
                      widget.controller!.responseExe =
                          widget.controller!.apiResponse.data;
                    }
                  }
                  if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                    _userWorkoutsDateViewModel.isFirst = true;
                  }
                  if (_userWorkoutsDateViewModel.isFirst == true) {
                    if (_userWorkoutsDateViewModel.isGreaterOne == false) {
                      log('back........1');
                      log('greater one ........false call');

                      Get.back();
                    }
                    if (_userWorkoutsDateViewModel.isHold == true) {
                      log('back........2');
                      log('hold true........call');

                      _userWorkoutsDateViewModel.isHold = false;
                      _userWorkoutsDateViewModel.isFirst = false;
                      Get.back();
                    } else {
                      _userWorkoutsDateViewModel.isHold = true;
                    }
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: ColorUtils.kTint,
                )),
            backgroundColor: ColorUtils.kBlack,
            title: Text('Warm-Up', style: FontTextStyle.kWhite16BoldRoboto),
            centerTitle: true,
            actions: [
              TextButton(
                  onPressed: () {
                    Get.offAll(HomeScreen());
                    _userWorkoutsDateViewModel.exeIdCounter = 0;
                    _userWorkoutsDateViewModel.isHold = false;
                    _userWorkoutsDateViewModel.isFirst = false;
                  },
                  child: Text(
                    'Quit',
                    style: FontTextStyle.kTine16W400Roboto,
                  ))
            ],
          ),
          body: int.parse(widget.controller!.responseExe!.data![0].exerciseSets
                      .toString()) <=
                  4
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: Padding(
                      //     padding: EdgeInsets.symmetric(
                      //         horizontal: Get.width * .075),
                      //     child: GestureDetector(
                      //         onTap: () {
                      //           Get.to(WeightExerciseScreen(
                      //               data:
                      //                   widget.controller!.responseExe!.data!));
                      //         },
                      //         child: Text(
                      //           "Edit",
                      //           style: FontTextStyle.kTint16BoldRoboto,
                      //         )),
                      //   ),
                      // ),
                      Container(
                        width: Get.width * 0.7,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                                  style: FontTextStyle.kWhite24BoldRoboto,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => ExerciseDetailPage(
                                      exerciseId: widget.controller!
                                          .responseExe!.data![0].exerciseId!,
                                      isFromExercise: true));
                                },
                                child: Image.asset(
                                  AppIcons.play,
                                  height: Get.height * 0.03,
                                  width: Get.height * 0.03,
                                  color: ColorUtils.kTint,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      Text(
                          '${widget.controller!.responseExe!.data![0].exerciseSets} sets of ${widget.controller!.responseExe!.data![0].exerciseReps} reps',
                          style: FontTextStyle.kLightGray16W300Roboto.copyWith(
                              fontSize: Get.height * 0.023,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w300)),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              top: 0,
                              right: Get.width * .06,
                              left: Get.width * .06),
                          itemCount: int.parse(widget
                              .controller!.responseExe!.data![0].exerciseSets
                              .toString()),
                          itemBuilder: (_, index) {
                            return NoWeightedCounterCard(
                              counter: int.parse(
                                  '${widget.controller!.responseExe!.data![0].exerciseReps}'
                                      .split("-")
                                      .first),
                              repsNo:
                                  '${widget.controller!.responseExe!.data![0].exerciseReps}'
                                      .split("-")
                                      .first,
                            );
                          }),

                      Spacer(),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * .06),
                        child: commonNavigationButton(
                            onTap: () async {
                              if (_userWorkoutsDateViewModel
                                  .supersetExerciseId.isEmpty) {
                                if (widget.controller!.responseExe!.data![0]
                                        .exerciseId ==
                                    _userWorkoutsDateViewModel
                                        .exerciseId.last) {
                                  UpdateStatusUserProgramRequestModel _request =
                                      UpdateStatusUserProgramRequestModel();

                                  log('user workout id check ====== > ${_userWorkoutsDateViewModel.userProgramDateID}');

                                  _request.userProgramDatesId =
                                      _userWorkoutsDateViewModel
                                          .userProgramDateID;

                                  await _updateStatusUserProgramViewModel
                                      .updateStatusUserProgramViewModel(
                                          _request);

                                  if (_updateStatusUserProgramViewModel
                                          .apiResponse.status ==
                                      Status.COMPLETE) {
                                    UpdateStatusUserProgramResponseModel
                                        response =
                                        _updateStatusUserProgramViewModel
                                            .apiResponse.data;

                                    if (response.success == true) {
                                      _userWorkoutsDateViewModel.exeIdCounter =
                                          0;

                                      Get.showSnackbar(GetSnackBar(
                                        message: '${response.msg}',
                                        duration: Duration(milliseconds: 1500),
                                      ));
                                      Get.to(ShareProgressScreen(
                                        exeData: widget
                                            .controller!.responseExe!.data!,
                                        data: widget.data,
                                        workoutId: widget.workoutId,
                                      ));
                                    } else if (response.success == false) {
                                      Get.showSnackbar(GetSnackBar(
                                        message: '${response.msg}',
                                        duration: Duration(milliseconds: 1500),
                                      ));
                                    }
                                  } else if (_updateStatusUserProgramViewModel
                                          .apiResponse.status ==
                                      Status.ERROR) {
                                    Get.showSnackbar(GetSnackBar(
                                      message: 'Something Went Wrong',
                                      duration: Duration(milliseconds: 1500),
                                    ));
                                  }
                                } else {
                                  _userWorkoutsDateViewModel.getExeId(
                                      counter: _userWorkoutsDateViewModel
                                          .exeIdCounter);
                                  if (_userWorkoutsDateViewModel.exeIdCounter <
                                      _userWorkoutsDateViewModel
                                          .exerciseId.length) {
                                    if (_userWorkoutsDateViewModel
                                            .exeIdCounter >
                                        0) {
                                      _userWorkoutsDateViewModel.isGreaterOne =
                                          true;
                                      log("--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                    }
                                    await widget.controller!
                                        .getExerciseByIdDetails(
                                            id: _userWorkoutsDateViewModel
                                                    .exerciseId[
                                                _userWorkoutsDateViewModel
                                                    .exeIdCounter]);
                                    if (widget.controller!.apiResponse.status ==
                                        Status.LOADING) {
                                      Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (widget.controller!.apiResponse.status ==
                                        Status.COMPLETE) {
                                      widget.controller!.responseExe =
                                          widget.controller!.apiResponse.data;
                                    }
                                  }

                                  if (_userWorkoutsDateViewModel
                                      .supersetExerciseId.isEmpty) {
                                    if (_userWorkoutsDateViewModel
                                            .exeIdCounter ==
                                        _userWorkoutsDateViewModel
                                            .exerciseId.length) {
                                      Get.to(ShareProgressScreen(
                                        exeData: widget
                                            .controller!.responseExe!.data!,
                                        data: widget.data,
                                        workoutId: widget.workoutId,
                                      ));
                                      _userWorkoutsDateViewModel.isFirst =
                                          false;
                                    }
                                  }
                                }
                              } else {
                                _userWorkoutsDateViewModel.getExeId(
                                    counter: _userWorkoutsDateViewModel
                                        .exeIdCounter);
                                if (_userWorkoutsDateViewModel.exeIdCounter <
                                    _userWorkoutsDateViewModel
                                        .exerciseId.length) {
                                  if (_userWorkoutsDateViewModel.exeIdCounter >
                                      0) {
                                    _userWorkoutsDateViewModel.isGreaterOne =
                                        true;
                                    log("--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                  }
                                  await widget.controller!
                                      .getExerciseByIdDetails(
                                          id: _userWorkoutsDateViewModel
                                                  .exerciseId[
                                              _userWorkoutsDateViewModel
                                                  .exeIdCounter]);
                                  if (widget.controller!.apiResponse.status ==
                                      Status.LOADING) {
                                    Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (widget.controller!.apiResponse.status ==
                                      Status.COMPLETE) {
                                    widget.controller!.responseExe =
                                        widget.controller!.apiResponse.data;
                                  }
                                }

                                if (_userWorkoutsDateViewModel
                                    .supersetExerciseId.isEmpty) {
                                  if (_userWorkoutsDateViewModel.exeIdCounter ==
                                      _userWorkoutsDateViewModel
                                          .exerciseId.length) {
                                    Get.to(ShareProgressScreen(
                                      exeData:
                                          widget.controller!.responseExe!.data!,
                                      data: widget.data,
                                      workoutId: widget.workoutId,
                                    ));
                                    _userWorkoutsDateViewModel.isFirst = false;
                                  }
                                }
                              }
                            },
                            name: _userWorkoutsDateViewModel
                                    .supersetExerciseId.isEmpty
                                ? widget.controller!.responseExe!.data![0]
                                            .exerciseId ==
                                        _userWorkoutsDateViewModel
                                            .exerciseId.last
                                    ? 'Save Exercise'
                                    : 'Next Exercise'
                                : 'Next Exercise'),
                      ),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                    ])
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: Padding(
                        //     padding: EdgeInsets.symmetric(
                        //         horizontal: Get.width * .075),
                        //     child: GestureDetector(
                        //         onTap: () {
                        //           Get.to(WeightExerciseScreen(
                        //               data:
                        //                   widget.controller!.responseExe!.data!));
                        //         },
                        //         child: Text(
                        //           "Edit",
                        //           style: FontTextStyle.kTint16BoldRoboto,
                        //         )),
                        //   ),
                        // ),

                        Container(
                          width: Get.width * 0.7,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                                    style: FontTextStyle.kWhite24BoldRoboto,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(() => ExerciseDetailPage(
                                        exerciseId: widget.controller!
                                            .responseExe!.data![0].exerciseId!,
                                        isFromExercise: true));
                                  },
                                  child: Image.asset(
                                    AppIcons.play,
                                    height: Get.height * 0.03,
                                    width: Get.height * 0.03,
                                    color: ColorUtils.kTint,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.015,
                        ),
                        Text(
                            '${widget.controller!.responseExe!.data![0].exerciseSets} sets of ${widget.controller!.responseExe!.data![0].exerciseReps} reps',
                            style: FontTextStyle.kLightGray16W300Roboto
                                .copyWith(
                                    fontSize: Get.height * 0.023,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w300)),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        GetBuilder<SaveUserCustomizedExerciseViewModel>(
                            builder: (controllerSave) {
                          return ListView.builder(
                              physics: BouncingScrollPhysics(),
                              shrinkWrap: true,
                              padding: EdgeInsets.only(
                                  top: 0,
                                  right: Get.width * .06,
                                  left: Get.width * .06),
                              itemCount: int.parse(widget.controller!
                                  .responseExe!.data![0].exerciseSets
                                  .toString()),
                              itemBuilder: (_, index) {
                                return NoWeightedCounterCard(
                                    counter: int.parse(
                                        '${widget.controller!.responseExe!.data![0].exerciseReps}'
                                            .split("-")
                                            .first),
                                    repsNo:
                                        '${widget.controller!.responseExe!.data![0].exerciseReps}'
                                            .split("-")
                                            .first);
                              });
                        }),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: Get.width * .06),
                          child: commonNavigationButton(
                              onTap: () async {
                                if (_userWorkoutsDateViewModel
                                    .supersetExerciseId.isEmpty) {
                                  if (widget.controller!.responseExe!.data![0]
                                          .exerciseId ==
                                      _userWorkoutsDateViewModel
                                          .exerciseId.last) {
                                    UpdateStatusUserProgramRequestModel
                                        _request =
                                        UpdateStatusUserProgramRequestModel();

                                    log('user workout id check ====== > ${_userWorkoutsDateViewModel.userProgramDateID}');

                                    _request.userProgramDatesId =
                                        _userWorkoutsDateViewModel
                                            .userProgramDateID;

                                    await _updateStatusUserProgramViewModel
                                        .updateStatusUserProgramViewModel(
                                            _request);

                                    if (_updateStatusUserProgramViewModel
                                            .apiResponse.status ==
                                        Status.COMPLETE) {
                                      UpdateStatusUserProgramResponseModel
                                          response =
                                          _updateStatusUserProgramViewModel
                                              .apiResponse.data;

                                      if (response.success == true) {
                                        _userWorkoutsDateViewModel
                                            .exeIdCounter = 0;

                                        Get.showSnackbar(GetSnackBar(
                                          message: '${response.msg}',
                                          duration:
                                              Duration(milliseconds: 1500),
                                        ));
                                        Get.to(ShareProgressScreen(
                                          exeData: widget
                                              .controller!.responseExe!.data!,
                                          data: widget.data,
                                          workoutId: widget.workoutId,
                                        ));
                                      } else if (response.success == false) {
                                        Get.showSnackbar(GetSnackBar(
                                          message: '${response.msg}',
                                          duration:
                                              Duration(milliseconds: 1500),
                                        ));
                                      }
                                    } else if (_updateStatusUserProgramViewModel
                                            .apiResponse.status ==
                                        Status.ERROR) {
                                      Get.showSnackbar(GetSnackBar(
                                        message: 'Something Went Wrong',
                                        duration: Duration(milliseconds: 1500),
                                      ));
                                    }
                                  } else {
                                    _userWorkoutsDateViewModel.getExeId(
                                        counter: _userWorkoutsDateViewModel
                                            .exeIdCounter);
                                    if (_userWorkoutsDateViewModel
                                            .exeIdCounter <
                                        _userWorkoutsDateViewModel
                                            .exerciseId.length) {
                                      if (_userWorkoutsDateViewModel
                                              .exeIdCounter >
                                          0) {
                                        _userWorkoutsDateViewModel
                                            .isGreaterOne = true;
                                        log("--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                      }
                                      await widget.controller!
                                          .getExerciseByIdDetails(
                                              id: _userWorkoutsDateViewModel
                                                      .exerciseId[
                                                  _userWorkoutsDateViewModel
                                                      .exeIdCounter]);
                                      if (widget
                                              .controller!.apiResponse.status ==
                                          Status.LOADING) {
                                        Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      if (widget
                                              .controller!.apiResponse.status ==
                                          Status.COMPLETE) {
                                        widget.controller!.responseExe =
                                            widget.controller!.apiResponse.data;
                                      }
                                    }

                                    if (_userWorkoutsDateViewModel
                                        .supersetExerciseId.isEmpty) {
                                      if (_userWorkoutsDateViewModel
                                              .exeIdCounter ==
                                          _userWorkoutsDateViewModel
                                              .exerciseId.length) {
                                        Get.to(ShareProgressScreen(
                                          exeData: widget
                                              .controller!.responseExe!.data!,
                                          data: widget.data,
                                          workoutId: widget.workoutId,
                                        ));
                                        _userWorkoutsDateViewModel.isFirst =
                                            false;
                                      }
                                    }
                                  }
                                } else {
                                  _userWorkoutsDateViewModel.getExeId(
                                      counter: _userWorkoutsDateViewModel
                                          .exeIdCounter);
                                  if (_userWorkoutsDateViewModel.exeIdCounter <
                                      _userWorkoutsDateViewModel
                                          .exerciseId.length) {
                                    if (_userWorkoutsDateViewModel
                                            .exeIdCounter >
                                        0) {
                                      _userWorkoutsDateViewModel.isGreaterOne =
                                          true;
                                      log("--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                    }
                                    await widget.controller!
                                        .getExerciseByIdDetails(
                                            id: _userWorkoutsDateViewModel
                                                    .exerciseId[
                                                _userWorkoutsDateViewModel
                                                    .exeIdCounter]);
                                    if (widget.controller!.apiResponse.status ==
                                        Status.LOADING) {
                                      Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (widget.controller!.apiResponse.status ==
                                        Status.COMPLETE) {
                                      widget.controller!.responseExe =
                                          widget.controller!.apiResponse.data;
                                    }
                                  }

                                  if (_userWorkoutsDateViewModel
                                      .supersetExerciseId.isEmpty) {
                                    if (_userWorkoutsDateViewModel
                                            .exeIdCounter ==
                                        _userWorkoutsDateViewModel
                                            .exerciseId.length) {
                                      Get.to(ShareProgressScreen(
                                        exeData: widget
                                            .controller!.responseExe!.data!,
                                        data: widget.data,
                                        workoutId: widget.workoutId,
                                      ));
                                      _userWorkoutsDateViewModel.isFirst =
                                          false;
                                    }
                                  }
                                }
                              },
                              name: _userWorkoutsDateViewModel
                                      .supersetExerciseId.isEmpty
                                  ? widget.controller!.responseExe!.data![0]
                                              .exerciseId ==
                                          _userWorkoutsDateViewModel
                                              .exerciseId.last
                                      ? 'Save Exercise'
                                      : 'Next Exercise'
                                  : 'Next Exercise'),
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                      ]),
                ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class TimeScreen extends StatefulWidget {
  final ExerciseByIdViewModel? controller;
  // bool isHold;
  // bool isFirst;
  // bool isGreaterOne;
  List<WorkoutById> data;
  final String? workoutId;

  TimeScreen(
      {Key? key,
      this.controller,
      // this.isFirst = false,
      // this.isGreaterOne = false,
      // this.isHold = false,
      this.workoutId,
      required this.data})
      : super(key: key);

  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen>
    with SingleTickerProviderStateMixin {
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  UpdateStatusUserProgramViewModel _updateStatusUserProgramViewModel =
      Get.put(UpdateStatusUserProgramViewModel());

  TimerController? _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;
  // SaveUserCustomizedExerciseViewModel _customizedExerciseViewModel =
  //     Get.put(SaveUserCustomizedExerciseViewModel());
  int totalRound = 0;

  timeDuration() {
    String time =
        '${_exerciseByIdViewModel.responseExe!.data![0].exerciseTime}';
    List<String> splittedTime = time.split(' ');
    log('------------- ${splittedTime.first}');
    int? timer;
    if (splittedTime.first.length == 1) {
      timer = int.parse(splittedTime.first) * 60;
      log(' ----------  timer $timer');
      return timer;
    } else if (splittedTime.first.length >= 2) {
      timer = int.parse(splittedTime.first);
      log('timer -==-=-=-=-=-= $timer');
      return timer;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _timerController = TimerController(this);

    timeDuration();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onHorizontalDragUpdate: (details) async {
      //   log("hello ${details.localPosition}");
      //   log("hello ${details.localPosition.dx}");
      //   log("hello ${details.globalPosition.distance}");
      //
      //   if (details.localPosition.dx < 100.0) {
      //     //SWIPE FROM RIGHT DETECTION
      //     log("hello ");
      //
      //     _timerController!.reset();
      //     setState(() {
      //       totalRound = 0;
      //     });
      //     _userWorkoutsDateViewModel.getBackId(
      //         counter: _userWorkoutsDateViewModel.exeIdCounter);
      //     if (_userWorkoutsDateViewModel.exeIdCounter <
      //         _userWorkoutsDateViewModel.exerciseId.length) {
      //       await widget.controller!.getExerciseByIdDetails(
      //           id: _userWorkoutsDateViewModel
      //               .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
      //       if (widget.controller!.apiResponse.status == Status.LOADING) {
      //         Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }
      //       if (widget.controller!.apiResponse.status == Status.COMPLETE) {
      //         widget.controller!.responseExe =
      //             widget.controller!.apiResponse.data;
      //       }
      //     }
      //     if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
      //       widget.isFirst = true;
      //     }
      //     if (widget.isFirst == true) {
      //       if (widget.isGreaterOne == false) {
      //         Get.back();
      //       }
      //       if (widget.isHold == true) {
      //         Get.back();
      //         widget.isHold = false;
      //         widget.isFirst = false;
      //       } else {
      //         widget.isHold = true;
      //       }
      //     }
      //     _videoPlayerController!.pause();
      //     _chewieController!.pause();
      //     _youTubePlayerController!.pause();
      //   }
      // },
      child: WillPopScope(
        onWillPop: () async {
          _timerController!.reset();
          setState(() {
            totalRound = 0;
          });
          _userWorkoutsDateViewModel.getBackId(
              counter: _userWorkoutsDateViewModel.exeIdCounter);
          if (_userWorkoutsDateViewModel.exeIdCounter <
              _userWorkoutsDateViewModel.exerciseId.length) {
            await widget.controller!.getExerciseByIdDetails(
                id: _userWorkoutsDateViewModel
                    .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
            if (widget.controller!.apiResponse.status == Status.LOADING) {
              Center(
                child: CircularProgressIndicator(),
              );
            }
            if (widget.controller!.apiResponse.status == Status.COMPLETE) {
              widget.controller!.responseExe =
                  widget.controller!.apiResponse.data;
            }
          }
          if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
            _userWorkoutsDateViewModel.isFirst = true;
          }
          if (_userWorkoutsDateViewModel.isFirst == true) {
            if (_userWorkoutsDateViewModel.isGreaterOne == false) {
              Get.back();
            }
            if (_userWorkoutsDateViewModel.isHold == true) {
              _userWorkoutsDateViewModel.isHold = false;
              _userWorkoutsDateViewModel.isFirst = false;
              Get.back();
            } else {
              _userWorkoutsDateViewModel.isHold = true;
            }
          }
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: ColorUtils.kBlack,
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: () async {
                  _timerController!.reset();
                  setState(() {
                    totalRound = 0;
                  });

                  _userWorkoutsDateViewModel.getBackId(
                      counter: _userWorkoutsDateViewModel.exeIdCounter);
                  if (_userWorkoutsDateViewModel.exeIdCounter <
                      _userWorkoutsDateViewModel.exerciseId.length) {
                    await widget.controller!.getExerciseByIdDetails(
                        id: _userWorkoutsDateViewModel.exerciseId[
                            _userWorkoutsDateViewModel.exeIdCounter]);
                    if (widget.controller!.apiResponse.status ==
                        Status.LOADING) {
                      Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (widget.controller!.apiResponse.status ==
                        Status.COMPLETE) {
                      widget.controller!.responseExe =
                          widget.controller!.apiResponse.data;
                    }
                  }
                  if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                    _userWorkoutsDateViewModel.isFirst = true;
                  }
                  if (_userWorkoutsDateViewModel.isFirst == true) {
                    if (_userWorkoutsDateViewModel.isGreaterOne == false) {
                      log('back........1');
                      Get.back();
                    }
                    if (_userWorkoutsDateViewModel.isHold == true) {
                      log('back........2');
                      Get.back();

                      _userWorkoutsDateViewModel.isHold = false;
                      _userWorkoutsDateViewModel.isFirst = false;
                    } else {
                      _userWorkoutsDateViewModel.isHold = true;
                    }
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: ColorUtils.kTint,
                )),
            backgroundColor: ColorUtils.kBlack,
            title: Text('Warm-Up', style: FontTextStyle.kWhite16BoldRoboto),
            centerTitle: true,
            actions: [
              TextButton(
                  onPressed: () {
                    Get.offAll(HomeScreen());
                    _userWorkoutsDateViewModel.exeIdCounter = 0;

                    _userWorkoutsDateViewModel.isFirst = false;
                    _userWorkoutsDateViewModel.isHold = false;

                    _timerController!.reset();
                    setState(() {
                      totalRound = 0;
                    });
                    // controller.totalRound = 0;
                  },
                  child: Text(
                    'Quit',
                    style: FontTextStyle.kTine16W400Roboto,
                  ))
            ],
          ),
          body: Container(
            height: Get.height,
            child: Column(children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: Get.width * .04,
              //   ),
              //   child: Align(
              //     alignment: Alignment.centerRight,
              //     child: InkWell(
              //         onTap: () {
              //           // Get.to(WeightExerciseScreen(
              //           //   data: widget.controller!.responseExe!.data!,
              //           // ));
              //           Get.to(SuperSetScreen());
              //         },
              //         child: Text(
              //           'Edit',
              //           style: FontTextStyle.kTine16W400Roboto
              //               .copyWith(fontSize: Get.height * 0.022),
              //         )),
              //   ),
              // ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Container(
                width: Get.width * 0.7,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                          style: FontTextStyle.kWhite24BoldRoboto,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => ExerciseDetailPage(
                              exerciseId: widget.controller!.responseExe!
                                  .data![0].exerciseId!,
                              isFromExercise: true));
                        },
                        child: Image.asset(
                          AppIcons.play,
                          height: Get.height * 0.03,
                          width: Get.height * 0.03,
                          color: ColorUtils.kTint,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.015,
              ),
              Text(
                '${widget.controller!.responseExe!.data![0].exerciseTime} seconds each set',
                style: FontTextStyle.kLightGray16W300Roboto.copyWith(
                    fontSize: Get.height * 0.023,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w300),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              totalRound == 0
                  ? Text(
                      'Sets ${widget.controller!.responseExe!.data![0].exerciseSets} ',
                      style: FontTextStyle.kLightGray16W300Roboto,
                    )
                  : Text(
                      'Sets $totalRound/${widget.controller!.responseExe!.data![0].exerciseSets} ',
                      style: FontTextStyle.kLightGray16W300Roboto,
                    ),
              Center(
                  child: Container(
                height: Get.height * .23,
                width: Get.height * .23,
                margin: EdgeInsets.symmetric(vertical: 10),
                child: SimpleTimer(
                  duration: Duration(
                      seconds: int.parse(
                          "${widget.controller!.responseExe!.data![0].exerciseTime}")),
                  controller: _timerController,
                  timerStyle: _timerStyle,
                  progressTextFormatter: (format) {
                    return formattedTime(timeInSecond: format.inSeconds);
                  },
                  backgroundColor: ColorUtils.kGray,
                  progressIndicatorColor: ColorUtils.kTint,
                  progressIndicatorDirection: _progressIndicatorDirection,
                  progressTextCountDirection: _progressTextCountDirection,
                  progressTextStyle: FontTextStyle.kWhite24BoldRoboto
                      .copyWith(fontSize: Get.height * 0.03),
                  strokeWidth: 17,
                  onStart: () {},
                  onEnd: () {
                    if (totalRound !=
                        int.parse(widget
                            .controller!.responseExe!.data![0].exerciseSets
                            .toString())) {
                      setState(() {
                        totalRound = totalRound + 1;
                      });
                      _timerController!.reset();
                    } else {
                      _timerController!.stop();
                    }
                  },
                ),
              )),
              SizedBox(
                height: Get.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      log('Start Pressed');
                      if (totalRound !=
                          int.parse(widget
                              .controller!.responseExe!.data![0].exerciseSets
                              .toString())) {
                        _timerController!.start();

                        log('controller.totalRound-------> $totalRound');
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Get.height * .06,
                      width: Get.width * .3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          colors: ColorUtilsGradient.kTintGradient,
                        ),
                      ),
                      child: Text(
                        'Start',
                        style: FontTextStyle.kBlack18w600Roboto.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: Get.height * 0.02),
                      ),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.05),
                  GestureDetector(
                    onTap: () {
                      log('Reset pressed ');
                      setState(() {
                        totalRound = 0;
                      });

                      // controller.totalRound = 0;
                      _timerController!.reset();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Get.height * .06,
                      width: Get.width * .3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: ColorUtils.kTint, width: 1.5)),
                      child: Text(
                        'Reset',
                        style: FontTextStyle.kTine17BoldRoboto,
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: Get.width * 0.9,
                child: commonNavigationButton(
                    onTap: () async {
                      _timerController!.reset();

                      setState(() {
                        totalRound = 0;
                      });
                      if (_userWorkoutsDateViewModel
                          .supersetExerciseId.isEmpty) {
                        if (widget
                                .controller!.responseExe!.data![0].exerciseId ==
                            _userWorkoutsDateViewModel.exerciseId.last) {
                          UpdateStatusUserProgramRequestModel _request =
                              UpdateStatusUserProgramRequestModel();

                          log('user workout id check ====== > ${_userWorkoutsDateViewModel.userProgramDateID}');

                          _request.userProgramDatesId =
                              _userWorkoutsDateViewModel.userProgramDateID;

                          await _updateStatusUserProgramViewModel
                              .updateStatusUserProgramViewModel(_request);

                          if (_updateStatusUserProgramViewModel
                                  .apiResponse.status ==
                              Status.COMPLETE) {
                            UpdateStatusUserProgramResponseModel response =
                                _updateStatusUserProgramViewModel
                                    .apiResponse.data;

                            if (response.success == true) {
                              _userWorkoutsDateViewModel.exeIdCounter = 0;

                              Get.showSnackbar(GetSnackBar(
                                message: '${response.msg}',
                                duration: Duration(milliseconds: 1500),
                              ));

                              Get.to(ShareProgressScreen(
                                exeData: widget.controller!.responseExe!.data!,
                                data: widget.data,
                                workoutId: widget.workoutId,
                              ));
                            } else if (response.success == false) {
                              Get.showSnackbar(GetSnackBar(
                                message: '${response.msg}',
                                duration: Duration(milliseconds: 1500),
                              ));
                            }
                          } else if (_updateStatusUserProgramViewModel
                                  .apiResponse.status ==
                              Status.ERROR) {
                            Get.showSnackbar(GetSnackBar(
                              message: 'Something Went Wrong',
                              duration: Duration(milliseconds: 1500),
                            ));
                          }
                        } else {
                          _userWorkoutsDateViewModel.getExeId(
                              counter: _userWorkoutsDateViewModel.exeIdCounter);
                          if (_userWorkoutsDateViewModel.exeIdCounter <
                              _userWorkoutsDateViewModel.exerciseId.length) {
                            if (_userWorkoutsDateViewModel.exeIdCounter > 0) {
                              _userWorkoutsDateViewModel.isGreaterOne = true;
                              log("--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                            }
                            await widget.controller!.getExerciseByIdDetails(
                                id: _userWorkoutsDateViewModel.exerciseId[
                                    _userWorkoutsDateViewModel.exeIdCounter]);
                            if (widget.controller!.apiResponse.status ==
                                Status.LOADING) {
                              Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (widget.controller!.apiResponse.status ==
                                Status.COMPLETE) {
                              widget.controller!.responseExe =
                                  widget.controller!.apiResponse.data;
                            }
                          }

                          if (_userWorkoutsDateViewModel
                              .supersetExerciseId.isEmpty) {
                            if (_userWorkoutsDateViewModel.exeIdCounter ==
                                _userWorkoutsDateViewModel.exerciseId.length) {
                              Get.to(ShareProgressScreen(
                                exeData: widget.controller!.responseExe!.data!,
                                data: widget.data,
                                workoutId: widget.workoutId,
                              ));
                              _userWorkoutsDateViewModel.isFirst = false;
                            }
                          }
                        }
                      } else {
                        _userWorkoutsDateViewModel.getExeId(
                            counter: _userWorkoutsDateViewModel.exeIdCounter);
                        if (_userWorkoutsDateViewModel.exeIdCounter <
                            _userWorkoutsDateViewModel.exerciseId.length) {
                          if (_userWorkoutsDateViewModel.exeIdCounter > 0) {
                            _userWorkoutsDateViewModel.isGreaterOne = true;
                            log("--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                          }
                          await widget.controller!.getExerciseByIdDetails(
                              id: _userWorkoutsDateViewModel.exerciseId[
                                  _userWorkoutsDateViewModel.exeIdCounter]);
                          if (widget.controller!.apiResponse.status ==
                              Status.LOADING) {
                            Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (widget.controller!.apiResponse.status ==
                              Status.COMPLETE) {
                            widget.controller!.responseExe =
                                widget.controller!.apiResponse.data;
                          }
                        }

                        if (_userWorkoutsDateViewModel
                            .supersetExerciseId.isEmpty) {
                          if (_userWorkoutsDateViewModel.exeIdCounter ==
                              _userWorkoutsDateViewModel.exerciseId.length) {
                            Get.to(ShareProgressScreen(
                              exeData: widget.controller!.responseExe!.data!,
                              data: widget.data,
                              workoutId: widget.workoutId,
                            ));
                            _userWorkoutsDateViewModel.isFirst = false;
                          }
                        }
                      }
                    },
                    name: _userWorkoutsDateViewModel.supersetExerciseId.isEmpty
                        ? widget.controller!.responseExe!.data![0].exerciseId ==
                                _userWorkoutsDateViewModel.exerciseId.last
                            ? 'Save Exercise'
                            : 'Next Exercise'
                        : 'Next Exercise'),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
            ]),
          ),
        ),
      ),
    );
    // }
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute:$second";
  }
}

// ignore: must_be_immutable
class WeightedCounter extends StatefulWidget {
  final ExerciseByIdViewModel? controller;
  List<WorkoutById> data;
  final String? workoutId;

  WeightedCounter(
      {Key? key, this.controller, this.workoutId, required this.data})
      : super(key: key);

  @override
  State<WeightedCounter> createState() => _WeightedCounterState();
}

class _WeightedCounterState extends State<WeightedCounter> {
  // SaveUserCustomizedExerciseViewModel _customizedExerciseViewModel =
  //     Get.put(SaveUserCustomizedExerciseViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  UpdateStatusUserProgramViewModel _updateStatusUserProgramViewModel =
      Get.put(UpdateStatusUserProgramViewModel());
  String? weight;

  @override
  void initState() {
    super.initState();
    weight = "${widget.controller!.responseExe!.data![0].exerciseWeight}";
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currPlayIndex = 0;
  int repsCounter = 0;

  int counterReps = 0;
  bool isShow = false;

  counterPlus() {
    setState(() {
      counterReps++;
    });
  }

  counterMinus() {
    setState(() {
      if (counterReps > 0) counterReps--;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('weightweightweightweight ==== > ${weight}');

    return WillPopScope(
      onWillPop: () async {
        _userWorkoutsDateViewModel.getBackId(
            counter: _userWorkoutsDateViewModel.exeIdCounter);
        if (_userWorkoutsDateViewModel.exeIdCounter <
            _userWorkoutsDateViewModel.exerciseId.length) {
          await widget.controller!.getExerciseByIdDetails(
              id: _userWorkoutsDateViewModel
                  .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
          if (widget.controller!.apiResponse.status == Status.LOADING) {
            Center(
              child: CircularProgressIndicator(),
            );
          }
          if (widget.controller!.apiResponse.status == Status.COMPLETE) {
            widget.controller!.responseExe =
                widget.controller!.apiResponse.data;
          }
        }
        if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
          _userWorkoutsDateViewModel.isFirst = true;
        }
        if (_userWorkoutsDateViewModel.isFirst == true) {
          if (_userWorkoutsDateViewModel.isGreaterOne == false) {
            Get.back();
          }
          if (_userWorkoutsDateViewModel.isHold == true) {
            _userWorkoutsDateViewModel.isHold = false;
            _userWorkoutsDateViewModel.isFirst = false;
            Get.back();
          } else {
            _userWorkoutsDateViewModel.isHold = true;
          }
        }

        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: ColorUtils.kBlack,
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              onPressed: () async {
                _userWorkoutsDateViewModel.getBackId(
                    counter: _userWorkoutsDateViewModel.exeIdCounter);
                if (_userWorkoutsDateViewModel.exeIdCounter <
                    _userWorkoutsDateViewModel.exerciseId.length) {
                  await widget.controller!.getExerciseByIdDetails(
                      id: _userWorkoutsDateViewModel
                          .exerciseId[_userWorkoutsDateViewModel.exeIdCounter]);
                  if (widget.controller!.apiResponse.status == Status.LOADING) {
                    Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (widget.controller!.apiResponse.status ==
                      Status.COMPLETE) {
                    widget.controller!.responseExe =
                        widget.controller!.apiResponse.data;
                  }
                }
                if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                  _userWorkoutsDateViewModel.isFirst = true;
                }
                if (_userWorkoutsDateViewModel.isFirst == true) {
                  if (_userWorkoutsDateViewModel.isGreaterOne == false) {
                    print('back........1');
                    print('greater one ........false call');

                    Get.back();
                  }
                  if (_userWorkoutsDateViewModel.isHold == true) {
                    print('back........2');
                    print('hold true........call');

                    _userWorkoutsDateViewModel.isHold = false;
                    _userWorkoutsDateViewModel.isFirst = false;
                    Get.back();
                  } else {
                    _userWorkoutsDateViewModel.isHold = true;
                  }
                }
              },
              icon: Icon(
                Icons.arrow_back_ios_sharp,
                color: ColorUtils.kTint,
              )),
          backgroundColor: ColorUtils.kBlack,
          title: Text(
              '${widget.controller!.responseExe!.data![0].exerciseTitle}',
              style: FontTextStyle.kWhite16BoldRoboto),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  Get.offAll(HomeScreen());
                },
                child: Text(
                  'Quit',
                  style: FontTextStyle.kTine16W400Roboto,
                ))
          ],
        ),
        // body:
        body: int.parse(widget.controller!.responseExe!.data![0].exerciseSets
                    .toString()) <=
                4
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Container(
                      width: Get.width * 0.7,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                                style: FontTextStyle.kWhite24BoldRoboto,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(() => ExerciseDetailPage(
                                    exerciseId: widget.controller!.responseExe!
                                        .data![0].exerciseId!,
                                    isFromExercise: true));
                              },
                              child: Image.asset(
                                AppIcons.play,
                                height: Get.height * 0.03,
                                width: Get.height * 0.03,
                                color: ColorUtils.kTint,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.015,
                    ),
                    Text(
                        '${widget.controller!.responseExe!.data![0].exerciseSets} sets of ${widget.controller!.responseExe!.data![0].exerciseReps} reps',
                        style: FontTextStyle.kLightGray16W300Roboto.copyWith(
                            fontSize: Get.height * 0.023,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w300)),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    SizedBox(
                      child: ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              top: 0,
                              right: Get.width * .06,
                              left: Get.width * .06),
                          itemCount: int.parse(widget
                              .controller!.responseExe!.data![0].exerciseSets
                              .toString()),
                          separatorBuilder: (_, index) {
                            var resRestTime =
                                "${widget.controller!.responseExe!.data![0].exerciseRest}"
                                    .toLowerCase();
                            restValue() {
                              if (resRestTime.contains('min')) {
                                int min = int.parse(
                                    "${widget.controller!.responseExe!.data![0].exerciseRest}"
                                        .split("-")
                                        .first);
                                print('restResponseValue == $min');
                                return double.parse("${min * 60}");
                              } else if (resRestTime.contains('sec') ||
                                  resRestTime.contains(" ")) {
                                int sec = int.parse(
                                    "${widget.controller!.responseExe!.data![0].exerciseRest}"
                                        .split(" ")
                                        .first
                                        .split("-")
                                        .first);
                                print('restResponseValue split == $sec');

                                return double.parse("$sec");
                              } else {
                                int sec = int.parse(
                                    "${widget.controller!.responseExe!.data![0].exerciseRest}"
                                        .split(" ")
                                        .first);
                                print('restResponseValue == $sec');

                                return double.parse("$sec");
                              }
                            }

                            /// 8000
                            // return Container(
                            //   alignment: Alignment.center,
                            //   height: Get.height * .03,
                            //   width: Get.width,
                            //   decoration: BoxDecoration(
                            //       color: ColorUtils.kGray,
                            //       borderRadius: BorderRadius.circular(6)),
                            //   child: Text(
                            //       "${widget.controller!.responseExe!.data![0].exerciseRest} Rest",
                            //       style: FontTextStyle.kWhite17W400Roboto),
                            // );
                            return WeightedProgressTimer(
                              title: "${widget.controller!.responseExe!.data![0].exerciseRest}"
                                          .toLowerCase()
                                          .contains("sec") ||
                                      "${widget.controller!.responseExe!.data![0].exerciseRest}"
                                          .toLowerCase()
                                          .contains("sec")
                                  ? '${widget.controller!.responseExe!.data![0].exerciseRest} Rest'
                                  : '${widget.controller!.responseExe!.data![0].exerciseRest} Rest',
                              restResponseValue: restValue(),
                              height: Get.height * .03,
                              width: Get.width,
                            );
                          },
                          itemBuilder: (_, index) {
                            return Stack(
                              alignment: Alignment.topRight,
                              children: [
                                WeightedCounterCard(
                                  counter: int.parse(
                                      '${widget.controller!.responseExe!.data![0].exerciseReps}'
                                          .split("-")
                                          .first),
                                  repsNo:
                                      '${widget.controller!.responseExe!.data![0].exerciseReps}'
                                          .split("-")
                                          .first,
                                  weight:
                                      '${widget.controller!.responseExe!.data![0].exerciseWeight}',
                                ),
                                Positioned(
                                  top: Get.height * .01,
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: Get.height * .027,
                                    width: Get.height * .09,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            colors: widget
                                                        .controller!
                                                        .responseExe!
                                                        .data![0]
                                                        .exerciseColor ==
                                                    "green"
                                                ? ColorUtilsGradient
                                                    .kGreenGradient
                                                : widget
                                                            .controller!
                                                            .responseExe!
                                                            .data![0]
                                                            .exerciseColor ==
                                                        "yellow"
                                                    ? ColorUtilsGradient
                                                        .kOrangeGradient
                                                    : ColorUtilsGradient
                                                        .kRedGradient,
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(6),
                                            bottomLeft: Radius.circular(6))),
                                    child: Text('RIR 0-1',
                                        style: FontTextStyle.kWhite12BoldRoboto
                                            .copyWith(
                                                fontWeight: FontWeight.w500)),
                                  ),
                                )
                              ],
                            );
                          }),
                    ),
                    // SizedBox(
                    //   height: Get.height * 0.05,
                    // ),
                    Spacer(),
                    // isShow == false
                    //     ? SizedBox(height: Get.height * .25)
                    //     : SizedBox(height: Get.height * .025),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * .06),
                      child: commonNavigationButton(
                          onTap: () async {
                            if (_userWorkoutsDateViewModel
                                .supersetExerciseId.isEmpty) {
                              if (widget.controller!.responseExe!.data![0]
                                      .exerciseId ==
                                  _userWorkoutsDateViewModel.exerciseId.last) {
                                UpdateStatusUserProgramRequestModel _request =
                                    UpdateStatusUserProgramRequestModel();

                                print(
                                    'user workout id check ====== > ${_userWorkoutsDateViewModel.userProgramDateID}');

                                _request.userProgramDatesId =
                                    _userWorkoutsDateViewModel
                                        .userProgramDateID;

                                await _updateStatusUserProgramViewModel
                                    .updateStatusUserProgramViewModel(_request);

                                if (_updateStatusUserProgramViewModel
                                        .apiResponse.status ==
                                    Status.COMPLETE) {
                                  UpdateStatusUserProgramResponseModel
                                      response =
                                      _updateStatusUserProgramViewModel
                                          .apiResponse.data;

                                  if (response.success == true) {
                                    _userWorkoutsDateViewModel.exeIdCounter = 0;

                                    Get.showSnackbar(GetSnackBar(
                                      message: '${response.msg}',
                                      duration: Duration(milliseconds: 1500),
                                    ));
                                    Get.to(ShareProgressScreen(
                                      exeData:
                                          widget.controller!.responseExe!.data!,
                                      data: widget.data,
                                      workoutId: widget.workoutId,
                                    ));
                                  } else if (response.success == false) {
                                    Get.showSnackbar(GetSnackBar(
                                      message: '${response.msg}',
                                      duration: Duration(milliseconds: 1500),
                                    ));
                                  }
                                } else if (_updateStatusUserProgramViewModel
                                        .apiResponse.status ==
                                    Status.ERROR) {
                                  Get.showSnackbar(GetSnackBar(
                                    message: 'Something Went Wrong',
                                    duration: Duration(milliseconds: 1500),
                                  ));
                                }
                              } else {
                                _userWorkoutsDateViewModel.getExeId(
                                    counter: _userWorkoutsDateViewModel
                                        .exeIdCounter);
                                if (_userWorkoutsDateViewModel.exeIdCounter <
                                    _userWorkoutsDateViewModel
                                        .exerciseId.length) {
                                  if (_userWorkoutsDateViewModel.exeIdCounter >
                                      0) {
                                    _userWorkoutsDateViewModel.isGreaterOne =
                                        true;
                                    print(
                                        "--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                  }
                                  await widget.controller!
                                      .getExerciseByIdDetails(
                                          id: _userWorkoutsDateViewModel
                                                  .exerciseId[
                                              _userWorkoutsDateViewModel
                                                  .exeIdCounter]);
                                  if (widget.controller!.apiResponse.status ==
                                      Status.LOADING) {
                                    Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (widget.controller!.apiResponse.status ==
                                      Status.COMPLETE) {
                                    widget.controller!.responseExe =
                                        widget.controller!.apiResponse.data;
                                  }
                                }

                                if (_userWorkoutsDateViewModel
                                    .supersetExerciseId.isEmpty) {
                                  if (_userWorkoutsDateViewModel.exeIdCounter ==
                                      _userWorkoutsDateViewModel
                                          .exerciseId.length) {
                                    Get.to(ShareProgressScreen(
                                      exeData:
                                          widget.controller!.responseExe!.data!,
                                      data: widget.data,
                                      workoutId: widget.workoutId,
                                    ));
                                    _userWorkoutsDateViewModel.isFirst = false;
                                  }
                                }
                              }
                            } else {
                              _userWorkoutsDateViewModel.getExeId(
                                  counter:
                                      _userWorkoutsDateViewModel.exeIdCounter);
                              if (_userWorkoutsDateViewModel.exeIdCounter <
                                  _userWorkoutsDateViewModel
                                      .exerciseId.length) {
                                if (_userWorkoutsDateViewModel.exeIdCounter >
                                    0) {
                                  _userWorkoutsDateViewModel.isGreaterOne =
                                      true;
                                  print(
                                      "--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                }
                                await widget.controller!.getExerciseByIdDetails(
                                    id: _userWorkoutsDateViewModel.exerciseId[
                                        _userWorkoutsDateViewModel
                                            .exeIdCounter]);
                                if (widget.controller!.apiResponse.status ==
                                    Status.LOADING) {
                                  Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (widget.controller!.apiResponse.status ==
                                    Status.COMPLETE) {
                                  widget.controller!.responseExe =
                                      widget.controller!.apiResponse.data;
                                }
                              }

                              if (_userWorkoutsDateViewModel
                                  .supersetExerciseId.isEmpty) {
                                if (_userWorkoutsDateViewModel.exeIdCounter ==
                                    _userWorkoutsDateViewModel
                                        .exerciseId.length) {
                                  Get.to(ShareProgressScreen(
                                    exeData:
                                        widget.controller!.responseExe!.data!,
                                    data: widget.data,
                                    workoutId: widget.workoutId,
                                  ));
                                  _userWorkoutsDateViewModel.isFirst = false;
                                }
                              }
                            }
                          },
                          name: _userWorkoutsDateViewModel
                                  .supersetExerciseId.isEmpty
                              ? widget.controller!.responseExe!.data![0]
                                          .exerciseId ==
                                      _userWorkoutsDateViewModel.exerciseId.last
                                  ? 'Save Exercise'
                                  : 'Next Exercise'
                              : 'Next Exercise'),
                    ),
                    SizedBox(height: Get.height * .04),
                  ])
            : SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width * 0.7,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  '${widget.controller!.responseExe!.data![0].exerciseTitle}',
                                  style: FontTextStyle.kWhite24BoldRoboto,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => ExerciseDetailPage(
                                      exerciseId: widget.controller!
                                          .responseExe!.data![0].exerciseId!,
                                      isFromExercise: true));
                                },
                                child: Image.asset(
                                  AppIcons.play,
                                  height: Get.height * 0.03,
                                  width: Get.height * 0.03,
                                  color: ColorUtils.kTint,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.015,
                      ),
                      Text(
                          '${widget.controller!.responseExe!.data![0].exerciseSets} sets of ${widget.controller!.responseExe!.data![0].exerciseReps} reps',
                          style: FontTextStyle.kLightGray16W300Roboto.copyWith(
                              fontSize: Get.height * 0.023,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w300)),
                      SizedBox(
                        height: Get.height * 0.05,
                      ),
                      SizedBox(
                        child: ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: int.parse(widget
                                .controller!.responseExe!.data![0].exerciseSets
                                .toString()),
                            padding: EdgeInsets.only(
                                top: 0,
                                right: Get.width * .06,
                                left: Get.width * .06),
                            separatorBuilder: (_, index) {
                              return Container(
                                alignment: Alignment.center,
                                height: Get.height * .03,
                                width: Get.width,
                                decoration: BoxDecoration(
                                    color: ColorUtils.kGray,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                    "${widget.controller!.responseExe!.data![0].exerciseRest} Seconds Rest",
                                    style: FontTextStyle.kWhite17W400Roboto),
                              );
                            },
                            itemBuilder: (_, index) {
                              return Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  WeightedCounterCard(
                                    counter: int.parse(
                                        '${widget.controller!.responseExe!.data![0].exerciseReps}'
                                            .split("-")
                                            .first),
                                    repsNo:
                                        '${widget.controller!.responseExe!.data![0].exerciseReps}'
                                            .split("-")
                                            .first,
                                    weight:
                                        '${widget.controller!.responseExe!.data![0].exerciseWeight}',
                                  ),
                                  Positioned(
                                    top: Get.height * .01,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: Get.height * .027,
                                      width: Get.height * .09,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: widget
                                                          .controller!
                                                          .responseExe!
                                                          .data![0]
                                                          .exerciseColor ==
                                                      "green"
                                                  ? ColorUtilsGradient
                                                      .kGreenGradient
                                                  : widget
                                                              .controller!
                                                              .responseExe!
                                                              .data![0]
                                                              .exerciseColor ==
                                                          "yellow"
                                                      ? ColorUtilsGradient
                                                          .kOrangeGradient
                                                      : ColorUtilsGradient
                                                          .kRedGradient,
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(6),
                                              bottomLeft: Radius.circular(6))),
                                      child: Text('RIR 0-1',
                                          style: FontTextStyle
                                              .kWhite12BoldRoboto
                                              .copyWith(
                                                  fontWeight: FontWeight.w500)),
                                    ),
                                  )
                                ],
                              );
                            }),
                      ),
                      // isShow == false
                      //     ? SizedBox(height: Get.height * .25)
                      //     : SizedBox(height: Get.height * .025),
                      SizedBox(
                        height: Get.height * 0.07,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * .06),
                        child: commonNavigationButton(
                            onTap: () async {
                              if (_userWorkoutsDateViewModel
                                  .supersetExerciseId.isEmpty) {
                                if (widget.controller!.responseExe!.data![0]
                                        .exerciseId ==
                                    _userWorkoutsDateViewModel
                                        .exerciseId.last) {
                                  UpdateStatusUserProgramRequestModel _request =
                                      UpdateStatusUserProgramRequestModel();

                                  print(
                                      'user workout id check ====== > ${_userWorkoutsDateViewModel.userProgramDateID}');

                                  _request.userProgramDatesId =
                                      _userWorkoutsDateViewModel
                                          .userProgramDateID;

                                  await _updateStatusUserProgramViewModel
                                      .updateStatusUserProgramViewModel(
                                          _request);

                                  if (_updateStatusUserProgramViewModel
                                          .apiResponse.status ==
                                      Status.COMPLETE) {
                                    UpdateStatusUserProgramResponseModel
                                        response =
                                        _updateStatusUserProgramViewModel
                                            .apiResponse.data;

                                    if (response.success == true) {
                                      _userWorkoutsDateViewModel.exeIdCounter =
                                          0;

                                      Get.showSnackbar(GetSnackBar(
                                        message: '${response.msg}',
                                        duration: Duration(milliseconds: 1500),
                                      ));
                                      Get.to(ShareProgressScreen(
                                        exeData: widget
                                            .controller!.responseExe!.data!,
                                        data: widget.data,
                                        workoutId: widget.workoutId,
                                      ));
                                    } else if (response.success == false) {
                                      Get.showSnackbar(GetSnackBar(
                                        message: '${response.msg}',
                                        duration: Duration(milliseconds: 1500),
                                      ));
                                    }
                                  } else if (_updateStatusUserProgramViewModel
                                          .apiResponse.status ==
                                      Status.ERROR) {
                                    Get.showSnackbar(GetSnackBar(
                                      message: 'Something Went Wrong',
                                      duration: Duration(milliseconds: 1500),
                                    ));
                                  }
                                } else {
                                  _userWorkoutsDateViewModel.getExeId(
                                      counter: _userWorkoutsDateViewModel
                                          .exeIdCounter);
                                  if (_userWorkoutsDateViewModel.exeIdCounter <
                                      _userWorkoutsDateViewModel
                                          .exerciseId.length) {
                                    if (_userWorkoutsDateViewModel
                                            .exeIdCounter >
                                        0) {
                                      _userWorkoutsDateViewModel.isGreaterOne =
                                          true;
                                      print(
                                          "--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                    }
                                    await widget.controller!
                                        .getExerciseByIdDetails(
                                            id: _userWorkoutsDateViewModel
                                                    .exerciseId[
                                                _userWorkoutsDateViewModel
                                                    .exeIdCounter]);
                                    if (widget.controller!.apiResponse.status ==
                                        Status.LOADING) {
                                      Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    if (widget.controller!.apiResponse.status ==
                                        Status.COMPLETE) {
                                      widget.controller!.responseExe =
                                          widget.controller!.apiResponse.data;
                                    }
                                  }

                                  if (_userWorkoutsDateViewModel
                                      .supersetExerciseId.isEmpty) {
                                    if (_userWorkoutsDateViewModel
                                            .exeIdCounter ==
                                        _userWorkoutsDateViewModel
                                            .exerciseId.length) {
                                      Get.to(ShareProgressScreen(
                                        exeData: widget
                                            .controller!.responseExe!.data!,
                                        data: widget.data,
                                        workoutId: widget.workoutId,
                                      ));
                                      _userWorkoutsDateViewModel.isFirst =
                                          false;
                                    }
                                  }
                                }
                              } else {
                                _userWorkoutsDateViewModel.getExeId(
                                    counter: _userWorkoutsDateViewModel
                                        .exeIdCounter);
                                if (_userWorkoutsDateViewModel.exeIdCounter <
                                    _userWorkoutsDateViewModel
                                        .exerciseId.length) {
                                  if (_userWorkoutsDateViewModel.exeIdCounter >
                                      0) {
                                    _userWorkoutsDateViewModel.isGreaterOne =
                                        true;
                                    print(
                                        "--------------------- > ${_userWorkoutsDateViewModel.isGreaterOne}");
                                  }
                                  await widget.controller!
                                      .getExerciseByIdDetails(
                                          id: _userWorkoutsDateViewModel
                                                  .exerciseId[
                                              _userWorkoutsDateViewModel
                                                  .exeIdCounter]);
                                  if (widget.controller!.apiResponse.status ==
                                      Status.LOADING) {
                                    Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  if (widget.controller!.apiResponse.status ==
                                      Status.COMPLETE) {
                                    widget.controller!.responseExe =
                                        widget.controller!.apiResponse.data;
                                  }
                                }

                                if (_userWorkoutsDateViewModel
                                    .supersetExerciseId.isEmpty) {
                                  if (_userWorkoutsDateViewModel.exeIdCounter ==
                                      _userWorkoutsDateViewModel
                                          .exerciseId.length) {
                                    Get.to(ShareProgressScreen(
                                      exeData:
                                          widget.controller!.responseExe!.data!,
                                      data: widget.data,
                                      workoutId: widget.workoutId,
                                    ));
                                    _userWorkoutsDateViewModel.isFirst = false;
                                  }
                                }
                              }
                            },
                            name: _userWorkoutsDateViewModel
                                    .supersetExerciseId.isEmpty
                                ? widget.controller!.responseExe!.data![0]
                                            .exerciseId ==
                                        _userWorkoutsDateViewModel
                                            .exerciseId.last
                                    ? 'Save Exercise'
                                    : 'Next Exercise'
                                : 'Next Exercise'),
                      ),

                      SizedBox(height: Get.height * .04),
                    ]),
              ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SuperSet extends StatefulWidget {
  final ExerciseByIdViewModel? controller;
  List<WorkoutById> data;
  final String? workoutId;
  SuperSet({Key? key, this.controller, this.workoutId, required this.data})
      : super(key: key);

  @override
  State<SuperSet> createState() => _SuperSetState();
}

class _SuperSetState extends State<SuperSet>
    with SingleTickerProviderStateMixin {
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  UpdateStatusUserProgramViewModel _updateStatusUserProgramViewModel =
      Get.put(UpdateStatusUserProgramViewModel());

  List<String> exeName = [
    "Dead Lift",
    "Pull-ups",
    "Bicep Curls",
    "Foam Roll Chest"
  ];
  int counter = 0;
  bool watchVideo = false;
  var a;
  bool start = false;
  bool isThere = true;

  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;
  TimerController? _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;

  // formattedTime({required int timeInSecond}) {
  //   int sec = timeInSecond % 60;
  //   int min = (timeInSecond / 60).floor();
  //   String minute = min.toString().length == 0 ? "" : "$min" + " minutes";
  //   String second = sec.toString().length == 0 ? "" : "$sec" + " seconds";
  //   return "$minute $second";
  // }
  formattedTime({required int timeInSecond}) {
    // log('formattedTime >> ${120 % 60}');
    // log('formattedTime >> ${120 / 60}');
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    if (timeInSecond % 60 == 0) {
      return "${(timeInSecond / 60).toString().split(".").first} minute";
    } else if (timeInSecond >= 60) {
      return "$minute : $second minute";
    } else {
      return "$timeInSecond second";
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _timerController = TimerController(this);
    super.initState();
  }

  apiCallSuperSet({int? index}) async {
    await _exerciseByIdViewModel.getExerciseByIdDetails(
        id: _userWorkoutsDateViewModel.supersetExerciseId[index!]);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserWorkoutsDateViewModel>(
      builder: (controllerUWD) {
        return WillPopScope(
          onWillPop: () async {
            controllerUWD.getBackId(counter: controllerUWD.exeIdCounter);
            if (controllerUWD.exeIdCounter < controllerUWD.exerciseId.length) {
              await widget.controller!.getExerciseByIdDetails(
                  id: controllerUWD.exerciseId[controllerUWD.exeIdCounter]);
              if (widget.controller!.apiResponse.status == Status.LOADING) {
                Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (widget.controller!.apiResponse.status == Status.COMPLETE) {
                widget.controller!.responseExe =
                    widget.controller!.apiResponse.data;
              }
            }
            if (controllerUWD.exeIdCounter == 0) {
              controllerUWD.isFirst = true;
            }
            if (controllerUWD.isFirst == true) {
              if (controllerUWD.isGreaterOne == false) {
                Get.back();
              }
              if (controllerUWD.isHold == true) {
                controllerUWD.isHold = false;
                controllerUWD.isFirst = false;
                Get.back();
              } else {
                controllerUWD.isHold = true;
              }
            }
            return Future.value(false);
          },
          child: Scaffold(
            backgroundColor: ColorUtils.kBlack,
            appBar: AppBar(
              elevation: 0,
              // leading: IconButton(
              //     onPressed: () async {
              //       log('supersetCounter ===================> ${controllerUWD.supersetCounter}');
              //       log('supersetRound ===================> ${controllerUWD.supersetRound}');
              //       if (controllerUWD.supersetCounter == 0) {
              //         // controllerUWD.getBackId(
              //         //     counter: controllerUWD.exeIdCounter);
              //         if (controllerUWD.exeIdCounter <
              //             controllerUWD.exerciseId.length) {
              //           await widget.controller!.getExerciseByIdDetails(
              //               id: controllerUWD
              //                   .exerciseId[controllerUWD.exeIdCounter]);
              //           if (widget.controller!.apiResponse.status ==
              //               Status.LOADING) {
              //             Center(
              //               child: CircularProgressIndicator(),
              //             );
              //           }
              //           if (widget.controller!.apiResponse.status ==
              //               Status.COMPLETE) {
              //             widget.controller!.responseExe =
              //                 widget.controller!.apiResponse.data;
              //           }
              //         }
              //         Get.back();
              //         controllerUWD.getSupersetBackRound();
              //
              //         // if (controllerUWD.exeIdCounter == 0) {
              //         //   controllerUWD.isFirst = true;
              //         // }
              //         // if (controllerUWD.isFirst == true) {
              //         //   if (controllerUWD.isGreaterOne == false) {
              //         //     log('back........1');
              //         //     log('greater one ........false call');
              //         //
              //         //     Get.back();
              //         //   }
              //         //   if (controllerUWD.isHold == true) {
              //         //     log('back........2');
              //         //     log('hold true........call');
              //         //
              //         //     controllerUWD.isHold = false;
              //         //     controllerUWD.isFirst = false;
              //         //     // _userWorkoutsDateViewModel.supersetRound = 0;
              //         //     // _userWorkoutsDateViewModel.supersetCounter = 0;
              //         //     Get.back();
              //         //   } else {
              //         //     controllerUWD.isHold = true;
              //         //   }
              //         // }
              //       } else {
              //         Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => SuperSet(
              //                 data: widget.data,
              //                 controller: widget.controller,
              //                 workoutId: widget.workoutId,
              //               ),
              //             ));
              //         controllerUWD.getSupersetBackRound();
              //         controllerUWD.resTimer!.cancel();
              //         controllerUWD.currentRestValue = 0;
              //       }
              //
              //     },
              //     icon: Icon(
              //       Icons.arrow_back_ios_sharp,
              //       color: ColorUtils.kTint,
              //     )),
              leading: IconButton(
                  onPressed: () async {
                    if (_userWorkoutsDateViewModel.supersetCounter == 0) {
                      print('Hello back ');
                      _userWorkoutsDateViewModel.getSupersetBackRound();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SuperSet(
                              data: widget.data,
                              controller: widget.controller,
                              workoutId: widget.workoutId,
                            ),
                          ));
                    } else {
                      _userWorkoutsDateViewModel.getBackId(
                          counter: _userWorkoutsDateViewModel.exeIdCounter);
                      if (_userWorkoutsDateViewModel.exeIdCounter <
                          _userWorkoutsDateViewModel.exerciseId.length) {
                        await widget.controller!.getExerciseByIdDetails(
                            id: _userWorkoutsDateViewModel.exerciseId[
                                _userWorkoutsDateViewModel.exeIdCounter]);
                        if (widget.controller!.apiResponse.status ==
                            Status.LOADING) {
                          Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (widget.controller!.apiResponse.status ==
                            Status.COMPLETE) {
                          widget.controller!.responseExe =
                              widget.controller!.apiResponse.data;
                        }
                      }
                      if (_userWorkoutsDateViewModel.exeIdCounter == 0) {
                        _userWorkoutsDateViewModel.isFirst = true;
                      }
                      if (_userWorkoutsDateViewModel.isFirst == true) {
                        if (_userWorkoutsDateViewModel.isGreaterOne == false) {
                          print('back........1');
                          print('greater one ........false call');

                          Get.back();
                        }
                        if (_userWorkoutsDateViewModel.isHold == true) {
                          print('back........2');
                          print('hold true........call');

                          _userWorkoutsDateViewModel.isHold = false;
                          _userWorkoutsDateViewModel.isFirst = false;
                          Get.back();
                        } else {
                          _userWorkoutsDateViewModel.isHold = true;
                        }
                      }
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_sharp,
                    color: ColorUtils.kTint,
                  )),

              backgroundColor: ColorUtils.kBlack,
              title: Text('Superset', style: FontTextStyle.kWhite16BoldRoboto),
              centerTitle: true,
              actions: [
                TextButton(
                    onPressed: () {
                      Get.offAll(HomeScreen());
                    },
                    child: Text(
                      'Quit',
                      style: FontTextStyle.kTine16W400Roboto,
                    ))
              ],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: SizedBox(
                width: Get.width,
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: Get.height * .027),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Superset',
                          style: FontTextStyle.kWhite24BoldRoboto
                              .copyWith(fontSize: Get.height * .03),
                        ),
                        SizedBox(height: Get.height * .015),
                        Text('${controllerUWD.supersetRound} rounds',
                            style: FontTextStyle.kLightGray18W300Roboto),
                        SizedBox(height: Get.height * .008),
                        Text(
                            '${controllerUWD.supersetRestTime} secs rest between rounds',
                            style: FontTextStyle.kLightGray18W300Roboto),
                      ],
                    ),
                  ),
                  Container(
                    height: Get.height * .055,
                    width: Get.width * .33,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        gradient: LinearGradient(
                            colors: ColorUtilsGradient.kGrayGradient,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter),
                        borderRadius: BorderRadius.circular(6)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Round', style: FontTextStyle.kWhite18BoldRoboto),
                        SizedBox(width: Get.width * .02),
                        CircleAvatar(
                            radius: Get.height * .019,
                            backgroundColor: ColorUtils.kTint,
                            child: Text(
                              '${controllerUWD.supersetCounter + 1}',
                              style: FontTextStyle.kBlack20BoldRoboto,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: Get.height * .03,
                        left: Get.height * .025,
                        right: Get.height * .025),
                    child: SizedBox(
                      width: Get.width,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: controllerUWD.supersetExerciseId.length,
                          // itemCount: exeName.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            // apiCallSuperSet(index: index);
                            log('index ================= ${controllerUWD.supersetExerciseId.length}');
                            // _exerciseByIdViewModel.getExerciseByIdDetails(
                            //     id: _userWorkoutsDateViewModel
                            //         .supersetExerciseId[index]);
                            // return SizedBox();
                            return superSet(
                                id: controllerUWD.supersetExerciseId[index]);
                          }),
                    ),
                  ),
                  controllerUWD.currentRestValue == 0
                      ? GestureDetector(
                          onTap: () {
                            if (controllerUWD.currentValue > 0) {
                              controllerUWD.currentValue = 0;
                              controllerUWD.timer!.cancel();
                            }
                            controllerUWD.startRestTimer();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.height * .025),
                            child: Container(
                                // margin: EdgeInsets.only(
                                //     top: Get.height * .01,
                                //     bottom: Get.height * .04,
                                //     left: Get.height * .025,
                                //     right: Get.height * .025),
                                alignment: Alignment.center,
                                width: Get.width,
                                height: Get.height * .055,
                                decoration: BoxDecoration(
                                    color: ColorUtils.kSaperatedGray,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  '${controllerUWD.supersetRestTime} second rest',
                                  style: FontTextStyle.kWhite17W400Roboto,
                                )),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.height * .025),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                // margin: EdgeInsets.only(
                                //     top: Get.height * .01,
                                //     bottom: Get.height * .01,
                                //     left: Get.height * .025,
                                //     right: Get.height * .025),
                                width: Get.width,
                                height: Get.height * .055,
                                child: FAProgressBar(
                                  animatedDuration: Duration(seconds: 1),
                                  currentValue:
                                      controllerUWD.currentRestValue.toDouble(),
                                  backgroundColor: ColorUtils.kSaperatedGray,
                                  progressColor: ColorUtils.kGreen,
                                  maxValue: double.parse(
                                      "${controllerUWD.supersetRestTime}"),
                                ),
                              ),
                              Text(
                                '${controllerUWD.supersetRestTime} second rest',
                                style: FontTextStyle.kWhite17W400Roboto,
                              )
                            ],
                          ),
                        ),
                  SizedBox(height: Get.height * .035),
                  Padding(
                      padding: EdgeInsets.only(
                          left: Get.height * .03,
                          right: Get.height * .03,
                          bottom: Get.height * .05),
                      child: commonNavigationButton(
                          name: controllerUWD.supersetCounter !=
                                  controllerUWD.supersetRound - 1
                              ? "Next Round"
                              : "Save Exercise",
                          onTap: () async {
                            controllerUWD.getSupersetRound();

                            log('supersetCounter ===================> ${controllerUWD.supersetCounter}');
                            log('supersetRound ===================> ${controllerUWD.supersetRound}');

                            if (controllerUWD.supersetCounter ==
                                controllerUWD.supersetRound) {
                              UpdateStatusUserProgramRequestModel _request =
                                  UpdateStatusUserProgramRequestModel();

                              log('user workout id check ====== > ${controllerUWD.userProgramDateID}');

                              _request.userProgramDatesId =
                                  controllerUWD.userProgramDateID;

                              await _updateStatusUserProgramViewModel
                                  .updateStatusUserProgramViewModel(_request);

                              if (_updateStatusUserProgramViewModel
                                      .apiResponse.status ==
                                  Status.COMPLETE) {
                                UpdateStatusUserProgramResponseModel response =
                                    _updateStatusUserProgramViewModel
                                        .apiResponse.data;

                                if (response.success == true) {
                                  _timerController!.reset();

                                  Get.showSnackbar(GetSnackBar(
                                    message: '${response.msg}',
                                    duration: Duration(milliseconds: 1500),
                                  ));

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ShareProgressScreen(
                                          data: widget.data,
                                          exeData: widget
                                              .controller!.responseExe!.data!,
                                          workoutId: widget.workoutId,
                                        ),
                                      ));
                                  controllerUWD.resTimer!.cancel();
                                  controllerUWD.currentRestValue = 0;

                                  // Get.to();
                                } else if (response.success == false) {
                                  Get.showSnackbar(GetSnackBar(
                                    message: '${response.msg}',
                                    duration: Duration(milliseconds: 1500),
                                  ));
                                }
                              } else if (_updateStatusUserProgramViewModel
                                      .apiResponse.status ==
                                  Status.ERROR) {
                                Get.showSnackbar(GetSnackBar(
                                  message: 'Something Went Wrong',
                                  duration: Duration(milliseconds: 1500),
                                ));
                              }
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SuperSet(
                                      data: widget.data,
                                      controller: widget.controller,
                                      workoutId: widget.workoutId,
                                    ),
                                  ));
                              controllerUWD.resTimer!.cancel();
                              controllerUWD.currentRestValue = 0;
                            }
                          }))
                ]),
              ),
            ),
          ),
        );
      },
    );
  }

  superSet({var id}) {
    return FutureBuilder<ExerciseByIdResponseModel>(
      future: ExerciseByIdRepo().exerciseByIdRepo(id: id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ExerciseByIdResponseModel response = snapshot.data!;
          _userWorkoutsDateViewModel.supersetWeight =
              TextEditingController(text: response.data![0].exerciseWeight);

          log(' exerciseTitle == ${response.data![0].exerciseTitle}');
          log('response exerciseTime== ${response.data![0].exerciseTime}');
          if (response.data![0].exerciseType == "REPS") {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('${response.data![0].exerciseTitle}',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * .026,
                          )),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ExerciseDetailPage(
                            exerciseId: id, isFromExercise: true));
                      },
                      child: Image.asset(
                        AppIcons.info,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                    SizedBox(width: Get.width * .03),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        AppIcons.compareArrow,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                    // SizedBox(width: Get.width * .03),
                    // GestureDetector(
                    //   onTap: () {
                    //     Get.to(() => ExerciseDetailPage(
                    //         exerciseId: id, isFromExercise: true));
                    //   },
                    //   child: Image.asset(
                    //     AppIcons.play,
                    //     height: Get.height * 0.03,
                    //     width: Get.height * 0.03,
                    //     color: ColorUtils.kTint,
                    //   ),
                    // ),
                  ],
                ),
                SizedBox(height: Get.height * .005),
                Text(
                  '${response.data![0].exerciseReps} reps',
                  style: FontTextStyle.kLightGray18W300Roboto,
                ),
                SizedBox(height: Get.height * .0075),
                NoWeightedCounterCard(
                    counter: int.parse(
                        "${response.data![0].exerciseReps}".split("-").first),
                    repsNo:
                        "${response.data![0].exerciseReps}".split("-").first),
                Divider(height: Get.height * .06, color: ColorUtils.kLightGray)
              ],
            );
          } else if (response.data![0].exerciseType == "TIME") {
            _userWorkoutsDateViewModel.responseTime =
                int.parse("${response.data![0].exerciseTime}");

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('${response.data![0].exerciseTitle}',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * .026,
                          )),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ExerciseDetailPage(
                            exerciseId: id, isFromExercise: true));
                      },
                      child: Image.asset(
                        AppIcons.info,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                    SizedBox(width: Get.width * .03),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        AppIcons.compareArrow,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .005),
                Text(
                  '${response.data![0].exerciseTime} seconds each side',
                  style: FontTextStyle.kLightGray18W300Roboto,
                ),
                SizedBox(height: Get.height * .0075),
                // Center(
                //     child: Container(
                //   height: Get.height * 0.18,
                //   width: Get.height * 0.18,
                //   margin: EdgeInsets.symmetric(vertical: 10),
                //   child: SimpleTimer(
                //     duration: Duration(
                //         seconds:
                //             int.parse("${response.data![0].exerciseTime}")),
                //     controller: _timerController,
                //     timerStyle: _timerStyle,
                //     progressTextFormatter: (format) {
                //       return formattedTime(timeInSecond: format.inSeconds);
                //     },
                //     backgroundColor: ColorUtils.kGray,
                //     progressIndicatorColor: ColorUtils.kTint,
                //     progressIndicatorDirection: _progressIndicatorDirection,
                //     progressTextCountDirection: _progressTextCountDirection,
                //     progressTextStyle: FontTextStyle.kWhite24BoldRoboto
                //         .copyWith(fontSize: Get.height * 0.025),
                //     strokeWidth: 15,
                //     onStart: () {},
                //     onEnd: () {
                //       _timerController!.stop();
                //     },
                //   ),
                // )),

                _userWorkoutsDateViewModel.currentValue == 0
                    ? Container(
                        alignment: Alignment.center,
                        height: Get.height * .1,
                        width: Get.width,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            gradient: LinearGradient(
                                colors: ColorUtilsGradient.kGrayGradient,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.circular(6)),
                        child: GestureDetector(
                          onTap: () {
                            if (_userWorkoutsDateViewModel.currentRestValue >
                                0) {
                              _userWorkoutsDateViewModel.timer!.cancel();
                            } else
                              _userWorkoutsDateViewModel.startTimer();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: Get.height * .05,
                            width: Get.width * .65,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: ColorUtilsGradient.kTintGradient,
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              "Start ${formattedTime(timeInSecond: int.parse("${response.data![0].exerciseTime}"))} timer",
                              style: FontTextStyle.kBlack18w600Roboto,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: Get.height * .1,
                        width: Get.width,
                        child: FAProgressBar(
                          size: 70,
                          currentValue: _userWorkoutsDateViewModel.currentValue
                              .toDouble(),
                          backgroundColor: ColorUtils.kGray,
                          animatedDuration: Duration(microseconds: 800),
                          progressColor: ColorUtils.kGreen,
                          maxValue:
                              double.parse("${response.data![0].exerciseTime}"),
                        ),
                      ),

                Divider(height: Get.height * .06, color: ColorUtils.kLightGray)
              ],
            );
          } else if (response.data![0].exerciseType == "WEIGHTED") {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('${response.data![0].exerciseTitle}',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * .026,
                          )),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ExerciseDetailPage(
                            exerciseId: id, isFromExercise: true));
                      },
                      child: Image.asset(
                        AppIcons.info,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                    SizedBox(width: Get.width * .03),
                    GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        AppIcons.compareArrow,
                        height: Get.height * 0.03,
                        width: Get.height * 0.03,
                        color: ColorUtils.kTint,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Get.height * .005),
                Text(
                  '${response.data![0].exerciseReps} reps',
                  style: FontTextStyle.kLightGray18W300Roboto,
                ),
                SizedBox(height: Get.height * .0075),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    WeightedCounterCard(
                      weight:
                          '${widget.controller!.responseExe!.data![0].exerciseWeight}',
                      counter: int.parse(
                          '${widget.controller!.responseExe!.data![0].exerciseReps}'
                              .split("-")
                              .first),
                      repsNo:
                          '${widget.controller!.responseExe!.data![0].exerciseReps}'
                              .split("-")
                              .first,
                    ),
                    Positioned(
                      top: Get.height * .01,
                      child: Container(
                        alignment: Alignment.center,
                        height: Get.height * .027,
                        width: Get.height * .09,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: widget.controller!.responseExe!.data![0]
                                            .exerciseColor ==
                                        "green"
                                    ? ColorUtilsGradient.kGreenGradient
                                    : widget.controller!.responseExe!.data![0]
                                                .exerciseColor ==
                                            "yellow"
                                        ? ColorUtilsGradient.kOrangeGradient
                                        : ColorUtilsGradient.kRedGradient,
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(6),
                                bottomLeft: Radius.circular(6))),
                        child: Text('RIR 0-1',
                            style: FontTextStyle.kWhite12BoldRoboto
                                .copyWith(fontWeight: FontWeight.w500)),
                      ),
                    )
                  ],
                ),
                Divider(height: Get.height * .06, color: ColorUtils.kLightGray)
              ],
            );
          } else {
            return SizedBox();
          }
        } else {
          return SizedBox(
            height: Get.height * .125,
            width: Get.height * .125,
            child: Center(
              child: CircularProgressIndicator(color: ColorUtils.kTint),
            ),
          );
        }
      },
    );
  }
  // GetBuilder<ExerciseByIdViewModel> superSet({var m}) {
  //   _exerciseByIdViewModel.getExerciseByIdDetails(id: m);
  //   return GetBuilder<ExerciseByIdViewModel>(builder: (controller) {
  //     if (controller.apiResponse.status == Status.LOADING) {
  //       return ColoredBox(
  //         color: ColorUtils.kBlack,
  //         child: Center(
  //           child: CircularProgressIndicator(
  //             color: ColorUtils.kTint,
  //           ),
  //         ),
  //       );
  //     }
  //
  //     if (controller.apiResponse.status == Status.COMPLETE) {
  //       ExerciseByIdResponseModel response = controller.apiResponse.data;
  //
  //       if (response.data![0].exerciseType == "REPS") {
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 Text('${response.data![0].exerciseTitle}',
  //                     style: FontTextStyle.kWhite24BoldRoboto.copyWith(
  //                       fontSize: Get.height * .026,
  //                     )),
  //                 SizedBox(width: Get.width * .03),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: Image.asset(
  //                     AppIcons.play,
  //                     height: Get.height * 0.03,
  //                     width: Get.height * 0.03,
  //                     color: ColorUtils.kTint,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: Get.height * .005),
  //             Text(
  //               '10 reps',
  //               style: FontTextStyle.kLightGray18W300Roboto,
  //             ),
  //             SizedBox(height: Get.height * .0075),
  //             NoWeightedCounter(
  //                 counter: int.parse("${response.data![0].exerciseReps}"),
  //                 repsNo: '5'),
  //             Divider(height: Get.height * .06, color: ColorUtils.kLightGray)
  //           ],
  //         );
  //
  //       } else if (response.data![0].exerciseType == "TIME") {
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 Text('${response.data![0].exerciseTitle}',
  //                     style: FontTextStyle.kWhite24BoldRoboto.copyWith(
  //                       fontSize: Get.height * .026,
  //                     )),
  //                 SizedBox(width: Get.width * .03),
  //                 GestureDetector(
  //                   onTap: () {},
  //                   child: Image.asset(
  //                     AppIcons.play,
  //                     height: Get.height * 0.03,
  //                     width: Get.height * 0.03,
  //                     color: ColorUtils.kTint,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: Get.height * .005),
  //             Text(
  //               '30 seconds each side',
  //               style: FontTextStyle.kLightGray18W300Roboto,
  //             ),
  //             SizedBox(height: Get.height * .0075),
  //             Center(
  //                 child: Container(
  //               height: Get.height * 0.18,
  //               width: Get.height * 0.18,
  //               margin: EdgeInsets.symmetric(vertical: 10),
  //               child: SimpleTimer(
  //                 duration: Duration(seconds: 30),
  //                 controller: _timerController,
  //                 timerStyle: _timerStyle,
  //                 progressTextFormatter: (format) {
  //                   return formattedTime(timeInSecond: format.inSeconds);
  //                 },
  //                 backgroundColor: ColorUtils.kGray,
  //                 progressIndicatorColor: ColorUtils.kTint,
  //                 progressIndicatorDirection: _progressIndicatorDirection,
  //                 progressTextCountDirection: _progressTextCountDirection,
  //                 progressTextStyle: FontTextStyle.kWhite24BoldRoboto
  //                     .copyWith(fontSize: Get.height * 0.025),
  //                 strokeWidth: 15,
  //                 onStart: () {},
  //                 onEnd: () {
  //                   _timerController!.stop();
  //                 },
  //               ),
  //             )),
  //             SizedBox(
  //               height: Get.height * 0.02,
  //             ),
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 GestureDetector(
  //                   onTap: () {
  //                     log('Start Pressed');
  //                     _timerController!.start();
  //                   },
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     height: Get.height * .047,
  //                     width: Get.width * .25,
  //                     decoration: BoxDecoration(
  //                       borderRadius: BorderRadius.circular(6),
  //                       gradient: LinearGradient(
  //                         begin: Alignment.topCenter,
  //                         end: Alignment.bottomCenter,
  //                         stops: [0.0, 1.0],
  //                         colors: ColorUtilsGradient.kTintGradient,
  //                       ),
  //                     ),
  //                     child: Text(
  //                       'Start',
  //                       style: FontTextStyle.kBlack18w600Roboto.copyWith(
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: Get.height * 0.02),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(width: Get.width * 0.05),
  //                 GestureDetector(
  //                   onTap: () {
  //                     log('Reset pressed ');
  //
  //                     _timerController!.reset();
  //                   },
  //                   child: Container(
  //                     alignment: Alignment.center,
  //                     height: Get.height * .047,
  //                     width: Get.width * .25,
  //                     decoration: BoxDecoration(
  //                         borderRadius: BorderRadius.circular(6),
  //                         border:
  //                             Border.all(color: ColorUtils.kTint, width: 1.5)),
  //                     child: Text(
  //                       'Reset',
  //                       style: FontTextStyle.kTine17BoldRoboto,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Divider(height: Get.height * .06, color: ColorUtils.kLightGray)
  //           ],
  //         );
  //       } else if (response.data![0].exerciseType == "WEIGHTED") {
  //         return CounterCard(
  //           counter: 5,
  //         );
  //       }
  //     }
  //     return SizedBox();
  //     // });
  //
  //     // return exeName[index] != "Foam Roll Chest"
  //     //     ?
  //     // Column(
  //     //         crossAxisAlignment: CrossAxisAlignment.start,
  //     //         children: [
  //     //           Row(
  //     //             children: [
  //     //               Text('${exeName[index]}',
  //     //                   style: FontTextStyle
  //     //                       .kWhite24BoldRoboto
  //     //                       .copyWith(
  //     //                     fontSize: Get.height * .026,
  //     //                   )),
  //     //               SizedBox(width: Get.width * .03),
  //     //               GestureDetector(
  //     //                 onTap: () {},
  //     //                 child: Image.asset(
  //     //                   AppIcons.play,
  //     //                   height: Get.height * 0.03,
  //     //                   width: Get.height * 0.03,
  //     //                   color: ColorUtils.kTint,
  //     //                 ),
  //     //               ),
  //     //             ],
  //     //           ),
  //     //           SizedBox(height: Get.height * .005),
  //     //           Text(
  //     //             '10 reps',
  //     //             style: FontTextStyle.kLightGray18W300Roboto,
  //     //           ),
  //     //           SizedBox(height: Get.height * .0075),
  //     //           CounterCard(counter: counter),
  //     //           Divider(
  //     //               height: Get.height * .06,
  //     //               color: ColorUtils.kLightGray)
  //     //         ],
  //     //       )
  //     //     : Column(
  //     //         crossAxisAlignment: CrossAxisAlignment.start,
  //     //         children: [
  //     //           Row(
  //     //             children: [
  //     //               Text('${exeName[index]}',
  //     //                   style: FontTextStyle
  //     //                       .kWhite24BoldRoboto
  //     //                       .copyWith(
  //     //                     fontSize: Get.height * .026,
  //     //                   )),
  //     //               SizedBox(width: Get.width * .03),
  //     //               GestureDetector(
  //     //                 onTap: () {},
  //     //                 child: Image.asset(
  //     //                   AppIcons.play,
  //     //                   height: Get.height * 0.03,
  //     //                   width: Get.height * 0.03,
  //     //                   color: ColorUtils.kTint,
  //     //                 ),
  //     //               ),
  //     //             ],
  //     //           ),
  //     //           SizedBox(height: Get.height * .005),
  //     //           Text(
  //     //             '30 seconds each side',
  //     //             style: FontTextStyle.kLightGray18W300Roboto,
  //     //           ),
  //     //           SizedBox(height: Get.height * .0075),
  //     //           Center(
  //     //               child: Container(
  //     //             height: Get.height * 0.18,
  //     //             width: Get.height * 0.18,
  //     //             margin: EdgeInsets.symmetric(vertical: 10),
  //     //             child: SimpleTimer(
  //     //               duration: Duration(seconds: 30),
  //     //               controller: _timerController,
  //     //               timerStyle: _timerStyle,
  //     //               progressTextFormatter: (format) {
  //     //                 return formattedTime(
  //     //                     timeInSecond: format.inSeconds);
  //     //               },
  //     //               backgroundColor: ColorUtils.kGray,
  //     //               progressIndicatorColor: ColorUtils.kTint,
  //     //               progressIndicatorDirection:
  //     //                   _progressIndicatorDirection,
  //     //               progressTextCountDirection:
  //     //                   _progressTextCountDirection,
  //     //               progressTextStyle: FontTextStyle
  //     //                   .kWhite24BoldRoboto
  //     //                   .copyWith(
  //     //                       fontSize: Get.height * 0.025),
  //     //               strokeWidth: 15,
  //     //               onStart: () {},
  //     //               onEnd: () {
  //     //                 _timerController!.stop();
  //     //               },
  //     //             ),
  //     //           )),
  //     //           SizedBox(
  //     //             height: Get.height * 0.02,
  //     //           ),
  //     //           Row(
  //     //             mainAxisAlignment: MainAxisAlignment.center,
  //     //             children: [
  //     //               GestureDetector(
  //     //                 onTap: () {
  //     //                   log('Start Pressed');
  //     //                   _timerController!.start();
  //     //                 },
  //     //                 child: Container(
  //     //                   alignment: Alignment.center,
  //     //                   height: Get.height * .047,
  //     //                   width: Get.width * .25,
  //     //                   decoration: BoxDecoration(
  //     //                     borderRadius:
  //     //                         BorderRadius.circular(6),
  //     //                     gradient: LinearGradient(
  //     //                       begin: Alignment.topCenter,
  //     //                       end: Alignment.bottomCenter,
  //     //                       stops: [0.0, 1.0],
  //     //                       colors: ColorUtilsGradient
  //     //                           .kTintGradient,
  //     //                     ),
  //     //                   ),
  //     //                   child: Text(
  //     //                     'Start',
  //     //                     style: FontTextStyle
  //     //                         .kBlack18w600Roboto
  //     //                         .copyWith(
  //     //                             fontWeight: FontWeight.bold,
  //     //                             fontSize:
  //     //                                 Get.height * 0.02),
  //     //                   ),
  //     //                 ),
  //     //               ),
  //     //               SizedBox(width: Get.width * 0.05),
  //     //               GestureDetector(
  //     //                 onTap: () {
  //     //                   log('Reset pressed ');
  //     //
  //     //                   _timerController!.reset();
  //     //                 },
  //     //                 child: Container(
  //     //                   alignment: Alignment.center,
  //     //                   height: Get.height * .047,
  //     //                   width: Get.width * .25,
  //     //                   decoration: BoxDecoration(
  //     //                       borderRadius:
  //     //                           BorderRadius.circular(6),
  //     //                       border: Border.all(
  //     //                           color: ColorUtils.kTint,
  //     //                           width: 1.5)),
  //     //                   child: Text(
  //     //                     'Reset',
  //     //                     style:
  //     //                         FontTextStyle.kTine17BoldRoboto,
  //     //                   ),
  //     //                 ),
  //     //               ),
  //     //             ],
  //     //           ),
  //     //           Divider(
  //     //               height: Get.height * .06,
  //     //               color: ColorUtils.kLightGray)
  //     //         ],
  //   });
  // }
}
// ignore: must_be_immutable
// class CounterCard extends StatefulWidget {
//   int counter;
//
//   CounterCard({Key? key, required this.counter}) : super(key: key);
//
//   @override
//   State<CounterCard> createState() => _CounterCardState();
// }
//
// class _CounterCardState extends State<CounterCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
//       child: Stack(
//         alignment: Alignment.topRight,
//         children: [
//           Container(
//             height: Get.height * .1,
//             width: Get.width,
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     colors: ColorUtilsGradient.kGrayGradient,
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter),
//                 borderRadius: BorderRadius.circular(6)),
//             child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     if (widget.counter > 0) widget.counter--;
//                   });
//                   log('minus ${widget.counter}');
//                 },
//                 child: CircleAvatar(
//                   radius: Get.height * .025,
//                   backgroundColor: ColorUtils.kTint,
//                   child: Icon(Icons.remove, color: ColorUtils.kBlack),
//                 ),
//               ),
//               SizedBox(width: Get.width * .08),
//               RichText(
//                   text: TextSpan(
//                       text: '${widget.counter} ',
//                       style: widget.counter == 0
//                           ? FontTextStyle.kWhite24BoldRoboto
//                               .copyWith(color: ColorUtils.kGray)
//                           : FontTextStyle.kWhite24BoldRoboto,
//                       children: [
//                     TextSpan(
//                         text: 'reps', style: FontTextStyle.kWhite17W400Roboto)
//                   ])),
//               SizedBox(width: Get.width * .08),
//               InkWell(
//                 onTap: () {
//                   setState(() {
//                     widget.counter++;
//                   });
//                   log('plus ${widget.counter}');
//                 },
//                 child: CircleAvatar(
//                   radius: Get.height * .025,
//                   backgroundColor: ColorUtils.kTint,
//                   child: Icon(Icons.add, color: ColorUtils.kBlack),
//                 ),
//               ),
//               VerticalDivider(
//                 width: Get.width * .08,
//                 thickness: 1.25,
//                 color: ColorUtils.kBlack,
//                 indent: Get.height * .015,
//                 endIndent: Get.height * .015,
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 10),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 40,
//                         child: TextField(
//                           style: widget.counter == 0
//                               ? FontTextStyle.kWhite24BoldRoboto
//                                   .copyWith(color: ColorUtils.kGray)
//                               : FontTextStyle.kWhite24BoldRoboto,
//                           keyboardType: TextInputType.number,
//                           maxLength: 3,
//                           cursorColor: ColorUtils.kTint,
//                           decoration: InputDecoration(
//                               hintText: '0',
//                               counterText: '',
//                               semanticCounterText: '',
//                               hintStyle: FontTextStyle.kWhite24BoldRoboto
//                                   .copyWith(color: ColorUtils.kGray),
//                               enabledBorder: UnderlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.transparent)),
//                               focusedBorder: UnderlineInputBorder(
//                                   borderSide:
//                                       BorderSide(color: Colors.transparent))),
//                         ),
//                       ),
//                       Text('lbs', style: FontTextStyle.kWhite17W400Roboto),
//                     ],
//                   ),
//                   SizedBox(),
//                 ],
//               ),
//             ]),
//           ),
//           Container(
//             alignment: Alignment.center,
//             height: Get.height * .027,
//             width: Get.height * .09,
//             decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                     colors: ColorUtilsGradient.kGreenGradient,
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter),
//                 borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(6),
//                     bottomLeft: Radius.circular(6))),
//             child: Text('RIR 0-1',
//                 style: FontTextStyle.kWhite12BoldRoboto
//                     .copyWith(fontWeight: FontWeight.w500)),
//           ),
//         ],
//       ),
//     );
//   }
// }
