import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/schedule_screens/my_schedule_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:table_calendar/table_calendar.dart';

class ProgramSetupPage extends StatefulWidget {
  @override
  State<ProgramSetupPage> createState() => _ProgramSetupPageState();
}

class _ProgramSetupPageState extends State<ProgramSetupPage> {
  DateTime _focusedDay = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
  }

  bool isSelected = false;
  bool _switchValue = true;

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
        title: Text('Setup Program', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.06, vertical: Get.height * 0.025),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    'Chest and Back Blast',
                    style: FontTextStyle.kWhite20BoldRoboto,
                  ),
                  SizedBox(height: Get.height * 0.01),
                  Text(
                    '4 days a week',
                    style: FontTextStyle.kLightGray16W300Roboto,
                  ),
                  SizedBox(height: Get.height * 0.04),
                  Text(
                    'What days do you want to workout?',
                    style: FontTextStyle.kWhite16BoldRoboto,
                  ),
                ],
              ),
              Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05,
                      vertical: Get.height * 0.045),
                  child: Container(
                    height: Get.height * 0.61,
                    width: Get.width,
                    child: ListView.separated(
                        separatorBuilder: (_, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Get.height * 0.01));
                        },
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: AppText.weekDays.length,
                        itemBuilder: (_, index) {
                          return InkWell(
                            onTap: () {
                              print('${AppText.weekDays[index]}');
                              setState(() {
                                if (isSelected) {
                                  isSelected = !isSelected;
                                } else {
                                  isSelected = true;
                                }
                              });
                            },
                            child: Container(
                              height: Get.height * 0.065,
                              width: Get.width,
                              decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(
                                          colors:
                                              ColorUtilsGradient.kTintGradient,
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter)
                                      : null,
                                  color: !isSelected ? ColorUtils.kBlack : null,
                                  borderRadius:
                                      BorderRadius.circular(Get.height * 0.1),
                                  border: !isSelected
                                      ? Border.all(color: ColorUtils.kTint)
                                      : null),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Get.width * 0.04),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    !isSelected
                                        ? SizedBox(
                                            height: Get.height * 0.05,
                                            width: Get.height * 0.05,
                                          )
                                        : Container(
                                            alignment: Alignment.center,
                                            height: Get.height * 0.05,
                                            width: Get.height * 0.05,
                                            decoration: BoxDecoration(
                                                color: ColorUtils.kBlack,
                                                shape: BoxShape.circle),
                                            child: Text(
                                              '1',
                                              style: FontTextStyle
                                                  .kTint20BoldRoboto,
                                            ),
                                          ),
                                    Text(AppText.weekDays[index],
                                        style: !isSelected
                                            ? FontTextStyle.kTint20BoldRoboto
                                            : FontTextStyle.kBlack20BoldRoboto),
                                    SizedBox(
                                      height: Get.height * 0.05,
                                      width: Get.height * 0.05,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  )),
              Divider(
                color: ColorUtils.kGray,
                thickness: 2,
                height: Get.height * 0.04,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Get.height * .02, horizontal: Get.width * .03),
                child: TableCalendar(
                  calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      weekendTextStyle: FontTextStyle.kWhite17W400Roboto,
                      defaultTextStyle: FontTextStyle.kWhite17W400Roboto,
                      selectedTextStyle: FontTextStyle.kBlack18w600Roboto,
                      selectedDecoration: BoxDecoration(
                          color: ColorUtils.kTint, shape: BoxShape.circle),
                      todayTextStyle: FontTextStyle.kBlack18w600Roboto,
                      todayDecoration: BoxDecoration(
                          color: ColorUtils.kTint.withOpacity(.6),
                          shape: BoxShape.circle)),
                  daysOfWeekHeight: Get.height * .05,
                  daysOfWeekStyle: DaysOfWeekStyle(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: ColorUtils.kGray)),
                      weekdayStyle: FontTextStyle.kWhite17W400Roboto,
                      weekendStyle: FontTextStyle.kWhite17W400Roboto),
                  headerStyle: HeaderStyle(
                    titleTextStyle: FontTextStyle.kWhite20BoldRoboto,
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
                  availableGestures: AvailableGestures.horizontalSwipe,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2018, 01, 01),
                  lastDay: DateTime.utc(2030, 12, 31),
                  calendarFormat: _calendarFormat,
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
                    _focusedDay = focusedDay;
                  },
                ),
              ),
              Divider(
                color: ColorUtils.kGray,
                thickness: 2,
                height: Get.height * 0.09,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: Get.height * .03),
                alignment: Alignment.center,
                height: Get.height * .045,
                width: Get.width * 0.27,
                decoration: BoxDecoration(
                    color: ColorUtils.kRed,
                    borderRadius: BorderRadius.circular(40)),
                child: Text(
                  'WARNING',
                  style: FontTextStyle.kWhite17BoldRoboto,
                ),
              ),
              AutoSizeText(
                AppText.warning,
                style: FontTextStyle.kWhite16BoldRoboto,
                maxLines: 2,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * .02),
                child: Text(
                  AppText.powerLifting,
                  style: FontTextStyle.kWhite20BoldRoboto,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      print('Keep Pressed');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Get.height * .05,
                      width: Get.width * .3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: LinearGradient(
                              colors: ColorUtilsGradient.kTintGradient,
                              begin: Alignment.center,
                              end: Alignment.center)),
                      child: Text(
                        'Keep',
                        style: FontTextStyle.kBlack18w600Roboto,
                      ),
                    ),
                  ),
                  SizedBox(width: Get.width * 0.05),
                  GestureDetector(
                    onTap: () {
                      print('Remove pressed ');
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: Get.height * .05,
                      width: Get.width * .3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border:
                              Border.all(color: ColorUtils.kTint, width: 1.5)),
                      child: Text(
                        'Remove',
                        style: FontTextStyle.kTine17BoldRoboto,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: ColorUtils.kGray,
                thickness: 2,
                height: Get.height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppText.getByEmail,
                      style:  TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Get.height * .02)),Spacer(),
                  CupertinoSwitch(
                    activeColor: ColorUtils.kTint,
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: Get.width * 0.05,
                    right: Get.width * 0.05,
                    top: Get.height * 0.03,
                    bottom: Get.height * 0.02),
                child: GestureDetector(
                  onTap: () {
                    Get.to(MyScheduleScreen());
                    print('Start Program presedddddddddd');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: Get.height * 0.06,
                    width: Get.width,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: ColorUtilsGradient.kTintGradient,
                            begin: Alignment.topCenter,
                            end: Alignment.topCenter),
                        borderRadius: BorderRadius.circular(Get.height * 0.1)),
                    child: Text('Start Program',
                        style: FontTextStyle.kBlack20BoldRoboto),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
