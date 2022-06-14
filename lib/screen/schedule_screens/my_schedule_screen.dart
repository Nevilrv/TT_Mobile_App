import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/custom_packages/table_calender/customization/calendar_style.dart';
import 'package:tcm/custom_packages/table_calender/customization/days_of_week_style.dart';
import 'package:tcm/custom_packages/table_calender/customization/header_style.dart';
import 'package:tcm/custom_packages/table_calender/shared/utils.dart';
import 'package:tcm/custom_packages/table_calender/table_calendar.dart';
import 'package:tcm/screen/schedule_screens/widgets/my_schedule_screen_widget.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';

class MyScheduleScreen extends StatefulWidget {
  @override
  State<MyScheduleScreen> createState() => _MyScheduleScreenState();
}

class _MyScheduleScreenState extends State<MyScheduleScreen>
    with AutomaticKeepAliveClientMixin<MyScheduleScreen> {
  bool? switchSelected = false;
  var tabs = ['Calender', 'List View'];
  int? focusSelected = 0;

  DateTime _focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  Map<DateTime, List> _eventsList = {};

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;

    _eventsList = {
      DateTime.now(): [
        {
          'title': 'Chest and Back Blast',
          'subtitle': 'Day 1 - Chest and Traps'
        },
        {'title': 'Legs', 'subtitle': ' Day 2 - Legs'},
        {
          'title': 'Biceps and Shoulder',
          'subtitle': 'Day 3 - Biceps and Shoulder'
        },
        {'title': 'Killer Core', 'subtitle': 'Day 4 - Killer Core'}
      ],
    };
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(_eventsList);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

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
      body: DefaultTabController(
        length: 2,
        child: Padding(
          padding: EdgeInsets.only(
              left: Get.width * 0.06,
              right: Get.width * 0.06,
              top: Get.height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: Get.height * .04,
                  width: Get.width * .6,
                  decoration: BoxDecoration(
                      color: ColorUtils.kGray,
                      borderRadius: BorderRadius.circular(Get.height * .05)),
                  child: TabBar(
                      physics: BouncingScrollPhysics(),
                      unselectedLabelColor: Colors.white,
                      unselectedLabelStyle: FontTextStyle.kWhite16BoldRoboto,
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
                        tabbarCommonTab(
                            icon: Icons.calendar_today_outlined,
                            tabName: 'Calendar'),
                        tabbarCommonTab(
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * .03),
                            child: TableCalendar(
                              calendarStyle: CalendarStyle(
                                  markerSize: 0,
                                  outsideDaysVisible: false,
                                  weekendTextStyle:
                                      FontTextStyle.kWhite17W400Roboto,
                                  defaultTextStyle:
                                      FontTextStyle.kWhite17W400Roboto,
                                  selectedTextStyle:
                                      FontTextStyle.kBlack18w600Roboto,
                                  selectedDecoration: BoxDecoration(
                                      color: ColorUtils.kTint,
                                      shape: BoxShape.circle),
                                  todayTextStyle:
                                      FontTextStyle.kWhite17W400Roboto,
                                  todayDecoration: BoxDecoration(
                                    color: Colors.transparent,
                                  )),
                              daysOfWeekHeight: Get.height * .05,
                              daysOfWeekStyle: DaysOfWeekStyle(
                                  // decoration: BoxDecoration(
                                  //     borderRadius: BorderRadius.circular(5),
                                  //     border:
                                  //         Border.all(color: ColorUtils.kGray)),
                                  weekdayStyle:
                                      FontTextStyle.kWhite17W400Roboto,
                                  weekendStyle:
                                      FontTextStyle.kWhite17W400Roboto),
                              headerStyle: HeaderStyle(
                                titleTextStyle:
                                    FontTextStyle.kWhite20BoldRoboto,
                                leftChevronIcon: Icon(
                                  Icons.arrow_back_ios_sharp,
                                  color: ColorUtils.kTint,
                                  size: Get.height * 0.025,
                                ),
                                rightChevronIcon: Icon(
                                  Icons.arrow_forward_ios_sharp,
                                  color: ColorUtils.kTint,
                                  size: Get.height * 0.025,
                                ),
                                formatButtonVisible: false,
                                titleCentered: true,
                              ),
                              availableGestures:
                                  AvailableGestures.horizontalSwipe,
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              focusedDay: _focusedDay,
                              firstDay: DateTime.utc(2018, 01, 01),
                              lastDay: DateTime.utc(2030, 12, 31),
                              calendarFormat: _calendarFormat,
                              eventLoader: _getEventForDay,
                              onFormatChanged: (format) {
                                if (_calendarFormat != format) {
                                  setState(() {
                                    _calendarFormat = format;
                                  });
                                }
                              },
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              onDaySelected: (selectedDay, focusedDay) {
                                if (!isSameDay(_selectedDay, selectedDay)) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                  });
                                }
                              },
                              onPageChanged: (focusedDay) {
                                focusedDay = focusedDay;
                              },
                            ),
                          ),
                          SizedBox(height: Get.width * 0.04),
                          Text(
                            AppText.scheduleWorkout,
                            style: FontTextStyle.kWhite18BoldRoboto,
                          ),
                          Divider(
                            color: ColorUtils.kTint,
                            thickness: 1.5,
                            height: Get.height * 0.04,
                          ),
                          ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: _getEventForDay(_selectedDay!)
                                .map((event) => ListTile(
                                      title: Text(
                                        event['title'].toString(),
                                        style: FontTextStyle.kWhite17BoldRoboto,
                                      ),
                                      subtitle: Text(
                                        event['subtitle'].toString(),
                                        style: FontTextStyle
                                            .kLightGray16W300Roboto,
                                      ),
                                      trailing: InkWell(
                                        onTap: () {
                                          openBottomSheet(event);
                                        },
                                        child: Icon(
                                          Icons.more_horiz_sharp,
                                          color: ColorUtils.kTint,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  listViewTab(
                      getEventForDay: _getEventForDay,
                      selectedDay: _selectedDay)
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
