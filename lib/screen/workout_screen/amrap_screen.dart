import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/workout_screen/super_set_second_screen.dart';
import 'package:tcm/screen/workout_screen/widget/workout_widgets.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';

class AMPRAPScreen extends StatefulWidget {
  const AMPRAPScreen({Key? key}) : super(key: key);

  @override
  State<AMPRAPScreen> createState() => _AMPRAPScreenState();
}

class _AMPRAPScreenState extends State<AMPRAPScreen> {
  List<String> exeName = [
    "Dead Lift",
    "Air Squats",
    "Bicep Curls",
  ];
  bool isBegin = true;

  @override
  Widget build(BuildContext context) {
    // if (!isBegin) {
    //   return StatesAMRAPScreen(
    //     isBegin: isBegin,
    //   );
    // } else {
    //   return BeginAMRAPScreen();
    // }
    return DoneAMRAPScreen();
  }
}

class StatesAMRAPScreen extends StatefulWidget {
  final bool isBegin;
  const StatesAMRAPScreen({Key? key, required this.isBegin}) : super(key: key);

  @override
  State<StatesAMRAPScreen> createState() => _StatesAMRAPScreenState();
}

class _StatesAMRAPScreenState extends State<StatesAMRAPScreen> {
  List<String> exeName = [
    "Dead Lift",
    "Air Squats",
    "Bicep Curls",
  ];
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
        title: Text('AMRAP', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () {
                Get.offAll(HomeScreen());
              },
              child: Text(
                'Quit',
                style: FontTextStyle.kTine16W400Roboto,
              ))
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          width: Get.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * .025),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * .027),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'AMRAP',
                      style: FontTextStyle.kWhite24BoldRoboto
                          .copyWith(fontSize: Get.height * .03),
                    ),
                    SizedBox(height: Get.height * .015),
                    SizedBox(
                      width: Get.height * .28,
                      child: Text('Do as many rounds as possible in 5 minutes.',
                          style: FontTextStyle.kLightGray18W300Roboto,
                          textAlign: TextAlign.center),
                    ),
                    // SizedBox(height: Get.height * .008),
                    // Text('30 secs rest between rounds',
                    //     style: FontTextStyle.kLightGray18W300Roboto),
                  ],
                ),
              ),
              // Container(
              //   height: Get.height * .055,
              //   width: Get.width * .33,
              //   decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //           colors: ColorUtilsGradient.kGrayGradient,
              //           begin: Alignment.topCenter,
              //           end: Alignment.bottomCenter),
              //       borderRadius: BorderRadius.circular(6)),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text('Round', style: FontTextStyle.kWhite18BoldRoboto),
              //       SizedBox(width: Get.width * .02),
              //       CircleAvatar(
              //           radius: Get.height * .019,
              //           backgroundColor: ColorUtils.kTint,
              //           child: Text(
              //             '1',
              //             style: FontTextStyle.kBlack20BoldRoboto,
              //           )),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: EdgeInsets.only(
              //       top: Get.height * .03,
              //       left: Get.height * .025,
              //       right: Get.height * .025),
              //   child: SizedBox(
              //     width: Get.width,
              //     child: ListView.builder(
              //         shrinkWrap: true,
              //         itemCount: exeName.length,
              //         physics: NeverScrollableScrollPhysics(),
              //         itemBuilder: (_, index) {
              //           return exeName[index] != "Foam Roll Chest"
              //               ? Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Row(
              //                       children: [
              //                         Text('${exeName[index]}',
              //                             style: FontTextStyle.kWhite24BoldRoboto
              //                                 .copyWith(
              //                               fontSize: Get.height * .026,
              //                             )),
              //                         Spacer(),
              //                         GestureDetector(
              //                           onTap: () {},
              //                           child: Image.asset(
              //                             AppIcons.info,
              //                             height: Get.height * 0.03,
              //                             width: Get.height * 0.03,
              //                             color: ColorUtils.kTint,
              //                           ),
              //                         ),
              //                         SizedBox(width: Get.width * .03),
              //                         GestureDetector(
              //                           onTap: () {},
              //                           child: Image.asset(
              //                             AppIcons.compareArrow,
              //                             height: Get.height * 0.03,
              //                             width: Get.height * 0.03,
              //                             color: ColorUtils.kTint,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     SizedBox(height: Get.height * .005),
              //                     Text(
              //                       '10 reps',
              //                       style: FontTextStyle.kLightGray18W300Roboto,
              //                     ),
              //                     SizedBox(height: Get.height * .0075),
              //                     Divider(
              //                         height: Get.height * .06,
              //                         color: ColorUtils.kLightGray)
              //                   ],
              //                 )
              //               : Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     Row(
              //                       children: [
              //                         Text('${exeName[index]}',
              //                             style: FontTextStyle.kWhite24BoldRoboto
              //                                 .copyWith(
              //                               fontSize: Get.height * .026,
              //                             )),
              //                         SizedBox(width: Get.width * .03),
              //                         GestureDetector(
              //                           onTap: () {},
              //                           child: Image.asset(
              //                             AppIcons.play,
              //                             height: Get.height * 0.03,
              //                             width: Get.height * 0.03,
              //                             color: ColorUtils.kTint,
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     SizedBox(height: Get.height * .005),
              //                     Text(
              //                       '30 seconds each side',
              //                       style: FontTextStyle.kLightGray18W300Roboto,
              //                     ),
              //                     SizedBox(height: Get.height * .0075),
              //                     SizedBox(
              //                       height: Get.height * 0.02,
              //                     ),
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         GestureDetector(
              //                           onTap: () {
              //                             print('Start Pressed');
              //                           },
              //                           child: Container(
              //                             alignment: Alignment.center,
              //                             height: Get.height * .047,
              //                             width: Get.width * .25,
              //                             decoration: BoxDecoration(
              //                               borderRadius:
              //                                   BorderRadius.circular(6),
              //                               gradient: LinearGradient(
              //                                 begin: Alignment.topCenter,
              //                                 end: Alignment.bottomCenter,
              //                                 stops: [0.0, 1.0],
              //                                 colors: ColorUtilsGradient
              //                                     .kTintGradient,
              //                               ),
              //                             ),
              //                             child: Text(
              //                               'Start',
              //                               style: FontTextStyle
              //                                   .kBlack18w600Roboto
              //                                   .copyWith(
              //                                       fontWeight: FontWeight.bold,
              //                                       fontSize: Get.height * 0.02),
              //                             ),
              //                           ),
              //                         ),
              //                         SizedBox(width: Get.width * 0.05),
              //                         GestureDetector(
              //                           onTap: () {
              //                             print('Reset pressed ');
              //                           },
              //                           child: Container(
              //                             alignment: Alignment.center,
              //                             height: Get.height * .047,
              //                             width: Get.width * .25,
              //                             decoration: BoxDecoration(
              //                                 borderRadius:
              //                                     BorderRadius.circular(6),
              //                                 border: Border.all(
              //                                     color: ColorUtils.kTint,
              //                                     width: 1.5)),
              //                             child: Text(
              //                               'Reset',
              //                               style:
              //                                   FontTextStyle.kTine17BoldRoboto,
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     Divider(
              //                         height: Get.height * .06,
              //                         color: ColorUtils.kLightGray)
              //                   ],
              //                 );
              //         }),
              //   ),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${exeName[0]}',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * .026,
                          )),
                      Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          AppIcons.info,
                          height: Get.height * 0.03,
                          width: Get.height * 0.03,
                          color: ColorUtils.kTint,
                        ),
                      ),
                      SizedBox(width: Get.width * .03),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          AppIcons.compareArrow,
                          height: Get.height * 0.03,
                          width: Get.height * 0.03,
                          color: ColorUtils.kTint,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * .005),
                  Text(
                    '8-10 reps',
                    style: FontTextStyle.kLightGray18W300Roboto,
                  ),
                  SizedBox(height: Get.height * .0075),
                  SizedBox(
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Weight you will use: ',
                          style: FontTextStyle.kLightGray20W600Roboto,
                        ),
                        SizedBox(width: Get.width * .03),
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * .08,
                          width: Get.width * .3,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                              colors: ColorUtilsGradient.kGrayGradient,
                            ),
                          ),
                          child: RichText(
                              text: TextSpan(
                                  text: "135 ",
                                  style: FontTextStyle.kWhite24BoldRoboto,
                                  children: [
                                TextSpan(
                                    text: "lbs",
                                    style: FontTextStyle.kLightGray18W300Roboto)
                              ])),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * .06),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${exeName[1]}',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * .026,
                          )),
                      Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          AppIcons.info,
                          height: Get.height * 0.03,
                          width: Get.height * 0.03,
                          color: ColorUtils.kTint,
                        ),
                      ),
                      SizedBox(width: Get.width * .03),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          AppIcons.compareArrow,
                          height: Get.height * 0.03,
                          width: Get.height * 0.03,
                          color: ColorUtils.kTint,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * .005),
                  Text(
                    '30 reps',
                    style: FontTextStyle.kLightGray18W300Roboto,
                  ),
                  SizedBox(height: Get.height * .06),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('${exeName[2]}',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * .026,
                          )),
                      Spacer(),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          AppIcons.info,
                          height: Get.height * 0.03,
                          width: Get.height * 0.03,
                          color: ColorUtils.kTint,
                        ),
                      ),
                      SizedBox(width: Get.width * .03),
                      GestureDetector(
                        onTap: () {},
                        child: Image.asset(
                          AppIcons.compareArrow,
                          height: Get.height * 0.03,
                          width: Get.height * 0.03,
                          color: ColorUtils.kTint,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * .005),
                  Text(
                    '10 reps',
                    style: FontTextStyle.kLightGray18W300Roboto,
                  ),
                  SizedBox(
                    width: Get.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Weight you will use: ',
                          style: FontTextStyle.kLightGray20W600Roboto,
                        ),
                        SizedBox(width: Get.width * .03),
                        Container(
                          alignment: Alignment.center,
                          height: Get.height * .08,
                          width: Get.width * .3,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.0, 1.0],
                              colors: ColorUtilsGradient.kGrayGradient,
                            ),
                          ),
                          child: RichText(
                              text: TextSpan(
                                  text: "45 ",
                                  style: FontTextStyle.kWhite24BoldRoboto,
                                  children: [
                                TextSpan(
                                    text: "lbs",
                                    style: FontTextStyle.kLightGray18W300Roboto)
                              ])),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * .06),
                ],
              ),
              // Container(
              //     margin: EdgeInsets.only(
              //         top: Get.height * .01,
              //         bottom: Get.height * .04,
              //         left: Get.height * .025,
              //         right: Get.height * .025),
              //     alignment: Alignment.center,
              //     width: Get.width,
              //     height: Get.height * .055,
              //     decoration: BoxDecoration(
              //         color: ColorUtils.kSaperatedGray,
              //         borderRadius: BorderRadius.circular(6)),
              //     child: Text(
              //       '30 second rest',
              //       style: FontTextStyle.kWhite17W400Roboto,
              //     )),
              Padding(
                  padding: EdgeInsets.only(
                      left: Get.height * .03,
                      right: Get.height * .03,
                      bottom: Get.height * .05),
                  child: commonNavigationButton(
                      name: "Begin AMRAP",
                      onTap: () {
                        Get.to(SuperSetSecondScreen());
                      }))
            ]),
          ),
        ),
      ),
    );
  }
}

