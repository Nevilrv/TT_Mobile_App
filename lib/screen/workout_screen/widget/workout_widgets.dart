import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';

class WeightedCounter extends StatefulWidget {
  int counter;
  String repsNo;

  WeightedCounter({Key? key, required this.counter, required this.repsNo})
      : super(key: key);

  @override
  State<WeightedCounter> createState() => _WeightedCounterState();
}

class _WeightedCounterState extends State<WeightedCounter> {
  @override
  Widget build(BuildContext context) {
    int repsCounter = int.parse(widget.repsNo.toString());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Container(
        height: Get.height * .1,
        width: Get.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: ColorUtilsGradient.kGrayGradient,
                begin: Alignment.topCenter,
                end: Alignment.topCenter),
            borderRadius: BorderRadius.circular(6)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
              setState(() {
                if (widget.counter > 0) widget.counter--;
              });
            },
            child: CircleAvatar(
              radius: Get.height * .03,
              backgroundColor: ColorUtils.kTint,
              child: Icon(Icons.remove, color: ColorUtils.kBlack),
            ),
          ),
          SizedBox(width: Get.width * .08),
          RichText(
              text: TextSpan(
                  text: '${widget.counter} ',
                  style: widget.counter == 0
                      ? FontTextStyle.kWhite24BoldRoboto
                          .copyWith(color: ColorUtils.kGray)
                      : FontTextStyle.kWhite24BoldRoboto,
                  children: [
                TextSpan(text: 'reps', style: FontTextStyle.kWhite17W400Roboto)
              ])),
          SizedBox(width: Get.width * .08),
          InkWell(
            onTap: () {
              setState(() {
                if (widget.counter < repsCounter) widget.counter++;
              });
            },
            child: CircleAvatar(
              radius: Get.height * .03,
              backgroundColor: ColorUtils.kTint,
              child: Icon(Icons.add, color: ColorUtils.kBlack),
            ),
          ),
          VerticalDivider(
            width: Get.width * .08,
            thickness: 1.25,
            color: ColorUtils.kGray,
            indent: Get.height * .015,
            endIndent: Get.height * .015,
          ),
          RichText(
              text: TextSpan(
                  text: '340 ',
                  style: widget.counter == 0
                      ? FontTextStyle.kWhite24BoldRoboto
                          .copyWith(color: ColorUtils.kGray)
                      : FontTextStyle.kWhite24BoldRoboto,
                  children: [
                TextSpan(text: 'lbs', style: FontTextStyle.kWhite17W400Roboto)
              ])),
        ]),
      ),
    );
  }
}

class NoWeightedCounter extends StatefulWidget {
  int counter;
  String repsNo;

  NoWeightedCounter({Key? key, required this.counter, required this.repsNo})
      : super(key: key);

  @override
  State<NoWeightedCounter> createState() => _NoWeightedCounterState();
}

class _NoWeightedCounterState extends State<NoWeightedCounter> {
  @override
  Widget build(BuildContext context) {
    int repsCounter = int.parse(widget.repsNo.toString());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Container(
        height: Get.height * .1,
        width: Get.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: ColorUtilsGradient.kGrayGradient,
                begin: Alignment.topCenter,
                end: Alignment.topCenter),
            borderRadius: BorderRadius.circular(6)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
              setState(() {
                setState(() {
                  if (widget.counter > 0) widget.counter--;
                });
              });
            },
            child: CircleAvatar(
              radius: Get.height * .03,
              backgroundColor: ColorUtils.kTint,
              child: Icon(Icons.remove, color: ColorUtils.kBlack),
            ),
          ),
          SizedBox(width: Get.width * .08),
          RichText(
              text: TextSpan(
                  text: '${widget.counter} ',
                  style: widget.counter == 0
                      ? FontTextStyle.kWhite24BoldRoboto
                          .copyWith(color: ColorUtils.kGray)
                      : FontTextStyle.kWhite24BoldRoboto,
                  children: [
                TextSpan(text: 'reps', style: FontTextStyle.kWhite17W400Roboto)
              ])),
          SizedBox(width: Get.width * .08),
          InkWell(
            onTap: () {
              setState(() {
                setState(() {
                  if (widget.counter < repsCounter) widget.counter++;
                });
              });
            },
            child: CircleAvatar(
              radius: Get.height * .03,
              backgroundColor: ColorUtils.kTint,
              child: Icon(Icons.add, color: ColorUtils.kBlack),
            ),
          ),
        ]),
      ),
    );
  }
}
