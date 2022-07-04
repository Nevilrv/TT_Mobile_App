import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/custom_habit_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/custom_habit_response_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/habit_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/habit_tracker/tracking_frequency_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/custom_habit_viewModel.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/habit_viewModel.dart';

class HabitSelectionScreen extends StatefulWidget {
  @override
  State<HabitSelectionScreen> createState() => _HabitSelectionScreenState();
}

class _HabitSelectionScreenState extends State<HabitSelectionScreen> {
  TextEditingController _alertDialogTextController = TextEditingController();
  HabitViewModel _habitViewModel = Get.put(HabitViewModel());
  CustomHabitViewModel _customHabitViewModel = Get.put(CustomHabitViewModel());
  // final _formKeyAddHabit = GlobalKey<FormState>();

  initState() {
    super.initState();
    print("uid -- ${PreferenceManager.getUId()}");
    _habitViewModel.getHabitDetail(userId: PreferenceManager.getUId());
  }

  dispose() {
    super.dispose();
  }

  int habitIndex = 0;

  @override
  Widget build(BuildContext context) {
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
              horizontal: Get.width * 0.06, vertical: Get.height * 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _habitViewModel.isAlertOpen == true
                  ? Text(AppText.paragraph,
                      style: FontTextStyle.kWhite17BoldRoboto, maxLines: 4)
                  : SizedBox(),
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
                                  childAspectRatio: 2 / 0.55,
                                  crossAxisSpacing: Get.height * .04,
                                  mainAxisSpacing: Get.height * .025),
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.selectedHabits(
                                    habits: '${response.data![index].name}',
                                    id: '${response.data![index].id}');
                                log('${response.data![index].name}');
                                log('${controller.selectedHabitList}');
                                print(
                                    '----------========= ${response.data![index].id}');
                                // setState(() {});
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: Get.height * 0.065,
                                width: Get.width * 0.45,
                                decoration: controller.selectedHabitList
                                        .contains(
                                            '${response.data![index].name}')
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Get.height * .05),
                                        gradient: LinearGradient(
                                            colors: ColorUtilsGradient
                                                .kTintGradient,
                                            begin: Alignment.center,
                                            end: Alignment.center))
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Get.height * .05),
                                        border:
                                            Border.all(color: ColorUtils.kTint),
                                        color: ColorUtils.kBlack),
                                child: controller.selectedHabitList.contains(
                                        '${response.data![index].name}')
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(height: 17, width: 17),
                                          Text(
                                            '${response.data![index].name}'
                                                        .length >=
                                                    10
                                                ? '${response.data![index].name!.substring(0, 10) + '..'}'
                                                : '${response.data![index].name}',
                                            style: controller.selectedHabitList
                                                    .contains(
                                                        '${response.data![index].name}')
                                                ? FontTextStyle
                                                    .kBlack20BoldRoboto
                                                : FontTextStyle
                                                    .kTint20BoldRoboto,
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
                                                .capitalizeFirst!,
                                            style: controller.selectedHabitList
                                                    .contains(
                                                        '${response.data![index].name}')
                                                ? FontTextStyle
                                                    .kBlack20BoldRoboto
                                                : FontTextStyle
                                                    .kTint20BoldRoboto,
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
                    if (_habitViewModel.isAlertOpen == false) {
                      _customHabitAlertDialog();
                      _habitViewModel.changeStatus();
                      setState(() {});
                    }
                  },
                  child: Container(
                    height: Get.height * 0.065,
                    width: Get.width * 0.6,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Get.height * .05),
                        gradient: LinearGradient(
                            colors: ColorUtilsGradient.kTintGradient,
                            begin: Alignment.center,
                            end: Alignment.center)),
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
                            style: FontTextStyle.kBlack22BoldRoboto),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * .08),
              commonNevigationButton(
                  onTap: () {
                    if (_habitViewModel.selectedHabitList.isNotEmpty) {
                      HabitResponseModel res = _habitViewModel.apiResponse.data;
                      Get.to(TrackingFrequencyScreen(data: res.data));
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
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Column(children: [
              Text('Custom Habit'),
              Text(
                'Enter the name of your custom habit',
                style: FontTextStyle.kBlack16W300Roboto,
              ),
              SizedBox(height: 25)
            ]),
            content: CupertinoTextField(
              placeholder: 'Habit name',
              controller: _alertDialogTextController,
            ),
            actions: [
              CupertinoDialogAction(
                  child:
                      Text('Cancel', style: FontTextStyle.kBlack24W400Roboto),
                  onPressed: () {
                    _habitViewModel.changeStatus();
                    Get.back();
                    _alertDialogTextController.clear();
                  }),
              CupertinoDialogAction(
                child: Text('Save', style: FontTextStyle.kBlack24W400Roboto),
                onPressed: () async {
                  _habitViewModel.changeStatus();
                  Get.back();

                  setState(() {});
                  if (_alertDialogTextController.text.isNotEmpty) {
                    CustomHabitRequestModel _request =
                        CustomHabitRequestModel();
                    _request.name = _alertDialogTextController.text.trim();
                    _request.userId = PreferenceManager.getUId();

                    await _customHabitViewModel.customHabitViewModel(_request);

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
          );
        });
  }
}
