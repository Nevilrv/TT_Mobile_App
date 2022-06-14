import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/day_based_exercise_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/training_plan_viewModel/day_based_exercise_viewModel.dart';
import 'excercise_detail_page.dart';

class WorkoutOverviewPage extends StatefulWidget {
  final int day;
  final String workoutId;

  WorkoutOverviewPage({
    Key? key,
    required this.day,
    required this.workoutId,
  }) : super(key: key);

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
        print(response.data!.length);
        print('data -------------- ${response.data!}');
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
              title: Text('Day ${widget.day + 1} Workout',
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
                                day: widget.day.toString(),
                                // data: response.data!,
                                // indexId: index,
                              ));
                              print("button pressed ");
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
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: response.data!.length,
                                itemBuilder: (_, index) {
                                  print(
                                      '${response.data![index].exercises![0].exerciseImage}');
                                  return GestureDetector(
                                    onTap: () {
                                      Get.to(ExerciseDetailPage(
                                        exerciseId:
                                            '${response.data![index].exercises![0].exerciseId}',

                                        workoutId: widget.workoutId,
                                        // data: response.data!,
                                        // indexId: index,
                                      ));
                                      print("button pressed ");
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 12),
                                          height: Get.height * 0.12,
                                          width: Get.width * 0.32,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: ColorUtils.kTint,
                                                  width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              image: DecorationImage(
                                                  image: response
                                                                  .data![index]
                                                                  .exercises![0]
                                                                  .exerciseImage !=
                                                              null ||
                                                          response
                                                                  .data![index]
                                                                  .exercises![0]
                                                                  .exerciseImage !=
                                                              ''
                                                      ? NetworkImage(
                                                          '$baseImageUrl${response.data![index].exercises![0].exerciseImage}')
                                                      : NetworkImage(
                                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW3Y7khQ-HoaS-SjqUniPtFKPZVn5uqVYL9LTQhgjPlYzd1_aLj3QZt9DEO-QJpR6iVhg&usqp=CAU'),
                                                  fit: BoxFit.cover)),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${response.data![index].exercises![0].exerciseTitle}',
                                                // textAlign: TextAlign.center,
                                                style: FontTextStyle
                                                    .kWhite16BoldRoboto,
                                              ),
                                              Text(
                                                  '${response.data![index].exercises![0].exerciseSets} sets : ${response.data![index].exercises![0].exerciseReps},${response.data![index].exercises![0].exerciseReps},${response.data![index].exercises![0].exerciseReps},${response.data![index].exercises![0].exerciseReps}',
                                                  style: FontTextStyle
                                                      .kLightGray16W300Roboto)
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
                                  );
                                })
                          ],
                        ),
                      ]),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: noDataLottie(),
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
