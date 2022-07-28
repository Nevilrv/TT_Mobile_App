import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/user_habit_tracker_status_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/habit_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/user_habit_tracker_status_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/habit_tracker/update_progress_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
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

  List<DateTime>? days = [];
  List<DateTime>? weekList = [];
  bool isFrequencyChange = false;

  DateTime selectedDate = DateTime.now();

  weekSelection({List? selectedDayList}) {
    for (int j = 0; j < selectedDayList!.length; j++) {
      selectedDate = selectedDayList[j];
      for (int i = 0; i < 7; i++) {
        DateTime weekDates = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day + i);
        print('weekDates $weekDates');

        if (weekList!.contains(weekDates)) {
        } else {
          weekList!.add(weekDates);
        }
      }
    }
    days!.clear();
    _habitTrackStatusViewModel.dateRangePickerController.selectedDates!
        .addAll(weekList!);
    print('weekList $weekList');
  }

  bool isFirstTime = false;

  monthSelection({List? selectedDayList}) {
    for (int j = 0; j < days!.length; j++) {
      selectedDate = selectedDayList![j];
      for (int i = 0; i < 30; i++) {
        DateTime weekDates = DateTime(
            selectedDate.year, selectedDate.month, selectedDate.day + i);
        print('weekDates $weekDates');
        if (weekList!.contains(weekDates)) {
        } else {
          weekList!.add(weekDates);
        }
      }
    }
    days!.clear();
    _habitTrackStatusViewModel.dateRangePickerController.selectedDates!
        .addAll(weekList!);
    print('weekList $weekList');
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
              horizontal: Get.width * .06, vertical: Get.height * .025),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                        // SizedBox(height: Get.height * .01),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: AppText.trackFrequency.length,
                          itemBuilder: (_, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * .06,
                                  vertical: Get.height * .015),
                              child: GestureDetector(
                                onTap: () {
                                  controller.frequencySelect(value: index);
                                  controller.selectedStatus =
                                      AppText.trackFrequency[index];

                                  isFrequencyChange = true;
                                  controller.dateRangePickerController
                                      .selectedDates = [];
                                  controller.dateRangePickerController
                                      .selectedDate = null;

                                  print(
                                      "isFrequencyChange on button ---------- $days");
                                  // days!.clear();
                                  isFirstTime = true;

                                  setState(() {});
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
                                                            .kTint20BoldRoboto),
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
                        SizedBox(
                          height: Get.height * .42,
                          child: SfDateRangePicker(
                            view: DateRangePickerView.month,
                            showNavigationArrow: true,
                            enablePastDates: false,
                            controller: controller.dateRangePickerController,
                            selectionMode:
                                DateRangePickerSelectionMode.multiple,
                            initialDisplayDate: DateTime.now(),
                            todayHighlightColor: ColorUtils.kTint,
                            selectionRadius: 17,
                            selectionColor: ColorUtils.kTint,
                            minDate: DateTime.utc(2019, 01, 01),
                            maxDate: DateTime.utc(2099, 12, 31),
                            selectionTextStyle:
                                FontTextStyle.kBlack18w600Roboto,
                            enableMultiView: false,
                            yearCellStyle: DateRangePickerYearCellStyle(
                                textStyle: FontTextStyle.kWhite17W400Roboto,
                                todayTextStyle:
                                    FontTextStyle.kWhite17W400Roboto,
                                disabledDatesTextStyle:
                                    FontTextStyle.kLightGray16W300Roboto),
                            monthCellStyle: DateRangePickerMonthCellStyle(
                              // todayCellDecoration:
                              //     BoxDecoration(color: Colors.transparent),
                              disabledDatesTextStyle:
                                  FontTextStyle.kLightGray16W300Roboto,
                              textStyle: FontTextStyle.kWhite17W400Roboto,
                              todayTextStyle: FontTextStyle.kWhite17W400Roboto,
                            ),
                            // initialSelectedDates:
                            // controllerWork
                            //     .defSelectedList,
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs args) {
                              weekList!.clear();
                              print("args ---------- ${args.value}");
                              // args.value.clear();
                              // print("args 222 ---------- ${args.value}");
                              print(
                                  "current frequency of args ---------- $isFrequencyChange");
                              // if (isFrequencyChange == true) {
                              //   args.value.clear();
                              //   isFrequencyChange = false;
                              //   setState(() {});
                              //   print(
                              //       "isFrequencyChange ---------- $isFrequencyChange");
                              // }
                              days = args.value;
                              if (controller.selectedIndex == 0) {
                                // weekList = days;
                                controller.setDateController(
                                    controller.defSelectedList);
                                print("week list daily == $weekList");
                              } else if (controller.selectedIndex == 1) {
                                weekSelection(selectedDayList: days);
                                controller.setDateController(
                                    controller.defSelectedList);
                                print("week list weekly == $weekList");
                              } else if (controller.selectedIndex == 2) {
                                monthSelection(selectedDayList: days);
                                controller.setDateController(
                                    controller.defSelectedList);
                                print("week list monthly == $weekList");
                              }
                            },
                            monthViewSettings: DateRangePickerMonthViewSettings(
                              firstDayOfWeek: 1,
                              dayFormat: 'EEE',
                              viewHeaderStyle: DateRangePickerViewHeaderStyle(
                                  textStyle: FontTextStyle.kWhite17W400Roboto),
                            ),
                            headerStyle: DateRangePickerHeaderStyle(
                              textAlign: TextAlign.center,
                              textStyle: FontTextStyle.kWhite20BoldRoboto,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                commonNavigationButton(
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
                          Get.to(UpdateProgressScreen());
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