class BeginAMRAPScreen extends StatefulWidget {
  const BeginAMRAPScreen({Key? key}) : super(key: key);

  @override
  State<BeginAMRAPScreen> createState() => _BeginAMRAPScreenState();
}

class _BeginAMRAPScreenState extends State<BeginAMRAPScreen>
    with SingleTickerProviderStateMixin {
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;
  TimerController? _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  List<String> exeName = [
    "Dead Lift",
    "Air Squats",
    "Bicep Curls",
  ];

  void initState() {
    // TODO: implement initState
    _timerController = TimerController(this);
    super.initState();
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
          title: Text('AMRAP', style: FontTextStyle.kWhite16BoldRoboto),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  Get.offAll(HomeScreen());
                },
                child: Text(
                  'Quit',
                  style: FontTextStyle.kTine16W400Roboto,
                ))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * .027),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'AMRAP',
                  style: FontTextStyle.kWhite24BoldRoboto
                      .copyWith(fontSize: Get.height * .03),
                ),
                GestureDetector(
                  onTap: () {
                    _timerController!.start();
                  },
                  child: Center(
                      child: Container(
                    height: Get.height * 0.3,
                    width: Get.height * 0.3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: SimpleTimer(
                      duration: Duration(seconds: int.parse("300")),
                      controller: _timerController,
                      timerStyle: _timerStyle,
                      progressTextFormatter: (format) {
                        return formattedTime(timeInSecond: format.inSeconds);
                      },
                      backgroundColor: ColorUtils.kGray,
                      progressIndicatorColor: ColorUtils.kTint,
                      progressIndicatorDirection: _progressIndicatorDirection,
                      progressTextCountDirection: _progressTextCountDirection,
                      progressTextStyle: FontTextStyle.kWhite24BoldRoboto
                          .copyWith(fontSize: Get.height * 0.025),
                      strokeWidth: 15,
                      onStart: () {},
                      onEnd: () {
                        _timerController!.stop();
                      },
                    ),
                  )),
                ),
                Column(
                  children: [
                    Text('${exeName[0]}',
                        style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                          fontSize: Get.height * .026,
                        )),
                    SizedBox(height: Get.height * .005),
                    Text(
                      '8-10 reps at 135 lbs',
                      style: FontTextStyle.kLightGray18W300Roboto,
                    ),
                    SizedBox(height: Get.height * .0075),
                  ],
                ),
                Column(
                  children: [
                    Text('${exeName[1]}',
                        style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                          fontSize: Get.height * .026,
                        )),
                    SizedBox(height: Get.height * .005),
                    Text(
                      '30 reps',
                      style: FontTextStyle.kLightGray18W300Roboto,
                    ),
                    SizedBox(height: Get.height * .0075),
                  ],
                ),
                Column(
                  children: [
                    Text('${exeName[2]}',
                        style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                          fontSize: Get.height * .026,
                        )),
                    SizedBox(height: Get.height * .005),
                    Text(
                      '8-10 reps at 45 lbs',
                      style: FontTextStyle.kLightGray18W300Roboto,
                    ),
                    SizedBox(height: Get.height * .0075),
                  ],
                ),
              ]),
        ));
  }
}

