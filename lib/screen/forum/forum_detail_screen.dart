import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';

import '../../model/response_model/forum_response_model/get_all_forums_response_model.dart';
import '../../utils/images.dart';

class ForumDetailScreen extends StatefulWidget {
  final Datum? response;
  ForumDetailScreen({Key? key, this.response}) : super(key: key);

  @override
  _ForumDetailScreenState createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  @override
  Widget build(BuildContext context) {
    print('Preference ${PreferenceManager.getUId()}');
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.03,
              ),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: ColorUtils.kTint,
                  )),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Text(
                '${widget.response!.postTitle!.replaceFirst(widget.response!.postTitle![0], widget.response!.postTitle![0].toUpperCase())}',
                style: FontTextStyle.kWhite12BoldRoboto.copyWith(
                  fontSize: Get.height * 0.023,
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Row(
                children: [
                  Text(
                    'Posted By Amit Shah',
                    style: FontTextStyle.kLightGray16W300Roboto.copyWith(
                        fontSize: Get.height * 0.018,
                        color: Colors.white.withOpacity(0.8)),
                  ),
                  SizedBox(
                    width: Get.width * 0.02,
                  ),
                  Icon(
                    Icons.circle,
                    size: Get.height * 0.007,
                    color: ColorUtils.kLightGray,
                  ),
                  SizedBox(
                    width: Get.width * 0.02,
                  ),
                  Text(
                    '${widget.response!.postDate}',
                    style: FontTextStyle.kLightGray16W300Roboto
                        .copyWith(fontSize: Get.height * 0.02),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          AppImages.arrowUp,
                          color: ColorUtils.kTint,
                          height: Get.height * 0.022,
                          width: Get.height * 0.022,
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Text(
                          '2.3k',
                          style: FontTextStyle.kWhite17W400Roboto.copyWith(
                            fontSize: Get.height * 0.0185,
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Image.asset(
                          AppImages.arrowDown,
                          color: ColorUtils.kTint,
                          height: Get.height * 0.022,
                          width: Get.height * 0.022,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppImages.comment,
                          color: ColorUtils.kTint,
                          height: Get.height * 0.022,
                          width: Get.height * 0.022,
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Text(
                          '2.3k',
                          style: FontTextStyle.kWhite17W400Roboto.copyWith(
                            fontSize: Get.height * 0.0185,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          AppImages.share,
                          color: ColorUtils.kTint,
                          height: Get.height * 0.022,
                          width: Get.height * 0.022,
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Text(
                          'Share',
                          style: FontTextStyle.kWhite17W400Roboto.copyWith(
                            fontSize: Get.height * 0.0185,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Text(
                '${widget.response!.postDescription}',
                style: FontTextStyle.kLightGray16W300Roboto.copyWith(
                    fontSize: Get.height * 0.02, color: Colors.white38),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
