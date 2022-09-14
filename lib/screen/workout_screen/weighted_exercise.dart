import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/workout_screen/widget/workout_widgets.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/save_user_customized_exercise_viewModel.dart';

class WeightExerciseScreen extends StatefulWidget {
  List<ExerciseById> data;

  WeightExerciseScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<WeightExerciseScreen> createState() => _WeightExerciseScreenState();
}

class _WeightExerciseScreenState extends State<WeightExerciseScreen> {
  SaveUserCustomizedExerciseViewModel _customizedExerciseViewModel =
      Get.put(SaveUserCustomizedExerciseViewModel());
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  @override
  void initState() {
    _connectivityCheckViewModel.startMonitoring();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  int currPlayIndex = 0;
  int repsCounter = 0;

  int counterReps = 0;
  bool isShow = false;

  counterPlus() {
    setState(() {
      counterReps++;
    });
  }

  counterMinus() {
    setState(() {
      if (counterReps > 0) counterReps--;
    });
  }

  List colors = [
    [Color(0xff057C00), Color(0xff045500)],
    [Color(0xffFFA200), Color(0xff9E6400)],
    [Color(0xffFF0000), Color(0xff8B0303)]
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      bool loader = false;

      return GetBuilder<ConnectivityCheckViewModel>(
        builder: (control) => control.isOnline
            ? Scaffold(
                backgroundColor: ColorUtils.kBlack,
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () async {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: ColorUtils.kTint,
                      )),
                  backgroundColor: ColorUtils.kBlack,
                  title: Text('${widget.data[0].exerciseTitle}',
                      style: FontTextStyle.kWhite16BoldRoboto),
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
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * .06,
                              vertical: Get.height * .02),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: Get.width * 0.7,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '${widget.data[0].exerciseTitle}',
                                            style: FontTextStyle
                                                .kWhite24BoldRoboto,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            log('hello...');
                                          },
                                          child: Image.asset(
                                            AppIcons.play,
                                            height: Get.height * 0.03,
                                            width: Get.height * 0.03,
                                            color: ColorUtils.kTint,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.015,
                                ),
                                Text(
                                    '${widget.data[0].exerciseSets} sets of ${widget.data[0].exerciseReps} reps',
                                    style: FontTextStyle.kLightGray16W300Roboto
                                        .copyWith(
                                            fontSize: Get.height * 0.023,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontWeight: FontWeight.w300)),
                                SizedBox(
                                  child: ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 3,
                                      separatorBuilder: (_, index) {
                                        return Container(
                                          alignment: Alignment.center,
                                          height: Get.height * .03,
                                          width: Get.width,
                                          decoration: BoxDecoration(
                                              color: ColorUtils.kGray,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: Text(
                                              "${widget.data[0].exerciseRest} Seconds Rest",
                                              style: FontTextStyle
                                                  .kWhite17W400Roboto),
                                        );
                                      },
                                      itemBuilder: (_, index) {
                                        return Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            WeightedCounterCard(
                                              counter: int.parse(
                                                  '${widget.data[0].exerciseReps}'),
                                              repsNo:
                                                  '${widget.data[0].exerciseReps}',
                                            ),
                                            Positioned(
                                              top: Get.height * .01,
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: Get.height * .027,
                                                width: Get.height * .09,
                                                decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                        colors: colors[index],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    6),
                                                            bottomLeft: Radius
                                                                .circular(6))),
                                                child: Text('RIR 0-1',
                                                    style: FontTextStyle
                                                        .kWhite12BoldRoboto
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                              ),
                                            )
                                          ],
                                        );
                                      }),
                                ),
                                isShow == false
                                    ? SizedBox(height: Get.height * .25)
                                    : SizedBox(height: Get.height * .025),
                                commonNavigationButton(
                                    onTap: () async {
                                      //   print(
                                      //       'Save Exercise pressed!!!');
                                      //
                                      //   setState(() {
                                      //     loader = true;
                                      //   });
                                      //
                                      //   print(
                                      //       'loader ----------- $loader');
                                      //
                                      //   print(
                                      //       'counter out ----------------- $counterReps');
                                      //   if (counterReps <= 0) {
                                      //     Get.showSnackbar(GetSnackBar(
                                      //       message:
                                      //           'Please set reps more than 0',
                                      //       duration:
                                      //           Duration(seconds: 2),
                                      //     ));
                                      //   }
                                      //
                                      //   if (counterReps != 0 &&
                                      //       counterReps > 0) {
                                      //     print(
                                      //         'counter ----------------- $counterReps');
                                      //     SaveUserCustomizedExerciseRequestModel
                                      //         _request =
                                      //         SaveUserCustomizedExerciseRequestModel();
                                      //     _request.userId =
                                      //         PreferenceManager
                                      //             .getUId();
                                      //     _request.exerciseId =
                                      //         widget.data[0].exerciseId;
                                      //     _request.reps =
                                      //         '$counterReps';
                                      //     _request.isCompleted = '1';
                                      //
                                      //     await controllerSave
                                      //         .saveUserCustomizedExerciseViewModel(
                                      //             _request);
                                      //
                                      //     if (controllerSave
                                      //             .apiResponse.status ==
                                      //         Status.COMPLETE) {
                                      //       SaveUserCustomizedExerciseResponseModel
                                      //           responseSave =
                                      //           controllerSave
                                      //               .apiResponse.data;
                                      //
                                      //       setState(() {
                                      //         loader = false;
                                      //       });
                                      //       if (responseSave.success ==
                                      //               true &&
                                      //           responseSave.data !=
                                      //               null) {
                                      //         if ('${widget.data[0].exerciseVideo}'
                                      //             .contains(
                                      //                 'www.youtube.com')) {
                                      //           _youTubePlayerController
                                      //               ?.pause();
                                      //         } else {
                                      //           _videoPlayerController
                                      //               ?.pause();
                                      //           _chewieController
                                      //               ?.pause();
                                      //         }
                                      //
                                      //         Get.back();
                                      //         setState(() {
                                      //           counterReps = 0;
                                      //         });
                                      //         Get.showSnackbar(
                                      //             GetSnackBar(
                                      //           message:
                                      //               '${responseSave.msg}',
                                      //           duration: Duration(
                                      //               seconds: 2),
                                      //         ));
                                      //       } else if (responseSave
                                      //                   .msg ==
                                      //               null ||
                                      //           responseSave.msg ==
                                      //                   "" &&
                                      //               responseSave.data ==
                                      //                   null ||
                                      //           responseSave.data ==
                                      //               "") {
                                      //         setState(() {
                                      //           loader = false;
                                      //         });
                                      //         Get.showSnackbar(
                                      //             GetSnackBar(
                                      //           message:
                                      //               '${responseSave.msg}',
                                      //           duration: Duration(
                                      //               seconds: 2),
                                      //         ));
                                      //       }
                                      //     } else if (controllerSave
                                      //             .apiResponse.status ==
                                      //         Status.ERROR) {
                                      //       setState(() {
                                      //         loader = false;
                                      //       });
                                      //       Get.showSnackbar(
                                      //           GetSnackBar(
                                      //         message:
                                      //             'Something went wrong !!! please try again !!!',
                                      //         duration:
                                      //             Duration(seconds: 2),
                                      //       ));
                                      //     }
                                      //   }
                                    },
                                    name: 'Next Exercise'),
                                SizedBox(height: Get.height * .04),
                              ]),
                        ),
                      ]),
                ),
              )
            : ConnectionCheckScreen(),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: ColorUtils.kTint,
        ),
      );
    }
  }
}
