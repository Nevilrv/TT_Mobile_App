import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/singIn_screens.dart';

import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'sing_up.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController _controller = PageController(
    initialPage: 0,
  );
  int index1 = 0;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: Get.height,
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (val) {
                      setState(() {
                        index1 = val;
                      });
                    },
                    children: [
                      pages(
                          image: 'asset/images/page1.png',
                          text:
                              'Learn How To Burn Fat, Build Muscle, Get Stronger, and actually enjoy the process!',
                          islogo: true),
                      pages(
                          image: 'asset/images/page2.png',
                          text:
                              'This is another blurb of text that hopefully will make people tap on the free trial button below.',
                          islogo: false),
                      pages(
                          image: 'asset/images/page3.png',
                          text:
                              'Nutrition is another area you could mention here even if it is an upsell to coaching. Should still mention it?',
                          islogo: false),
                      pages(
                          image: 'asset/images/page4.png',
                          text:
                              'This is the last page of the onboard flow. This is the final message to get people to signup. It’s do or die here.',
                          islogo: false),
                    ],
                  ),
                ),
              ],
            ),
            footerText(),
          ],
        ),
      ),
    );
  }

  Widget circle({Color? color}) {
    return CircleAvatar(
      radius: 5,
      backgroundColor: color,
    );
  }

  Widget footerText() {
    return Positioned(
      top: Get.height * 0.8,
      child: Column(
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  4,
                  (index) => Row(
                        children: [
                          circle(
                              color:
                                  index1 == index ? Colors.white : Colors.grey),
                          SizedBox(
                            width: Get.width * .02,
                          ),
                        ],
                      ))),
          SizedBox(
            height: Get.height * 0.04,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: Get.height * 0.06,
                width: Get.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ColorUtils.kTint),
                child: Center(
                    child: Text(
                  'Start 7-Day Free Trial',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: Get.height*0.02),
                )),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.017,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already a member?',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: Get.height*0.018),
              ),
              InkWell(
                child: Text(
                  ' Sign In',
                  style: TextStyle(
                    color: ColorUtils.kTint,
                    fontSize: Get.height*0.022,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),
                ),
                onTap: () {
                  Get.to(SingInScreen());
                  // Get.to(SignUpScreen());
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget pages({String? image, String? text, bool? islogo}) {
    return Stack(
      children: [
        Container(
          height: Get.height,
          width: Get.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    image!,
                  ),
                  colorFilter:
                      ColorFilter.mode(Colors.white, BlendMode.colorBurn),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              islogo == true
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                      child: SizedBox(
                        height: Get.height * 0.29,
                        width: Get.width * 0.37,
                        child: Image.asset('asset/images/logo.png'),
                      ),
                    )
                  : SizedBox(
                      height: Get.height * 0.29,
                      width: Get.width * 0.37,
                    ),
              SizedBox(
                height: Get.height * 0.4,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.16),
                child: Container(
                  width: Get.width * 0.7,
                  child: Text(
                    text!,
                    textAlign: TextAlign.center,
                    style: FontTextStyle.kWhite17W400Roboto,
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.04,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
