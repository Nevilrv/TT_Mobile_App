import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/home_screen.dart';

import '../utils/ColorUtils.dart';
import 'on_boarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 1),
        () => PreferenceManager.isGetLogin() == true
            ? Get.off(() => HomeScreen(
                  id: PreferenceManager.getUId(),
                ))
            : Get.to(() => OnBoardingScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      body: Center(
          child: Image.asset(
        'asset/images/logo.png',
        height: Get.height,
        width: Get.width,
      )),
    );
  }
}
