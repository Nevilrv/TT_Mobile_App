import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_by_id_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/training_plan_screens/plan_overview.dart';
import 'package:tcm/screen/workout_screen/time_based_exercise_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';

// ignore: must_be_immutable
class WorkoutHomeScreen extends StatelessWidget {
  List<ExerciseById> exeData;
  List<WorkoutById> data;
  final String? workoutId;

  WorkoutHomeScreen(
      {Key? key, required this.data, this.workoutId, required this.exeData})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    print('is data comming ????? ${data[0].workoutTitle}');

    if (exeData.isNotEmpty) {
      String exerciseInstructions = '${data[0].workoutDescription}';
      List<String> splitHTMLInstruction = exerciseInstructions.split('</li>');
      List<String> finalHTMLInstruction = [];
      splitHTMLInstruction.forEach((element) {
        finalHTMLInstruction
            .add(element.replaceAll('<ol>', '').replaceAll('</ol>', ''));
      });

      String exerciseTips = '${exeData[0].exerciseTips}';
      List<String> splitHTMLTips = exerciseTips.split('</li>');
      List<String> finalHTMLTips = [];
      splitHTMLTips.forEach((element) {
        finalHTMLTips
            .add(element.replaceAll('<ul>', '').replaceAll('</ul>', ''));
      });

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
          title:
              Text('Workout Overview', style: FontTextStyle.kWhite16BoldRoboto),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.09, vertical: Get.height * 0.02),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '${data[0].workoutTitle}',
                    style: FontTextStyle.kWhite20BoldRoboto,
                  ),
                  SizedBox(height: Get.height * .02),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: finalHTMLInstruction.length - 1,
                      itemBuilder: (_, index) =>
                          htmlToTextGrey(data: finalHTMLInstruction[index])),
                  SizedBox(height: Get.height * .03),
                  commonNavigationButtonWithIcon(
                      onTap: () {
                        Get.to(PlanOverviewScreen(id: workoutId!));
                      },
                      name: 'Watch Overview Video',
                      iconImg: AppIcons.video,
                      iconColor: ColorUtils.kBlack),
                  SizedBox(height: Get.height * .03),
                  Container(
                    // height: Get.height * .4,
                    width: Get.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            colors: ColorUtilsGradient.kGrayGradient,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          // color: Colors.pink,
                          width: Get.width * .525,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: Get.height * .05),
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          radius: Get.height * .02,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              AssetImage(AppIcons.kettle_bell)),
                                      SizedBox(width: Get.width * .03),
                                      Expanded(
                                        child: Text('Equipment needed',
                                            style: FontTextStyle
                                                .kWhite20BoldRoboto),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: Get.height * .05),
                                Container(
                                  // color: Colors.teal,
                                  width: Get.width * .4,
                                  alignment: Alignment.centerLeft,
                                  child: ListView.separated(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          data[0].availableEquipments!.length,
                                      separatorBuilder: (_, index) {
                                        return SizedBox(
                                            height: Get.height * .008);
                                      },
                                      itemBuilder: (_, index) {
                                        if ('${data[0].availableEquipments![index]}' !=
                                            "No Equipment") {
                                          return Row(
                                            children: [
                                              SizedBox(width: Get.width * .075),
                                              RichText(
                                                  text: TextSpan(
                                                      text: '● ',
                                                      style: FontTextStyle
                                                          .kLightGray16W300Roboto,
                                                      children: [
                                                    TextSpan(
                                                        text:
                                                            '${data[0].availableEquipments![index]}',
                                                        style: FontTextStyle
                                                            .kWhite17BoldRoboto)
                                                  ])),
                                            ],
                                          );
                                        } else {
                                          return SizedBox();
                                        }
                                      }),
                                ),
                                SizedBox(height: Get.height * .05),
                                Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                          radius: Get.height * .02,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage:
                                              AssetImage(AppIcons.clock)),
                                      SizedBox(width: Get.width * .03),
                                      Expanded(
                                        child: Text(
                                          '${exeData[0].exerciseRest} rest between sets',
                                          style:
                                              FontTextStyle.kWhite20BoldRoboto,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: Get.height * .05),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * .03),
                  // ListView.builder(
                  //     physics: NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: finalHTMLTips.length - 1,
                  //     itemBuilder: (_, index) =>
                  //         ),
                  // htmlToTextGrey(data: finalHTMLTips[1]),
                  SizedBox(height: Get.height * .03),
                  commonNevigationButton(
                      name: 'Begin Warm-Up',
                      onTap: () {
                        Get.to(TimeBasedExesiceScreen(
                          data: exeData,
                        ));
                      })
                ]),
          ),
        ),
      );
    } else {
      return Center(
        child: CircularProgressIndicator(
          color: ColorUtils.kTint,
        ),
      );
    }
  }

  Padding commonNavigationButtonWithIcon(
      {Function()? onTap, String? name, String? iconImg, Color? iconColor}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.height * .02),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
            alignment: Alignment.center,
            height: Get.height * .065,
            width: Get.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: ColorUtilsGradient.kTintGradient,
                    end: Alignment.center,
                    begin: Alignment.center),
                borderRadius: BorderRadius.circular(Get.height * .06)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(iconImg!,
                    color: iconColor,
                    width: Get.width * 0.042,
                    height: Get.width * 0.036,
                    fit: BoxFit.fill),
                Text(
                  name!,
                  style: FontTextStyle.kBlack16BoldRoboto,
                ),
                SizedBox(
                  width: Get.width * 0.042,
                  height: Get.width * 0.036,
                ),
              ],
            )),
      ),
    );
  }
}
