import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'home_screen.dart';

class PrimaryGoalsScreen extends StatefulWidget {
  const PrimaryGoalsScreen({Key? key}) : super(key: key);

  @override
  _PrimaryGoalsScreenState createState() => _PrimaryGoalsScreenState();
}

class _PrimaryGoalsScreenState extends State<PrimaryGoalsScreen> {
  int? index = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorUtils.kBlack,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorUtils.kTint,
            )),
        backgroundColor: ColorUtils.kBlack,
        title: Text('Primary Goals', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: Container(
        height: Get.height,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: Get.height * 0.04,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Choose what your primary fitness goals are. You can choose multiple.',
                  style: FontTextStyle.kWhite16W300Roboto,
                  textAlign: TextAlign.center,
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
                  height: Get.height * 0.17,
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
                                      'Fat Loss',
                                      style: index == 1
                                          ? FontTextStyle.kBlack20BoldRoboto
                                          : FontTextStyle.kWhite20BoldRoboto,
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
                                      'Fat Loss',
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
                            'Whether you need to lose a lot or just those last few stubborn pounds',
                            style: index == 1
                                ? FontTextStyle.kBlack16W300Roboto
                                : FontTextStyle.kWhite16W300Roboto,
                          ),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 2;
                  });
                },
                child: Container(
                  height: Get.height * 0.17,
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
                                      'Muscle Size',
                                      style: index == 2
                                          ? FontTextStyle.kBlack20BoldRoboto
                                          : FontTextStyle.kWhite20BoldRoboto,
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
                                      'Muscle Size',
                                      style: index == 2
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
                            'Also known as hypertrophy, increasing muscle size will get you jacked.',
                            style: index == 2
                                ? FontTextStyle.kBlack16W300Roboto
                                : FontTextStyle.kWhite16W300Roboto,
                          ),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 3;
                  });
                },
                child: Container(
                  height: Get.height * 0.17,
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
                                      'Strength',
                                      style: index == 3
                                          ? FontTextStyle.kBlack20BoldRoboto
                                          : FontTextStyle.kWhite20BoldRoboto,
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
                                      'Strength',
                                      style: index == 3
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
                            'You want to get strong, really strong. This will also add muscle size.',
                            style: index == 3
                                ? FontTextStyle.kBlack16W300Roboto
                                : FontTextStyle.kWhite16W300Roboto,
                          ),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index = 4;
                  });
                },
                child: Container(
                  height: Get.height * 0.17,
                  width: Get.width * 0.99,
                  decoration: index == 4
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorUtils.kTint)
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xff363636)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        index == 4
                            ? Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(
                                      'Conditioning',
                                      style: index == 4
                                          ? FontTextStyle.kBlack20BoldRoboto
                                          : FontTextStyle.kWhite20BoldRoboto,
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
                                      'Conditioning',
                                      style: index == 4
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
                            'Your cardiovascular performance is what matters most to you.',
                            style: index == 4
                                ? FontTextStyle.kBlack16W300Roboto
                                : FontTextStyle.kWhite16W300Roboto,
                          ),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                child: GestureDetector(
                  onTap: () {
                    Get.to(HomeScreen());
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
                          fontSize:Get.height*0.02),
                    )),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.05,
              )
            ]),
          ),
        ),
      ),
    ));
  }
}
