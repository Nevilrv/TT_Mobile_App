import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/day_based_exercise_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/training_plan_viewModel/day_based_exercise_viewModel.dart';
import 'exercise_detail_page.dart';

class WorkoutOverviewPage extends StatefulWidget {
  final int day;
  final String workoutId;
  final String? workoutDay;
  final String? workoutName;

  WorkoutOverviewPage(
      {Key? key,
      required this.day,
      required this.workoutId,
      this.workoutDay,
      this.workoutName})
      : super(key: key);

  @override
  State<WorkoutOverviewPage> createState() => _WorkoutOverviewPageState();
}

class _WorkoutOverviewPageState extends State<WorkoutOverviewPage> {
  // DayViewModel _dayViewModel = Get.put(DayViewModel());
  DayBasedExerciseViewModel _dayBasedExerciseViewModel =
      Get.put(DayBasedExerciseViewModel());

  void initState() {
    // _dayViewModel.getWorkoutByDayDetail(widget.id);
    _dayBasedExerciseViewModel.getDayBasedExerciseDetails(
        id: widget.workoutId, day: widget.day.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DayBasedExerciseViewModel>(builder: (controller) {
      if (controller.apiResponse.status == Status.COMPLETE) {
        DayBasedExerciseResponseModel response = controller.apiResponse.data;
        // log('length -- - - - ${response.data!.length}');
        // log('data -------------- ${response.data!}');
        // if (response.data!.isNotEmpty && response.data != []) {
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
              title: Text('Day ${widget.day} Workout',
                  style: FontTextStyle.kWhite16BoldRoboto),
              centerTitle: true,
              actions: response.data!.isNotEmpty && response.data != []
                  ? [
                      Padding(
                          padding: const EdgeInsets.all(18),
                          child: InkWell(
                            onTap: () {
                              Get.to(ExerciseDetailPage(
                                exerciseId:
                                    '${response.data![0].exercises![0].exerciseId}',
                                workoutId: widget.workoutId,
                                // day: widget.day.toString(),
                                workoutDay: widget.workoutDay,
                                workoutName: widget.workoutName,
                                workoutImage: response
                                    .data![0].exercises![0].exerciseImage,
                                isFromExercise: false,

                                // data: response.data!,
                                // indexId: index,
                              ));
                              // log("button pressed ");
                            },
                            child: Text('Start',
                                style: FontTextStyle.kTine16W400Roboto),
                          )),
                    ]
                  : [],
            ),
            body: response.data!.isNotEmpty && response.data != []
                ? SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 18, right: 18, top: 10, bottom: 15),
                      child: Column(children: [
                        Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'CONDITIONING',
                                style: FontTextStyle.kWhite16BoldRoboto,
                              ),
                            ),
                            Divider(
                              color: ColorUtils.kTint,
                              thickness: 1,
                            ),
                            // ListView.builder(
                            //     shrinkWrap: true,
                            //     physics: NeverScrollableScrollPhysics(),
                            //     itemCount: response.data!.length,
                            //     itemBuilder: (_, index) {
                            // log('index ============== $index');
                            // log('length ============== ${response.data!.length}');

                            // log('data -------------- 111 ${response.data![index].exercises![index]}');
                            // log('---------- $index ${response.data![1].exercises![index].exerciseTitle}');

                            // return
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: response.data![0].exercises!.length,
                                itemBuilder: (_, index) {
                                  // log('index1 ============== $index1');
                                  log('${response.data![0].exercises![index].exerciseImage}');
                                  return response.data![0].exercises![index]
                                              .exerciseSets!.isNotEmpty ||
                                          response.data![0].exercises![index]
                                                  .exerciseSets! !=
                                              ""
                                      ? GestureDetector(
                                          onTap: () {
                                            Get.to(ExerciseDetailPage(
                                              exerciseId:
                                                  '${response.data![0].exercises![index].exerciseId}',
                                              workoutId: widget.workoutId,
                                              workoutDay: widget.workoutDay,
                                              workoutName: widget.workoutName,
                                              workoutImage: response
                                                  .data![0]
                                                  .exercises![index]
                                                  .exerciseImage,
                                              isFromExercise: false,
                                              // data: response.data!,
                                              // indexId: index,
                                            ));
                                            // log("button pressed");
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                  margin:
                                                      EdgeInsets.only(top: 12),
                                                  height: Get.height * 0.12,
                                                  width: Get.width * 0.32,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                              ColorUtils.kTint,
                                                          width: 2),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                          image: response.data![0].exercises![index].exerciseImage ==
                                                                      null ||
                                                                  response
                                                                      .data![0]
                                                                      .exercises![
                                                                          index]
                                                                      .exerciseImage!
                                                                      .isEmpty
                                                              ? NetworkImage(
                                                                  'https://cdn.sanity.io/images/0vv8moc6/ophtalmology/d198c3b708a35d9adcfa0435ee12fe454db49662-640x400.png/no-image-available-icon-6.jpg?w=1500&fit=max&auto=format')
                                                              : NetworkImage('${response.data![0].exercises![index].exerciseImage}'),
                                                          fit: BoxFit.fill))),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${response.data![0].exercises![index].exerciseTitle}',
                                                      // textAlign: TextAlign.center,
                                                      style: FontTextStyle
                                                          .kWhite16BoldRoboto,
                                                    ),
                                                    SizedBox(
                                                      height: Get.height * .019,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                              '${response.data![0].exercises![index].exerciseSets} sets : ',
                                                              style: FontTextStyle
                                                                  .kLightGray16W300Roboto),
                                                          Container(
                                                            width:
                                                                Get.width * 0.3,
                                                            child: ListView
                                                                .separated(
                                                                    itemCount: int.parse('${response.data![0].exercises![index].exerciseSets!}') >=
                                                                            7
                                                                        ? 7
                                                                        : int.parse(
                                                                            '${response.data![0].exercises![index].exerciseSets!}'),
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    separatorBuilder: (_,
                                                                        index1) {
                                                                      return Text(
                                                                        ',',
                                                                        style: FontTextStyle
                                                                            .kLightGray16W300Roboto,
                                                                      );
                                                                    },
                                                                    itemBuilder:
                                                                        (_, index1) {
                                                                      return Text(
                                                                          '${response.data![0].exercises![index].exerciseReps}',
                                                                          style:
                                                                              FontTextStyle.kLightGray16W300Roboto);
                                                                    }),
                                                          ),
                                                          int.parse('${response.data![0].exercises![index].exerciseSets!}') >
                                                                  7
                                                              ? Text(' ..',
                                                                  style: FontTextStyle
                                                                      .kLightGray16W300Roboto)
                                                              : SizedBox(),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward_ios_sharp,
                                                color: ColorUtils.kTint,
                                                size: Get.height * 0.026,
                                              )
                                            ],
                                          ),
                                        )
                                      : SizedBox();
                                  // });
                                })
                          ],
                        ),
                      ]),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: noData(),
                    ),
                  ));
        // } else {
        //   return Center(
        //     child: noDataLottie(),
        //   );
        // }
      } else {
        return Center(
            child: CircularProgressIndicator(
          color: ColorUtils.kTint,
        ));
      }
    });
  }
}
