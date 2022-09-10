import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/get_habit_record_date_request_model.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/habit_record_add_update_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/get_habit_record_date_response_model.dart'
    as gh;
import 'package:tcm/model/response_model/habit_tracker_model/habit_record_add_update_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/habit_tracker/habit_selection_screen.dart';
import 'package:tcm/screen/habit_tracker/perfect_day_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/get_habit_record_viewModel.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/habit_record_add_update_viewModel.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/habit_viewModel.dart';

class UpdateProgressScreen extends StatefulWidget {
  UpdateProgressScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UpdateProgressScreen> createState() => _UpdateProgressScreenState();
}

class _UpdateProgressScreenState extends State<UpdateProgressScreen> {
  HabitViewModel _habitViewModel = Get.put(HabitViewModel());
  HabitRecordAddUpdateViewModel _habitRecordAddUpdateViewModel =
      Get.put(HabitRecordAddUpdateViewModel());
  GetHabitRecordDateViewModel _getHabitRecordDateViewModel =
      Get.put(GetHabitRecordDateViewModel());
  int index = 0;
  List tmpDateList = [];
  String? finalDate;
  List oldHabitList = [];
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  gh.GetHabitRecordDateResponseModel? recordResponse;
  DateTime? userSelectedDate = DateTime.now();
  dateIncrement() {
    print('------------- +++ date $userSelectedDate');
    DateTime today = DateTime.now();
    if (userSelectedDate!
        .isBefore(DateTime(today.year, today.month, today.day))) {
      userSelectedDate = DateTime(userSelectedDate!.year,
          userSelectedDate!.month, userSelectedDate!.day + 1);
    }
    print('------------- +++ later ++++++++++++ date $userSelectedDate');

    setState(() {});
  }

  dateDecrement() {
    userSelectedDate = DateTime(userSelectedDate!.year, userSelectedDate!.month,
        userSelectedDate!.day - 1);
    print('------------- --- date $userSelectedDate');
    setState(() {});
  }

  dateApiCall() async {
    tmpDateList = userSelectedDate.toString().split(" ");
    finalDate = tmpDateList[0];
    GetHabitRecordDateRequestModel _request = GetHabitRecordDateRequestModel();

    _request.userId = PreferenceManager.getUId();
    print("date init ---------------- $finalDate");
    _request.date = finalDate;
    await _getHabitRecordDateViewModel.getHabitRecordDateViewModel(
        isLoading: true, model: _request);
    gh.GetHabitRecordDateResponseModel resp1 =
        _getHabitRecordDateViewModel.apiResponse.data;

    recordResponse = resp1;
    preCompleteHabit();
    idForEdit();
  }

  initState() {
    super.initState();
    _habitViewModel.getHabitDetail(userId: PreferenceManager.getUId());
    _habitViewModel.tmpHabitUpdatesList.clear();
    dateApiCall();
  }

  idForEdit() {
    for (int i = 0; i < recordResponse!.data!.length; i++) {
      oldHabitList.add(recordResponse!.data![i].habitId);
    }
  }

  // DateTime defDate = DateTime.now();
  // DateTime? userSelectedDate;
  // int dateCounter = 0;
  //
  // dateIncrement({int? counter}) {
  //   userSelectedDate =
  //       DateTime(defDate.year, defDate.month, defDate.day + counter!);
  //
  //   print('------------- +++ date $userSelectedDate');
  // }
  //
  // dateDecrement({int? counter}) {
  //   userSelectedDate =
  //       DateTime(defDate.year, defDate.month, defDate.day + counter!);
  //
  //   print('------------- --- date $userSelectedDate');
  // }

