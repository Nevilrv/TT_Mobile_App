import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/get_habit_record_date_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/get_habit_record_date_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/habit_tracker/habit_selection_screen.dart';
import 'package:tcm/screen/habit_tracker/update_progress_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/habit_tracking_viewModel/get_habit_record_viewModel.dart';

class HabitTrackerHomeScreen extends StatefulWidget {
  @override
  State<HabitTrackerHomeScreen> createState() => _HabitTrackerHomeScreenState();
}

class _HabitTrackerHomeScreenState extends State<HabitTrackerHomeScreen> {
  GetHabitRecordDateViewModel _getHabitRecordDateViewModel =
      Get.put(GetHabitRecordDateViewModel());

  List tmpDateList = [];
  String? finalDate;
  DateTime today = DateTime.now();
  GetHabitRecordDateResponseModel? response;

  initState() {
    super.initState();
    dateApiCall();
  }

  dateApiCall() async {
    tmpDateList = today.toString().split(" ");
    finalDate = tmpDateList[0];

    GetHabitRecordDateRequestModel _request = GetHabitRecordDateRequestModel();

    _request.userId = PreferenceManager.getUId();
    _request.date = finalDate;
    await _getHabitRecordDateViewModel.getHabitRecordDateViewModel(
        isLoding: true, model: _request);
    GetHabitRecordDateResponseModel resp =
        _getHabitRecordDateViewModel.apiResponse.data;

    response = resp;
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text('Habit Tracking', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * .06, vertical: Get.height * .025),
        child: Column(
          children: [
            Container(
              height: Get.height * .7,
              width: Get.width,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: Get.height * .3,
                      width: Get.height * .45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: AssetImage(
                                AppImages.habitTrackerHome,
                              ),
                              fit: BoxFit.fitHeight)),
                    ),
                    SizedBox(height: Get.height * .07),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                          text: AppText.habitTrackerHome1,
                          style: FontTextStyle.kWhite16W300Roboto.copyWith(
                            fontSize: Get.height * 0.02,
                          ),
                          children: [
                            TextSpan(
                                text: ' Habit\nTracker! ',
                                style: FontTextStyle.kWhite16BoldRoboto),
                            TextSpan(
                                text: AppText.habitTrackerHome2,
                                style: FontTextStyle.kWhite16W300Roboto
                                    .copyWith(fontSize: Get.height * .02))
                          ]),
                    )
                  ]),
            ),
            commonNavigationButton(
                onTap: () {
                  Get.to(HabitSelectionScreen());
                },
                name: 'Get Started!')
          ],
        ),
      ),
    );
  }
}
