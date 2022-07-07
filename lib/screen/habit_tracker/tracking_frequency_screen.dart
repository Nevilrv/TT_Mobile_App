import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/user_habit_tracker_status_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/habit_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/user_habit_tracker_status_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/habit_tracker/update_progress_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/habit_viewModel.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/user_habit_track_status_viewModel.dart';

class TrackingFrequencyScreen extends StatefulWidget {
  List<Habit>? data;

  TrackingFrequencyScreen({Key? key, required this.data}) : super(key: key);
  @override
  State<TrackingFrequencyScreen> createState() =>
      _TrackingFrequencyScreenState();
}

class _TrackingFrequencyScreenState extends State<TrackingFrequencyScreen> {
  bool isSelect = false;
  UserHabitTrackStatusViewModel _habitTrackStatusViewModel =
      Get.put(UserHabitTrackStatusViewModel());

  void initState() {
    super.initState();
    _habitTrackStatusViewModel.initialized;
  }

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
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.06, vertical: Get.height * 0.025),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                GetBuilder<UserHabitTrackStatusViewModel>(
                  builder: (controller) {
                    return Column(
                      children: [
                        Text(
                          'WHAT KIND OF HABITS WOULD YOU LIKE TO SET?',
                          style: FontTextStyle.kWhite17BoldRoboto,
                        ),
                        Divider(
                          height: Get.height * .02,
                          color: ColorUtils.kTint,
                          thickness: 1.5,
                        ),
                        SizedBox(height: Get.height * .035),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: AppText.trackFrequency.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * .06,
                                  vertical: Get.height * .015),
                              child: GestureDetector(
                                onTap: () {
                                  controller.frequencySelect(value: index);
                                  controller.selectedStatus =
                                      AppText.trackFrequency[index];
                                  print(
                                      "frequency ------------------ ${AppText.trackFrequency[index]}");
                                },
                                child: Container(
                                  height: Get.height * .065,
                                  width: Get.width,
                                  decoration: index == controller.selectedIndex
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
                                          border: Border.all(
                                              color: ColorUtils.kTint),
                                          color: ColorUtils.kBlack),
                                  child: index == controller.selectedIndex
                                      ? Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(width: 20, height: 20),
                                                Text(
                                                  '${AppText.trackFrequency[index]}'
                                                      .capitalizeFirst!,
                                                  style: index ==
                                                          controller
                                                              .selectedIndex
                                                      ? FontTextStyle
                                                          .kBlack20BoldRoboto
                                                      : FontTextStyle
                                                          .kTint20BoldRoboto,
                                                ),
                                                CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Colors.black,
                                                    child: Icon(
                                                      Icons.done,
                                                      size: 12.5,
                                                      color: ColorUtils.kTint,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            '${AppText.trackFrequency[index]}'
                                                .capitalizeFirst!,
                                            style: index ==
                                                    controller.selectedIndex
                                                ? FontTextStyle
                                                    .kBlack20BoldRoboto
                                                : FontTextStyle
                                                    .kTint20BoldRoboto,
                                          ),
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                commonNevigationButton(
                    onTap: () async {
                      if (_habitTrackStatusViewModel
                          .selectedStatus.isNotEmpty) {
                        UserHabitTrackStatusRequestModel _request =
                            UserHabitTrackStatusRequestModel();
                        _request.userId = PreferenceManager.getUId();
                        _request.status = _habitTrackStatusViewModel
                            .selectedStatus
                            .toLowerCase();

                        await _habitTrackStatusViewModel
                            .userHabitTrackStatusViewModel(_request);

                        if (_habitTrackStatusViewModel.apiResponse.status ==
                            Status.COMPLETE) {
                          UserHabitTrackStatusResponseModel res =
                              _habitTrackStatusViewModel.apiResponse.data;

                          Get.showSnackbar(GetSnackBar(
                            message: '${res.msg}',
                            duration: Duration(seconds: 2),
                          ));
                          print(
                              "------------------- ${_habitTrackStatusViewModel.selectedStatus}");
                          print(
                              "_habitTrackStatusViewModel.apiResponse.message  ${res.msg}");
                          Get.to(UpdateProgressScreen(
                            data: widget.data,
                          ));
                        } else if (_habitTrackStatusViewModel
                                .apiResponse.status ==
                            Status.ERROR) {
                          Get.showSnackbar(GetSnackBar(
                            message:
                                'Something went wrong!!! \nPlease try again',
                            duration: Duration(seconds: 2),
                          ));
                        }
                      } else {
                        Get.showSnackbar(GetSnackBar(
                          message: 'Please select how you want track habits',
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    name: 'Next')
              ])),
    );
  }
}
