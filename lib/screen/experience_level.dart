import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/primary_goals_screen.dart';

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
              SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  Text('Experience Level',
                      style: FontTextStyle.kWhite17BoldRoboto),
                  InkWell(
                    onTap: () {},
                    child: Text('Skip', style: FontTextStyle.kTine16W400Roboto),
                  ),
                ],
            ),
            SizedBox(
                height: Get.height * 0.04,
            ),
            SingleChildScrollView(
                child: Column(
                  children: [
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
                              index == 1
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'Beginner',
                                            style: index == 1
                                                ? FontTextStyle.kBlack20BoldRoboto
                                                : FontTextStyle
                                                    .kWhite20BoldRoboto,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.black,
                                              child: Icon(
                                                Icons.done,
                                                size: 30,
                                                color: ColorUtils.kTint,
                                              )),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'Beginner',
                                            style: index == 1
                                                ? FontTextStyle.kBlack20BoldRoboto
                                                : FontTextStyle
                                                    .kWhite20BoldRoboto,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                              index == 2
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'Intermediate',
                                            style: index == 2
                                                ? FontTextStyle.kBlack20BoldRoboto
                                                : FontTextStyle
                                                    .kWhite20BoldRoboto,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.black,
                                              child: Icon(
                                                Icons.done,
                                                size: 30,
                                                color: ColorUtils.kTint,
                                              )),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'Intermediate',
                                            style: index == 2
                                                ? FontTextStyle.kBlack20BoldRoboto
                                                : FontTextStyle
                                                    .kWhite20BoldRoboto,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'You have some experience working out with weights but you definitely have a lot to still learn.',
                                  style: index == 2
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
                              index == 3
                                  ? Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'Advanced',
                                            style: index == 3
                                                ? FontTextStyle.kBlack20BoldRoboto
                                                : FontTextStyle
                                                    .kWhite20BoldRoboto,
                                          ),
                                        ),
                                        Spacer(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: CircleAvatar(
                                              radius: 20,
                                              backgroundColor: Colors.black,
                                              child: Icon(
                                                Icons.done,
                                                size: 30,
                                                color: ColorUtils.kTint,
                                              )),
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                            'Advanced',
                                            style: index == 3
                                                ? FontTextStyle.kBlack20BoldRoboto
                                                : FontTextStyle
                                                    .kWhite20BoldRoboto,
                                          ),
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Text(
                                  'You are very knowledgable about all aspects of fitness and nutrition and you’re just looking to take it up a notch.',
                                  style: index == 3
                                      ? FontTextStyle.kBlack16W300Roboto
                                      : FontTextStyle.kWhite16W300Roboto,
                                ),
                              )
                            ]),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.08,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                      child: GestureDetector(
                        onTap: () {
                          Get.to(PrimaryGoalsScreen());
                        },
                        child: Container(
                          height: Get.height * 0.06,
                          width: Get.width * 0.9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: ColorUtils.kTint),
                          child: Center(
                              child: Text(
                            'Next',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: Get.height*0.02),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
            )
          ]),
              ),
        ),
      ),
    );
  }
}
