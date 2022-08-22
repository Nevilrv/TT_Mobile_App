import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/add_user_habit_id_request_model.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/custom_habit_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/add_user_habit_id_response_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/custom_habit_response_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/habit_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/habit_tracker/tracking_frequency_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/add_user_habit_id_viewModel.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/custom_habit_viewModel.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/habit_viewModel.dart';

class HabitSelectionScreen extends StatefulWidget {
  List? oldHabitsId = [];

  HabitSelectionScreen({Key? key, this.oldHabitsId}) : super(key: key);

  @override
  State<HabitSelectionScreen> createState() => _HabitSelectionScreenState();
}

class _HabitSelectionScreenState extends State<HabitSelectionScreen> {
  TextEditingController _alertDialogTextController = TextEditingController();
  HabitViewModel _habitViewModel = Get.put(HabitViewModel());
  CustomHabitViewModel _customHabitViewModel = Get.put(CustomHabitViewModel());
  // final _formKeyAddHabit = GlobalKey<FormState>();
  AddUserHabitIdViewModel _addUserHabitIdViewModel =
      Get.put(AddUserHabitIdViewModel());
  int habitIndex = 0;
  List habitId = [];
  String? idList;

  initState() {
    super.initState();
    print("uid -- ${PreferenceManager.getUId()}");
    oldId();
  }

  dispose() {
    super.dispose();
  }

  oldId() async {
    await _habitViewModel.getHabitDetail(userId: PreferenceManager.getUId());
    if (_habitViewModel.apiResponse.status == Status.LOADING) {
      Center(
        child: CircularProgressIndicator(color: ColorUtils.kTint),
      );
    }
    if (_habitViewModel.apiResponse.status == Status.COMPLETE) {
      HabitResponseModel checkResp = _habitViewModel.apiResponse.data;
      for (int i = 0; i < checkResp.data!.length; i++) {
        if (widget.oldHabitsId!.contains(checkResp.data![i].id)) {
          if (habitId.contains(checkResp.data![i].id)) {
          } else {
            habitId.add(checkResp.data![i].id);
          }
        }
      }
      // print("habit id from old id =============== $habitId");
      listOfHabitId();
    }
  }

