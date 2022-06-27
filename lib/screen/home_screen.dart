import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/user_detail_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/habit_tracker/habit_tracker_home_screen.dart';
import 'package:tcm/screen/profile_view_screen.dart';
import 'package:tcm/screen/schedule_screens/my_schedule_screen.dart';
import 'package:tcm/screen/signIn_screens.dart';
import 'package:tcm/screen/training_plan_screens/plan_overview.dart';
import 'package:tcm/screen/training_plan_screens/training_plan.dart';
import 'package:tcm/screen/video_library/video_library_screen.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/home_viewModel.dart';
import 'package:tcm/viewModel/sign_in_viewModel.dart';
import 'package:tcm/viewModel/user_detail_viewModel.dart';
import '../utils/ColorUtils.dart';
import '../utils/font_styles.dart';
import 'edit_profile_page.dart';

class HomeScreen extends StatefulWidget {
  final String? id;
  HomeScreen({Key? key, this.id}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserDetailViewModel _userDetailViewModel = Get.put(UserDetailViewModel());
  HomeViewModel _homeViewModel = Get.put(HomeViewModel());
  SignInViewModel _signInViewModel = Get.put(SignInViewModel());

  void initState() {
    super.initState();
    _userDetailViewModel.userDetailViewModel(
        id: widget.id ?? PreferenceManager.getUId());
    _homeViewModel.initialized;
    _signInViewModel.initialized;
  }

  void dispose() {
    super.dispose();
    _homeViewModel.dispose();
  }

  bool selected = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: Scaffold(
        backgroundColor: ColorUtils.kBlack,
        drawer: _drawerList(),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorUtils.kBlack,
          centerTitle: true,
          title: Image.asset(
            'asset/images/logoSmall.png',
            height: Get.height * 0.033,
            fit: BoxFit.cover,
          ),
          // actions: [
          //   bild(
          //       image: AppIcons.logout,
          //       text: 'Log Out',
          //       onTap: () {
          //         _logOutAlertDialog(onTapCancel: () {
          //           Get.back();
          //         }, onTapLogOut: () {
          //           Get.showSnackbar(GetSnackBar(
          //             message: 'Logout Successfully',
          //             duration: Duration(seconds: 2),
          //           ));
          //           PreferenceManager.clearData();
          //           PreferenceManager.isSetLogin(false);
          //           Get.offAll(SignInScreen());
          //         });
          //       }),
          // ]
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              SizedBox(
                height: Get.height * .04,
              ),
              Container(
                height: Get.height * 0.22,
                width: Get.width * 0.99,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xff363636)),
                child: selected == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, bottom: 10, top: 20, right: 20),
                            child: Text(
                              'Your Next Workout',
                              style: FontTextStyle.kWhite20BoldRoboto,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  height: Get.height * .12,
                                  width: Get.width * .24,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: ColorUtils.kTint),
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'asset/images/image.png',
                                        ),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                SizedBox(
                                  width: Get.width * .04,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chest and Back Blast',
                                      style: FontTextStyle.kWhite17BoldRoboto,
                                    ),
                                    Text(
                                      'Friday, April 30th',
                                      style: FontTextStyle.kGrey18BoldRoboto,
                                    ),
                                    SizedBox(
                                      height: Get.height * .01,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(PlanOverviewScreen(
                                          id: '1',
                                        ));
                                      },
                                      child: Container(
                                        height: Get.height * 0.042,
                                        width: Get.width * 0.5,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: ColorUtils.kTint),
                                        child: Center(
                                            child: Text(
                                          'Start Workout',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: Get.height * 0.02),
                                        )),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, bottom: 10, top: 20, right: 20),
                              child: Text(
                                'No Workouts Scheduled',
                                style: FontTextStyle.kWhite20BoldRoboto,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                'Looks like you don’t have any upcoming workouts. Get started by a plan.  ',
                                style: FontTextStyle.kWhite16W300Roboto,
                              ),
                            ),
                            SizedBox(
                              height: Get.height * .03,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Get.width * 0.05),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selected = !selected;
                                  });
                                },
                                child: Container(
                                  height: Get.height * .05,
                                  width: Get.width * .9,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: ColorUtils.kTint),
                                  child: Center(
                                      child: Text(
                                    'Choose a Workout Plan',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: Get.height * 0.02),
                                  )),
                                ),
                              ),
                            ),
                          ]),
              ),
              SizedBox(
                height: Get.height * .04,
              ),
              category(
                  onTap: () {
                    Get.to(TrainingPlanScreen());
                  },
                  image: 'asset/images/training.png',
                  text: 'Training Plans'),
              category(
                  onTap: () {
                    Get.to(VideoLibraryScreen());
                  },
                  image: 'asset/images/videos.png',
                  text: 'Video Library'),
              category(image: 'asset/images/forums.png', text: 'The Forums'),
              category(
                  image: 'asset/images/habit.png',
                  text: 'Habit Tracker',
                  onTap: () {
                    Get.to(HabitTrackerHomeScreen());
                  })
            ]),
          ),
        ),
      ),
    );
  }

  Widget category({String? image, String? text, Function()? onTap}) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                height: Get.height * .2,
                width: Get.width * .99,
                decoration: BoxDecoration(
                    border: Border.all(color: ColorUtils.kTint),
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(
                        image!,
                      ),
                      fit: BoxFit.cover,
                    )),
              ),
              Positioned(
                bottom: 1,
                top: 110,
                left: 1,
                right: 1,
                child: Container(
                    height: Get.height * .08,
                    width: Get.width * .9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          colors: ColorUtilsGradient.kBlackGradient,
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter),
                    )),
              ),
              Positioned(
                  bottom: Get.height * 0.02,
                  left: Get.width * .05,
                  child: Row(
                    children: [
                      Container(
                        width: Get.width * .013,
                        color: ColorUtils.kTint,
                        height: Get.height * .03,
                      ),
                      SizedBox(
                        width: Get.width * .02,
                      ),
                      Text(
                        text!,
                        style: FontTextStyle.kWhite24BoldRoboto,
                      ),
                    ],
                  ))
            ],
          ),
        ),
        SizedBox(
          height: Get.height * .02,
        ),
      ],
    );
  }

  _drawerList() {
    return Drawer(
      backgroundColor: ColorUtils.kBlack,
      child: Padding(
        padding: EdgeInsets.only(top: Get.height * .02),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.close,
                    color: ColorUtils.kTint,
                  )),
            ],
          ),

          SizedBox(
            height: Get.height * .02,
          ),
          GetBuilder<UserDetailViewModel>(
            builder: (controller) {
              if (controller.apiResponse.status == Status.LOADING) {
                return Center(
                  child: CircularProgressIndicator(color: ColorUtils.kTint),
                );
              }
              if (controller.apiResponse.status == Status.ERROR) {
                return Center(
                  child: Text('Data Not Found!',
                      style: FontTextStyle.kTine16W400Roboto),
                );
              }
              UserdetailResponseModel response = controller.apiResponse.data;
              print('Name====${response.data!.name}');
              print('Pref Name====${PreferenceManager.getUserName()}');
              if (response.data != null ||
                  response.data != '' ||
                  response.success == true) {
                print('----------- ${PreferenceManager.getProfilePic()}');
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(ProfileViewScreen(
                          userDetails: response.data,
                        ));
                        // Get.to(EditProfilePage(
                        //   userDetails: response.data,
                        // ));
                      },
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Color(0xff363636),
                        child: ClipRRect(
                          child: Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(120),
                              border: Border.all(color: Colors.white, width: 4),
                              color: Color(0xff363636),
                            ),
                            child: PreferenceManager.getProfilePic() == ''
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(120),
                                    child: Image.asset(
                                      AppImages.logo,
                                      scale: 2,
                                    ),
                                  )
                                : PreferenceManager.getProfilePic() == null
                                    ? Center(
                                        child: CircularProgressIndicator(
                                          color: ColorUtils.kTint,
                                        ),
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(120),
                                        child: Image.network(
                                          PreferenceManager.getProfilePic(),
                                          fit: BoxFit.fill,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: ColorUtils.kTint,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .01,
                    ),
                    Text(
                      '${PreferenceManager.getUserName() == null || PreferenceManager.getUserName() == '' ? '' : PreferenceManager.getUserName() ?? response.data!.name}',
                      style: FontTextStyle.kWhite16BoldRoboto,
                    ),
                  ],
                );
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(
            height: Get.height * .05,
          ),
          bild(
              image: AppIcons.dumbell,
              text: 'Training Plans',
              onTap: () {
                Get.to(TrainingPlanScreen());
              }),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(
              image: AppIcons.video,
              text: 'Video Library',
              onTap: () {
                Get.to(VideoLibraryScreen());
              }),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(image: AppIcons.forum, text: 'The Forums'),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(
              image: AppIcons.journal,
              text: 'Habit Tracker',
              onTap: () {
                Get.to(HabitTrackerHomeScreen());
              }),
          SizedBox(
            height: Get.height * .03,
          ),
          GetBuilder<UserDetailViewModel>(
            builder: (controller) {
              if (controller.apiResponse.status == Status.LOADING) {
                return Center(
                  child: CircularProgressIndicator(color: ColorUtils.kTint),
                );
              }
              if (controller.apiResponse.status == Status.ERROR) {
                return Center(
                  child: Text('Data Not Found!',
                      style: FontTextStyle.kTine16W400Roboto),
                );
              }
              UserdetailResponseModel response = controller.apiResponse.data;
              if (response.data != null ||
                  response.data != '' ||
                  response.success == true) {
                return bild(
                    image: AppIcons.profile_app_icon,
                    text: 'Profile',
                    onTap: () {
                      Get.to(EditProfilePage(
                        userDetails: response.data,
                      ));
                    });
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(
              image: AppIcons.calender,
              text: 'Schedule',
              onTap: () {
                Get.to(MyScheduleScreen());
              }),
          SizedBox(
            height: Get.height * .03,
          ),
          bild(
              image: AppIcons.logout,
              text: 'Sign Out',
              onTap: () {
                _logOutAlertDialog(onTapCancel: () {
                  Get.back();
                }, onTapLogOut: () {
                  Get.showSnackbar(GetSnackBar(
                    message: 'Sign out Successfully',
                    duration: Duration(seconds: 2),
                  ));
                  PreferenceManager.clearData();
                  PreferenceManager.isSetLogin(false);
                  Get.offAll(SignInScreen());
                });
              }),
          SizedBox(height: Get.height * .08),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     GestureDetector(
          //       onTap: () {
          //         _homeViewModel.launchInsta();
          //       },
          //       child: Image.asset(AppIcons.instagram),
          //     ),
          //     GestureDetector(
          //         onTap: () {
          //           _homeViewModel.launchYoutube();
          //         },
          //         child: Image.asset(AppIcons.youtube)),
          //     GestureDetector(
          //         onTap: () {
          //           _homeViewModel.launchTwitter();
          //         },
          //         child: Image.asset(AppIcons.twitter))
          //   ],
          // ),
          // SizedBox(height: Get.height * .04)
        ]),
      ),
    );
  }

  Widget bild({String? image, String? text, Function()? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Container(
                  height: Get.height * .03,
                  width: Get.height * .03,
                  // color: Colors.white,
                  child: Image.asset(
                    image!,
                    color: ColorUtils.kTint,
                    fit: BoxFit.contain,
                  )),
              SizedBox(
                width: 20,
              ),
              Container(
                child: Text(
                  text!,
                  style: FontTextStyle.kWhite16W300Roboto,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _logOutAlertDialog({Function()? onTapCancel, Function()? onTapLogOut}) {
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Column(children: [
              Text('Logout',
                  style: FontTextStyle.kBlack24W400Roboto
                      .copyWith(fontWeight: FontWeight.bold)),
              Text(
                'Are you sure you want to log out?',
                style: FontTextStyle.kBlack16W300Roboto,
              ),
            ]),
            actions: [
              CupertinoDialogAction(
                  child:
                      Text('Cancel', style: FontTextStyle.kBlack24W400Roboto),
                  onPressed: onTapCancel),
              CupertinoDialogAction(
                child: Text('Log Out',
                    style: FontTextStyle.kBlack24W400Roboto.copyWith(
                        color: ColorUtils.kRed, fontWeight: FontWeight.bold)),
                onPressed: onTapLogOut,
              ),
            ],
          );
        });
  }
}
