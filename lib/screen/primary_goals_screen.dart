import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/register_request_model.dart';
import 'package:tcm/model/response_model/goal_res_model.dart';
import 'package:tcm/model/response_model/register_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/viewModel/goal_view_model.dart';
import 'package:tcm/viewModel/register_viewModel.dart';
import 'package:dio/dio.dart' as dio;

import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'home_screen.dart';

class PrimaryGoalsScreen extends StatefulWidget {
  final File? image;
  final String? skippedImage;
  final String? fname;
  final String? lname;
  final String? email;
  final String? pass;
  final String? userName;
  final String? gender;
  final String? phone;
  final String? dob;
  final String? weight;
  final String? experienceLevel;
  const PrimaryGoalsScreen(
      {Key? key,
      this.image,
      this.fname,
      this.lname,
      this.email,
      this.pass,
      this.userName,
      this.gender,
      this.phone,
      this.dob,
      this.weight,
      this.experienceLevel,
      this.skippedImage})
      : super(key: key);

  @override
  _PrimaryGoalsScreenState createState() => _PrimaryGoalsScreenState();
}

class _PrimaryGoalsScreenState extends State<PrimaryGoalsScreen> {
  GoalViewModel _goalViewModel = Get.put(GoalViewModel());
  RegisterViewModel _registerViewModel = Get.put(RegisterViewModel());

  int? index = 0;
  @override
  void initState() {
    _goalViewModel.goals();
    super.initState();

    print('image+++++${widget.image}');
    print('skippedImage+++++${widget.skippedImage}');
    print('fname======== ${widget.fname}');
    print('lname======== ${widget.lname}');
    print('email======== ${widget.email}');
    print('pass======== ${widget.pass}');
    print('userName======== ${widget.userName}');
    print('gender======== ${widget.gender}');
    print('phone======== ${widget.phone}');
    print('dob======== ${widget.dob}');
    print('weight======== ${widget.weight}');
    print('level======== ${widget.experienceLevel}');
  }

