import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/training_plan_screens/training_plan.dart';
import 'package:tcm/screen/video_library/video_library_screen.dart';
import 'package:tcm/utils/images.dart';

import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'edit_profile_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? selected = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: ColorUtils.kBlack,
      drawer: _drawerList(),
      appBar: AppBar(
          backgroundColor: ColorUtils.kBlack,
          centerTitle: true,
          title: Image.asset('asset/images/logoSmall.png',height: Get.height*0.033,fit: BoxFit.cover,)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            SizedBox(
              height: Get.height * .04,
            ),
            Container(
              height: Get.height * 0.22,
              width: Get.width * 0.99,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xff363636)),
              child: selected == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, bottom: 10, top: 20, right: 20),
                          child: Text(
                            'Your Next Workout',
                            style: FontTextStyle.kWhite20BoldRoboto,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                height: Get.height * .12,
                                width: Get.width * .24,
                                decoration: BoxDecoration(
                                    border: Border.all(color: ColorUtils.kTint),
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'asset/images/image.png',
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(
                                width: Get.width * .04,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Chest and Back Blast',
                                    style: FontTextStyle.kWhite17BoldRoboto,
                                  ),
                                  Text(
                                    'Friday, April 30th',
                                    style: FontTextStyle.kGrey18BoldRoboto,
                                  ),
                                  SizedBox(
                                    height: Get.height * .01,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selected = !selected!;
                                      });
                                    },
                                    child: Container(
                                      height: Get.height * 0.042,
                                      width: Get.width * 0.5,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: ColorUtils.kTint),
                                      child: Center(
                                          child: Text(
                                        'Start Workout',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize:Get.height*0.02),
                                      )),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 10, top: 20, right: 20),
                            child: Text(
                              'No Workouts Scheduled',
                              style: FontTextStyle.kWhite20BoldRoboto,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Looks like you don’t have any upcoming workouts. Get started by choosing a plan.  ',
                              style: FontTextStyle.kWhite16W300Roboto,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * .03,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.05),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selected = !selected!;
                                });
                              },
                              child: Container(
                                height: Get.height * 0.05,
                                width: Get.width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: ColorUtils.kTint),
                                child: Center(
                                    child: Text(
                                  'Choose a Workout Plan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: Get.height*0.02),
                                )),
                              ),
                            ),
                          ),
                        ]),
            ),
            SizedBox(
              height: Get.height * .04,
            ),
            category(
                onTap: () {
                  Get.to(TrainingPlanScreen());
                },
                image: 'asset/images/training.png',
                text: 'Training Plans'),
            category(onTap: (){
              Get.to(VideoLibraryScreen());
            },image: 'asset/images/videos.png', text: 'Video Library'),
            category(image: 'asset/images/forums.png', text: 'The Forums'),
            category(image: 'asset/images/habit.png', text: 'Habit Tracker')
          ]),
        ),
      ),
    ));
  }

  Widget category({String? image, String? text, Function()? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                height: Get.height*0.2,
                width: Get.width * .99,
                decoration: BoxDecoration(
                    border: Border.all(color: ColorUtils.kTint),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        image!,
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
              Positioned(
                  bottom: Get.height*0.02,
                  left: Get.width * .05,
                  child: Row(
                    children: [
                      Container(
                        width: Get.width * .013,
                        color: ColorUtils.kTint,
                        height: Get.height * .03,
                      ),
                      SizedBox(
                        width: Get.width * .02,
                      ),
                      Text(
                        text!,
                        style: FontTextStyle.kWhite24BoldRoboto,
                      ),
                    ],
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

  _drawerList() {
    return Drawer(
      backgroundColor: ColorUtils.kBlack,
      child: SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: ColorUtils.kTint,
                  )),
            ],
          ),
          SizedBox(
            height: Get.height * .04,
          ),
          SizedBox(
              width: Get.width * .4,
              height: Get.height * .12,
              child: Image.asset(
                'asset/images/logo.png',
              )),
          SizedBox(
            height: Get.height * .04,
          ),
          GestureDetector(
            onTap: () {
              Get.to(EditProfilePage());
            },
            child: CircleAvatar(
              radius: 80,
              backgroundColor: Color(0xff363636),
              child: ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                      border: Border.all(color: Colors.white, width: 4),
                      color: Color(0xff363636),
                      image: DecorationImage(
                        image: AssetImage('asset/images/pick.png'),
                        fit: BoxFit.fill,
                      )),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * .01,
          ),
          Text(
            'ShreddedLee',
            style: FontTextStyle.kWhite16BoldRoboto,
          ),
          SizedBox(
            height: Get.height * .05,
          ),
          bild(image: AppIcons.dumbell, text: 'Training Plans'),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(image: AppIcons.video, text: 'Video Library'),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(image: AppIcons.forum, text: 'The Forums'),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(image: AppIcons.journal, text: 'Habit Tracker'),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(image: AppIcons.profile_app_icon, text: 'Profile'),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(image: AppIcons.calender, text: 'Schedule'),
          SizedBox(height: Get.height * .09),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(child: Image.asset(AppIcons.instagram)),
              GestureDetector(child: Image.asset(AppIcons.youtube)),
              GestureDetector(child: Image.asset(AppIcons.twitter))
            ],
          )
        ]),
      ),
    );
  }

  Widget bild({String? image, String? text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Column(
              children: [
                Image.asset(image!),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text!,
                  style: FontTextStyle.kWhite16W300Roboto,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
