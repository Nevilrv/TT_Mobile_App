import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tcm/screen/schedule_screens/widgets/my_schedule_screen_widget.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';

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
                  calendarTab(
                    getEventForDay: _getEventForDay,
                    calendarFormat: _calendarFormat,
                    focusedDay: _focusedDay,
                    selectedDay: _selectedDay,
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
