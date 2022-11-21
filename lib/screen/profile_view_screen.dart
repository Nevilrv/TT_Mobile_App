import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/edit_profile_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';

class ProfileViewScreen extends StatefulWidget {
  // Data? userDetails;
  ProfileViewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  DateTime? prefDOB;
  ConnectivityCheckViewModel _connectivityCheckViewModel =
      Get.put(ConnectivityCheckViewModel());

  @override
  void initState() {
    _connectivityCheckViewModel.startMonitoring();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    try {
      print('dob1 >>> ${_connectivityCheckViewModel.userData['dob']}');
      prefDOB = DateTime.parse(_connectivityCheckViewModel.userData['dob']);
      return GetBuilder<ConnectivityCheckViewModel>(
        builder: (control) => control.isOnline
            ? Scaffold(
                backgroundColor: ColorUtils.kBlack,
                appBar: AppBar(
                  elevation: 0,
                  leading: IconButton(
                      onPressed: () {
                        // Get.offAll(HomeScreen());
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        color: ColorUtils.kTint,
                      )),
                  backgroundColor: ColorUtils.kBlack,
                  title: Text('My Profile',
                      style: FontTextStyle.kWhite16BoldRoboto),
                  centerTitle: true,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: InkWell(
                        onTap: () async {
                          print('navigator page ');
                          Get.to(EditProfilePage());
                        },
                        child: Text('Edit',
                            style: FontTextStyle.kTine16W400Roboto),
                      ),
                    ),
                  ],
                ),
                body: Column(children: [
                  SizedBox(
                    height: Get.height * .02,
                  ),
                  Center(
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
                          child: control.userData['image'] == ''
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(120),
                                  child: Image.asset(
                                    AppImages.logo,
                                    scale: 2,
                                  ),
                                )
                              : control.userData['image'] == null
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: ColorUtils.kTint),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(120),
                                      child: CachedNetworkImage(
                                        imageUrl: control.userData['image'],
                                        fit: BoxFit.fill,
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress,
                                                color: ColorUtils.kTint),
                                      ),
                                    ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * .01,
                  ),
                  Column(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: Get.height * 0.03,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'First name',
                                  style: FontTextStyle.kGreyBoldRoboto,
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.05,
                              ),
                              Expanded(
                                  child: Text('Last name',
                                      style: FontTextStyle.kGreyBoldRoboto)),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 40,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: ColorUtils.kBlack,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: ColorUtils.kTint, width: 1.5)),
                                  child: Text(
                                    '${control.userData['firstName']}',
                                    style: FontTextStyle.kWhite17BoldRoboto,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Get.width * 0.05,
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 40,
                                  width: Get.width,
                                  decoration: BoxDecoration(
                                      color: ColorUtils.kBlack,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: ColorUtils.kTint, width: 1.5)),
                                  child: Text(
                                    '${control.userData['lastName']}',
                                    style: FontTextStyle.kWhite17BoldRoboto,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Text(
                            'Email address',
                            style: FontTextStyle.kGreyBoldRoboto,
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 40,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: ColorUtils.kBlack,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: ColorUtils.kTint, width: 1.5)),
                            child: Text(
                              '${control.userData['email']}',
                              style: FontTextStyle.kWhite17BoldRoboto,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Text(
                            'Date of Birth',
                            style: FontTextStyle.kGreyBoldRoboto,
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            height: 40,
                            width: Get.width,
                            decoration: BoxDecoration(
                                color: ColorUtils.kBlack,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: ColorUtils.kTint, width: 1.5)),
                            child: Text(
                              '${DateFormat.yMMMMd().format(DateTime.parse(_connectivityCheckViewModel.userData['dob']))}',
                              style: FontTextStyle.kWhite17BoldRoboto,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Username',
                                style: FontTextStyle.kGreyBoldRoboto,
                              ),
                              SizedBox(
                                height: Get.height * 0.01,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 40,
                                width: Get.width,
                                decoration: BoxDecoration(
                                    color: ColorUtils.kBlack,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: ColorUtils.kTint, width: 1.5)),
                                child: Text(
                                  '${control.userData['userName']}',
                                  style: FontTextStyle.kWhite17BoldRoboto,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Weight',
                                style: FontTextStyle.kGreyBoldRoboto,
                              ),
                              SizedBox(
                                height: Get.height * .01,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 40,
                                width: Get.height * .18,
                                decoration: BoxDecoration(
                                    color: ColorUtils.kBlack,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        color: ColorUtils.kTint, width: 1.5)),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${control.userData['weight']}',
                                        style: FontTextStyle.kWhite17BoldRoboto,
                                      ),
                                      Text('lbs',
                                          style: FontTextStyle.kGreyBoldRoboto),
                                    ]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                  ]),
                ]),
              )
            : ConnectionCheckScreen(),
      );
    } catch (e) {
      return SizedBox();
    }
  }
}
