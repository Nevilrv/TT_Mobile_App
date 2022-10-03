import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/screen/common_widget/conecction_check_screen.dart';
import 'package:tcm/screen/edit_profile_page.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/conecction_check_viewModel.dart';

import '../model/response_model/user_detail_response_model.dart';

class ProfileViewScreen extends StatefulWidget {
  Data? userDetails;
  ProfileViewScreen({Key? key, required this.userDetails}) : super(key: key);

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
    prefDOB = DateTime.parse(PreferenceManager.getDOB());

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
                title:
                    Text('My Profile', style: FontTextStyle.kWhite16BoldRoboto),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: InkWell(
                      onTap: () async {
                        Get.to(
                            EditProfilePage(userDetails: widget.userDetails));
                      },
                      child:
                          Text('Edit', style: FontTextStyle.kTine16W400Roboto),
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
                                        color: ColorUtils.kTint),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(120),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          PreferenceManager.getProfilePic(),

                                      fit: BoxFit.fill,

                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress,
                                              color: ColorUtils.kTint),
                                      // loadingBuilder: (BuildContext context,
                                      //     Widget child,
                                      //     ImageChunkEvent?
                                      //         loadingProgress) {
                                      //   if (loadingProgress == null) {
                                      //     return child;
                                      //   }
                                      //   return Center(
                                      //     child: CircularProgressIndicator(
                                      //         color: ColorUtils.kTint,
                                      //         value: loadingProgress
                                      //                     .expectedTotalBytes !=
                                      //                 null
                                      //             ? loadingProgress
                                      //                     .cumulativeBytesLoaded /
                                      //                 loadingProgress
                                      //                     .expectedTotalBytes!
                                      //             : null),
                                      //   );
                                      // },
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
                                  '${PreferenceManager.getFirstName()}',
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
                                  '${PreferenceManager.getLastName()}',
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
                            '${PreferenceManager.getEmail()}',
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
                            '${DateFormat.yMMMMd().format(prefDOB!)}',
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
                                '${PreferenceManager.getUserName()}',
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
                                      '${PreferenceManager.getWeight()}',
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
  }
}
