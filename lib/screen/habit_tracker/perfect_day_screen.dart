import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/habit_tracker/widgets/habit_progress_share.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/workout_viewModel/share_viewModel.dart';

class PerfectDayScreen extends StatelessWidget {
  ShareViewModel _shareViewModel = Get.put(ShareViewModel());

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
        actions: [
          GestureDetector(
            onTap: () {},
            child: Image.asset(
              AppIcons.checked,
              height: Get.height * .025,
              width: Get.height * .025,
              color: ColorUtils.kWhite,
            ),
          ),
        ],
        backgroundColor: ColorUtils.kBlack,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('HABITS COMPLETE', style: FontTextStyle.kWhite16BoldRoboto),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06, vertical: Get.height * 0.015),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(
                right: Get.width * .06,
                left: Get.width * .06,
                bottom: Get.height * .015),
            child: SizedBox(
              height: Get.height * .65,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Perfect Day',
                      style: FontTextStyle.kWhite24BoldRoboto.copyWith(
                        fontSize: Get.height * 0.032,
                      ),
                    ),
                    Image.asset(AppImages.perfectDayIllustration,
                        height: Get.height * .35,
                        width: Get.width,
                        fit: BoxFit.fitHeight),
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Image.asset(AppIcons.facebook,
                    //         height: Get.height * .05,
                    //         width: Get.height * .05,
                    //         fit: BoxFit.contain),
                    //     Image.asset(AppIcons.twitter,
                    //         height: Get.height * .05,
                    //         width: Get.height * .05,
                    //         fit: BoxFit.contain),
                    //     Image.asset(AppIcons.instagram,
                    //         height: Get.height * .05,
                    //         width: Get.height * .05,
                    //         fit: BoxFit.contain),
                    //   ],
                    // ),
                  ]),
            ),
          ),
          SizedBox(
            width: Get.width * .5,
            child: commonNavigationButton(
                name: 'Share',
                onTap: () {
                  Get.to(HabitProgressShare(), transition: Transition.downToUp);
                  // shareBottomSheet();
                }),
          ),
          SizedBox(height: Get.height * .04),
          commonNavigationButton(
              name: 'Next',
              onTap: () {
                Get.off(HomeScreen());
              })
        ]),
      ),
    );
  }

  Future<dynamic> shareBottomSheet() {
    return Get.bottomSheet(Container(
      decoration: BoxDecoration(
          color: ColorUtils.kBlack,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * .04),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 15, height: 15),
                  Text('Share', style: FontTextStyle.kTint20BoldRoboto),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: ColorUtils.kTint,
                      )),
                ]),
          ),
          Container(
            height: Get.height * .2,
            width: Get.width * .3,
            child: Image.asset(AppImages.perfectDayIllustration),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () {
                    _shareViewModel.launchFacebook();
                  },
                  child: Image.asset(AppIcons.facebook,
                      height: Get.height * .05,
                      width: Get.height * .05,
                      fit: BoxFit.contain)),
              GestureDetector(
                  onTap: () {
                    _shareViewModel.launchTwitter();
                  },
                  child: Image.asset(AppIcons.twitter,
                      height: Get.height * .05,
                      width: Get.height * .05,
                      fit: BoxFit.contain)),
              GestureDetector(
                  onTap: () {
                    _shareViewModel.launchInsta();
                  },
                  child: Image.asset(AppIcons.instagram,
                      height: Get.height * .05,
                      width: Get.height * .05,
                      fit: BoxFit.contain))
            ],
          ),
          // Row(
          //   mainAxisAlignment:
          //       MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Image.asset(AppIcons.facebook,
          //         height: Get.height * .05,
          //         width: Get.height * .05,
          //         fit: BoxFit.contain),
          //     Image.asset(AppIcons.twitter,
          //         height: Get.height * .05,
          //         width: Get.height * .05,
          //         fit: BoxFit.contain),
          //     Image.asset(AppIcons.instagram,
          //         height: Get.height * .05,
          //         width: Get.height * .05,
          //         fit: BoxFit.contain),
          //   ],
          // ),
        ],
      ),
    ));
  }
}
