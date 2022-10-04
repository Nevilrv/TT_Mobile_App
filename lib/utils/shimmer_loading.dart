import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
