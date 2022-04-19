import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'ColorUtils.dart';

class FontTextStyle {
  static TextStyle kWhite17W400Roboto = TextStyle(
    color: Colors.white,
    fontSize: Get.width * 0.038,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );
  static TextStyle kWhite17BoldRoboto = TextStyle(
    color: Colors.white,
    fontSize: Get.width * 0.038,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
  );

  static TextStyle kTine16W400Roboto = TextStyle(
    color: ColorUtils.kTint,
    fontSize: Get.width * 0.036,
    fontWeight: FontWeight.w400,
    fontFamily: 'Roboto',
  );
  static TextStyle kWhite24BoldRoboto = TextStyle(
    color: Colors.white,
    fontSize: Get.width * 0.05,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
  );
  static TextStyle kTine17BoldRoboto = TextStyle(
    color: ColorUtils.kTint,
    fontSize: Get.width * 0.038,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
  );

  static TextStyle kWhite16W300Roboto = TextStyle(
      color: Colors.white,
      fontSize: Get.width * 0.036,
      fontWeight: FontWeight.w300,
      fontFamily: 'Roboto');
  static TextStyle kBlack16W300Roboto = TextStyle(
      color: Colors.black,
      fontSize: Get.width * 0.036,
      fontWeight: FontWeight.w300,
      fontFamily: 'Roboto');
  static TextStyle kWhite20BoldRoboto = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: Get.width * .042);
  static TextStyle kBlack20BoldRoboto = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: Get.width * .042);

  static TextStyle kGreyBoldRoboto = TextStyle(
      color: Colors.grey, fontWeight: FontWeight.bold, fontFamily: 'Roboto');
  static TextStyle kGrey18BoldRoboto = TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.bold,
      fontFamily: 'Roboto',
      fontSize: Get.width * 0.038);
}
