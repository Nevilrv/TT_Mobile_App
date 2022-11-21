import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/exp_res_model.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/primary_goals_screen%20.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';
import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import '../viewModel/experience_view_model.dart';

class ExperienceLevelPage extends StatefulWidget {
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
  const ExperienceLevelPage(
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
      this.skippedImage})
      : super(key: key);

  @override
  _ExperienceLevelPageState createState() => _ExperienceLevelPageState();
}

class _ExperienceLevelPageState extends State<ExperienceLevelPage> {
  ExperienceViewModel _experienceLevelRes = Get.put(ExperienceViewModel());

  int? selectedIndex = 0;
  String? selectedLevel;
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());
  @override
  void initState() {
    super.initState();
    _connectivityCheckViewModel.startMonitoring();
    _experienceLevelRes.getExperienceLevel();
    print('image========${widget.image}');
    print('skippedImage========${widget.skippedImage}');
    print('fname======== ${widget.fname}');
    print('lname======== ${widget.lname}');
    print('email======== ${widget.email}');
    print('pass======== ${widget.pass}');
    print('userName======== ${widget.userName}');
    print('gender======== ${widget.gender}');
    print('phone======== ${widget.phone}');
    print('dob======== ${widget.dob}');
    print('weight======== ${widget.weight}');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ConnectivityCheckViewModel>(
      builder: (control) => control.isOnline
          ? Scaffold(
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
                title: Text('Experience Level',
                    style: FontTextStyle.kWhite16BoldRoboto),
                centerTitle: true,
                actions: [
                  GetBuilder<ExperienceViewModel>(builder: (controller) {
                    if (controller.apiResponse.status == Status.COMPLETE) {
                      ExperienceLevelResModel response =
                          controller.apiResponse.data;
                      String? skipSelected = response.data![0].title;
                      return TextButton(
                          onPressed: () async {
                            print('level ------ $skipSelected');
                            Get.to(PrimaryGoalsScreen(
                              skippedImage: widget.skippedImage,
                              image: widget.image,
                              fname: widget.fname,
                              lname: widget.lname,
                              email: widget.email,
                              pass: widget.pass,
                              userName: widget.userName,
                              gender: widget.gender,
                              phone: widget.phone,
                              weight: widget.weight,
                              dob: widget.dob,
                              experienceLevel: 'beginner',
                            ));
                          },
                          child: Text(
                            'Skip',
                            style: FontTextStyle.kTine16W400Roboto,
                          ));
                    } else {
                      return SizedBox();
                    }
                  })
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        GetBuilder<ExperienceViewModel>(
                          builder: (controller) {
                            if (controller.apiResponse.status ==
                                Status.LOADING) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: Get.height * .32),
                                child: Center(
                                  child: CircularProgressIndicator(
                                      color: ColorUtils.kTint),
                                ),
                              );
                            }
                            if (controller.apiResponse.status == Status.ERROR) {
                              return Text('Data not found!');
                            }
                            ExperienceLevelResModel response =
                                _experienceLevelRes.apiResponse.data;

                            return Column(
                              children: [
                                Center(
                                  child: Text(
                                    'Choose your current experience level.',
                                    style: FontTextStyle.kWhite17W400Roboto,
                                  ),
                                ),
                                SizedBox(
                                  height: Get.height * 0.04,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: response.data!.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              selectedIndex = index;
                                              selectedLevel =
                                                  response.data![index].slug;
                                            });
                                          },
                                          child: Container(
                                            // height: Get.height * 0.18,
                                            // width: Get.width * 0.99,
                                            decoration: index == selectedIndex
                                                ? BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: ColorUtils.kTint)
                                                : BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Color(0xff363636)),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  index == selectedIndex
                                                      ? Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              child: Text(
                                                                '${response.data![index].title}',
                                                                style: index == selectedIndex
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
                                                                  horizontal:
                                                                      20),
                                                              child:
                                                                  CircleAvatar(
                                                                      radius:
                                                                          20,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .black,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .done,
                                                                        size:
                                                                            30,
                                                                        color: ColorUtils
                                                                            .kTint,
                                                                      )),
                                                            )
                                                          ],
                                                        )
                                                      : Row(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(20),
                                                              child: Text(
                                                                '${response.data![index].title}',
                                                                style: index == selectedIndex
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
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 20),
                                                    child: Text(
                                                      '${response.data![index].description}',
                                                      style: index ==
                                                              selectedIndex
                                                          ? FontTextStyle
                                                              .kBlack16W300Roboto
                                                          : FontTextStyle
                                                              .kWhite16W300Roboto,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: Get.height * .02,
                                                  )
                                                ]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: Get.height * 0.04,
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       index = 1;
                                //       selectedlevel = response.data![1].title;
                                //       print('level ---------------  $selectedlevel');
                                //     });
                                //   },
                                //   child: Container(
                                //     // height: Get.height * 0.18,
                                //     // width: Get.width * 0.99,
                                //     decoration: index == 1
                                //         ? BoxDecoration(
                                //             borderRadius: BorderRadius.circular(10),
                                //             color: ColorUtils.kTint)
                                //         : BoxDecoration(
                                //             borderRadius: BorderRadius.circular(10),
                                //             color: Color(0xff363636)),
                                //     child: Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           index == 1
                                //               ? Row(
                                //                   children: [
                                //                     Padding(
                                //                       padding: const EdgeInsets.all(20),
                                //                       child: Text(
                                //                         '${response.data![1].title}',
                                //                         style: index == 1
                                //                             ? FontTextStyle
                                //                                 .kBlack20BoldRoboto
                                //                             : FontTextStyle
                                //                                 .kWhite20BoldRoboto,
                                //                       ),
                                //                     ),
                                //                     Spacer(),
                                //                     Padding(
                                //                       padding: const EdgeInsets.symmetric(
                                //                           horizontal: 20),
                                //                       child: CircleAvatar(
                                //                           radius: 20,
                                //                           backgroundColor: Colors.black,
                                //                           child: Icon(
                                //                             Icons.done,
                                //                             size: 30,
                                //                             color: ColorUtils.kTint,
                                //                           )),
                                //                     )
                                //                   ],
                                //                 )
                                //               : Row(
                                //                   children: [
                                //                     Padding(
                                //                       padding: const EdgeInsets.all(20),
                                //                       child: Text(
                                //                         '${response.data![1].title}',
                                //                         style: index == 1
                                //                             ? FontTextStyle
                                //                                 .kBlack20BoldRoboto
                                //                             : FontTextStyle
                                //                                 .kWhite20BoldRoboto,
                                //                       ),
                                //                     ),
                                //                     Spacer(),
                                //                   ],
                                //                 ),
                                //           Padding(
                                //             padding:
                                //                 const EdgeInsets.symmetric(horizontal: 20),
                                //             child: Text(
                                //               '${response.data![1].description}',
                                //               style: index == 1
                                //                   ? FontTextStyle.kBlack16W300Roboto
                                //                   : FontTextStyle.kWhite16W300Roboto,
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             height: Get.height * .02,
                                //           )
                                //         ]),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: Get.height * 0.04,
                                // ),
                                // GestureDetector(
                                //   onTap: () {
                                //     setState(() {
                                //       index = 2;
                                //       selectedlevel = response.data![2].title;
                                //       print('level --------------- $selectedlevel');
                                //     });
                                //   },
                                //   child: Container(
                                //     // height: Get.height * 0.18,
                                //     // width: Get.width * 0.99,
                                //     decoration: index == 2
                                //         ? BoxDecoration(
                                //             borderRadius: BorderRadius.circular(10),
                                //             color: ColorUtils.kTint)
                                //         : BoxDecoration(
                                //             borderRadius: BorderRadius.circular(10),
                                //             color: Color(0xff363636)),
                                //     child: Column(
                                //         crossAxisAlignment: CrossAxisAlignment.start,
                                //         children: [
                                //           index == 2
                                //               ? Row(
                                //                   children: [
                                //                     Padding(
                                //                       padding: const EdgeInsets.all(20),
                                //                       child: Text(
                                //                         '${response.data![2].title}',
                                //                         style: index == 2
                                //                             ? FontTextStyle
                                //                                 .kBlack20BoldRoboto
                                //                             : FontTextStyle
                                //                                 .kWhite20BoldRoboto,
                                //                       ),
                                //                     ),
                                //                     Spacer(),
                                //                     Padding(
                                //                       padding: const EdgeInsets.symmetric(
                                //                           horizontal: 20),
                                //                       child: CircleAvatar(
                                //                           radius: 20,
                                //                           backgroundColor: Colors.black,
                                //                           child: Icon(
                                //                             Icons.done,
                                //                             size: 30,
                                //                             color: ColorUtils.kTint,
                                //                           )),
                                //                     )
                                //                   ],
                                //                 )
                                //               : Row(
                                //                   children: [
                                //                     Padding(
                                //                       padding: const EdgeInsets.all(20),
                                //                       child: Text(
                                //                         '${response.data![2].title}',
                                //                         style: index == 2
                                //                             ? FontTextStyle
                                //                                 .kBlack20BoldRoboto
                                //                             : FontTextStyle
                                //                                 .kWhite20BoldRoboto,
                                //                       ),
                                //                     ),
                                //                     Spacer(),
                                //                   ],
                                //                 ),
                                //           Padding(
                                //             padding:
                                //                 const EdgeInsets.symmetric(horizontal: 20),
                                //             child: Text(
                                //               '${response.data![2].description}',
                                //               style: index == 2
                                //                   ? FontTextStyle.kBlack16W300Roboto
                                //                   : FontTextStyle.kWhite16W300Roboto,
                                //             ),
                                //           ),
                                //           SizedBox(
                                //             height: Get.height * .02,
                                //           )
                                //         ]),
                                //   ),
                                // ),
                                SizedBox(height: Get.height * 0.02),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width * 0.05),
                                  child: GestureDetector(
                                    onTap: () {
                                      print('level ---------- $selectedLevel');
                                      if (response.success == true) {
                                        Get.to(PrimaryGoalsScreen(
                                          skippedImage: widget.skippedImage,
                                          image: widget.image,
                                          fname: widget.fname,
                                          lname: widget.lname,
                                          email: widget.email,
                                          pass: widget.pass,
                                          userName: widget.userName,
                                          gender: widget.gender,
                                          phone: widget.phone,
                                          weight: widget.weight,
                                          dob: widget.dob,
                                          experienceLevel:
                                              selectedLevel ?? 'beginner',
                                        ));
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
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: ColorUtils.kTint),
                                      child: Center(
                                          child: Text(
                                        'Next',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: Get.height * 0.02),
                                      )),
                                    ),
                                  ),
                                ),
                                SizedBox(height: Get.height * 0.05),
                              ],
                            );
                          },
                        )
                      ]),
                ),
              ),
            )
          : ConnectionCheckScreen(),
    );
  }
}
