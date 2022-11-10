import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tcm/utils/ColorUtils.dart';

import 'font_styles.dart';

Widget shimmerLoading() {
  return Shimmer.fromColors(
      child: TextButton(
        onPressed: null,
        child: Text(
          "Loading...",
          style: FontTextStyle.kTint24W400Roboto,
        ),
      ),
      baseColor: ColorUtils.kBlack,
      highlightColor: ColorUtils.kTint.withOpacity(0.5));
}

Widget shimmerButtonLoading({double? height, double? width}) {
  return Shimmer.fromColors(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * .02),
        child: Container(
            height: height,
            width: width,
            color: ColorUtils.kTint.withOpacity(0.5)),
      ),
      baseColor: ColorUtils.kBlack,
      highlightColor: ColorUtils.kTint.withOpacity(0.5));
}
