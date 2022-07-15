import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/get_habit_record_date_request_model.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/habit_record_add_update_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/get_habit_record_date_response_model.dart'
    as gh;
import 'package:tcm/model/response_model/habit_tracker_model/habit_model.dart';
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
  List<Habit>? data;

  UpdateProgressScreen({Key? key, required this.data}) : super(key: key);

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
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  gh.GetHabitRecordDateResponseModel? recordResponse;
  DateTime? userSelectedDate = DateTime.now();
  dateIncrement() {
    userSelectedDate = DateTime(userSelectedDate!.year, userSelectedDate!.month,
        userSelectedDate!.day + 1);
    print('------------- +++ date $userSelectedDate');
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
    await _getHabitRecordDateViewModel.getHabitRecordDateViewModel(_request);
    gh.GetHabitRecordDateResponseModel resp1 =
        _getHabitRecordDateViewModel.apiResponse.data;

    recordResponse = resp1;
  }

  initState() {
    super.initState();
    _habitViewModel.getHabitDetail(userId: PreferenceManager.getUId());
    _habitViewModel.tmpHabitUpdatesList.clear();
    dateApiCall();
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
                Get.to(HabitSelectionScreen());
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
              horizontal: Get.width * 0.06, vertical: Get.height * 0.015),
          child: Column(children: [
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
                        print("date decrement ---------------- $finalDate");
                        _request.date = finalDate;
                        await _getHabitRecordDateViewModel
                            .getHabitRecordDateViewModel(_request);
                        gh.GetHabitRecordDateResponseModel resp =
                            _getHabitRecordDateViewModel.apiResponse.data;
                        recordResponse = resp;
                        print(
                            'date counter ----------------- ${userSelectedDate}');
                      });
                      _habitViewModel.tmpHabitUpdatesList.clear();
                      controller.progressCounter(
                          selectedHabitListLength:
                              controller.tmpHabitUpdatesList.length,
                          totalListLength: recordResponse!.data!.length);
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
                              cancelStyle: FontTextStyle.kTine16W400Roboto,
                              doneStyle: FontTextStyle.kTine16W400Roboto,
                              itemStyle: FontTextStyle.kWhite16W300Roboto),
                          showTitleActions: true,
                          minTime: DateTime(2019, 1, 1),
                          maxTime: DateTime(2099, 12, 31), onChanged: (date) {
                        userSelectedDate = date;
                        print('change $date');
                      }, onConfirm: (date) async {
                        setState(() {});
                        userSelectedDate = date;
                        // String pickedDateString =
                        //     formatter.format(controller.userSelectedDate!);
                        //
                        // print('date $pickedDateString');

                        // Map<String, dynamic> body = {
                        //   "user_id": PreferenceManager.getUId(),
                        //   "date": pickedDateString
                        // };
                        GetHabitRecordDateRequestModel _request =
                            GetHabitRecordDateRequestModel();

                        _request.userId = PreferenceManager.getUId();
                        print("date center ---------------- $finalDate");

                        _request.date = finalDate;
                        await _getHabitRecordDateViewModel
                            .getHabitRecordDateViewModel(_request);
                        gh.GetHabitRecordDateResponseModel resp =
                            _getHabitRecordDateViewModel.apiResponse.data;
                        print('resp --------------- $resp');
                        recordResponse = resp;
                        _habitViewModel.tmpHabitUpdatesList.clear();
                        controller.progressCounter(
                            selectedHabitListLength:
                                controller.tmpHabitUpdatesList.length,
                            totalListLength: recordResponse!.data!.length);
                      }, currentTime: userSelectedDate, locale: LocaleType.en);
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
                        print("date increment ---------------- $finalDate");

                        _request.date = finalDate;
                        await _getHabitRecordDateViewModel
                            .getHabitRecordDateViewModel(_request);
                        gh.GetHabitRecordDateResponseModel resp =
                            _getHabitRecordDateViewModel.apiResponse.data;

                        recordResponse = resp;
                        print(
                            'date counter ----------------- ${userSelectedDate}');
                      });

                      _habitViewModel.tmpHabitUpdatesList.clear();
                      controller.progressCounter(
                          selectedHabitListLength:
                              controller.tmpHabitUpdatesList.length,
                          totalListLength: recordResponse!.data!.length);
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
            GetBuilder<HabitViewModel>(
              builder: (controller) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorUtils.kTint),
                          borderRadius:
                              BorderRadius.circular(Get.height * .05)),
                      child: LinearPercentIndicator(
                        lineHeight: Get.height * .03,
                        width: Get.width * .7,
                        padding: EdgeInsets.zero,
                        barRadius: Radius.circular(Get.height * .05),
                        animation: true,
                        percent: controller.percent! / 100,
                        progressColor: ColorUtils.kTint,
                        backgroundColor: ColorUtils.kBlack,
                      ),
                    ),
                    Text(
                      '${controller.tmpHabitUpdatesList.length}/${recordResponse!.data!.length}',
                      style: FontTextStyle.kWhite20BoldRoboto,
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: Get.height * .03),
            Text(
              'UPDATE YOUR PROGRESS',
              style: FontTextStyle.kWhite17BoldRoboto,
            ),
            Divider(
              height: Get.height * .02,
              color: ColorUtils.kTint,
              thickness: 1.5,
            ),
            SizedBox(height: Get.height * .02),
            Center(
              child: Container(
                height: Get.height * .3,
                width: Get.height * .3,
                child: Image.asset(_habitViewModel.selectedBodyIllu,
                    fit: BoxFit.contain),
              ),
            ),
            SizedBox(height: Get.height * .03),

            GetBuilder<HabitViewModel>(
              builder: (controller) {
                print('final Date ------------ $finalDate');
                // print('-------------- ${controller.apiResponse.status}');
                //
                // if (controller.apiResponse.status == Status.ERROR) {
                //   print('-------------- ${controller.apiResponse.status}');
                //
                //   return Text('Data not Found!');
                // }
                // if (controller.apiResponse.status == Status.LOADING) {
                //   print('-------------- ${controller.apiResponse.status}');
                //   return Center(
                //     child: CircularProgressIndicator(color: ColorUtils.kTint),
                //   );
                // }
                // if (controller.apiResponse.status == Status.COMPLETE) {
                //   print('-------------- ${controller.apiResponse.status}');
                //
                //   HabitResponseModel response = controller.apiResponse.data;
                return SizedBox(
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: recordResponse!.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 2 / .55,
                          crossAxisSpacing: Get.height * .02,
                          mainAxisSpacing: Get.height * .02),
                      itemBuilder: (_, index) {
                        // return Container(
                        //   child: commonSelectionButton(
                        //     name: '${AppText.habitsTracking[index]}',
                        //     habitList: _habitViewModel.habitUpdatesList,
                        //     onTap: () {
                        //       _habitViewModel.habitUpdates(
                        //           habits: '${AppText.habitsTracking[index]}');
                        //       print('${AppText.habitsTracking[index]}');
                        //       print('${_habitViewModel.habitUpdatesList}');
                        //       // setState(() {});
                        //     },
                        //   ),
                        // );
                        return GestureDetector(
                          onTap: () {
                            controller.updateSelectedHabits(
                                id: '${recordResponse!.data![index].habitId}');
                            controller.progressCounter(
                                selectedHabitListLength:
                                    controller.tmpHabitUpdatesList.length,
                                totalListLength: recordResponse!.data!.length);

                            print(
                                '------------- tmpSelectedHabitIDList ${controller.tmpHabitUpdatesList}');
                            setState(() {});
                            controller.joinIDList(
                                listOfId: controller.tmpHabitUpdatesList);
                            print(
                                " list of id string = = = = = ${controller.tmpHabitUpdatesList}");

                            print(
                                "condition check ${controller.tmpHabitUpdatesList.contains('${recordResponse!.data![index].habitId}')}");
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: Get.height * .065,
                            width: Get.width * .45,
                            decoration: controller.tmpHabitUpdatesList.contains(
                                    '${recordResponse!.data![index].habitId}')
                                // ||
                                //     recordResponse!.data!.habits![index].name ==
                                //         controller.selectedHabitList[index]
                                ? BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Get.height * .05),
                                    gradient: LinearGradient(
                                        colors:
                                            ColorUtilsGradient.kTintGradient,
                                        begin: Alignment.center,
                                        end: Alignment.center))
                                : BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Get.height * .05),
                                    border: Border.all(color: ColorUtils.kTint),
                                    color: ColorUtils.kBlack),
                            child: controller.tmpHabitUpdatesList.contains(
                                    '${recordResponse!.data![index].habitId}')
                                // ||
                                //     recordResponse!.data!.habits![index].name ==
                                //         controller.selectedHabitList[index]
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(height: 15, width: 15),
                                      Text(
                                        '${recordResponse!.data![index].habitName}'
                                                    .length >
                                                15
                                            ? '${recordResponse!.data![index].habitName!.substring(0, 14) + '..'}'
                                                .capitalizeFirst!
                                            : '${recordResponse!.data![index].habitName}'
                                                .capitalizeFirst!,
                                        style: controller.tmpHabitUpdatesList
                                                .contains(
                                                    '${recordResponse!.data![index].habitId}')
                                            ? FontTextStyle.kBlack20BoldRoboto
                                            : FontTextStyle.kTint20BoldRoboto,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${recordResponse!.data![index].habitName}'
                                                    .length >
                                                15
                                            ? '${recordResponse!.data![index].habitName!.substring(0, 14) + '..'}'
                                                .capitalizeFirst!
                                            : '${recordResponse!.data![index].habitName}'
                                                .capitalizeFirst!,
                                        style: controller.tmpHabitUpdatesList
                                                .contains(
                                                    '${recordResponse!.data![index].habitId}')
                                            ? FontTextStyle.kBlack20BoldRoboto
                                            : FontTextStyle.kTint20BoldRoboto,
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                );

                // } else {
                //   return SizedBox();
                // }
              },
              // builder: (controller) {
              //   return SizedBox(
              //     child:
              //     ListView.builder(
              //         shrinkWrap: true,
              //         physics: NeverScrollableScrollPhysics(),
              //         itemCount: AppText.habitsTracking.length,
              //         itemBuilder: (_, index) {
              //           return commonSelectionButton(
              //             name: '${AppText.habitsTracking[index]}',
              //             habitList: _habitViewModel.habitUpdatesList,
              //             onTap: () {
              //               _habitViewModel.habitUpdates(
              //                   habits: '${AppText.habitsTracking[index]}');
              //               print('${AppText.habitsTracking[index]}');
              //               print('${_habitViewModel.habitUpdatesList}');
              //               // setState(() {});
              //             },
              //           );
              //         }),
              //   );
              // },
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Get.height * .05,
                horizontal: Get.width * .03,
              ),
              child: commonNevigationButton(
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

                      if (_habitRecordAddUpdateViewModel.apiResponse.status ==
                          Status.COMPLETE) {
                        HabitRecordAddUpdateResponseModel res =
                            _habitRecordAddUpdateViewModel.apiResponse.data;

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
                          message: 'Something went wrong!!! \nPlease try again',
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
          ]),
        ),
      ),
    );
  }
}
