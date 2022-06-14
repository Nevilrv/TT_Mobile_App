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
                    Image.asset(
                      AppImages.habitTrackerIllustration,
                      height: Get.height * .3,
                      width: Get.height * .3,
                    ),
                    SizedBox(height: Get.height * .04),
                    Text(
                      AppText.paragraph,
                      maxLines: 4,
                      style: FontTextStyle.kWhite16BoldRoboto,
                    )
                  ]),
            ),
            commonNevigationButton(
                onTap: () {
                  Get.to(HabitSelectionScreen());
                },
                name: 'Get Started')
          ],
        ),
      ),
    );
  }
}
