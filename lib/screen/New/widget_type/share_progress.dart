import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/home_screen.dart';
import 'package:tcm/screen/workout_screen/widget/share_sheet_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/app_text.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import 'package:tcm/viewModel/update_status_user_program_viewModel.dart';
import 'package:tcm/viewModel/workout_viewModel/share_viewModel.dart';

class NewShareProgressScreen extends StatefulWidget {
  final String? workoutId;
  NewShareProgressScreen({Key? key, this.workoutId}) : super(key: key);

  @override
  State<NewShareProgressScreen> createState() => _NewShareProgressScreenState();
}

class _NewShareProgressScreenState extends State<NewShareProgressScreen> {
  ShareViewModel _shareViewModel = Get.put(ShareViewModel());

  UpdateStatusUserProgramViewModel _updateStatusUserProgramViewModel =
      Get.put(UpdateStatusUserProgramViewModel());

  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  @override
  void initState() {
    print('NewShareProgressScreen userDateid >>>> ${widget.workoutId}');
    _connectivityCheckViewModel.startMonitoring();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(
      builder: (control) => control.isOnline
          ? Scaffold(
              backgroundColor: ColorUtils.kBlack,
              body: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.06, vertical: Get.height * 0.015),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.06),
                        child: SizedBox(
                          height: Get.height * .75,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'COMPLETE',
                                  style:
                                      FontTextStyle.kWhite24BoldRoboto.copyWith(
                                    fontSize: Get.height * 0.032,
                                  ),
                                ),
                                Container(
                                  height: Get.height * .33,
                                  width: Get.width * .5,
                                  child: Image.asset(
                                    AppImages.workoutProgress,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  AppText.shareProgressSuccess,
                                  style: FontTextStyle.kWhite20BoldRoboto
                                      .copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: Get.height * .022),
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '',
                                  style: FontTextStyle.kWhite24BoldRoboto
                                      .copyWith(fontSize: Get.height * 0.023),
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  width: Get.width * .5,
                                  child: commonNavigationButton(
                                      name: 'Share',
                                      onTap: () {
                                        Get.to(ShareSheetScreen(),
                                            transition: Transition.downToUp);
                                        // shareBottomSheet();
                                      }),
                                ),
                              ]),
                        ),
                      ),
                      commonNavigationButton(
                          name: 'Finish',
                          onTap: () {
                            Get.offAll(HomeScreen());

                            /* UpdateStatusUserProgramRequestModel _request =
                                UpdateStatusUserProgramRequestModel();

                            _request.userProgramDatesId = widget.workoutId;

                            await _updateStatusUserProgramViewModel
                                .updateStatusUserProgramViewModel(_request);

                            if (_updateStatusUserProgramViewModel
                                    .apiResponse.status ==
                                Status.COMPLETE) {
                              UpdateStatusUserProgramResponseModel response =
                                  _updateStatusUserProgramViewModel
                                      .apiResponse.data;

                              if (response.success == true) {
                                print('message === ${response.msg}');
                                Get.showSnackbar(GetSnackBar(
                                  message: '${response.msg}',
                                  duration: Duration(milliseconds: 1500),
                                ));
                              } else if (response.success == false) {
                                Get.showSnackbar(GetSnackBar(
                                  message: '${response.msg}',
                                  duration: Duration(milliseconds: 1500),
                                ));
                              }
                            } else if (_updateStatusUserProgramViewModel
                                    .apiResponse.status ==
                                Status.ERROR) {
                              Get.showSnackbar(GetSnackBar(
                                message: 'Something Went Wrong',
                                duration: Duration(milliseconds: 1500),
                              ));
                            }*/
                          })
                    ]),
              ),
            )
          : ConnectionCheckScreen(),
    );
  }

  Future<dynamic> shareBottomSheet() {
    return Get.bottomSheet(Container(
      decoration: BoxDecoration(
          color: ColorUtils.kBlack,
          borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.height * .04),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 15, height: 15),
                  Text('Share', style: FontTextStyle.kTint20BoldRoboto),
                  InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: ColorUtils.kTint,
                      )),
                ]),
          ),
          Container(
            height: Get.height * .2,
            width: Get.width * .3,
            child: Image.asset(AppImages.perfectDayIllustration),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                  onTap: () {
                    _shareViewModel.launchFacebook();
                  },
                  child: Image.asset(AppIcons.facebook,
                      height: Get.height * .05,
                      width: Get.height * .05,
                      fit: BoxFit.contain)),
              GestureDetector(
                  onTap: () {
                    _shareViewModel.launchTwitter();
                  },
                  child: Image.asset(AppIcons.twitter,
                      height: Get.height * .05,
                      width: Get.height * .05,
                      fit: BoxFit.contain)),
              GestureDetector(
                  onTap: () {
                    _shareViewModel.launchInsta();
                  },
                  child: Image.asset(AppIcons.instagram,
                      height: Get.height * .05,
                      width: Get.height * .05,
                      fit: BoxFit.contain))
            ],
          ),
          // Row(
          //   mainAxisAlignment:
          //       MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Image.asset(AppIcons.facebook,
          //         height: Get.height * .05,
          //         width: Get.height * .05,
          //         fit: BoxFit.contain),
          //     Image.asset(AppIcons.twitter,
          //         height: Get.height * .05,
          //         width: Get.height * .05,
          //         fit: BoxFit.contain),
          //     Image.asset(AppIcons.instagram,
          //         height: Get.height * .05,
          //         width: Get.height * .05,
          //         fit: BoxFit.contain),
          //   ],
          // ),
        ],
      ),
    ));
  }
}
