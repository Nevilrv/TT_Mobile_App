import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/training_plan_request_model/save_user_customized_exercise_request_model.dart';
import 'package:tcm/model/request_model/update_status_user_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/update_status_user_program_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/New/widget_type/reps_type.dart';
import 'package:tcm/screen/New/widget_type/super_set.dart';
import 'package:tcm/screen/New/widget_type/time_type.dart';
import 'package:tcm/screen/New/widget_type/weighted_type.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/save_user_customized_exercise_viewModel.dart';
import 'package:tcm/viewModel/update_status_user_program_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/workout_base_exercise_viewModel.dart';

import 'widget_type/share_progress.dart';

class NewNoWeightExercise extends StatefulWidget {
  final List exerciseList;
  final String userProgramDatesId;
  final List superSetList;
  final int superSetRound;
  const NewNoWeightExercise({
    Key? key,
    required this.exerciseList,
    required this.superSetList,
    required this.superSetRound,
    required this.userProgramDatesId,
  }) : super(key: key);

  @override
  _NewNoWeightExerciseState createState() => _NewNoWeightExerciseState();
}

class _NewNoWeightExerciseState extends State<NewNoWeightExercise> {
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  WorkoutBaseExerciseViewModel _workoutBaseExerciseViewModel =
      Get.put(WorkoutBaseExerciseViewModel());
  UpdateStatusUserProgramViewModel _updateStatusUserProgramViewModel =
      Get.put(UpdateStatusUserProgramViewModel());
  SaveUserCustomizedExerciseViewModel _saveUserCustomizedExerciseViewModel =
      Get.put(SaveUserCustomizedExerciseViewModel());
  int lastBackIndex = 0;
  bool isLastBackCheck = false;

