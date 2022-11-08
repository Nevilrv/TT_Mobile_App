import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/model/request_model/create_subscription_request_model.dart';
import 'package:tcm/model/response_model/subscription_res_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/viewModel/create_subscription_viewModel.dart';
import 'package:tcm/viewModel/subscription_viewModel.dart';

import '../../utils/ColorUtils.dart';
import '../../utils/font_styles.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int index = 1;
  int amount = 0;
  int endTime = 1;
  String plan = 'month';
  bool isExpired = false;
  CreateSubscriptionViewModel createSubscriptionViewModel =
      Get.put(CreateSubscriptionViewModel());
  @override
  void initState() {
    // TODO: implement initState
    checkPlanIsExpired();
    super.initState();
  }

  checkPlanIsExpired() {
    DateTime dt1 = DateTime.now();
    DateTime dt2 =
        DateTime.parse("${PreferenceManager.isGetSubscriptionEndDate()}");

    if (dt2.isBefore(dt1)) {
      print(">>> Plan end ");
      setState(() {
        index = 2;
        amount = 50;
        isExpired = true;
      });
    } else if (PreferenceManager.isGetSubscriptionPlan() == 'free') {
      index = 2;
      amount = 50;
      isExpired = true;
    } else {
      isExpired = false;
      print(">>> Plan Continue ");
    }
  }

  @override
  Widget build(BuildContext context) {
    print('now ?> ${Jiffy().dateTime}');
    DateTime d = Jiffy().add(months: 6).dateTime; // 2020-04-26 10:05:57.469367
    print('6 month >> $d');

    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorUtils.kTint,
            )),
        backgroundColor: ColorUtils.kBlack,
        title: Text('Subscription', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.03, vertical: Get.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isExpired == true) {
                      setState(() {
                        index = 2;
                        amount = 50;
                        plan = "month";
                        endTime = 1;
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: Get.height * 0.09,
                        width: Get.width * 0.9,
                        decoration: PreferenceManager.isGetSubscriptionPlan() ==
                                    'month' &&
                                isExpired == false
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                  colors: ColorUtilsGradient.kTintGradient,
                                ),
                                color: ColorUtils.kTint)
                            : index == 2
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 1.0],
                                      colors: ColorUtilsGradient.kTintGradient,
                                    ),
                                    color: ColorUtils.kTint)
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                        Border.all(color: ColorUtils.kTint)),
                        child: Center(
                            child: Text(
                          '\$50 / Monthly',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  PreferenceManager.isGetSubscriptionPlan() ==
                                              'month' &&
                                          isExpired == false
                                      ? Colors.black
                                      : index == 2
                                          ? Colors.black
                                          : ColorUtils.kTint,
                              fontSize: Get.height * 0.023),
                        )),
                      ),
                      PreferenceManager.isGetSubscriptionPlan() == 'month' &&
                              isExpired == false
                          ? Positioned(
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ColorUtils.kGreen,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomLeft: Radius.circular(6))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.03,
                                      vertical: Get.height * 0.003),
                                  child: Text(
                                    'Active',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: ColorUtils.kWhite,
                                        fontSize: Get.height * 0.016),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    if (isExpired == true) {
                      setState(() {
                        index = 3;
                        amount = 200;
                        plan = "year";
                        endTime = 12;
                      });
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: Get.height * 0.09,
                        width: Get.width * 0.9,
                        decoration: PreferenceManager.isGetSubscriptionPlan() ==
                                    'year' &&
                                isExpired == false
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.0, 1.0],
                                  colors: ColorUtilsGradient.kTintGradient,
                                ),
                                color: ColorUtils.kTint)
                            : index == 3
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      stops: [0.0, 1.0],
                                      colors: ColorUtilsGradient.kTintGradient,
                                    ),
                                    color: ColorUtils.kTint)
                                : BoxDecoration(
                                    borderRadius: BorderRadius.circular(6),
                                    border:
                                        Border.all(color: ColorUtils.kTint)),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Get.height * 0.009,
                            ),
                            Text(
                              '\$200 / Yearly',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: PreferenceManager
                                                  .isGetSubscriptionPlan() ==
                                              'year' &&
                                          isExpired == false
                                      ? Colors.black
                                      : index == 3
                                          ? Colors.black
                                          : ColorUtils.kTint,
                                  fontSize: Get.height * 0.023),
                            ),
                            Text(
                              'Save \$400 a year',
                              style: TextStyle(
                                  color: PreferenceManager
                                                  .isGetSubscriptionPlan() ==
                                              'year' &&
                                          isExpired == false
                                      ? Colors.black
                                      : index == 3
                                          ? Colors.black
                                          : ColorUtils.kTint,
                                  fontSize: Get.height * 0.015),
                            ),
                          ],
                        )),
                      ),
                      PreferenceManager.isGetSubscriptionPlan() == 'year' &&
                              isExpired == false
                          ? Positioned(
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ColorUtils.kGreen,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(6),
                                        bottomLeft: Radius.circular(6))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.03,
                                      vertical: Get.height * 0.003),
                                  child: Text(
                                    'Active',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: ColorUtils.kWhite,
                                        fontSize: Get.height * 0.016),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
              ],
            ),
            PreferenceManager.isGetSubscriptionPlan() == 'free'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Free Plan - ",
                        style: FontTextStyle.kWhite16BoldRoboto,
                      ),
                      Text(
                        "${DateTime.parse(PreferenceManager.isGetSubscriptionEndDate()).difference(DateTime.now()).inDays} Day Left",
                        style: FontTextStyle.kWhite16BoldRoboto.copyWith(
                            fontSize: Get.height * 0.018,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                : isExpired == true
                    ? Center(
                        child: Text(
                          "Please purchase new plan ",
                          style: FontTextStyle.kWhite16BoldRoboto.copyWith(
                              fontSize: Get.height * 0.018,
                              fontWeight: FontWeight.w400),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Your plan will be expired on ${DateFormat('dd, MMMM yyyy').format(DateTime.parse(PreferenceManager.isGetSubscriptionEndDate()))} ",
                            style: FontTextStyle.kWhite16BoldRoboto.copyWith(
                                fontSize: Get.height * 0.018,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
            Spacer(),
            isExpired == true
                ? Column(
                    children: [
                      Divider(
                        color: ColorUtils.kTint,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: Get.height * 0.01,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: Get.width * 0.05,
                          ),
                          Text(
                            '\$$amount',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: ColorUtils.kWhite,
                                fontSize: Get.height * 0.025),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: () async {
                              print('plan >>> $plan');
                              print('month >>> $endTime');
                              print(
                                  'expire plan date >>> ${Jiffy().add(months: endTime).dateTime.toString()}');
                              SubscriptionRequestModel model =
                                  SubscriptionRequestModel();
                              model.userId = PreferenceManager.getUId();
                              model.startDate = Jiffy().dateTime.toString();
                              model.endDate = Jiffy()
                                  .add(months: endTime)
                                  .dateTime
                                  .toString();
                              model.currentPlan = plan;
                              await createSubscriptionViewModel
                                  .subscriptionViewModel(
                                      model, ApiRoutes().updateSubscriptionUrl)
                                  .whenComplete(() {
                                Get.to(HomeScreen());
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: ColorUtils.kTint,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Get.height * 0.01,
                                    horizontal: Get.width * 0.1),
                                child: Text(
                                  'Pay',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtils.kBlack,
                                      fontSize: Get.height * 0.018),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Get.width * 0.05,
                          ),
                        ],
                      )
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: Get.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
