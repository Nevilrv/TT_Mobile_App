import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/training_plans_response_model/all_categories_response_model.dart';
import 'package:tcm/model/response_model/video_library_response_model/all_video_res_model.dart';
import 'package:tcm/screen/common_widget/common_widget.dart';
import 'package:tcm/screen/video_library/video_single_cat_screen.dart';
import 'package:tcm/screen/video_library/watch_video_screen.dart';
import 'package:tcm/utils/ColorUtils.dart';
import 'package:tcm/utils/font_styles.dart';
import 'package:tcm/utils/images.dart';
import 'package:tcm/viewModel/all_categories_viewModel.dart';
import 'package:tcm/viewModel/video_library_viewModel/all_video_viewModel.dart';

class VideoLibraryScreen extends StatefulWidget {
  @override
  State<VideoLibraryScreen> createState() => _VideoLibraryScreenState();
}

class _VideoLibraryScreenState extends State<VideoLibraryScreen> {
  AllVideoViewModel _allVideoViewModel = Get.put(AllVideoViewModel());
  AllCategoriesViewModel _allCategoriesViewModel =
      Get.put(AllCategoriesViewModel());
  // final String _url = 'https://www.youtube.com/';

  void initState() {
    super.initState();
    // _allVideoViewModel.getVideoDetails();
    _allCategoriesViewModel.getCategoriesDetails();
    _allVideoViewModel.getVideoDetails();
  }

  void dispose() {
    super.dispose();
    _allVideoViewModel.dispose();
  }

  // _launchURL() async {
  //   if (Platform.isIOS) {
  //     if (await canLaunch(_url)) {
  //       await launch(_url, forceSafariVC: false);
  //     } else {
  //       if (await canLaunch(_url)) {
  //         await launch(_url);
  //       } else {
  //         throw 'Could not launch $_url';
  //       }
  //     }
  //   } else {
  //     if (await canLaunch(_url)) {
  //       await launch(_url);
  //     } else {
  //       throw 'Could not launch $_url';
  //     }
  //   }
  // }

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
        title: Text('Video Library', style: FontTextStyle.kWhite16BoldRoboto),
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
              SizedBox(
                child: GetBuilder<AllCategoriesViewModel>(
                    builder: (categoriesController) {
                  return GetBuilder<AllVideoViewModel>(
                    builder: (videoController) {
                      if (categoriesController.apiResponse.status ==
                          Status.LOADING) {
                        return SizedBox(
                          height: Get.height,
                          width: Get.width,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: ColorUtils.kTint)),
                        );
                      }
                      if (videoController.apiResponse.status ==
                          Status.LOADING) {
                        return SizedBox(
                          height: Get.height,
                          width: Get.width,
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: ColorUtils.kTint)),
                        );
                      }
                      if (categoriesController.apiResponse.status ==
                          Status.ERROR) {
                        return Center(child: noDataLottie());
                      }
                      if (videoController.apiResponse.status == Status.ERROR) {
                        return Center(child: noDataLottie());
                      }
                      if (categoriesController.apiResponse.status ==
                          Status.COMPLETE) {
                        CategoriesResponseModel catResponse =
                            categoriesController.apiResponse.data;

                        AllVideoResponseModel videoResponse =
                            videoController.apiResponse.data;

                        if (videoController.apiResponse.status ==
                            Status.COMPLETE) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: catResponse.data!.length,
                              itemBuilder: (_, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: Get.height * .03),
                                          child: Text(
                                            '${catResponse.data![index].categoryTitle}',
                                            style: FontTextStyle
                                                .kWhite16BoldRoboto,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: Get.height * .03,
                                              right: 5,
                                              left: 5),
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(VideoSingleCatScreen(
                                                videoCatID:
                                                    '${catResponse.data![index].categoryId}',
                                                videoCatName:
                                                    '${catResponse.data![index].categoryTitle}',
                                              ));
                                            },
                                            child: Text(
                                              'More',
                                              style: FontTextStyle
                                                  .kTine16W400Roboto,
                                            ),
                                          ),
                                        ),
                                      ],
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
                                    SizedBox(
                                      height: Get.height * 0.175,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          itemCount:
                                              videoResponse.data!.length >= 10
                                                  ? 10
                                                  : videoResponse.data!.length,
                                          itemBuilder: (_, index1) {
                                            print(
                                                'CHECK------${catResponse.data![index].categoryId == videoResponse.data![index1].categoryId}');

                                            return catResponse.data![index]
                                                        .categoryId ==
                                                    videoResponse.data![index1]
                                                        .categoryId
                                                ? GestureDetector(
                                                    onTap: () {
                                                      Get.to(WatchVideoScreen(
                                                        id: index1,
                                                        data:
                                                            videoResponse.data!,
                                                        // id: response.data![index1].videoId)
                                                      ));
                                                      print("button pressed ");
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.only(
                                                          top: Get.height * .01,
                                                          right:
                                                              Get.height * .02),
                                                      height:
                                                          Get.height * 0.175,
                                                      width: Get.height * 0.125,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: ColorUtils
                                                                  .kTint,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          image: DecorationImage(
                                                              image: AssetImage(
                                                                  AppImages
                                                                      .videoThumbnail),
                                                              fit:
                                                                  BoxFit.fill)),
                                                    ),
                                                  )
                                                : SizedBox();
                                          }),
                                    )
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
                              });
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorUtils.kTint,
                          ),
                        );
                      }
                    },
                  );
                }),
              ),
              SizedBox(height: Get.height * .025)
            ],
          ),
        ),
      ),
    );
  }
}
