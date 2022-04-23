import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';

import 'cheast_back_blast_page.dart';

class TrainingPlanScreen extends StatefulWidget {
  const TrainingPlanScreen({Key? key}) : super(key: key);

  @override
  _TrainingPlanScreenState createState() => _TrainingPlanScreenState();
}

class _TrainingPlanScreenState extends State<TrainingPlanScreen> {
  bool? switchSelected = false;
  int? daySelected = 0;
  int? focusSelected = 0;
  var day = [
    1,
    2,
    3,
    4,
    5,
  ];
  var focus = ['Build Muscle', 'Cardio', 'Strength', 'Fat Loss'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text('Training Plans', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Get.width * .05, vertical: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Filter By',
              style: FontTextStyle.kWhite17BoldRoboto,
            ),
            SizedBox(
              height: Get.height*0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                genderSwitch(),
                SizedBox(
                  width: Get.width * .023,
                ),
                selectedDays(),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'FOCUS',
              style: FontTextStyle.kGreyBoldRoboto,
            ),
            SizedBox(
              height: 10,
            ),
            focusCategory(),
            SizedBox(
              height: 20,
            ),
            focusSelected == 0 ? buildMuscle() : SizedBox(),
            focusSelected == 1 ? cardio() : SizedBox(),
            focusSelected == 2 ? strength() : SizedBox(),
            focusSelected == 3 ? fatLoss() : SizedBox(),
          ]),
        ),
      ),
    );
  }

  Widget buildMuscle() {
    return Column(
      children: [
        selectedFocus(
          onTap: () {
            Get.to(ChestAndBackBlastScreen());
          },
          text: 'Chest and Back Blast',
          image: 'asset/images/training.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Killer Core',
          image: 'asset/images/training.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Chest and Back Blast',
          image: 'asset/images/training.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Killer Core',
          image: 'asset/images/training.png',
        ),
      ],
    );
  }

  Widget cardio() {
    return Column(
      children: [
        selectedFocus(
          onTap: () {},
          text: 'Chest and Back Blast',
          image: 'asset/images/videos.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Killer Core',
          image: 'asset/images/training.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Chest and Back Blast',
          image: 'asset/images/training.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Killer Core',
          image: 'asset/images/training.png',
        ),
      ],
    );
  }

  Widget strength() {
    return Column(
      children: [
        selectedFocus(
          onTap: () {},
          text: 'Chest and Back Blast',
          image: 'asset/images/training.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Killer Core',
          image: 'asset/images/videos.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Chest and Back Blast',
          image: 'asset/images/training.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Killer Core',
          image: 'asset/images/training.png',
        ),
      ],
    );
  }

  Widget fatLoss() {
    return Column(
      children: [
        selectedFocus(
          onTap: () {},
          text: 'Chest and Back Blast',
          image: 'asset/images/training.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Killer Core',
          image: 'asset/images/training.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Chest and Back Blast',
          image: 'asset/images/videos.png',
        ),
        selectedFocus(
          onTap: () {},
          text: 'Killer Core',
          image: 'asset/images/training.png',
        ),
      ],
    );
  }

  Widget focusCategory() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        height: Get.height * .06,
        width: Get.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: ColorUtils.kGray),
        child: SingleChildScrollView(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(
                  focus.length,
                  (index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          focusSelected = index;
                        });
                      },
                      child: focusSelected == index
                          ? Container(
                              alignment: Alignment.center,
                              height: Get.height * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ColorUtils.kTint,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 11, horizontal: Get.width * .038),
                                child: Text('${focus[index]}',
                                    style: focusSelected == index
                                        ? FontTextStyle.kBlack16W300Roboto
                                        : FontTextStyle.kWhite16BoldRoboto),
                              ))
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: ColorUtils.kGray,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 11, horizontal: Get.width * .038),
                                child: Text('${focus[index]}',
                                    style: focusSelected == index
                                        ? FontTextStyle.kBlack16W300Roboto
                                        : FontTextStyle.kWhite16BoldRoboto),
                              ))))),
        ),
      ),
    );
  }

  Widget selectedFocus({String? image, String? text, Function()? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                height: 170,
                width: Get.width * .99,
                decoration: BoxDecoration(
                    border: Border.all(color: ColorUtils.kTint),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        image!,
                      ),
                      fit: BoxFit.fill,
                    )),
              ),
              Positioned(
                  top: 140,
                  left: Get.width * .05,
                  child: Text(
                    text!,
                    style: FontTextStyle.kWhite17W400Roboto,
                  ))
            ],
          ),
        ),
        SizedBox(
          height: Get.height * .02,
        ),
      ],
    );
  }

  Expanded selectedDays() {
    return Expanded(
        flex: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'DAYS PER WEEK',
              style: FontTextStyle.kGreyBoldRoboto,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
                height: Get.height * .05,
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorUtils.kGray),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: List.generate(
                        day.length,
                        (index) => GestureDetector(
                              onTap: () {
                                setState(() {
                                  daySelected = index;
                                });
                              },
                              child: CircleAvatar(
                                radius: Get.width * 0.05,
                                backgroundColor: daySelected == index
                                    ? ColorUtils.kTint
                                    : ColorUtils.kGray,
                                child: Text('${day[index]}',
                                    style: daySelected == index
                                        ? FontTextStyle.kBlack20BoldRoboto
                                        : FontTextStyle.kWhite20BoldRoboto),
                              ),
                            )))),
          ],
        ));
  }

  Expanded genderSwitch() {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GENDER',
          style: FontTextStyle.kGreyBoldRoboto,
        ),
        SizedBox(
          height: Get.height*0.016,
        ),
        switchSelected == false
            ? Container(
                height: Get.height * .05,
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorUtils.kGray),
                child: Row(children: [
                  Container(
                    width: Get.width * .13,
                    height: Get.height * .05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorUtils.kTint,
                    ),
                    child: Center(
                        child: Text(
                      'Male',
                      style: FontTextStyle.kBlack12BoldRoboto,
                    )),
                  ),
                  SizedBox(
                    width: Get.width * .017,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        switchSelected = !switchSelected!;
                      });
                    },
                    child: Center(
                      child: Text(
                        'Female',
                        style: FontTextStyle.kWhite12BoldRoboto,
                      ),
                    ),
                  )
                ]),
              )
            : Container(
                height: Get.height * .05,
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorUtils.kGray),
                child: Row(children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        switchSelected = !switchSelected!;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: Get.width * .026),
                      child: Text(
                        'Male',
                        style: FontTextStyle.kWhite12BoldRoboto,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * .025,
                  ),
                  Container(
                    width: Get.width * .16,
                    height: Get.height * .05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: ColorUtils.kTint,
                    ),
                    child: Center(
                        child: Text(
                      'Female',
                      style: FontTextStyle.kBlack12BoldRoboto,
                    )),
                  ),
                ]),
              )
      ],
    ));
  }
}