class DoneAMRAPScreen extends StatefulWidget {
  const DoneAMRAPScreen({Key? key}) : super(key: key);

  @override
  State<DoneAMRAPScreen> createState() => _DoneAMRAPScreenState();
}

class _DoneAMRAPScreenState extends State<DoneAMRAPScreen>
    with SingleTickerProviderStateMixin {
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;
  TimerController? _timerController;
  TimerStyle _timerStyle = TimerStyle.ring;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  List<String> exeName = [
    "Dead Lift",
    "Air Squats",
    "Bicep Curls",
  ];

  void initState() {
    // TODO: implement initState
    _timerController = TimerController(this);
    super.initState();
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
          title: Text('AMRAP', style: FontTextStyle.kWhite16BoldRoboto),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  Get.offAll(HomeScreen());
                },
                child: Text(
                  'Quit',
                  style: FontTextStyle.kTine16W400Roboto,
                ))
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: Get.height * .027),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'AMRAP',
                  style: FontTextStyle.kWhite24BoldRoboto
                      .copyWith(fontSize: Get.height * .03),
                ),
                GestureDetector(
                  onTap: () {
                    // _timerController!.start();
                  },
                  child: Center(
                      child: Container(
                    height: Get.height * 0.3,
                    width: Get.height * 0.3,
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: SimpleTimer(
                      duration: Duration(seconds: int.parse("300")),
                      controller: _timerController,
                      timerStyle: _timerStyle,
                      progressTextFormatter: (format) {
                        return "DONE";
                      },
                      backgroundColor: ColorUtils.kGray,
                      progressIndicatorColor: ColorUtils.kTint,
                      progressIndicatorDirection: _progressIndicatorDirection,
                      progressTextCountDirection: _progressTextCountDirection,
                      progressTextStyle: FontTextStyle.kWhite24BoldRoboto
                          .copyWith(fontSize: Get.height * 0.025),
                      strokeWidth: 15,
                      onStart: () {},
                      onEnd: () {
                        _timerController!.stop();
                      },
                    ),
                  )),
                ),
                Text(
                  'enter the number of rounds completed',
                  style: FontTextStyle.kLightGray18W300Roboto,
                ),

                Padding(
                  padding: EdgeInsets.only(
                      left: Get.height * .03,
                      right: Get.height * .03,
                      bottom: Get.height * .02),
                  child: NoWeightedCounterCard(counter: 12, repsNo: "12"),
                ),
                SizedBox(height: Get.height * .1),
                Padding(
                    padding: EdgeInsets.only(
                        left: Get.height * .03,
                        right: Get.height * .03,
                        bottom: Get.height * .02),
                    child: commonNavigationButton(
                        name: "Next Exercise",
                        onTap: () {
                          Get.to(SuperSetSecondScreen());
                        }))

                // Column(
                //   children: [
                //     Text('${exeName[0]}',
                //         style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                //           fontSize: Get.height * .026,
                //         )),
                //     SizedBox(height: Get.height * .005),
                //     Text(
                //       '8-10 reps at 135 lbs',
                //       style: FontTextStyle.kLightGray18W300Roboto,
                //     ),
                //     SizedBox(height: Get.height * .0075),
                //   ],
                // ),
                // Column(
                //   children: [
                //     Text('${exeName[1]}',
                //         style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                //           fontSize: Get.height * .026,
                //         )),
                //     SizedBox(height: Get.height * .005),
                //     Text(
                //       '30 reps',
                //       style: FontTextStyle.kLightGray18W300Roboto,
                //     ),
                //     SizedBox(height: Get.height * .0075),
                //   ],
                // ),
                // Column(
                //   children: [
                //     Text('${exeName[2]}',
                //         style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                //           fontSize: Get.height * .026,
                //         )),
                //     SizedBox(height: Get.height * .005),
                //     Text(
                //       '8-10 reps at 45 lbs',
                //       style: FontTextStyle.kLightGray18W300Roboto,
                //     ),
                //     SizedBox(height: Get.height * .0075),
                //   ],
                // ),
              ]),
        ));
  }
}
