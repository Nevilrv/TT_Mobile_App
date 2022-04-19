import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';

class ExperienceLevelPage extends StatefulWidget {
  const ExperienceLevelPage({Key? key}) : super(key: key);

  @override
  _ExperienceLevelPageState createState() => _ExperienceLevelPageState();
}

class _ExperienceLevelPageState extends State<ExperienceLevelPage> {
  int? index = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorUtils.kBlack,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_sharp,
                      color: ColorUtils.kTint,
                    )),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.01),
                  child: Text('Profile Photo',
                      style: FontTextStyle.kWhite17BoldRoboto),
                ),
                Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.01),
                  child: InkWell(
                    onTap: () {},
                    child: Text('Skip', style: FontTextStyle.kTine16W400Roboto),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            Center(
              child: Text(
                'Choose your current experience level.',
                style: FontTextStyle.kWhite17W400Roboto,
              ),
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  index = 1;
                });
              },
              child: Container(
                height: Get.height * 0.18,
                width: Get.width * 0.99,
                decoration: index == 1
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorUtils.kTint)
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff363636)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Beginner',
                              style: index == 1
                                  ? FontTextStyle.kBlack20BoldRoboto
                                  : FontTextStyle.kWhite20BoldRoboto,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'You have little or no experience with working out. This is the beginning of your journey.',
                          style: index == 1
                              ? FontTextStyle.kBlack16W300Roboto
                              : FontTextStyle.kWhite16W300Roboto,
                        ),
                      )
                    ]),
              ),
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  index = 2;
                });
              },
              child: Container(
                height: Get.height * 0.18,
                width: Get.width * 0.99,
                decoration: index == 2
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorUtils.kTint)
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff363636)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Intermediate',
                              style: FontTextStyle.kWhite20BoldRoboto,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'You have some experience working out with weights but you definitely have a lot to still learn.',
                          style: FontTextStyle.kWhite16W300Roboto,
                        ),
                      )
                    ]),
              ),
            ),
            SizedBox(
              height: Get.height * 0.04,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  index = 3;
                });
              },
              child: Container(
                height: Get.height * 0.18,
                width: Get.width * 0.99,
                decoration: index == 3
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorUtils.kTint)
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xff363636)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'Advanced',
                              style: FontTextStyle.kWhite20BoldRoboto,
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'You are very knowledgable about all aspects of fitness and nutrition and you’re just looking to take it up a notch.',
                          style: FontTextStyle.kWhite16W300Roboto,
                        ),
                      )
                    ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget experience(
      {String? text,
      String? text1,
      Function()? onTap,
      BoxDecoration? decoration}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: Get.height * 0.18,
        width: Get.width * 0.99,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Color(0xff363636)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  text!,
                  style: FontTextStyle.kWhite20BoldRoboto,
                ),
              ),
              Spacer(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              text1!,
              style: FontTextStyle.kWhite16W300Roboto,
            ),
          )
        ]),
      ),
    );
  }
}
