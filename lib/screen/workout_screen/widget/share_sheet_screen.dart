import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';

class ShareSheetScreen extends StatefulWidget {
  ShareSheetScreen({Key? key}) : super(key: key);

  @override
  _ShareSheetScreenState createState() => _ShareSheetScreenState();
}

class _ShareSheetScreenState extends State<ShareSheetScreen> {
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            )),
        title: Text(
          'Share',
          style: FontTextStyle.kWhite20BoldRoboto
              .copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: Align(
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(color: Colors.black
              /* gradient: new LinearGradient(
            colors: [
              Colors.grey.shade800,
              Colors.black,
            ],
            stops: [0.0, 1.0],
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
          )*/
              ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: Get.height * 0.02, horizontal: Get.height * 0.02),
                child: Column(
                  children: [
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    Screenshot(
                      controller: screenshotController,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          Container(
                            height: Get.height * 0.25,
                            width: Get.height * 0.25,
                            child: Image.network(
                              'https://i.pinimg.com/222x/7a/11/b9/7a11b9f739c130eed437d1a237cc3b7d.jpg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Text(
                            'Day 3 - Upper Body',
                            style: FontTextStyle.kWhite24BoldRoboto
                                .copyWith(fontSize: Get.height * 0.023),
                            maxLines: 4,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Text(
                            'Pure BodyBuilding',
                            style: FontTextStyle.kWhite20BoldRoboto.copyWith(
                                fontWeight: FontWeight.w300,
                                fontSize: Get.height * 0.017,
                                color: Colors.grey),
                          ),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.03,
              ),
              Spacer(),
              Container(
                color: Colors.black,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: Get.height * 0.02,
                        horizontal: Get.height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            commonMethod(
                                onTap: () {
                                  SocialShare.shareSms(
                                    "Day 3 - Upper Body\n",
                                    url:
                                        "https://i.pinimg.com/222x/7a/11/b9/7a11b9f739c130eed437d1a237cc3b7d.jpg",
                                    trailingText: "\nPure BodyBuilding",
                                  ).then((data) {
                                    print(data);
                                  });
                                },
                                title: 'Messages',
                                image: AppIcons.sms),
                            commonMethod(
                                onTap: () async {
                                  await screenshotController
                                      .capture()
                                      .then((image) async {
                                    final directory =
                                        await getApplicationDocumentsDirectory();
                                    final file =
                                        await File('${directory.path}/temp.png')
                                            .create();
                                    await file.writeAsBytes(image!);
                                    //facebook appId is mandatory for andorid or else share won't work
                                    Platform.isAndroid
                                        ? SocialShare.shareFacebookStory(
                                            file.path,
                                            "#000000",
                                            "#000000",
                                            "https://google.com",
                                            appId: "1234567289741",
                                          ).then((data) {
                                            print(data);
                                          })
                                        : SocialShare.shareFacebookStory(
                                            file.path,
                                            "#000000",
                                            "#000000",
                                            "https://google.com",
                                          ).then((data) {
                                            print(data);
                                          });
                                  });
                                },
                                title: 'Story',
                                image: AppIcons.facebook1),
                            commonMethod(
                                onTap: () async {
                                  await screenshotController
                                      .capture()
                                      .then((image) async {
                                    final directory =
                                        await getApplicationDocumentsDirectory();
                                    final file =
                                        await File('${directory.path}/temp.png')
                                            .create();
                                    await file.writeAsBytes(image!);

                                    SocialShare.shareInstagramStory(
                                      file.path,
                                      backgroundTopColor: "#000000",
                                      backgroundBottomColor: "#000000",
                                      attributionURL: "https://deep-link-url",
                                    ).then((data) {
                                      print(data);
                                    });
                                  });
                                },
                                title: 'Story',
                                image: AppIcons.instagram1),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            commonMethod(
                                onTap: () {
                                  SocialShare.shareWhatsapp(
                                    "Day 3 - Upper Body \n https://i.pinimg.com/222x/7a/11/b9/7a11b9f739c130eed437d1a237cc3b7d.jpg",
                                  ).then((data) {
                                    print(data);
                                  });
                                },
                                title: 'Whatsapp',
                                image: AppIcons.whatsapp),
                            commonMethod(
                                onTap: () {
                                  SocialShare.shareTwitter(
                                    "Day 3 - Upper Body",
                                    url:
                                        "https://i.pinimg.com/222x/7a/11/b9/7a11b9f739c130eed437d1a237cc3b7d.jpg",
                                    trailingText: "\nPure BodyBuilding",
                                  ).then((data) {
                                    print(data);
                                  });
                                },
                                title: 'Tweet',
                                image: AppIcons.twitter1),
                            commonMethod(
                                onTap: () {
                                  SocialShare.shareOptions(
                                    "Day 3 - Upper Body \n https://i.pinimg.com/222x/7a/11/b9/7a11b9f739c130eed437d1a237cc3b7d.jpg",
                                  ).then((data) {
                                    print(data);
                                  });
                                },
                                title: 'more',
                                image: AppIcons.more),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget commonMethod({String? image, String? title, Function()? onTap}) {
    return Column(
      children: [
        GestureDetector(
            onTap: onTap,
            child: Image.asset(image!,
                height: Get.height * .05,
                width: Get.height * .05,
                fit: BoxFit.contain)),
        SizedBox(
          height: 5,
        ),
        Text(
          title!,
          style: FontTextStyle.kTine16W400Roboto.copyWith(fontSize: 12),
        )
      ],
    );
  }
}
