import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/update_status_user_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/update_status_user_program_response_model.dart';
import 'package:tcm/screen/New/widget_type/reps_type.dart';
import 'package:tcm/screen/New/widget_type/super_set.dart';
import 'package:tcm/screen/New/widget_type/time_type.dart';
import 'package:tcm/screen/New/widget_type/weighted_type.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
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
  int lastBackIndex = 0;
  bool isLastBackCheck = false;
  dataFetchById({required String id}) async {
    if (_workoutBaseExerciseViewModel.currentIndex <
        widget.exerciseList.length) {
      _workoutBaseExerciseViewModel.setIsButtonShow(isShow: false);
      print('if');
      await _exerciseByIdViewModel.getExerciseByIdDetails(id: id);
      if (_exerciseByIdViewModel.apiResponse.status == Status.COMPLETE) {
        ExerciseByIdResponseModel exerciseByIdResponse =
            _exerciseByIdViewModel.apiResponse.data;
        _workoutBaseExerciseViewModel.setIsButtonShow(isShow: true);

        if (exerciseByIdResponse.data![0].exerciseType == "REPS") {
          _workoutBaseExerciseViewModel
              .updateAppBarTitle(exerciseByIdResponse.data![0].exerciseTitle!);
          _workoutBaseExerciseViewModel.setWidgetOfIndex(
              value: repsType(
                  controller: _workoutBaseExerciseViewModel,
                  title: exerciseByIdResponse.data![0].exerciseTitle!,
                  sets: exerciseByIdResponse.data![0].exerciseSets!,
                  exercisesId: exerciseByIdResponse.data![0].exerciseId!,
                  reps: exerciseByIdResponse.data![0].exerciseReps!));
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

          _workoutBaseExerciseViewModel.setWidgetOfIndex(
              value: WeightedType(
                  exerciseSets: exerciseByIdResponse.data![0].exerciseSets!,
                  exerciseId: exerciseByIdResponse.data![0].exerciseId!,
                  exerciseTitle: exerciseByIdResponse.data![0].exerciseTitle!,
                  exerciseReps: exerciseByIdResponse.data![0].exerciseReps!,
                  exerciseRest: exerciseByIdResponse.data![0].exerciseRest!,
                  exerciseWeight: exerciseByIdResponse.data![0].exerciseWeight!,
                  exerciseColor: exerciseByIdResponse.data![0].exerciseColor!));
        }
      }
    } else {
      print('else');
      if (widget.superSetList.length != 0) {
        print(' sout 1');
        _workoutBaseExerciseViewModel.roundCount++;
        if (_workoutBaseExerciseViewModel.allIdList.length >
            _workoutBaseExerciseViewModel.currentIndex) {
          print('sout 2');
          if (_workoutBaseExerciseViewModel.currentIndex -
                  widget.exerciseList.length !=
              widget.superSetRound) {
            print('sout 3');

            print('Superset called');
            _workoutBaseExerciseViewModel.updateAppBarTitle("Super Set");
            print('Round count  =====a ${widget.superSetRound}');
            _workoutBaseExerciseViewModel.setWidgetOfIndex(
                value: SuperSetExercise(
              superSetRound: widget.superSetRound,
              superSetIdList: widget.superSetList,
              roundCount: _workoutBaseExerciseViewModel.roundCount,
              superSetExercisesList: _workoutBaseExerciseViewModel
                  .allIdList[_workoutBaseExerciseViewModel.currentIndex],
            ));
          } else {
            print(' sout 4');
            _workoutBaseExerciseViewModel.updateAppBarTitle("TRAINING SESSION");
            _workoutBaseExerciseViewModel.setWidgetOfIndex(
                value: NewShareProgressScreen(
              workoutId: widget.userProgramDatesId,
            ));
          }
        } else {
          print('sout 5${widget.userProgramDatesId}');
          _workoutBaseExerciseViewModel.updateAppBarTitle("TRAINING SESSION");

          _workoutBaseExerciseViewModel.setWidgetOfIndex(
              value: NewShareProgressScreen(
            workoutId: widget.userProgramDatesId,
          ));
          print(
              'widgetOfIndexwidgetOfIndex  ${_workoutBaseExerciseViewModel.widgetOfIndex}');
          print(
              'widgetOfIndexwidgetOfIndex  ${_workoutBaseExerciseViewModel.widgetOfIndex.length}');
          print('${_workoutBaseExerciseViewModel.currentIndex}');
        }
      } else {
        print('sout 6');
        _workoutBaseExerciseViewModel.updateAppBarTitle("TRAINING SESSION");

        _workoutBaseExerciseViewModel.setWidgetOfIndex(
            value: NewShareProgressScreen(
          workoutId: widget.userProgramDatesId,
        ));
      }
    }
  }

  getSuperSetList() {
    try {
      for (int i = 0; i < widget.superSetRound; i++) {
        _workoutBaseExerciseViewModel.allIdList.add(widget.superSetList);
      }
    } catch (e) {}
  }

  @override
  void initState() {
    print('supersetttt ${widget.superSetList}');
    print('supersetttt round    ${widget.superSetRound}');

    print('InItState call');
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
    print('Enter in new no weight screen');
    return GetBuilder<WorkoutBaseExerciseViewModel>(
      builder: (controller) {
        print('widgetOfIndex tttt ${controller.widgetOfIndex}');

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
                                if (lastBackIndex <
                                        _workoutBaseExerciseViewModel
                                            .currentIndex ||
                                    isLastBackCheck == false) {
                                  print('treeee');
                                  isLastBackCheck = false;
                                  if (_workoutBaseExerciseViewModel
                                          .currentIndex <
                                      widget.exerciseList.length) {
                                    print('print 1');
                                    _workoutBaseExerciseViewModel
                                        .currentIndex++;
                                  } else {
                                    if (widget.superSetList.length != 0) {
                                      print('print 2');

                                      if (_workoutBaseExerciseViewModel
                                                  .currentIndex -
                                              widget.exerciseList.length !=
                                          widget.superSetRound) {
                                        print('print 3');
                                        _workoutBaseExerciseViewModel
                                            .currentIndex++;
                                        try {
                                          print(
                                              'superSetDataCountList >>  ${_workoutBaseExerciseViewModel.superSetDataCountList}');
                                          _workoutBaseExerciseViewModel
                                              .superSetDataCountList
                                              .clear();
                                          _workoutBaseExerciseViewModel
                                              .currentValue = 0;
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

                                        print('print 4');
                                      }
                                    } else {
                                      _workoutBaseExerciseViewModel
                                          .currentIndex++;

                                      print('print 5');

                                      print('Over');
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
                                    print('Save    l.ll;l;');
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
                if (isLastBackCheck == false &&
                    lastBackIndex <
                        _workoutBaseExerciseViewModel.currentIndex) {
                  isLastBackCheck = true;
                  if (_workoutBaseExerciseViewModel.currentIndex != 0) {
                    _workoutBaseExerciseViewModel.currentIndex--;
                    lastBackIndex = _workoutBaseExerciseViewModel.currentIndex;
                    print('lastBackIndex ˘>> $lastBackIndex');
                  } else {
                    Get.back();
                    print('Back');
                  }
                } else {
                  if (_workoutBaseExerciseViewModel.currentIndex != 0) {
                    _workoutBaseExerciseViewModel.currentIndex--;
                  } else {
                    Get.back();
                    print('Back else');
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