  preCompleteHabit() {
    _habitViewModel.tmpHabitUpdatesList.clear();

    for (int i = 0; i < recordResponse!.data!.length; i++) {
      if (recordResponse!.data![i].completed == "true") {
        _habitViewModel.tmpHabitUpdatesList
            .add(recordResponse!.data![i].habitId);
      }
    }
    print(
        'List call on button or init ----------- ${_habitViewModel.tmpHabitUpdatesList}');

    _habitViewModel.progressCounter(
        selectedHabitListLength: _habitViewModel.tmpHabitUpdatesList.length,
        totalListLength: recordResponse!.data!.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("init call response $recordResponse");

    print(
        ' _habitViewModel.tmpHabitUpdatesList ${_habitViewModel.tmpHabitUpdatesList}');

    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
              userSelectedDate = DateTime.now();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorUtils.kTint,
            )),
        backgroundColor: ColorUtils.kBlack,
        title: Text('Habit Tracking', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Get.to(HabitSelectionScreen(
                  oldHabitsId: oldHabitList,
                ));
              },
              child: Text(
                'Edit',
                style: FontTextStyle.kTine16W400Roboto,
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.04, vertical: Get.height * 0.025),
          child: GetBuilder<GetHabitRecordDateViewModel>(
            builder: (controller) {
              if (controller.apiResponse.status == Status.LOADING) {
                return SizedBox(
                  height: Get.height * .85,
                  child: Center(
                      child: CircularProgressIndicator(
                    color: ColorUtils.kTint,
                  )),
                );
              }

              return Column(
                children: [
                  // TableCalendar(
                  //   focusedDay: DateTime.now(),
                  //   firstDay: DateTime.utc(2021, 05, 1),
                  //   lastDay: DateTime.utc(2022, 12, 1),
                  //   headerStyle: HeaderStyle(
                  //     titleTextStyle: FontTextStyle.kWhite20BoldRoboto,
                  //     formatButtonVisible: false,
                  //     titleCentered: true,
                  //     leftChevronIcon: Icon(
                  //       Icons.arrow_back_ios_sharp,
                  //       color: ColorUtils.kTint,
                  //       size: Get.height * .025,
                  //     ),
                  //     rightChevronIcon: Icon(
                  //       Icons.arrow_forward_ios_sharp,
                  //       color: ColorUtils.kTint,
                  //       size: Get.height * .025,
                  //     ),
                  //   ),
                  // ),
                  GetBuilder<HabitViewModel>(builder: (controller) {
                    tmpDateList = userSelectedDate.toString().split(" ");
                    finalDate = tmpDateList[0];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () async {
                            dateDecrement();
                            Future.delayed(Duration(seconds: 1), () async {
                              GetHabitRecordDateRequestModel _request =
                                  GetHabitRecordDateRequestModel();
                              _request.userId = PreferenceManager.getUId();
                              print(
                                  "date decrement ---------------- $finalDate");
                              _request.date = finalDate;
                              await _getHabitRecordDateViewModel
                                  .getHabitRecordDateViewModel(model: _request);
                              gh.GetHabitRecordDateResponseModel resp =
                                  _getHabitRecordDateViewModel.apiResponse.data;
                              recordResponse = resp;
                              print(
                                  'date counter ----------------- $userSelectedDate');
                            }).then((value) => preCompleteHabit());
                            // _habitViewModel.tmpHabitUpdatesList.clear();

                            // setState(() {});
                          },
                          child: Icon(
                            Icons.arrow_back_ios_sharp,
                            color: ColorUtils.kTint,
                            size: Get.height * .03,
                          ),
                        ),
                        SizedBox(width: Get.height * .04),
                        InkWell(
                          onTap: () {
                            DatePicker.showDatePicker(context,
                                theme: DatePickerTheme(
                                    backgroundColor: ColorUtils.kBlack,
                                    cancelStyle:
                                        FontTextStyle.kTine16W400Roboto,
                                    doneStyle: FontTextStyle.kTine16W400Roboto,
                                    itemStyle:
                                        FontTextStyle.kWhite16W300Roboto),
                                showTitleActions: true,
                                minTime: DateTime(2019, 1, 1),
                                maxTime: DateTime.now(), onChanged: (date) {
                              userSelectedDate = date;
                              print('change $date');
                            }, onConfirm: (date) async {
                              setState(() {});
                              userSelectedDate = date;

                              Future.delayed(Duration(seconds: 1), () async {
                                GetHabitRecordDateRequestModel _request =
                                    GetHabitRecordDateRequestModel();

                                _request.userId = PreferenceManager.getUId();
                                print(
                                    "date increment ---------------- $finalDate");

                                _request.date = finalDate;
                                await _getHabitRecordDateViewModel
                                    .getHabitRecordDateViewModel(
                                        model: _request);
                                gh.GetHabitRecordDateResponseModel resp =
                                    _getHabitRecordDateViewModel
                                        .apiResponse.data;

                                recordResponse = resp;
                                print(
                                    'date counter ----------------- $userSelectedDate');
                              }).then((value) => preCompleteHabit());

                              // setState(() {});
                            },
                                currentTime: userSelectedDate,
                                locale: LocaleType.en);
                          },
                          child: Text(
                              '${Jiffy(userSelectedDate).format('EEEE, MMMM do')}',
                              style: FontTextStyle.kWhite20BoldRoboto),
                        ),
                        SizedBox(width: Get.height * .04),
                        InkWell(
                          onTap: () async {
                            dateIncrement();
                            Future.delayed(Duration(seconds: 1), () async {
                              GetHabitRecordDateRequestModel _request =
                                  GetHabitRecordDateRequestModel();

                              _request.userId = PreferenceManager.getUId();
                              print(
                                  "date increment ---------------- $finalDate");

                              _request.date = finalDate;
                              await _getHabitRecordDateViewModel
                                  .getHabitRecordDateViewModel(model: _request);
                              gh.GetHabitRecordDateResponseModel resp =
                                  _getHabitRecordDateViewModel.apiResponse.data;

                              recordResponse = resp;
                              print(
                                  'date counter ----------------- $userSelectedDate');
                            }).then((value) => preCompleteHabit());
                          },
                          child: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: ColorUtils.kTint,
                            size: Get.height * .03,
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: Get.height * .04),
                  // GetBuilder<HabitViewModel>(
                  //   builder: (controller) {
                  //     return Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         Container(
                  //           decoration: BoxDecoration(
                  //               border: Border.all(color: ColorUtils.kTint),
                  //               borderRadius:
                  //                   BorderRadius.circular(Get.height * .05)),
                  //           child: LinearPercentIndicator(
                  //             lineHeight: Get.height * .03,
                  //             width: Get.width * .7,
                  //             padding: EdgeInsets.zero,
                  //             barRadius: Radius.circular(Get.height * .05),
                  //             animation: true,
                  //             percent: controller.percent! / 100,
                  //             progressColor: ColorUtils.kTint,
                  //             backgroundColor: ColorUtils.kBlack,
                  //           ),
                  //         ),
                  //         Text(
                  //           '${controller.tmpHabitUpdatesList.length}/${recordResponse!.data!.length}',
                  //           style: FontTextStyle.kWhite20BoldRoboto,
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // ),
                  Container(
                    height: 230,
                    width: 230,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          bottom: 29.5,
                          left: 41,
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: Color(0xffDF3541),
                          ),
                        ),
                        Positioned(
                          bottom: 29.5,
                          right: 41,
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: Color(0xff00FE07),
                          ),
                        ),
                        Container(
                            height: 230,
                            width: 230,
                            child: SfRadialGauge(
                              axes: [
                                RadialAxis(
                                  minimum: 0,
                                  maximum:
                                      recordResponse!.data!.length.toDouble(),
                                  axisLabelStyle:
                                      GaugeTextStyle(color: Colors.transparent),
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                      startValue: 0,
                                      endValue: recordResponse!.data!.length
                                              .toDouble() /
                                          3,
                                      gradient: SweepGradient(
                                        colors: [
                                          Color(0xffDF3541),
                                          Color(0xff7E7F9D)
                                        ],
                                        stops: <double>[0.4, 1],
                                      ),
                                      startWidth: 18,
                                      endWidth: 18,
                                    ),
                                    GaugeRange(
                                      startValue: recordResponse!.data!.length
                                              .toDouble() /
                                          3,
                                      endValue: recordResponse!.data!.length
                                              .toDouble() /
                                          2,
                                      gradient: SweepGradient(
                                        colors: [
                                          Color(0xff7E7F9D),
                                          Color(0xff21C4F8),
                                        ],
                                        stops: <double>[0, 0.3],
                                      ),
                                      startWidth: 18,
                                      endWidth: 18,
                                    ),
                                    GaugeRange(
                                      startValue: recordResponse!.data!.length
                                              .toDouble() /
                                          2,
                                      endValue: recordResponse!.data!.length
                                              .toDouble() /
                                          1,
                                      // color: Colors.green,

                                      gradient: SweepGradient(
                                        colors: [
                                          Color(0xff21C4F8),
                                          Color(0xff10E0A7),
                                        ],
                                        stops: <double>[0, 0.2],
                                      ),
                                      startWidth: 18,
                                      endWidth: 18,
                                    ),
                                    GaugeRange(
                                      startValue: recordResponse!.data!.length
                                              .toDouble() /
                                          1.5,
                                      endValue: recordResponse!.data!.length
                                          .toDouble(),
                                      gradient: SweepGradient(
                                        colors: [
                                          Color(0xff10E0A7),
                                          Color(0xff00FE07)
                                        ],
                                        stops: <double>[0, 0.2],
                                      ),
                                      startWidth: 18,
                                      endWidth: 18,
                                    )
                                  ],
                                  interval: 1,
                                  pointers: [
                                    NeedlePointer(
                                      needleEndWidth: 80,
                                      needleLength: .92,
                                      enableAnimation: true,
                                      animationType: AnimationType.ease,
                                      needleColor: ColorUtils.kBlack,
                                      value: _habitViewModel
                                          .tmpHabitUpdatesList.length
                                          .toDouble(),
                                    ),
                                    NeedlePointer(
                                      needleEndWidth: 65,
                                      needleLength: .87,
                                      enableAnimation: true,
                                      animationType: AnimationType.ease,
                                      needleColor: ColorUtils.kSaperatedGray,
                                      value: _habitViewModel
                                          .tmpHabitUpdatesList.length
                                          .toDouble(),
                                      knobStyle: KnobStyle(
                                          knobRadius: .75,
                                          color: ColorUtils.kSaperatedGray),
                                    )
                                  ],
                                )
                              ],
                            )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${_habitViewModel.tmpHabitUpdatesList.length}/${recordResponse!.data!.length}',
                              style: FontTextStyle.kWhite20BoldRoboto
                                  .copyWith(fontSize: Get.height * 0.055),
                            ),
                            Text(
                              'TRACKED',
                              style: FontTextStyle.kWhite17BoldRoboto,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Text(
                  //   'UPDATE YOUR PROGRESS',
                  //   style: FontTextStyle.kWhite17BoldRoboto,
                  // ),
                  // Divider(
                  //   height: Get.height * .02,
                  //   color: ColorUtils.kTint,
                  //   thickness: 1.5,
                  // ),
                  // SizedBox(height: Get.height * .02),
                  // Center(
                  //   child: SizedBox(
                  //     height: Get.height * .275,
                  //     width: Get.height * .3,
                  //     child: Image.asset(
                  //       _habitViewModel.selectedBodyIllu,
                  //       fit: BoxFit.contain,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: Get.height * .03),

                  GetBuilder<HabitViewModel>(
                    builder: (controller) {
                      print('final Date ------------ $finalDate');

                      if (controller.apiResponse.status == Status.ERROR) {
                        return Center(
                            child: Text(
                          'Something went wrong!!!',
                          style: FontTextStyle.kWhite24BoldRoboto,
                        ));
                      }
                      if (controller.apiResponse.status == Status.LOADING) {
                        return Center(
                            child: CircularProgressIndicator(
                          color: ColorUtils.kTint,
                        ));
                      }

                      if (controller.apiResponse.status == Status.COMPLETE) {
                        return SizedBox(
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: recordResponse!.data!.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / .52,
                                      crossAxisSpacing: Get.height * .02,
                                      mainAxisSpacing: Get.height * .025),
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.updateSelectedHabits(
                                        id: '${recordResponse!.data![index].habitId}');
                                    controller.progressCounter(
                                        selectedHabitListLength: controller
                                            .tmpHabitUpdatesList.length,
                                        totalListLength:
                                            recordResponse!.data!.length);

                                    print(
                                        '------------- tmpSelectedHabitIDList ${controller.tmpHabitUpdatesList}');
                                    setState(() {});
                                    controller.joinIDList(
                                        listOfId:
                                            controller.tmpHabitUpdatesList);
                                    print(
                                        " list of id string = = = = = ${controller.tmpHabitUpdatesList}");

                                    print(
                                        "condition check ${controller.tmpHabitUpdatesList.contains('${recordResponse!.data![index].habitId}')}");
                                  },
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: Get.height * .065,
                                    width: Get.width * .45,
                                    decoration: controller.tmpHabitUpdatesList
                                            .contains(
                                                '${recordResponse!.data![index].habitId}')
                                        ? BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              stops: [0.0, 1.0],
                                              colors: ColorUtilsGradient
                                                  .kTintGradient,
                                            ),
                                          )
                                        : BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            border: Border.all(
                                                color: ColorUtils.kTint),
                                            color: ColorUtils.kBlack),
                                    child: controller.tmpHabitUpdatesList.contains(
                                            '${recordResponse!.data![index].habitId}')
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(height: 15, width: 15),
                                              Text(
                                                '${recordResponse!.data![index].habitName}'
                                                            .length >
                                                        16
                                                    ? '${recordResponse!.data![index].habitName!.substring(0, 14) + '..'}'
                                                        .capitalizeFirst!
                                                    : '${recordResponse!.data![index].habitName}'
                                                        .capitalizeFirst!,
                                                style: controller
                                                        .tmpHabitUpdatesList
                                                        .contains(
                                                            '${recordResponse!.data![index].habitId}')
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
                                                '${recordResponse!.data![index].habitName}'
                                                            .length >
                                                        24
                                                    ? '${recordResponse!.data![index].habitName!.substring(0, 23) + '..'}'
                                                        .capitalizeFirst!
                                                    : '${recordResponse!.data![index].habitName}'
                                                        .capitalizeFirst!,
                                                style: controller
                                                        .tmpHabitUpdatesList
                                                        .contains(
                                                            '${recordResponse!.data![index].habitId}')
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
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Get.height * .05,
                      horizontal: Get.width * .03,
                    ),
                    child: commonNavigationButton(
                        name: 'COMPLETE!',
                        onTap: () async {
                          if (_habitViewModel.habitIdString!.isNotEmpty) {
                            HabitRecordAddUpdateRequestModel _request =
                                HabitRecordAddUpdateRequestModel();
                            _request.userId = PreferenceManager.getUId();
                            _request.habitIds = _habitViewModel.habitIdString;
                            _request.date = finalDate!;

                            await _habitRecordAddUpdateViewModel
                                .habitRecordAddUpdateViewModel(_request);

                            if (_habitRecordAddUpdateViewModel
                                    .apiResponse.status ==
                                Status.COMPLETE) {
                              HabitRecordAddUpdateResponseModel res =
                                  _habitRecordAddUpdateViewModel
                                      .apiResponse.data;

                              Get.showSnackbar(GetSnackBar(
                                message: '${res.msg}',
                                duration: Duration(seconds: 2),
                              ));
                              print(
                                  "------------------- $_habitRecordAddUpdateViewModel");
                              print(
                                  "_habitTrackStatusViewModel.apiResponse.message  ${res.msg}");
                              Get.to(PerfectDayScreen());
                            } else if (_habitRecordAddUpdateViewModel
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
                              message: 'Please select at least one habit',
                              duration: Duration(seconds: 2),
                            ));
                          }
                        }),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
