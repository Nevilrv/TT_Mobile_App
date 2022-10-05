import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/response_model/schedule_response_model/schedule_by_date_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/schedule_screens/widgets/my_schedule_screen_widget.dart';
import 'package:tcm/screen/training_plan_screens/plan_overview.dart';
import 'package:tcm/screen/training_plan_screens/program_setup_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/schedule_viewModel/schedule_by_date_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/remove_workout_program_viewModel.dart';
import '../../model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import '../../model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import '../../model/response_model/workout_response_model/user_workouts_date_response_model.dart';
import '../../viewModel/training_plan_viewModel/exercise_by_id_viewModel.dart';
import '../../viewModel/training_plan_viewModel/workout_by_id_viewModel.dart';
import '../../viewModel/workout_viewModel/user_workouts_date_viewModel.dart';
import '../workout_screen/workout_home.dart';

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
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  ExerciseByIdViewModel _exerciseByIdViewModel =
      Get.put(ExerciseByIdViewModel());
  WorkoutByIdViewModel _workoutByIdViewModel = Get.put(WorkoutByIdViewModel());
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  @override
  void initState() {
    super.initState();
    _connectivityCheckViewModel.startMonitoring();

    _scheduleByDateViewModel.getScheduleByDateDetails(
        userId: PreferenceManager.getUId());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(builder: (control) {
      return control.isOnline
          ? Scaffold(
              backgroundColor: ColorUtils.kBlack,
              appBar: appBarWidget(),
              body: GetBuilder<ScheduleByDateViewModel>(builder: (controller) {
                if (controller.apiResponse.status == Status.COMPLETE) {
                  ScheduleByDateResponseModel scheduleResponse =
                      controller.apiResponse.data;

                  for (int i = 0; i < scheduleResponse.data!.length; i++) {
                    if (scheduleResponse.data![i].programData!.isNotEmpty) {
                      if (controller.dayList.contains(DateTime.parse(
                          '${scheduleResponse.data![i].date}'))) {
                      } else {
                        ///888
                        // controller.dayList = [];
                        controller.dayList.add(DateTime.parse(
                            '${scheduleResponse.data![i].date}'));
                      }

                      controller.allDates(date: controller.dayList);
                    }
                  }
                  controller.completeDate = [];
                  controller.pendingFutureDate = [];
                  controller.missedPastDate = [];
                  for (int i = 0; i < scheduleResponse.data!.length; i++) {
                    if (scheduleResponse.data![i].isCompleted == 'completed') {
                      controller.completeDate
                              .contains(scheduleResponse.data![i].date)
                          ? null
                          : controller.completeDate
                              .add(scheduleResponse.data![i].date);
                    } else {
                      var now = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      );

                      var apiDate =
                          DateTime.parse('${scheduleResponse.data![i].date}');

                      if (now.isAfter(apiDate)) {
                        // print('Before date >> ${scheduleResponse.data![i].date}');
                        controller.missedPastDate
                                .contains(scheduleResponse.data![i].date)
                            ? null
                            : controller.missedPastDate
                                .add(scheduleResponse.data![i].date);
                      } else {
                        controller.pendingFutureDate
                                .contains(scheduleResponse.data![i].date)
                            ? null
                            : controller.pendingFutureDate
                                .add(scheduleResponse.data![i].date);
                      }
                    }
                  }
                  // print('completeDate past >> ${controller.completeDate}');
                  // print('== Pending Future List >> ${missedFutureExercises}');
                  // print('== complete Future List >> ${completeExercise}');
                  // print('-------------------- selected day ${controller.selectedDay}');
                  print('-------------------- DayList ${controller.dayList}');

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
                                          colors:
                                              ColorUtilsGradient.kTintGradient,
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter),
                                      borderRadius: BorderRadius.circular(
                                          Get.height * .05)),
                                  tabs: [
                                    tabBarCommonTab(
                                        icon: Icons.calendar_today_outlined,
                                        tabName: 'Calendar'),
                                    tabBarCommonTab(
                                        icon: Icons.list_sharp,
                                        tabName: 'List View'),
                                  ]),
                            ),
                          ),
                          Expanded(
                            child: TabBarView(children: [
                              Padding(
                                padding:
                                    EdgeInsets.only(top: Get.height * 0.02),
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            allowViewNavigation: false,
                                            // enablePastDates: false,
                                            controller: controller
                                                .dateRangePickerController,
                                            initialDisplayDate:
                                                controller.dayList.isNotEmpty
                                                    ? controller.dayList.first
                                                    : DateTime.now(),
                                            todayHighlightColor:
                                                ColorUtils.kTint,
                                            selectionColor: Colors.transparent,
                                            minDate: DateTime.utc(2019, 01, 01),
                                            maxDate: DateTime.utc(2099, 12, 31),
                                            selectionTextStyle: FontTextStyle
                                                .kBlack18w600Roboto,
                                            enableMultiView: false,
                                            yearCellStyle:
                                                DateRangePickerYearCellStyle(
                                                    textStyle:
                                                        FontTextStyle
                                                            .kWhite17W400Roboto,
                                                    todayTextStyle:
                                                        FontTextStyle
                                                            .kWhite17W400Roboto,
                                                    disabledDatesTextStyle:
                                                        FontTextStyle
                                                            .kLightGray16W300Roboto),
                                            cellBuilder: (BuildContext context,
                                                DateRangePickerCellDetails
                                                    details) {
                                              return Padding(
                                                padding: EdgeInsets.all(4),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      // color: controller.dayList
                                                      //         .contains(details.date)
                                                      //     ? completeExercise.contains(
                                                      //             details.date)
                                                      //         ? ColorUtils.kGreen
                                                      //         : missedExercises.contains(
                                                      //                 details.date)
                                                      //             ? ColorUtils.kRed
                                                      //             : ColorUtils.kTint
                                                      //     : ColorUtils.kBlack,
                                                      gradient: controller.dayList.contains(
                                                              details.date)
                                                          ? controller.completeDate.contains(details.date
                                                                  .toString()
                                                                  .split(' ')
                                                                  .first)
                                                              ? LinearGradient(
                                                                  colors: ColorUtilsGradient.kGreenGradient,
                                                                  begin: Alignment.topCenter,
                                                                  end: Alignment.bottomCenter,
                                                                  stops: [
                                                                      0.0,
                                                                      0.7
                                                                    ])
                                                              : controller.missedPastDate.contains(details
                                                                      .date
                                                                      .toString()
                                                                      .split(
                                                                          ' ')
                                                                      .first)
                                                                  ? LinearGradient(
                                                                      colors: ColorUtilsGradient.kRedGradient,
                                                                      begin: Alignment.topCenter,
                                                                      end: Alignment.bottomCenter,
                                                                      stops: [
                                                                          0.0,
                                                                          0.7
                                                                        ])
                                                                  : LinearGradient(
                                                                      colors: ColorUtilsGradient.kTintGradient,
                                                                      begin: Alignment.topCenter,
                                                                      end: Alignment.bottomCenter,
                                                                      stops: [0.0, 0.7])
                                                          : LinearGradient(colors: [Colors.transparent, Colors.transparent]),
                                                      shape: BoxShape.circle),
                                                  child: Text(
                                                    details.date.day.toString(),
                                                    style: controller.dayList
                                                            .contains(
                                                                details.date)
                                                        ? controller.missedPastDate
                                                                    .contains(details
                                                                        .date
                                                                        .toString()
                                                                        .split(
                                                                            ' ')
                                                                        .first) ||
                                                                controller
                                                                    .completeDate
                                                                    .contains(details
                                                                        .date
                                                                        .toString()
                                                                        .split(
                                                                            ' ')
                                                                        .first)
                                                            ? FontTextStyle
                                                                .kWhite17W400Roboto
                                                            : FontTextStyle
                                                                .kBlack18w600Roboto
                                                        : FontTextStyle
                                                            .kWhite17W400Roboto,
                                                  ),
                                                ),
                                              );
                                            },
                                            monthCellStyle:
                                                DateRangePickerMonthCellStyle(
                                              todayCellDecoration:
                                                  BoxDecoration(
                                                      color:
                                                          Colors.transparent),
                                              disabledDatesTextStyle:
                                                  FontTextStyle
                                                      .kLightGray16W300Roboto,
                                              // blackoutDateTextStyle:
                                              //     FontTextStyle.kWhite17W400Roboto,
                                              // blackoutDatesDecoration: BoxDecoration(
                                              //     color: ColorUtils.kRed,
                                              //     shape: BoxShape.circle),
                                              textStyle: FontTextStyle
                                                  .kWhite17W400Roboto,
                                              todayTextStyle: FontTextStyle
                                                  .kWhite17W400Roboto,
                                            ),
                                            selectionMode:
                                                DateRangePickerSelectionMode
                                                    .multiple,
                                            // initialSelectedDates: controller.dayList,
                                            monthViewSettings:
                                                DateRangePickerMonthViewSettings(
                                              firstDayOfWeek: 1,
                                              dayFormat: 'EEE',
                                              // blackoutDates: holiday,
                                              viewHeaderStyle:
                                                  DateRangePickerViewHeaderStyle(
                                                      textStyle: FontTextStyle
                                                          .kWhite17W400Roboto),
                                            ),

                                            headerStyle:
                                                DateRangePickerHeaderStyle(
                                              textAlign: TextAlign.center,
                                              textStyle: FontTextStyle
                                                  .kWhite20BoldRoboto,
                                            ),

                                            onSelectionChanged:
                                                (DateRangePickerSelectionChangedArgs
                                                    args) {
                                              controller
                                                      .dateRangePickerController
                                                      .selectedDates =
                                                  controller.dayList;

                                              controller.selectedDay =
                                                  args.value.last;
                                              args.value.clear();

                                              setState(() {});
                                            },
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
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: Get.width * .01),
                                        child: Text(
                                          '${Jiffy(controller.selectedDay).format('EEEE, MMMM do')}',
                                          style:
                                              FontTextStyle.kWhite16BoldRoboto,
                                        ),
                                      ),

                                      controller.dayList
                                              .contains(controller.selectedDay)
                                          ? ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  scheduleResponse.data!.length,
                                              itemBuilder: (_, index) {
                                                List<String> finalDate =
                                                    controller.selectedDay
                                                        .toString()
                                                        .split(" ");
                                                // print(" -=-=-==-=-=-= ${finalDate[0]}");
                                                // print(
                                                //     'date from api ${scheduleResponse.data![index].date}');
                                                // print(
                                                //     "condition ========= ${scheduleResponse.data![index].date == finalDate[0]}");
                                                if (scheduleResponse
                                                        .data![index].date ==
                                                    finalDate[0]) {
                                                  return ListView.builder(
                                                      itemCount:
                                                          scheduleResponse
                                                              .data![index]
                                                              .programData!
                                                              .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemBuilder: (_, index1) {
                                                        return ListTile(
                                                            title: Text(
                                                              scheduleResponse
                                                                  .data![index]
                                                                  .programData![
                                                                      index1]
                                                                  .workoutTitle!,
                                                              style: FontTextStyle
                                                                  .kWhite17BoldRoboto,
                                                            ),
                                                            subtitle: scheduleResponse
                                                                        .data![
                                                                            index]
                                                                        .programData![
                                                                            0]
                                                                        .exerciseTitle ==
                                                                    null
                                                                ? SizedBox()
                                                                : Text(
                                                                    '${scheduleResponse.data![index].programData![0].exerciseTitle}' +
                                                                        " - " +
                                                                        ' ${scheduleResponse.data![index].programData![0].exerciseTitle} ',
                                                                    style: FontTextStyle
                                                                        .kLightGray16W300Roboto,
                                                                  ),
                                                            trailing: InkWell(
                                                              onTap: () {
                                                                print(
                                                                    'HELLOOOOOO');
                                                                print(
                                                                    'date>>>>><<<<< ${scheduleResponse.data![index].date}');

                                                                openBottomSheet(
                                                                    scheduleByDateViewModel:
                                                                        controller,
                                                                    removeWorkoutProgramViewModel:
                                                                        _removeWorkoutProgramViewModel,
                                                                    context:
                                                                        context,
                                                                    date: scheduleResponse
                                                                        .data![
                                                                            index]
                                                                        .date,
                                                                    // onPressedStart:
                                                                    //     () {
                                                                    //   print(
                                                                    //       'date>>>>> ${scheduleResponse.data![index].date}');
                                                                    //
                                                                    //   // Get.back();
                                                                    //   getExercisesId(
                                                                    //     scheduleResponse
                                                                    //         .data![index]
                                                                    //         .date!,
                                                                    //   );
                                                                    // },
                                                                    event: scheduleResponse
                                                                            .data![
                                                                        index],
                                                                    onPressedView:
                                                                        () {
                                                                      Get.to(() =>
                                                                          PlanOverviewScreen(
                                                                              id: "${scheduleResponse.data![index].programData![0].workoutId}"));
                                                                    },
                                                                    onPressedEdit:
                                                                        () {
                                                                      Get.to(() =>
                                                                          ProgramSetupPage(
                                                                            day:
                                                                                '1',
                                                                            workoutName:
                                                                                scheduleResponse.data![index].programData![0].workoutTitle,
                                                                            workoutId:
                                                                                scheduleResponse.data![index].programData![0].workoutId,
                                                                            exerciseId:
                                                                                scheduleResponse.data![index].programData![0].exerciseId,
                                                                            programData:
                                                                                scheduleResponse.data![index].programData,
                                                                            isEdit:
                                                                                true,
                                                                            workoutProgramId:
                                                                                scheduleResponse.data![index].userProgramId,
                                                                          ));
                                                                    });
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .more_horiz_sharp,
                                                                color:
                                                                    ColorUtils
                                                                        .kTint,
                                                              ),
                                                            ));
                                                      });
                                                } else {
                                                  return SizedBox();
                                                }
                                              })
                                          : Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: Get.height * .03,
                                                  vertical: Get.height * .02),
                                              child: Text('No Exercises Today',
                                                  style: FontTextStyle
                                                      .kWhite17BoldRoboto),
                                            ),
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
            )
          : ConnectionCheckScreen();
    });
  }

  AppBar appBarWidget() {
    return AppBar(
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            // _scheduleByDateViewModel.selectedDay = DateTime(
            //     DateTime.now().year,
            //     DateTime.now().month,
            //     DateTime.now().day);
            // _scheduleByDateViewModel.dayList.clear();
            //
            // _scheduleByDateViewModel
            //     .dateRangePickerController.selectedDates!
            //     .clear();
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: ColorUtils.kTint,
          )),
      backgroundColor: ColorUtils.kBlack,
      title: Text('My Schedule', style: FontTextStyle.kWhite16BoldRoboto),
      centerTitle: true,
    );
  }

  getExercisesId(String time) async {
    // print("called 123");
    // print('hello........................3');
    // print('$time........................time');
    // print('$time........................date');
    await _userWorkoutsDateViewModel.getUserWorkoutsDateDetails(
        userId: PreferenceManager.getUId(), date: time);

    if (_userWorkoutsDateViewModel.apiResponse.status == Status.COMPLETE) {
      // print("complete api call");
      UserWorkoutsDateResponseModel resp =
          _userWorkoutsDateViewModel.apiResponse.data;

      // print("--------------- dates ${resp.msg}");
      //
      // print("success ------------- true");

      if (resp.success == true) {
        _userWorkoutsDateViewModel.supersetExerciseId.clear();
        _userWorkoutsDateViewModel.exerciseId.clear();

        print(
            'supersetExerciseId >>>>>>>>>>>>>> ${_userWorkoutsDateViewModel.supersetExerciseId}');
        print(
            'exerciseId >>>>>>>>>>>>>> ${_userWorkoutsDateViewModel.exerciseId}');
        print(
            'userProgramDatesId >>>>>>>>>>>>>> ${_userWorkoutsDateViewModel.userProgramDateID}');

        _userWorkoutsDateViewModel.exerciseId = resp.data!.exercisesIds!;
        _userWorkoutsDateViewModel.userProgramDateID =
            resp.data!.userProgramDatesId!;

        if (resp.data!.supersetExercisesIds! != [] ||
            resp.data!.supersetExercisesIds!.isNotEmpty) {
          _userWorkoutsDateViewModel.supersetExerciseId =
              resp.data!.supersetExercisesIds!;
        } else {
          _userWorkoutsDateViewModel.supersetExerciseId = [];
        }

        // print(
        //     'NEXT supersetExerciseId >>>>>>>>>>>>>> ${_userWorkoutsDateViewModel.supersetExerciseId}');
        // print(
        //     'NEXT exerciseId >>>>>>>>>>>>>> ${_userWorkoutsDateViewModel.exerciseId}');
        // print(
        //     'NEXT userProgramDatesId >>>>>>>>>>>>>> ${_userWorkoutsDateViewModel.userProgramDateID}');

        await _exerciseByIdViewModel.getExerciseByIdDetails(
            id: _userWorkoutsDateViewModel
                    .exerciseId[_userWorkoutsDateViewModel.exeIdCounter] ??
                '1');

        ExerciseByIdResponseModel exerciseResponse =
            _exerciseByIdViewModel.apiResponse.data;

        await _workoutByIdViewModel.getWorkoutByIdDetails(
            id: resp.data!.workoutId ?? '1');

        WorkoutByIdResponseModel workoutResponse =
            _workoutByIdViewModel.apiResponse.data;
        print('Workout id === ${workoutResponse.data![0].workoutId}');
        Get.to(() => WorkoutHomeScreen(
              workoutId: workoutResponse.data![0].workoutId,
              exeData: exerciseResponse.data!,
              data: workoutResponse.data!,
              date: _scheduleByDateViewModel.selectedDay
                  .toString()
                  .split(' ')
                  .first,
            ));
        // print('workoutResponse>>>>>>  ${workoutResponse.data}');
      } else {
        print("success ------------- false");
      }
    }
  }
}