  listOfHabitId() {
    idList = habitId.join(",");
    // print("inside ------------------ $idList");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    listOfHabitId();
    // print("habit id list 1111111 ------------------ $idList");
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorUtils.kTint,
            )),
        backgroundColor: ColorUtils.kBlack,
        title: Text('Habit Tracking', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04, vertical: Get.height * 0.025),
          child: Column(
            children: [
              SizedBox(height: Get.height * .03),
              Text(
                'CHOOSE HABIT TO TRACK',
                style: FontTextStyle.kWhite17BoldRoboto,
              ),
              Divider(
                height: Get.height * .02,
                color: ColorUtils.kTint,
                thickness: 1.5,
              ),
              SizedBox(height: Get.height * .04),
              GetBuilder<HabitViewModel>(
                builder: (controller) {
                  if (controller.apiResponse.status == Status.ERROR) {
                    return Text('Data not Found!');
                  }
                  if (controller.apiResponse.status == Status.LOADING) {
                    return Center(
                      child: CircularProgressIndicator(color: ColorUtils.kTint),
                    );
                  }
                  if (controller.apiResponse.status == Status.COMPLETE) {
                    HabitResponseModel response = controller.apiResponse.data;

                    return SizedBox(
                      child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: response.data!.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 2 / 0.52,
                                  crossAxisSpacing: Get.height * .02,
                                  mainAxisSpacing: Get.height * .025),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                if (habitId
                                    .contains('${response.data![index].id}')) {
                                  habitId.remove('${response.data![index].id}');
                                } else {
                                  habitId.add('${response.data![index].id}');
                                }

                                controller.firstSelectedHabits(
                                    id: '${response.data![index].id}');
                                listOfHabitId();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.height * .01),
                                height: Get.height * .065,
                                width: Get.width * .5,
                                decoration: habitId
                                        .contains('${response.data![index].id}')
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          stops: [0.0, 1.0],
                                          colors:
                                              ColorUtilsGradient.kTintGradient,
                                        ),
                                      )
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border:
                                            Border.all(color: ColorUtils.kTint),
                                        color: ColorUtils.kBlack),
                                child: habitId
                                        .contains('${response.data![index].id}')
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                              height: 17,
                                              width: Get.height * .01),
                                          Text(
                                            '${response.data![index].name}'
                                                        .length >
                                                    18
                                                ? '${response.data![index].name!.substring(0, 17) + '..'}'
                                                    .capitalizeFirst!
                                                : '${response.data![index].name}'
                                                    .capitalizeFirst!,
                                            style: habitId.contains(
                                                    '${response.data![index].id}')
                                                ? FontTextStyle
                                                    .kBlack10BoldRoboto
                                                : FontTextStyle
                                                    .kTint10BoldRoboto,
                                          ),
                                          CircleAvatar(
                                              radius: 9,
                                              backgroundColor: Colors.black,
                                              child: Icon(
                                                Icons.done,
                                                size: 11.5,
                                                color: ColorUtils.kTint,
                                              ))
                                        ],
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${response.data![index].name}'
                                                        .length >
                                                    24
                                                ? '${response.data![index].name!.substring(0, 23) + '..'}'
                                                    .capitalizeFirst!
                                                : '${response.data![index].name}'
                                                    .capitalizeFirst!,
                                            style: habitId.contains(
                                                    '${response.data![index].id}')
                                                ? FontTextStyle
                                                    .kBlack10BoldRoboto
                                                : FontTextStyle
                                                    .kTint10BoldRoboto,
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
              SizedBox(height: Get.height * .04),
              Center(
                child: GestureDetector(
                  onTap: () {
                    _customHabitAlertDialog();

                    setState(() {});
                    // }
                  },
                  child: Container(
                    height: Get.height * 0.065,
                    width: Get.width * 0.6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                        colors: ColorUtilsGradient.kTintGradient,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.black,
                            child: Icon(
                              Icons.add,
                              size: 12.5,
                              color: ColorUtils.kTint,
                            )),
                        SizedBox(width: Get.width * .025),
                        Text('Add Custom Habit',
                            style: FontTextStyle.kBlack22BoldRoboto
                                .copyWith(fontSize: Get.height * 0.022)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .08),
              commonNavigationButton(
                  onTap: () async {
                    if (idList!.isNotEmpty) {
                      AddUserHabitIdRequestModel _request =
                          AddUserHabitIdRequestModel();

                      _request.userId = PreferenceManager.getUId();
                      _request.habitIds = idList;

                      await _addUserHabitIdViewModel
                          .addUserHabitIdViewModel(_request);

                      if (_addUserHabitIdViewModel.apiResponse.status ==
                          Status.COMPLETE) {
                        AddUserHabitIdResponseModel res =
                            _addUserHabitIdViewModel.apiResponse.data;

                        Get.showSnackbar(GetSnackBar(
                          message: '${res.msg}',
                          duration: Duration(seconds: 2),
                        ));
                        HabitResponseModel resp =
                            _habitViewModel.apiResponse.data;
                        Get.to(TrackingFrequencyScreen(data: resp.data));
                      } else if (_addUserHabitIdViewModel.apiResponse.status ==
                          Status.ERROR) {
                        Get.showSnackbar(GetSnackBar(
                          message: 'Something went wrong!!! \nPlease try again',
                          duration: Duration(seconds: 2),
                        ));
                      }
                    } else {
                      Get.showSnackbar(GetSnackBar(
                        message: 'Please select at least one habit',
                        duration: Duration(seconds: 1),
                      ));
                    }
                  },
                  name: 'Next')
            ],
          ),
        ),
      ),
    );
  }

  _customHabitAlertDialog() {
    Get.dialog(
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          backgroundColor: ColorUtils.kBlack,
          actionsOverflowDirection: VerticalDirection.down,
          title: Column(children: [
            Text('Custom Habit', style: TextStyle(color: ColorUtils.kTint)),
            SizedBox(height: 10),
            Text(
              'Enter the name of your custom habit that you want to track',
              style: FontTextStyle.kTine16W400Roboto,
            ),
          ]),
          content: CupertinoTextField(
            placeholder: 'Habit name',
            placeholderStyle: TextStyle(color: ColorUtils.kHintTextGray),
            controller: _alertDialogTextController,
            cursorColor: ColorUtils.kTint,
            style: TextStyle(color: ColorUtils.kWhite),
            decoration: BoxDecoration(
                color: ColorUtils.kBlack,
                border: Border.all(color: ColorUtils.kTint),
                borderRadius: BorderRadius.circular(5)),
          ),
          elevation: 10,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed))
                            return ColorUtils.kTint.withOpacity(0.2);
                          return null;
                        },
                      ),
                    ),
                    child:
                        Text('Cancel', style: FontTextStyle.kTint24W400Roboto),
                    onPressed: () {
                      Get.back();
                      _alertDialogTextController.clear();
                    }),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return ColorUtils.kTint.withOpacity(0.2);
                        return null;
                      },
                    ),
                  ),
                  child: Text('Save',
                      style: FontTextStyle.kTint24W400Roboto
                          .copyWith(fontWeight: FontWeight.bold)),
                  onPressed: () async {
                    Get.back();
                    setState(() {});
                    if (_alertDialogTextController.text.isNotEmpty) {
                      CustomHabitRequestModel _request =
                          CustomHabitRequestModel();
                      _request.name = _alertDialogTextController.text.trim();
                      _request.userId = PreferenceManager.getUId();

                      await _customHabitViewModel
                          .customHabitViewModel(_request);

                      if (_customHabitViewModel.apiResponse.status ==
                          Status.COMPLETE) {
                        CustomHabitResponseModel res =
                            _customHabitViewModel.apiResponse.data;

                        Get.showSnackbar(GetSnackBar(
                          message: '${res.msg}',
                          duration: Duration(seconds: 2),
                        ));
                        print(
                            "_customHabitViewModel.apiResponse.message  ${res.msg}");
                        _habitViewModel.getHabitDetail(
                            userId: PreferenceManager.getUId());
                        _alertDialogTextController.clear();
                        setState(() {});
                      } else if (_customHabitViewModel.apiResponse.status ==
                          Status.ERROR) {
                        Get.showSnackbar(GetSnackBar(
                          message: 'Something went wrong!!! \nPlease try again',
                          duration: Duration(seconds: 2),
                        ));
                      }
                    } else {
                      Get.showSnackbar(GetSnackBar(
                        message: 'Please Enter Habit Name',
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        barrierColor: ColorUtils.kBlack.withOpacity(0.6));
  }
}
