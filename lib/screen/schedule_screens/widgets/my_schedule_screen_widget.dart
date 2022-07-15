import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/training_plan_request_model/remove_workout_program_request_model.dart';
import 'package:tcm/model/response_model/training_plans_response_model/remove_workout_program_response_model.dart';
import 'package:tcm/model/schedule_response_model/schedule_by_date_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/viewModel/schedule_viewModel/schedule_by_date_viewModel.dart';
import 'package:tcm/viewModel/training_plan_viewModel/remove_workout_program_viewModel.dart';

RemoveWorkoutProgramViewModel _removeWorkoutProgramViewModel =
    Get.put(RemoveWorkoutProgramViewModel());
ScheduleByDateViewModel _scheduleByDateViewModel =
    Get.put(ScheduleByDateViewModel());

Padding listViewTab({
  required List<Schedule> getEventForDay,
  DateTime? selectedDay,
}) {
  return Padding(
    padding: EdgeInsets.only(top: Get.height * 0.03),
    child: SizedBox(
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: getEventForDay.length,
          itemBuilder: (_, index) {
            if (getEventForDay[index].programData!.isNotEmpty ||
                getEventForDay[index].programData! == []) {
              return Padding(
                padding: EdgeInsets.only(bottom: Get.height * .03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${Jiffy(getEventForDay[index].date).format('EEEE, MMMM do')}',
                      style: FontTextStyle.kWhite16BoldRoboto,
                    ),
                    Divider(
                      color: ColorUtils.kTint,
                      height: Get.height * .03,
                      thickness: 1.5,
                    ),
                    ListView.builder(
                        itemCount: getEventForDay[index].programData!.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index1) {
                          return ListTile(
                            title: Text(
                              getEventForDay[index]
                                  .programData![index1]
                                  .workoutTitle,
                              style: FontTextStyle.kWhite17BoldRoboto,
                            ),
                            subtitle: Text(
                              '${getEventForDay[index].programData![0].workoutDurationData![0]['days'][0]['day_name']}' +
                                  " - " +
                                  ' ${getEventForDay[index].programData![0].exerciseTitle} ',
                              style: FontTextStyle.kLightGray16W300Roboto,
                            ),
                            trailing: InkWell(
                              onTap: () {
                                openBottomSheet(event: getEventForDay[index]);
                              },
                              child: Icon(
                                Icons.more_horiz_sharp,
                                color: ColorUtils.kTint,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
            } else {
              return SizedBox();
            }
          }),
    ),
  );
}

Tab tabBarCommonTab({IconData? icon, String? tabName}) {
  return Tab(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: Get.height * .02,
        ),
        SizedBox(width: Get.height * .006),
        Text(
          tabName!,
          style: TextStyle(fontSize: Get.height * .017),
        ),
      ],
    ),
  );
}

void openBottomSheet({Schedule? event}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(8),
      height: Get.height * .5,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9.5), color: ColorUtils.kBlack),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(height: Get.width * .1),
          Center(
            child: Text('${event!.programData![0].workoutTitle}',
                style: FontTextStyle.kWhite20BoldRoboto
                    .copyWith(fontSize: Get.height * .024),
                textAlign: TextAlign.center),
          ),
          Divider(
            color: ColorUtils.kTint,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                'View Workout',
                style: FontTextStyle.kTint24W400Roboto,
              )),
          Divider(
            color: ColorUtils.kTint,
          ),
          TextButton(
              onPressed: () {},
              child: Text(
                'Edit Workout',
                style: FontTextStyle.kTint24W400Roboto,
              )),
          Divider(
            color: ColorUtils.kTint,
          ),
          TextButton(
              onPressed: () async {
                RemoveWorkoutProgramRequestModel _request =
                    RemoveWorkoutProgramRequestModel();
                _request.userWorkoutProgramId = '${event.userProgramId}';
                await _removeWorkoutProgramViewModel
                    .removeWorkoutProgramViewModel(_request);

                print('goes');
                Get.back();

                if (_removeWorkoutProgramViewModel.apiResponse.status ==
                    Status.COMPLETE) {
                  print('${_removeWorkoutProgramViewModel.apiResponse.status}');

                  RemoveWorkoutProgramResponseModel removeWorkoutResponse =
                      _removeWorkoutProgramViewModel.apiResponse.data;
                  if (removeWorkoutResponse.success == true &&
                      removeWorkoutResponse.msg != null) {
                    print('${removeWorkoutResponse.msg}');

                    Get.showSnackbar(GetSnackBar(
                      message: '${removeWorkoutResponse.msg}',
                      duration: Duration(seconds: 2),
                    ));
                  } else if (removeWorkoutResponse.success == true &&
                      removeWorkoutResponse.msg == null) {
                    Get.showSnackbar(GetSnackBar(
                      message: '${removeWorkoutResponse.msg}',
                      duration: Duration(seconds: 2),
                    ));
                    print('${removeWorkoutResponse.msg}');
                  }
                } else if (_removeWorkoutProgramViewModel.apiResponse.status ==
                    Status.ERROR) {
                  print('${_removeWorkoutProgramViewModel.apiResponse.status}');

                  Get.showSnackbar(GetSnackBar(
                    message: 'Something went wrong!!!',
                    duration: Duration(seconds: 2),
                  ));
                }
                _scheduleByDateViewModel.getScheduleByDateDetails(
                    userId: PreferenceManager.getUId());
              },
              style: ButtonStyle(
                  overlayColor: MaterialStateColor.resolveWith(
                      (states) => ColorUtils.kRed.withOpacity(.1))),
              child: Text(
                'Delete Workout',
                style: FontTextStyle.kTint24W400Roboto.copyWith(
                    color: ColorUtils.kRed, fontWeight: FontWeight.w600),
              )),
          InkWell(
            onTap: () {
              print('Cancel');

              Get.back();
            },
            child: Container(
              alignment: Alignment.center,
              height: Get.height * .075,
              width: Get.width,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Cancel',
                style: FontTextStyle.kTint24W400Roboto
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    ),
    backgroundColor: ColorUtils.kBottomSheetGray,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
