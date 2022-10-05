import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:get/get.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/workout_viewModel/user_workouts_date_viewModel.dart';

class WeightedCounterCard extends StatefulWidget {
  TextEditingController editingController;
  int counter;
  int index;
  String repsNo;
  String weight;

  WeightedCounterCard({
    Key? key,
    required this.counter,
    required this.editingController,
    required this.repsNo,
    required this.weight,
    required this.index,
  }) : super(key: key);

  @override
  State<WeightedCounterCard> createState() => _WeightedCounterCardState();
}

class _WeightedCounterCardState extends State<WeightedCounterCard> {
  // TextEditingController? _weight;
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());

  @override
  void initState() {
    super.initState();
    widget.editingController = TextEditingController(text: widget.weight);
  }

  @override
  Widget build(BuildContext context) {
    int repsCounter = int.parse(widget.repsNo.toString());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Container(
        height: Get.height * .1,
        width: Get.width,
        decoration: BoxDecoration(
            border: Border.all(color: ColorUtils.kBlack, width: 2),
            gradient: LinearGradient(
                colors: ColorUtilsGradient.kGrayGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(6)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
              setState(() {
                if (widget.counter > 0) widget.counter--;
                _userWorkoutsDateViewModel.repsList.removeAt(widget.index);
                _userWorkoutsDateViewModel.repsList
                    .insert(widget.index, widget.counter);
                log('==================> ${_userWorkoutsDateViewModel.repsList}');
              });
              print('minus ${widget.counter}');
            },
            child: Container(
              height: Get.height * .06,
              width: Get.height * .06,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: ColorUtilsGradient.kTintGradient,
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
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
                // if (widget.counter < repsCounter)
                widget.counter++;
                _userWorkoutsDateViewModel.repsList.removeAt(widget.index);
                _userWorkoutsDateViewModel.repsList
                    .insert(widget.index, widget.counter);
                log('==================> ${_userWorkoutsDateViewModel.repsList}');
              });
              print('plus ${widget.counter}');
            },
            child: Container(
              height: Get.height * .06,
              width: Get.height * .06,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: ColorUtilsGradient.kTintGradient,
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
              child: Icon(Icons.add, color: ColorUtils.kBlack),
            ),
          ),
          VerticalDivider(
            width: Get.width * .08,
            thickness: 1.25,
            color: ColorUtils.kBlack,
            indent: Get.height * .015,
            endIndent: Get.height * .015,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Row(
                children: [
                  GetBuilder<UserWorkoutsDateViewModel>(
                    builder: (controller) {
                      return SizedBox(
                        width: 40,
                        child: TextField(
                          controller: widget.editingController,
                          style: widget.counter == 0
                              ? FontTextStyle.kWhite24BoldRoboto
                                  .copyWith(color: ColorUtils.kGray)
                              : FontTextStyle.kWhite24BoldRoboto,
                          keyboardType: TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          maxLength: 3,
                          cursorColor: ColorUtils.kTint,
                          onChanged: (value) {
                            if (value.isEmpty) value = "0";
                            _userWorkoutsDateViewModel.weightList
                                .removeAt(widget.index);
                            _userWorkoutsDateViewModel.weightList
                                .insert(widget.index, value);
                            log("===============> ${_userWorkoutsDateViewModel.weightList}");
                          },
                          decoration: InputDecoration(
                              hintText: '0',
                              counterText: '',
                              semanticCounterText: '',
                              hintStyle: FontTextStyle.kWhite24BoldRoboto
                                  .copyWith(color: ColorUtils.kGray),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent))),
                        ),
                      );
                    },
                  ),
                  Text('lbs', style: FontTextStyle.kWhite17W400Roboto),
                ],
              ),
              SizedBox(),
            ],
          ),
        ]),
      ),
    );
  }
}

class NoWeightedCounterCard extends StatefulWidget {
  int counter;
  String repsNo;
  int index;

  NoWeightedCounterCard({
    Key? key,
    required this.counter,
    required this.repsNo,
    required this.index,
  }) : super(key: key);

  @override
  State<NoWeightedCounterCard> createState() => _NoWeightedCounterCardState();
}

