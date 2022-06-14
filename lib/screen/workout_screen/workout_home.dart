import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/training_plan_screens/plan_overview.dart';
import 'package:tcm/screen/workout_screen/time_based_exercise_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';

// ignore: must_be_immutable
class WorkoutHomeScreen extends StatelessWidget {
  List<ExerciseById> data;
  final String? workoutId;

  WorkoutHomeScreen({Key? key, required this.data, this.workoutId})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (data.isNotEmpty) {
      String exerciseInstructions = '${data[0].exerciseInstructions}';
      List<String> splitHTMLInstruction = exerciseInstructions.split('</li>');
      List<String> finalHTMLInstruction = [];
      splitHTMLInstruction.forEach((element) {
        finalHTMLInstruction
            .add(element.replaceAll('<ol>', '').replaceAll('</ol>', ''));
      });

      String exerciseTips = '${data[0].exerciseTips}';
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
                    '${data[0].exerciseTitle}',
                    style: FontTextStyle.kWhite20BoldRoboto,
                  ),
                  SizedBox(height: Get.height * .02),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: finalHTMLInstruction.length - 1,
                      itemBuilder: (_, index) =>
                          htmlToTextGrey(data: finalHTMLInstruction[index])),
                  // Text(
                  //   '${data[0].exerciseInstructions}',
                  //   style: FontTextStyle.kLightGray18W300Roboto,
                  //   maxLines: 3,
                  //   textAlign: TextAlign.center,
                  // ),
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
                    height: Get.height * .4,
                    width: Get.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            colors: ColorUtilsGradient.kGrayGradient,
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                  radius: Get.height * .02,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage:
                                      AssetImage(AppIcons.kettle_bell)),
                              SizedBox(width: Get.width * .03),
                              Text('Equipment needed',
                                  style: FontTextStyle.kWhite20BoldRoboto)
                            ],
                          ),
                          ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 1,
                              itemBuilder: (_, index) {
                                return Align(
                                  alignment: Alignment.center,
                                  child: RichText(
                                      text: TextSpan(
                                          text: '●\t',
                                          style: FontTextStyle
                                              .kLightGray16W300Roboto,
                                          children: [
                                        TextSpan(
                                            text: '${data[0].equipmentTitle}',
                                            style: FontTextStyle
                                                .kWhite17BoldRoboto)
                                      ])),
                                );
                              }),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                    radius: Get.height * .02,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage:
                                        AssetImage(AppIcons.clock)),
                                SizedBox(width: Get.width * .03),
                                Flexible(
                                  child: Text(
                                    '${data[0].exerciseRest}\trest  between sets',
                                    style: FontTextStyle.kWhite20BoldRoboto,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(height: Get.height * .03),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: finalHTMLTips.length - 1,
                      itemBuilder: (_, index) =>
                          htmlToTextGrey(data: finalHTMLTips[index])),
                  // Text(
                  //   '${data[0].exerciseTips}',
                  //   style: FontTextStyle.kLightGray18W300Roboto,
                  //   maxLines: 3,
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: Get.height * .03),
                  commonNevigationButton(
                      name: 'Begin Warm-Up',
                      onTap: () {
                        Get.to(TimeBasedExesiceScreen(
                          data: data,
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