  String? ids;
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
          title: Text('Primary Goals', style: FontTextStyle.kWhite16BoldRoboto),
          centerTitle: true,
        ),
        body: GetBuilder<GoalViewModel>(
          builder: (controller) {
            if (_goalViewModel.apiResponse.status == Status.LOADING) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: Get.height * .1),
                child: Center(
                  child: CircularProgressIndicator(
                    color: ColorUtils.kTint,
                  ),
                ),
              );
            }
            if (_goalViewModel.apiResponse.status == Status.ERROR) {
              return Text('Data not found!');
            }

            GoalsResModel response = _goalViewModel.apiResponse.data;
            return Container(
              height: Get.height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.04,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Text(
                            'Choose what your primary fitness goals are You can choose multiple.',
                            style: FontTextStyle.kWhite16W300Roboto,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.04,
                        ),
                        ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: response.data!.length,
                          separatorBuilder: (_, index) {
                            return SizedBox(
                              height: Get.height * 0.03,
                            );
                          },
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                controller.selectedGoals(
                                    goals:
                                        '${response.data![index].goalTitle}');
                                log('${response.data![index].goalTitle}');
                                log('${controller.selectedGoalList}');
                              },
                              child: Container(
                                // height: Get.height * 0.17,
                                // width: Get.width * 0.99,
                                decoration: controller.selectedGoalList.contains(
                                        '${response.data![index].goalTitle}')
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: ColorUtils.kTint)
                                    : BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xff363636)),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      controller.selectedGoalList.contains(
                                              '${response.data![index].goalTitle}')
                                          ? Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    '${response.data![index].goalTitle}',
                                                    style: controller
                                                            .selectedGoalList
                                                            .contains(
                                                                '${response.data![index].goalTitle}')
                                                        ? FontTextStyle
                                                            .kBlack20BoldRoboto
                                                        : FontTextStyle
                                                            .kWhite20BoldRoboto,
                                                  ),
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: CircleAvatar(
                                                      radius: 20,
                                                      backgroundColor:
                                                          Colors.black,
                                                      child: Icon(
                                                        Icons.done,
                                                        size: 30,
                                                        color: ColorUtils.kTint,
                                                      )),
                                                )
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  child: Text(
                                                    '${response.data![index].goalTitle}',
                                                    style: controller
                                                            .selectedGoalList
                                                            .contains(
                                                                '${response.data![index].goalTitle}')
                                                        ? FontTextStyle
                                                            .kBlack20BoldRoboto
                                                        : FontTextStyle
                                                            .kWhite20BoldRoboto,
                                                  ),
                                                ),
                                                Spacer(),
                                              ],
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: controller.selectedGoalList.contains(
                                                '${response.data![index].goalTitle}')
                                            ? htmlToTextGoalSelected(
                                                data: response.data![index]
                                                    .goalDescription)
                                            : htmlToTextGoalUnselected(
                                                data: response.data![index]
                                                    .goalDescription),

                                        // Text(
                                        //   '${response.data![0].goalDescription}',
                                        //   style: index == 1
                                        //       ? FontTextStyle.kBlack16W300Roboto
                                        //       : FontTextStyle.kWhite16W300Roboto,
                                        // ),
                                      ),
                                      SizedBox(
                                        height: Get.height * .02,
                                      ),
                                    ]),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Get.width * 0.05),
                          child: GestureDetector(
                            onTap: () async {
                              if (response.success == true) {
                                RegisterRequestModel _request =
                                    RegisterRequestModel();

                                _request.fname = widget.fname;
                                _request.lname = widget.lname;
                                _request.email = widget.email;
                                _request.password = widget.pass;
                                _request.username = widget.userName;
                                _request.gender = widget.gender;
                                _request.phone = widget.phone;
                                _request.dob = widget.dob;
                                _request.weight = widget.weight;
                                _request.experienceLevel =
                                    widget.experienceLevel;

                                await _registerViewModel
                                    .registerViewModel(_request);

                                if (_registerViewModel.apiResponse.status ==
                                    Status.COMPLETE) {
                                  RegisterResponseModel response =
                                      _registerViewModel.apiResponse.data;

                                  print('response --- $response');

                                  if (response.data != null ||
                                      response.data != '') {
                                    if (response.success == true &&
                                        response.data != null) {
                                      Get.showSnackbar(GetSnackBar(
                                        message: 'Register Done',
                                        duration: Duration(seconds: 1),
                                      ));

                                      ids = response.data!.id;
                                      PreferenceManager.setEmail(
                                          response.data!.email!);
                                      PreferenceManager.setPassword(
                                          response.data!.password!);
                                      PreferenceManager.setUserName(
                                          response.data!.username!);
                                      PreferenceManager.setUId(
                                          response.data!.id!);
                                      PreferenceManager.setWeight(
                                          response.data!.weight!);
                                      PreferenceManager.setPhoneNumber(
                                          response.data!.phone!);
                                      PreferenceManager.setUserType(
                                          response.data!.gender!);
                                      PreferenceManager.isSetLogin(true);

                                      print(
                                          'response.data!.id!=========== ${response.data!.id!}');
                                      print(
                                          'EMAIL ${PreferenceManager.getEmail()}');
                                      Get.off(HomeScreen(
                                        id: PreferenceManager.getUId(),
                                      ));
                                    } else {
                                      Get.showSnackbar(GetSnackBar(
                                        message: response.msg,
                                        duration: Duration(seconds: 2),
                                      ));
                                    }
                                  }
                                } else {
                                  CircularProgressIndicator(
                                    color: ColorUtils.kTint,
                                  );
                                }

                                if (widget.image ==
                                        "https://tcm.sataware.dev" ||
                                    widget.image == null) {
                                  Map<String, dynamic> data = {
                                    'user_id': ids.toString(),
                                    'profile_pic':
                                        await dio.MultipartFile.fromFile(
                                            widget.skippedImage!),
                                  };

                                  Map<String, String> header = {
                                    'content-type': 'application/json'
                                  };

                                  dio.FormData formData =
                                      dio.FormData.fromMap(data);

                                  dio.Response result = await dio.Dio().post(
                                      'https://tcm.sataware.dev//json/data_user_profile.php',
                                      data: formData,
                                      options: dio.Options(headers: header));
                                  Map<String, dynamic> dataa = result.data;
                                  print(
                                      'dataa profile===${dataa['data'][0]['profile_pic']}');
                                  print('dataa all ===${dataa['data'][0]}');
                                  print('dataa -----> ===${dataa['data']}');
                                  print('dataa===$dataa');

                                  PreferenceManager.setProfilePic(
                                      dataa['data'][0]['profile_pic']);
                                } else {
                                  Map<String, dynamic> data = {
                                    'user_id': ids.toString(),
                                    'profile_pic':
                                        await dio.MultipartFile.fromFile(
                                            widget.image!.path),
                                  };

                                  Map<String, String> header = {
                                    'content-type': 'application/json'
                                  };

                                  dio.FormData formData =
                                      dio.FormData.fromMap(data);

                                  dio.Response result = await dio.Dio().post(
                                      'https://tcm.sataware.dev//json/data_user_profile.php',
                                      data: formData,
                                      options: dio.Options(headers: header));
                                  Map<String, dynamic> dataa = result.data;
                                  print(
                                      'dataa profile===${dataa['data'][0]['profile_pic']}');
                                  print('dataa all ===${dataa['data'][0]}');
                                  print('dataa -----> ===${dataa['data']}');
                                  print('dataa===$dataa');

                                  PreferenceManager.setProfilePic(
                                      dataa['data'][0]['profile_pic']);
                                }
                              } else {
                                CircularProgressIndicator(
                                  color: ColorUtils.kTint,
                                );
                              }
                            },
                            child: Container(
                              height: Get.height * 0.06,
                              width: Get.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: ColorUtils.kTint),
                              child: Center(
                                  child: Text(
                                'Finish Profile',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: Get.height * 0.02),
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.05,
                        )
                      ]),
                ),
              ),
            );
          },
        ));
  }
}