  dataFetchById({required String id}) async {
    print('id idiiiidididi $id');
    if (_workoutBaseExerciseViewModel.currentIndex <
        widget.exerciseList.length) {
      _workoutBaseExerciseViewModel.setIsButtonShow(isShow: false);
      await _exerciseByIdViewModel.getExerciseByIdDetails(id: id);
      if (_exerciseByIdViewModel.apiResponse.status == Status.COMPLETE) {
        ExerciseByIdResponseModel exerciseByIdResponse =
            _exerciseByIdViewModel.apiResponse.data;
        _workoutBaseExerciseViewModel.setIsButtonShow(isShow: true);
        _workoutBaseExerciseViewModel.exerciseType =
            "${exerciseByIdResponse.data![0].exerciseType}";

        try {
          _workoutBaseExerciseViewModel.userSaveExeId =
              "${exerciseByIdResponse.data![0].userExercise!.id}";
          print(
              'exerciseByIdResponse.data![0].userExercise!.id ============> ${"${exerciseByIdResponse.data![0].userExercise!.id!}"}');
        } catch (e) {
          _workoutBaseExerciseViewModel.userSaveExeId = "";
        }

        if (exerciseByIdResponse.data![0].exerciseType == "REPS") {
          _workoutBaseExerciseViewModel
              .updateAppBarTitle(exerciseByIdResponse.data![0].exerciseTitle!);
          String? repsById;
          try {
            repsById = exerciseByIdResponse.data![0].userExercise!.repsData;
          } catch (e) {
            repsById = '';
          }
          _workoutBaseExerciseViewModel.setWidgetOfIndex(
              value: repsType(
                  controller: _workoutBaseExerciseViewModel,
                  title: exerciseByIdResponse.data![0].exerciseTitle!,
                  sets: exerciseByIdResponse.data![0].exerciseSets!,
                  exercisesId: exerciseByIdResponse.data![0].exerciseId!,
                  reps: exerciseByIdResponse.data![0].exerciseReps!,
                  repsData: repsById,
                  exerciseColor: exerciseByIdResponse.data![0].exerciseColor!));
        } else if (exerciseByIdResponse.data![0].exerciseType == "TIME") {
          _workoutBaseExerciseViewModel
              .updateAppBarTitle(exerciseByIdResponse.data![0].exerciseTitle!);
          _workoutBaseExerciseViewModel.setWidgetOfIndex(
              value: TimeType(
                  title: exerciseByIdResponse.data![0].exerciseTitle!,
                  exerciseId: exerciseByIdResponse.data![0].exerciseId!,
                  exerciseTime: exerciseByIdResponse.data![0].exerciseTime!,
                  exerciseSets: exerciseByIdResponse.data![0].exerciseSets!));
        } else if (exerciseByIdResponse.data![0].exerciseType == "WEIGHTED") {
          _workoutBaseExerciseViewModel
              .updateAppBarTitle(exerciseByIdResponse.data![0].exerciseTitle!);

          String? repsById;
          String? weightById;
          try {
            repsById = exerciseByIdResponse.data![0].userExercise!.repsData;
            weightById = exerciseByIdResponse.data![0].userExercise!.weightData;
          } catch (e) {
            repsById = '';
            weightById = '';
          }

          _workoutBaseExerciseViewModel.setWidgetOfIndex(
              value: WeightedType(
                  exerciseSets: exerciseByIdResponse.data![0].exerciseSets!,
                  exerciseId: exerciseByIdResponse.data![0].exerciseId!,
                  exerciseTitle: exerciseByIdResponse.data![0].exerciseTitle!,
                  exerciseReps:
                      exerciseByIdResponse.data![0].exerciseReps!.isEmpty ||
                              exerciseByIdResponse.data![0].exerciseReps == ""
                          ? "5"
                          : exerciseByIdResponse.data![0].exerciseReps!,
                  repsData: repsById,
                  weightData: weightById,
                  exerciseRest: exerciseByIdResponse.data![0].exerciseRest!,
                  exerciseWeight: exerciseByIdResponse.data![0].exerciseWeight!,
                  exerciseColor: exerciseByIdResponse.data![0].exerciseColor!));
        }
      }
    } else {
      if (widget.superSetList.length != 0) {
        print(
            'widgetOfIndex >>>${_workoutBaseExerciseViewModel.widgetOfIndex}');
        _workoutBaseExerciseViewModel.roundCount++;
        if (_workoutBaseExerciseViewModel.allIdList.length >
            _workoutBaseExerciseViewModel.currentIndex) {
          if (_workoutBaseExerciseViewModel.currentIndex -
                  widget.exerciseList.length !=
              widget.superSetRound) {
            _workoutBaseExerciseViewModel.exerciseType = "Super Set";
            _workoutBaseExerciseViewModel.updateAppBarTitle("Super Set");
            print('Round count  =====a ${widget.superSetRound}');
            print('roundCount >>> ${_workoutBaseExerciseViewModel.roundCount}');
            print('all id >>> ${_workoutBaseExerciseViewModel.allIdList}');
            _workoutBaseExerciseViewModel.setWidgetOfIndex(
                value: SuperSetExercise(
              superSetRound: widget.superSetRound,
              superSetIdList: widget.superSetList,
              roundCount: _workoutBaseExerciseViewModel.roundCount,
              superSetExercisesList: _workoutBaseExerciseViewModel
                  .allIdList[_workoutBaseExerciseViewModel.currentIndex],
            ));
          } else {
            _workoutBaseExerciseViewModel.updateAppBarTitle("TRAINING SESSION");
            _workoutBaseExerciseViewModel.setWidgetOfIndex(
                value: NewShareProgressScreen(
              workoutId: widget.userProgramDatesId,
            ));
          }
        } else {
          _workoutBaseExerciseViewModel.updateAppBarTitle("TRAINING SESSION");

          _workoutBaseExerciseViewModel.setWidgetOfIndex(
              value: NewShareProgressScreen(
            workoutId: widget.userProgramDatesId,
          ));
          print(
              'widgetOfIndexWidgetOfIndex  ${_workoutBaseExerciseViewModel.widgetOfIndex}');
          print(
              'widgetOfIndexWidgetOfIndex  ${_workoutBaseExerciseViewModel.widgetOfIndex.length}');
          print('${_workoutBaseExerciseViewModel.currentIndex}');
        }
      } else {
        _workoutBaseExerciseViewModel.updateAppBarTitle("");
        _workoutBaseExerciseViewModel.setWidgetOfIndex(
            value: NewShareProgressScreen(
          workoutId: widget.userProgramDatesId,
        ));
      }
    }
  }

  getSuperSetList() {
    try {
      print('super set round *---  ${widget.superSetRound}');
      for (int i = 0; i < widget.superSetRound; i++) {
        print(
            'widget.superSetRound =================== > ${widget.superSetList}');
        _workoutBaseExerciseViewModel.allIdList.add(widget.superSetList);
      }
      print('all id list ???? ${_workoutBaseExerciseViewModel.allIdList}');
    } catch (e) {}
  }

