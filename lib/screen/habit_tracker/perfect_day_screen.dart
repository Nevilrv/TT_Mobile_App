import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/habit_tracker/widgets/habit_selection_widget.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';

class PerfectDayScreen extends StatelessWidget {
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
        title: Text('Nice Work', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06, vertical: Get.height * 0.015),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                child: SizedBox(
                  height: Get.height * .75,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Perfect Day',
                          style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                            fontSize: Get.height * 0.032,
                          ),
                        ),
                        Container(
                          height: Get.height * .35,
                          width: Get.width * .5,
                          child: Image.asset(AppImages.perfectDayIllustration),
                        ),
                        Text(
                          AppText.perfectDayText,
                          style: FontTextStyle.kWhite20BoldRoboto
                              .copyWith(fontWeight: FontWeight.w500),
                          maxLines: 4,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          AppText.shareYourSuccess,
                          style: FontTextStyle.kWhite24BoldRoboto,
                          maxLines: 4,
                          textAlign: TextAlign.center,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(AppIcons.facebook,
                                height: Get.height * .05,
                                width: Get.height * .05,
                                fit: BoxFit.contain),
                            Image.asset(AppIcons.twitter,
                                height: Get.height * .05,
                                width: Get.height * .05,
                                fit: BoxFit.contain),
                            Image.asset(AppIcons.instagram,
                                height: Get.height * .05,
                                width: Get.height * .05,
                                fit: BoxFit.contain),
                          ],
                        ),
                      ]),
                ),
              ),
              commonNevigationButton(
                  name: 'Next',
                  onTap: () {
                    Get.off(HomeScreen());
                  })
            ]),
      ),
    );
  }
}
