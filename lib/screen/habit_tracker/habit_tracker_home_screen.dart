import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/habit_tracker/habit_selection_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';

class HabitTrackerHomeScreen extends StatelessWidget {
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
        title: Text('Habit Tracking', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * .06, vertical: Get.height * .025),
        child: Column(
          children: [
            Container(
              height: Get.height * .7,
              width: Get.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        AppImages.habitTrackerHome,
                        height: Get.height * .3,
                        width: Get.height * .45,
                      ),
                    ),
                    SizedBox(height: Get.height * .07),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: AppText.habitTrackerHome1,
                          style: FontTextStyle.kWhite16W300Roboto.copyWith(
                            fontSize: Get.height * 0.02,
                          ),
                          children: [
                            TextSpan(
                                text: '\tHabit Tracker!\t',
                                style: FontTextStyle.kWhite16BoldRoboto),
                            TextSpan(
                                text: AppText.habitTrackerHome2,
                                style: FontTextStyle.kWhite16W300Roboto
                                    .copyWith(fontSize: Get.height * 0.02))
                          ]),
                    )
                  ]),
            ),
            commonNevigationButton(
                onTap: () {
                  Get.to(HabitSelectionScreen());
                },
                name: 'Get Started!')
          ],
        ),
      ),
    );
  }
}