  @override
  void initState() {
    print('supersetttt ${widget.superSetList}');
    print('supersetttt round    ${widget.superSetRound}');
    print('>>>> InItState call exerciseList   ${widget.exerciseList}');
    _workoutBaseExerciseViewModel.isButtonShow = false;
    _workoutBaseExerciseViewModel.weightedEnter = false;

    _workoutBaseExerciseViewModel.allIdList.clear();
    print('superSetegswdegstList >>> ${widget.superSetList}');
    widget.exerciseList.forEach((element) {
      _workoutBaseExerciseViewModel.allIdList.add(element);
    });
    print('alll id list 9999 ${_workoutBaseExerciseViewModel.allIdList}');
    print('runtimeType --- ${widget.superSetRound}');
    if (widget.superSetList != [] && widget.superSetList.isNotEmpty) {
      getSuperSetList();
    }
    print('Alll id List >>>>>  ${_workoutBaseExerciseViewModel.allIdList}');

    _workoutBaseExerciseViewModel.appBarTitle.clear();
    dataFetchById(id: _workoutBaseExerciseViewModel.allIdList[0]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkoutBaseExerciseViewModel>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          bottomNavigationBar: controller.isButtonShow
              ? controller.allIdList.length == controller.currentIndex
                  ? SizedBox()
                  : Padding(
                      padding: EdgeInsets.only(
                          bottom: 40,
                          left: Get.width * 0.05,
                          right: Get.width * 0.05),
                      child: SizedBox(
                          child: commonNavigationButton(
                              onTap: () async {
                                _workoutBaseExerciseViewModel.resTimerCancel();

                                if (_workoutBaseExerciseViewModel
                                            .exerciseType ==
                                        "REPS" ||
                                    _workoutBaseExerciseViewModel
                                            .exerciseType ==
                                        "WEIGHTED") {
                                  SaveUserCustomizedExerciseRequestModel _req =
                                      SaveUserCustomizedExerciseRequestModel();

                                  _req.id = _workoutBaseExerciseViewModel
                                              .userSaveExeId ==
                                          ""
                                      ? ""
                                      : _workoutBaseExerciseViewModel
                                          .userSaveExeId;

                                  _req.exerciseId = widget.exerciseList[
                                      _workoutBaseExerciseViewModel
                                          .currentIndex];
                                  _req.userId = PreferenceManager.getUId();
                                  _req.exerciseType =
                                      _workoutBaseExerciseViewModel
                                                  .exerciseType ==
                                              "WEIGHTED"
                                          ? "weight"
                                          : "reps";
                                  print(
                                      'list of weight >>>> ${_workoutBaseExerciseViewModel.weightedRepsList}');
                                  _req.repsData = _workoutBaseExerciseViewModel
                                              .exerciseType ==
                                          "WEIGHTED"
                                      ? "${_workoutBaseExerciseViewModel.weightedRepsList}"
                                      : "${_workoutBaseExerciseViewModel.repsList}";

                                  _req.weightData =
                                      _workoutBaseExerciseViewModel
                                                  .exerciseType ==
                                              "WEIGHTED"
                                          ? "${controller.lbsList}"
                                          : "";

                                  _saveUserCustomizedExerciseViewModel
                                      .saveUserCustomizedExerciseViewModel(
                                          _req);

                                  // if (_saveUserCustomizedExerciseViewModel
                                  //         .apiResponse.status ==
                                  //     Status.COMPLETE) {
                                  //   SaveUserCustomizedExerciseResponseModel
                                  //       resp =
                                  //       SaveUserCustomizedExerciseResponseModel();
                                  // }
                                }

                                if (lastBackIndex <
                                        _workoutBaseExerciseViewModel
                                            .currentIndex ||
                                    isLastBackCheck == false) {
                                  isLastBackCheck = false;
                                  if (_workoutBaseExerciseViewModel
                                          .currentIndex <
                                      widget.exerciseList.length) {
                                    _workoutBaseExerciseViewModel
                                        .currentIndex++;
                                  } else {
                                    if (widget.superSetList.length != 0) {
                                      if (_workoutBaseExerciseViewModel
                                                  .currentIndex -
                                              widget.exerciseList.length !=
                                          widget.superSetRound) {
                                        print(
                                            'currentindex >>> ${_workoutBaseExerciseViewModel.currentIndex}');
                                        _workoutBaseExerciseViewModel
                                            .currentIndex++;
                                        try {
                                          _workoutBaseExerciseViewModel
                                              .superSetDataCountList
                                              .clear();
                                          _workoutBaseExerciseViewModel
                                              .cancelTimer();

                                          /*_workoutBaseExerciseViewModel
                                              .resTimer!
                                              .cancel();
                                          _workoutBaseExerciseViewModel
                                              .showTimer = null;
                                          _workoutBaseExerciseViewModel
                                              .currentValue = 0;*/
                                          _workoutBaseExerciseViewModel
                                              .staticTimer = false;
                                          _workoutBaseExerciseViewModel
                                              .superSetCurrentValue = null;
                                          _workoutBaseExerciseViewModel
                                              .isClickForSuperSet = false;
                                        } catch (e) {
                                          _workoutBaseExerciseViewModel
                                              .currentIndex++;
                                        }
                                      } else {
                                        _workoutBaseExerciseViewModel
                                            .currentIndex++;
                                      }
                                    } else {
                                      _workoutBaseExerciseViewModel
                                          .currentIndex++;
                                    }
                                  }

                                  dataFetchById(
                                      id: _workoutBaseExerciseViewModel
                                                  .currentIndex <
                                              widget.exerciseList.length
                                          ? widget.exerciseList[
                                              _workoutBaseExerciseViewModel
                                                  .currentIndex]
                                          : '');
                                  if (controller.allIdList.length ==
                                      controller.currentIndex) {
                                    UpdateStatusUserProgramRequestModel
                                        _request =
                                        UpdateStatusUserProgramRequestModel();

                                    _request.userProgramDatesId =
                                        widget.userProgramDatesId;

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
                                        print('message === ${response.msg}');
                                        Get.showSnackbar(GetSnackBar(
                                          message: '${response.msg}',
                                          duration:
                                              Duration(milliseconds: 1500),
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
                                  }
                                } else {
                                  _workoutBaseExerciseViewModel.currentIndex++;
                                }
                              },
                              name: controller.allIdList.length - 1 ==
                                      controller.currentIndex
                                  ? "Save Exercise"
                                  : "Next Exercise")),
                    )
              : SizedBox(),
          body: viewBody(controller),
        );
      },
    );
  }