class _NoWeightedCounterCardState extends State<NoWeightedCounterCard> {
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  @override
  Widget build(BuildContext context) {
    int repsCounter = int.parse(widget.repsNo.toString());

    return Padding(
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.01),
      child: Container(
        height: Get.height * .1,
        width: Get.width,
        decoration: BoxDecoration(
            border: Border.all(color: ColorUtils.kBlack, width: 2),
            gradient: LinearGradient(
                colors: ColorUtilsGradient.kGrayGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
            borderRadius: BorderRadius.circular(6)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          InkWell(
            onTap: () {
              setState(() {
                if (widget.counter > 0) widget.counter--;
                _userWorkoutsDateViewModel.repsList.removeAt(widget.index);
                _userWorkoutsDateViewModel.repsList
                    .insert(widget.index, widget.counter);
                log('==================> ${_userWorkoutsDateViewModel.repsList}');
              });
            },
            child: Container(
              height: Get.height * .06,
              width: Get.height * .06,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: ColorUtilsGradient.kTintGradient,
                      stops: [0.0, 1.0],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter)),
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
                  // if (widget.counter < repsCounter)
                  widget.counter++;
                  _userWorkoutsDateViewModel.repsList.removeAt(widget.index);
                  _userWorkoutsDateViewModel.repsList
                      .insert(widget.index, widget.counter);
                  log('==================> ${_userWorkoutsDateViewModel.repsList}');
                });
              },
              child: Container(
                height: Get.height * .06,
                width: Get.height * .06,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                        colors: ColorUtilsGradient.kTintGradient,
                        stops: [0.0, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter)),
                child: Icon(Icons.add, color: ColorUtils.kBlack),
              )),
        ]),
      ),
    );
  }
}

class WeightedProgressTimer extends StatefulWidget {
  final double restResponseValue;
  final height;
  final width;
  final String title;
  // Timer? resTimer;

  WeightedProgressTimer({
    Key? key,
    required this.restResponseValue,
    this.height,
    this.width,
    required this.title,
    // required this.resTimer
  }) : super(key: key);
  @override
  _WeightedProgressTimerState createState() => _WeightedProgressTimerState();
}

class _WeightedProgressTimerState extends State<WeightedProgressTimer> {
  UserWorkoutsDateViewModel _userWorkoutsDateViewModel =
      Get.put(UserWorkoutsDateViewModel());
  // Timer? resTimer;
  int currentValue = 0;
  void startRestTimer() {
    // widget.resTimer = Timer.periodic(
    // resTimer =

    _userWorkoutsDateViewModel.newTimer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (currentValue >= 0 && currentValue < widget.restResponseValue) {
          setState(() {
            currentValue++;
            print('count>>>>>$currentValue');
          });
        } else {
          print('Timer Cancel');
          setState(() {
            currentValue = 0;
            // widget.resTimer!.cancel();
            // resTimer!.cancel();
            _userWorkoutsDateViewModel.newTimer!.cancel();
          });
        }
      },
    );
  }

  @override
  void dispose() {
    // widget.resTimer!.cancel();
    // resTimer!.cancel();
    // _userWorkoutsDateViewModel.newTimer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return currentValue == 0
        ? GestureDetector(
            onTap: () {
              startRestTimer();
            },
            child: Container(
              alignment: Alignment.center,
              height: widget.height ?? Get.height * .055,
              width: widget.width ?? Get.width,
              decoration: BoxDecoration(
                  color: ColorUtils.kGray,
                  borderRadius: BorderRadius.circular(6)),
              child:
                  Text(widget.title, style: FontTextStyle.kWhite17W400Roboto),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: widget.width ?? Get.width,
                height: widget.height ?? Get.height * .055,
                child: FAProgressBar(
                  animatedDuration: Duration(seconds: 1),
                  currentValue: currentValue.toDouble(),
                  backgroundColor: ColorUtils.kSaperatedGray,
                  progressColor: ColorUtils.kGreen,
                  maxValue: widget.restResponseValue,
                ),
              ),
              Text(
                widget.title,
                style: FontTextStyle.kWhite17W400Roboto,
              )
            ],
          );
  }
}
