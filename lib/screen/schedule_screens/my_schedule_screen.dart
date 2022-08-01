import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/response_model/schedule_response_model/schedule_by_date_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/schedule_screens/widgets/my_schedule_screen_widget.dart';
import 'package:tcm/screen/training_plan_screens/plan_overview.dart';
import 'package:tcm/screen/training_plan_screens/program_setup_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/schedule_viewModel/schedule_by_date_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/remove_workout_program_viewModel.dart';

class MyScheduleScreen extends StatefulWidget {
  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen>
    with AutomaticKeepAliveClientMixin<MyScheduleScreen> {
  var tabs = ['Calender', 'List View'];

  @override
  bool get wantKeepAlive => true;

  ScheduleByDateViewModel _scheduleByDateViewModel =
      Get.put(ScheduleByDateViewModel());
  RemoveWorkoutProgramViewModel _removeWorkoutProgramViewModel =
      Get.put(RemoveWorkoutProgramViewModel());

  @override
  void initState() {
    super.initState();
    _scheduleByDateViewModel.getScheduleByDateDetails(
        userId: PreferenceManager.getUId());
  }

  @override
  void dispose() {
    super.dispose();
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
        title: Text('My Schedule', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: GetBuilder<ScheduleByDateViewModel>(builder: (controller) {
        if (controller.apiResponse.status == Status.COMPLETE) {
          ScheduleByDateResponseModel scheduleResponse =
              controller.apiResponse.data;

          for (int i = 0; i < scheduleResponse.data!.length; i++) {
            print(
                "-------------- date condition is ${scheduleResponse.data![i].programData!.isNotEmpty}");

            if (scheduleResponse.data![i].programData!.isNotEmpty) {
              if (controller.dayList.contains(
                  DateTime.parse('${scheduleResponse.data![i].date}'))) {
              } else {
                controller.dayList
                    .add(DateTime.parse('${scheduleResponse.data![i].date}'));
              }

              controller.allDates(date: controller.dayList);
            }
          }

          return DefaultTabController(
            length: 2,
            child: Padding(
              padding: EdgeInsets.only(
                  left: Get.width * .06,
                  right: Get.width * .06,
                  top: Get.height * .02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: Get.height * .04,
                      width: Get.width * .6,
                      decoration: BoxDecoration(
                          color: ColorUtils.kGray,
                          borderRadius:
                              BorderRadius.circular(Get.height * .05)),
                      child: TabBar(
                          physics: BouncingScrollPhysics(),
                          unselectedLabelColor: Colors.white,
                          unselectedLabelStyle:
                              FontTextStyle.kWhite16BoldRoboto,
                          labelColor: ColorUtils.kBlack,
                          labelStyle: FontTextStyle.kBlack16BoldRoboto,
                          indicator: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: ColorUtilsGradient.kTintGradient,
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter),
                              borderRadius:
                                  BorderRadius.circular(Get.height * .05)),
                          tabs: [
                            tabBarCommonTab(
                                icon: Icons.calendar_today_outlined,
                                tabName: 'Calendar'),
                            tabBarCommonTab(
                                icon: Icons.list_sharp, tabName: 'List View'),
                          ]),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(children: [
                      Padding(
                        padding: EdgeInsets.only(top: Get.height * 0.02),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: EdgeInsets.symmetric(
                              //       horizontal: Get.width * .03),
                              //   child: TableCalendar(
                              //     calendarStyle: CalendarStyle(
                              //         markerSize: 0,
                              //         outsideDaysVisible: false,
                              //         weekendTextStyle:
                              //             FontTextStyle.kWhite17W400Roboto,
                              //         defaultTextStyle:
                              //             FontTextStyle.kWhite17W400Roboto,
                              //         selectedTextStyle:
                              //             FontTextStyle.kBlack18w600Roboto,
                              //         selectedDecoration: BoxDecoration(
                              //             color: ColorUtils.kTint,
                              //             shape: BoxShape.circle),
                              //         todayTextStyle:
                              //             FontTextStyle.kWhite17W400Roboto,
                              //         todayDecoration: BoxDecoration(
                              //           color: Colors.transparent,
                              //         )),
                              //     daysOfWeekHeight: Get.height * .05,
                              //     daysOfWeekStyle: DaysOfWeekStyle(
                              //         // decoration: BoxDecoration(
                              //         //     borderRadius: BorderRadius.circular(5),
                              //         //     border:
                              //         //         Border.all(color: ColorUtils.kGray)),
                              //         weekdayStyle:
                              //             FontTextStyle.kWhite17W400Roboto,
                              //         weekendStyle:
                              //             FontTextStyle.kWhite17W400Roboto),
                              //     headerStyle: HeaderStyle(
                              //       titleTextStyle:
                              //           FontTextStyle.kWhite20BoldRoboto,
                              //       leftChevronIcon: Icon(
                              //         Icons.arrow_back_ios_sharp,
                              //         color: ColorUtils.kTint,
                              //         size: Get.height * 0.025,
                              //       ),
                              //       rightChevronIcon: Icon(
                              //         Icons.arrow_forward_ios_sharp,
                              //         color: ColorUtils.kTint,
                              //         size: Get.height * 0.025,
                              //       ),
                              //       formatButtonVisible: false,
                              //       titleCentered: true,
                              //     ),
                              //     availableGestures:
                              //         AvailableGestures.horizontalSwipe,
                              //     startingDayOfWeek: StartingDayOfWeek.monday,
                              //     focusedDay: _focusedDay,
                              //     firstDay: DateTime.utc(2018, 01, 01),
                              //     lastDay: DateTime.utc(2030, 12, 31),
                              //     calendarFormat: _calendarFormat,
                              //     eventLoader: _getEventForDay,
                              //     onFormatChanged: (format) {
                              //       if (_calendarFormat != format) {
                              //         setState(() {
                              //           _calendarFormat = format;
                              //         });
                              //       }
                              //     },
                              //     selectedDayPredicate: (day) {
                              //       return isSameDay(_selectedDay, day);
                              //     },
                              //     onDaySelected: (selectedDay, focusedDay) {
                              //       if (!isSameDay(_selectedDay, selectedDay)) {
                              //         setState(() {
                              //           _selectedDay = selectedDay;
                              //           _focusedDay = focusedDay;
                              //         });
                              //       }
                              //     },
                              //     onPageChanged: (focusedDay) {
                              //       focusedDay = focusedDay;
                              //     },
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: Get.height * .02,
                                    left: Get.width * .03,
                                    right: Get.width * .03),
                                child: SizedBox(
                                  height: Get.height * .55,
                                  child: SfDateRangePicker(
                                    view: DateRangePickerView.month,
                                    showNavigationArrow: true,
                                    // enablePastDates: false,
                                    controller:
                                        controller.dateRangePickerController,
                                    initialDisplayDate:
                                        controller.dayList.isNotEmpty
                                            ? controller.dayList.first
                                            : DateTime.now(),
                                    todayHighlightColor: ColorUtils.kTint,
                                    selectionRadius: 17,
                                    selectionColor: ColorUtils.kTint,
                                    minDate: DateTime.utc(2019, 01, 01),
                                    maxDate: DateTime.utc(2099, 12, 31),
                                    selectionTextStyle:
                                        FontTextStyle.kBlack18w600Roboto,

                                    enableMultiView: false,
                                    yearCellStyle: DateRangePickerYearCellStyle(
                                        textStyle:
                                            FontTextStyle.kWhite17W400Roboto,
                                        todayTextStyle:
                                            FontTextStyle.kWhite17W400Roboto,
                                        disabledDatesTextStyle: FontTextStyle
                                            .kLightGray16W300Roboto),
                                    monthCellStyle:
                                        DateRangePickerMonthCellStyle(
                                      todayCellDecoration: BoxDecoration(
                                          color: Colors.transparent),
                                      disabledDatesTextStyle:
                                          FontTextStyle.kLightGray16W300Roboto,
                                      textStyle:
                                          FontTextStyle.kWhite17W400Roboto,
                                      todayTextStyle:
                                          FontTextStyle.kWhite17W400Roboto,
                                    ),
                                    selectionMode:
                                        DateRangePickerSelectionMode.multiple,
                                    initialSelectedDates: controller.dayList,

                                    onSelectionChanged:
                                        (DateRangePickerSelectionChangedArgs
                                            args) {
                                      controller.dateRangePickerController
                                          .selectedDates = controller.dayList;
                                      args.value.clear();
                                      setState(() {});
                                    },
                                    monthViewSettings:
                                        DateRangePickerMonthViewSettings(
                                      firstDayOfWeek: 1,
                                      dayFormat: 'EEE',
                                      viewHeaderStyle:
                                          DateRangePickerViewHeaderStyle(
                                              textStyle: FontTextStyle
                                                  .kWhite17W400Roboto),
                                    ),
                                    headerStyle: DateRangePickerHeaderStyle(
                                      textAlign: TextAlign.center,
                                      textStyle:
                                          FontTextStyle.kWhite20BoldRoboto,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.width * .04),
                              Text(
                                AppText.scheduleWorkout,
                                style: FontTextStyle.kWhite18BoldRoboto,
                              ),
                              Divider(
                                color: ColorUtils.kTint,
                                thickness: 1.5,
                                height: Get.height * .04,
                              ),
                              ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: scheduleResponse.data!.length,
                                  itemBuilder: (_, index) {
                                    // List<String> finalDate =
                                    //     selectedDay.toString().split(" ");
                                    // print(" -=-=-==-=-=-= ${finalDate[0]}");
                                    // print(
                                    //     'date from api ${scheduleResponse.data![index].date}');
                                    // print(
                                    //     "condition =========${scheduleResponse.data![index].date == finalDate[0]} ");
                                    // if (scheduleResponse.data![index].date ==
                                    //     finalDate[0]) {
                                    return ListView.builder(
                                        itemCount: scheduleResponse
                                            .data![index].programData!.length,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (_, index1) {
                                          return ListTile(
                                            title: Text(
                                              scheduleResponse
                                                  .data![index]
                                                  .programData![index1]
                                                  .workoutTitle!,
                                              style: FontTextStyle
                                                  .kWhite17BoldRoboto,
                                            ),
                                            subtitle: Text(
                                              '${scheduleResponse.data![index].programData![0].exerciseTitle}' +
                                                  " - " +
                                                  ' ${scheduleResponse.data![index].programData![0].exerciseTitle} ',
                                              style: FontTextStyle
                                                  .kLightGray16W300Roboto,
                                            ),
                                            trailing: InkWell(
                                              onTap: () {
                                                openBottomSheet(
                                                    scheduleByDateViewModel:
                                                        controller,
                                                    removeWorkoutProgramViewModel:
                                                        _removeWorkoutProgramViewModel,
                                                    context: context,
                                                    event: scheduleResponse
                                                        .data![index],
                                                    onPressedView: () {
                                                      Get.to(PlanOverviewScreen(
                                                          id: "${scheduleResponse.data![index].programData![0].workoutId}"));
                                                    },
                                                    onPressedEdit: () {
                                                      Get.to(ProgramSetupPage(
                                                        day: '1',
                                                        workoutName:
                                                            scheduleResponse
                                                                .data![index]
                                                                .programData![0]
                                                                .workoutTitle,
                                                        workoutId:
                                                            scheduleResponse
                                                                .data![index]
                                                                .programData![0]
                                                                .workoutId,
                                                        exerciseId:
                                                            scheduleResponse
                                                                .data![index]
                                                                .programData![0]
                                                                .exerciseId,
                                                        programData:
                                                            scheduleResponse
                                                                .data![index]
                                                                .programData,
                                                        isEdit: true,
                                                        workoutProgramId:
                                                            scheduleResponse
                                                                .data![index]
                                                                .userProgramId,
                                                      ));
                                                    });
                                              },
                                              child: Icon(
                                                Icons.more_horiz_sharp,
                                                color: ColorUtils.kTint,
                                              ),
                                            ),
                                          );
                                        });
                                    // } else {
                                    //   return SizedBox();
                                    // }
                                  }),
                            ],
                          ),
                        ),
                      ),
                      listViewTab(
                          getEventForDay: scheduleResponse.data!,
                          context: context,
                          scheduleResponse: scheduleResponse)
                    ]),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(color: ColorUtils.kTint),
          );
        }
      }),
    );
  }
}