  Widget viewBody(WorkoutBaseExerciseViewModel controller) {
    try {
      return Column(
        children: [
          appBarExercises(
              title:
                  "${_workoutBaseExerciseViewModel.appBarTitle[_workoutBaseExerciseViewModel.currentIndex]}",
              backTap: () {
                _workoutBaseExerciseViewModel.resTimerCancel();

                if (isLastBackCheck == false &&
                    lastBackIndex <
                        _workoutBaseExerciseViewModel.currentIndex) {
                  isLastBackCheck = true;
                  if (_workoutBaseExerciseViewModel.currentIndex != 0) {
                    _workoutBaseExerciseViewModel.currentIndex--;
                    lastBackIndex = _workoutBaseExerciseViewModel.currentIndex;
                  } else {
                    Get.back();
                  }
                } else {
                  _workoutBaseExerciseViewModel.cancelTimer();
                  /*_workoutBaseExerciseViewModel.resTimer!.cancel();
                  _workoutBaseExerciseViewModel.showTimer = null;
                  _workoutBaseExerciseViewModel.currentValue = 0;*/
                  if (_workoutBaseExerciseViewModel.currentIndex != 0) {
                    _workoutBaseExerciseViewModel.currentIndex--;
                  } else {
                    Get.back();
                  }
                }
              }),
          Expanded(
              child: controller
                  .widgetOfIndex[_workoutBaseExerciseViewModel.currentIndex])
        ],
      );
    } catch (e) {
      return Center(
          child: CircularProgressIndicator(
        color: ColorUtils.kTint,
      ));
    }
  }
}

AppBar appBarExercises(
    {required String title, required GestureTapCallback backTap}) {
  return AppBar(
    elevation: 0,
    leading: IconButton(
        onPressed: backTap,
        icon: Icon(
          Icons.arrow_back_ios_sharp,
          color: ColorUtils.kTint,
        )),
    backgroundColor: ColorUtils.kBlack,
    title: Text(title, style: FontTextStyle.kWhite16BoldRoboto),
    centerTitle: true,
    actions: [
      TextButton(
          onPressed: () {
            Get.offAll(HomeScreen());
            // _userWorkoutsDateViewModel.exeIdCounter = 0;
            // _userWorkoutsDateViewModel.isHold = false;
            // _userWorkoutsDateViewModel.isFirst = false;
          },
          child: Text(
            'Quit',
            style: FontTextStyle.kTine16W400Roboto,
          ))
    ],
  );
}
