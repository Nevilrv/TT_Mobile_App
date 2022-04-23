import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'excercise_detail_page.dart';

class WorkoutOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
        title: Text('Day 1 Workout', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: InkWell(
              onTap: () {},
              child: Text('Start', style: FontTextStyle.kTine16W400Roboto),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 18, right: 18, top: 10, bottom: 15),
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
                Container(
                  height: Get.height * 0.42,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(ExerciseDetailPage());
                            print("button pressed ");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 12),
                                height: Get.height * 0.12,
                                width: Get.width * 0.32,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorUtils.kTint, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: AssetImage(AppImages.workout1),
                                        fit: BoxFit.cover)),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: 'Seated Cable Row\n',
                                      style: FontTextStyle.kWhite16BoldRoboto,
                                      children: [
                                    TextSpan(
                                        text: '4 sets : 10,10,10,10',
                                        style: FontTextStyle
                                            .kLightGray16W300Roboto)
                                  ])),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: ColorUtils.kTint,
                                size: Get.height * 0.026,
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
            SizedBox(height: Get.height * 0.03),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'COMPOUND LIFTS',
                    style: FontTextStyle.kWhite16BoldRoboto,
                  ),
                ),
                Divider(
                  color: ColorUtils.kTint,
                  thickness: 1,
                ),
                Container(
                  height: Get.height * 0.42,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(ExerciseDetailPage());
                            print("button pressed ");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 12),
                                height: Get.height * 0.12,
                                width: Get.width * 0.32,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorUtils.kTint, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: AssetImage(AppImages.workout1),
                                        fit: BoxFit.cover)),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: 'Seated Cable Row\n',
                                      style: FontTextStyle.kWhite16BoldRoboto,
                                      children: [
                                    TextSpan(
                                        text: '4 sets : 10,10,10,10',
                                        style: FontTextStyle
                                            .kLightGray16W300Roboto)
                                  ])),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: ColorUtils.kTint,
                                size: Get.height * 0.026,
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
            SizedBox(height: Get.height * 0.03),
            Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'ISOLATION LIFTS',
                    style: FontTextStyle.kWhite16BoldRoboto,
                  ),
                ),
                Divider(
                  color: ColorUtils.kTint,
                  thickness: 1,
                ),
                Container(
                  height: Get.height * 0.42,
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            Get.to(ExerciseDetailPage());
                            print("button pressed ");
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 12),
                                height: Get.height * 0.12,
                                width: Get.width * 0.32,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: ColorUtils.kTint, width: 2),
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: AssetImage(AppImages.workout1),
                                        fit: BoxFit.cover)),
                              ),
                              RichText(
                                  text: TextSpan(
                                      text: 'Seated Cable Row\n',
                                      style: FontTextStyle.kWhite16BoldRoboto,
                                      children: [
                                    TextSpan(
                                        text: '4 sets : 10,10,10,10',
                                        style: FontTextStyle
                                            .kLightGray16W300Roboto)
                                  ])),
                              Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: ColorUtils.kTint,
                                size: Get.height * 0.026,
                              )
                            ],
                          ),
                        );
                      }),
                )
              ],
            ),
          ]),
        ),
      ),
    ));
  }
}
