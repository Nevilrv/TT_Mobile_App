import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/video_library_response_model/all_video_res_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/video_library/watch_video_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/video_library_viewModel/all_video_viewModel.dart';

class VideoSingleCatScreen extends StatefulWidget {
  String? videoCatID;
  String? videoCatName;

  VideoSingleCatScreen({this.videoCatID, this.videoCatName, Key? key})
      : super(key: key);

  @override
  State<VideoSingleCatScreen> createState() => _VideoSingleCatScreenState();
}

class _VideoSingleCatScreenState extends State<VideoSingleCatScreen> {
  AllVideoViewModel _allVideoViewModel = Get.put(AllVideoViewModel());
  // AllCategoriesViewModel _allCategoriesViewModel =
  //     Get.put(AllCategoriesViewModel());
  // final String _url = 'https://www.youtube.com/';

  void initState() {
    super.initState();
    // _allVideoViewModel.getVideoDetails();
    // _allCategoriesViewModel.getCategoriesDetails();
    _allVideoViewModel.getVideoDetails();
  }

  void dispose() {
    super.dispose();
    // _allVideoViewModel.dispose();
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
        title:
            Text(widget.videoCatName!, style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: EdgeInsets.symmetric(horizontal: Get.height * .02),
        //     child: IconButton(
        //       onPressed: () {
        //         // _launchURL();
        //       },
        //       icon: Image.asset(
        //         AppIcons.youtube,
        //         height: Get.height * 0.035,
        //         width: Get.height * 0.035,
        //         fit: BoxFit.contain,
        //       ),
        //     ),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * .05),
          child: Column(
            children: [
              SizedBox(child: GetBuilder<AllVideoViewModel>(
                builder: (videoController) {
                  if (videoController.apiResponse.status == Status.LOADING) {
                    print(
                        'status ------ ${videoController.apiResponse.status}');
                    return SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: ColorUtils.kTint)),
                    );
                  }

                  if (videoController.apiResponse.status == Status.ERROR) {
                    print(
                        'status ------ ${videoController.apiResponse.status}');
                    return Center(child: noDataLottie());
                  }

                  AllVideoResponseModel videoResponse =
                      videoController.apiResponse.data;
                  print('status ------ ${videoController.apiResponse.status}');
                  if (videoController.apiResponse.status == Status.COMPLETE) {
                    print(
                        'status ------ ${videoController.apiResponse.status}');
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: Get.height * .03),
                          child: Text(
                            widget.videoCatName!,
                            style: FontTextStyle.kWhite16BoldRoboto,
                          ),
                        ),
                        Divider(
                          color: ColorUtils.kTint,
                          height: Get.height * .03,
                          thickness: 1.5,
                        ),
                        // print('----------video list view-----------');
                        // if (responseVideo.data![index].categoryId ==
                        //     catResponse.data![index].categoryId) {
                        //   print('compare title ---------');
                        //
                        // } else {
                        //   print('else part of title ---------');
                        //
                        //   return Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // }

                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: videoResponse.data!.length,
                            itemBuilder: (_, index) {
                              return widget.videoCatID ==
                                      videoResponse.data![index].categoryId
                                  ? GestureDetector(
                                      onTap: () {
                                        Get.to(WatchVideoScreen(
                                          id: index,
                                          data: videoResponse.data!,
                                          // id: response.data![index1].videoId)
                                        ));
                                        print("button pressed ");
                                      },
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              margin: EdgeInsets.only(
                                                  top: Get.height * .02),
                                              height: Get.height * 0.1,
                                              width: Get.height * 0.1,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: ColorUtils.kTint,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          AppImages
                                                              .videoThumbnail),
                                                      fit: BoxFit.fill)),
                                            ),
                                          ),
                                          SizedBox(width: Get.height * .015),
                                          Expanded(
                                            flex: 4,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                    height: Get.height * .012),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: Get.height * .013),
                                                  child: Text(
                                                    '${videoResponse.data![index].videoTitle}',
                                                    // '${videoResponse.data![index1].videoTitle}',
                                                    style: FontTextStyle
                                                        .kWhite17BoldRoboto,
                                                  ),
                                                ),
                                                htmlToTextGreyVidDesc(
                                                    data: '${videoResponse.data![index].videoDescription!}'
                                                                .length >
                                                            30
                                                        ? videoResponse
                                                                .data![index]
                                                                .videoDescription!
                                                                .substring(
                                                                    0, 30) +
                                                            ('...')
                                                        : videoResponse
                                                            .data![index]
                                                            .videoDescription!),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : SizedBox();
                            })
                        // GetBuilder<AllVideoViewModel>(
                        //     builder: (videoController) {
                        //       if (videoController.apiResponse.status ==
                        //           Status.LOADING) {
                        //         return Center(
                        //           child: CircularProgressIndicator(
                        //               color: ColorUtils.kTint),
                        //         );
                        //       }
                        //
                        //       AllVideoResponseModel responseVideo =
                        //           videoController.apiResponse.data;
                        //       if (videoController.apiResponse.status ==
                        //           Status.COMPLETE) {
                        //
                        //       } else {
                        //         print('teal container');
                        //         return Container(
                        //           color: Colors.teal,
                        //           height: 120,
                        //           width: 120,
                        //         );
                        //       }
                        //     }),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )),
              SizedBox(height: Get.height * .025)
            ],
          ),
        ),
      ),
    );
  }
}
