import 'package:flutter/material.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';

class ConnectionCheckScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      body: Center(
          child: Text(
        "Please Check your Internet Connection!",
        style: FontTextStyle.kTint20BoldRoboto,
      )),
    );
  }
}
